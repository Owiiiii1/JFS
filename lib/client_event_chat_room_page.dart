import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_settings.dart';
import 'api/auth_service.dart';
import 'gen_l10n/app_localizations.dart';

const _kChatBg = Color(0xFF000000);
const _kChatIncoming = Color(0xFF242424);
const _kChatOutgoing = Color(0xFFF2CA50);
const _kChatPrimary = Color(0xFFF2CA50);

class ClientEventChatRoomPage extends StatefulWidget {
  const ClientEventChatRoomPage({
    super.key,
    required this.auth,
    required this.roomId,
    required this.title,
    required this.subtitle,
  });

  final AuthService auth;
  final int roomId;
  final String title;
  final String subtitle;

  @override
  State<ClientEventChatRoomPage> createState() => _ClientEventChatRoomPageState();
}

class _ClientEventChatRoomPageState extends State<ClientEventChatRoomPage> {
  static final RegExp _urlPattern = RegExp(
    r'((?:https?:\/\/|www\.)[^\s]+)',
    caseSensitive: false,
  );
  static final _imagePicker = ImagePicker();
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<ClientChatMessage> _messages = [];
  Timer? _pollTimer;
  bool _loading = true;
  bool _sending = false;
  String? _pickedPhotoPath;
  String? _error;
  int? _replyToMessageId;
  int? _editingMessageId;
  String _replyToSenderName = '';
  String _replyToPreview = '';

  @override
  void initState() {
    super.initState();
    _loadInitial();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _pollNewMessages();
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _clearReplyDraft() {
    _replyToMessageId = null;
    _replyToSenderName = '';
    _replyToPreview = '';
  }

  void _clearEditDraft() {
    _editingMessageId = null;
  }

  void _beginReplyTo(ClientChatMessage m) {
    final l10n = AppLocalizations.of(context)!;
    final t = m.body.trim();
    final preview = t.isNotEmpty
        ? (t.length > 100 ? '${t.substring(0, 100)}…' : t)
        : (m.hasImage ? l10n.chatReplyPreviewPhoto : '');
    setState(() {
      _clearEditDraft();
      _replyToMessageId = m.id;
      _replyToSenderName = m.senderName;
      _replyToPreview = preview;
    });
  }

  void _beginEdit(ClientChatMessage m) {
    setState(() {
      _clearReplyDraft();
      _editingMessageId = m.id;
      _controller.text = m.body;
      _pickedPhotoPath = null;
    });
  }

  Future<void> _loadInitial() async {
    try {
      final payload = await widget.auth.getChatRoomMessages(widget.roomId);
      if (!mounted) return;
      setState(() {
        _clearReplyDraft();
        _clearEditDraft();
        _messages
          ..clear()
          ..addAll(payload.messages);
        _loading = false;
        _error = null;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _pollNewMessages() async {
    if (!mounted) return;
    try {
      final payload = await widget.auth.getChatRoomMessages(widget.roomId);
      if (!mounted) return;
      final next = payload.messages;
      if (!_areMessageListsEqual(_messages, next)) {
        setState(() {
          _messages
            ..clear()
            ..addAll(next);
        });
      }
    } catch (_) {
      // silent background poll errors
    }
  }

  bool _areMessageListsEqual(
    List<ClientChatMessage> a,
    List<ClientChatMessage> b,
  ) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      final left = a[i];
      final right = b[i];
      if (left.id != right.id ||
          left.senderRole != right.senderRole ||
          left.senderName != right.senderName ||
          left.body != right.body ||
          left.imageUrl != right.imageUrl ||
          left.isMine != right.isMine ||
          left.createdAt != right.createdAt) {
        return false;
      }
      final lReply = left.replyTo;
      final rReply = right.replyTo;
      if ((lReply == null) != (rReply == null)) {
        return false;
      }
      if (lReply != null &&
          rReply != null &&
          (lReply.id != rReply.id ||
              lReply.senderName != rReply.senderName ||
              lReply.bodyPreview != rReply.bodyPreview ||
              lReply.hasImage != rReply.hasImage ||
              lReply.imageUrl != rReply.imageUrl)) {
        return false;
      }
    }
    return true;
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context)!;
    final text = _controller.text.trim();
    final photoPath = _pickedPhotoPath;
    final editingId = _editingMessageId;
    if (editingId != null) {
      if (text.isEmpty || _sending) {
        return;
      }
      setState(() => _sending = true);
      try {
        final updated = await widget.auth.editChatRoomMessage(
          widget.roomId,
          editingId,
          body: text,
        );
        if (!mounted) return;
        final idx = _messages.indexWhere((m) => m.id == editingId);
        _controller.clear();
        setState(() {
          if (idx >= 0) {
            _messages[idx] = updated;
          }
          _sending = false;
          _clearEditDraft();
        });
      } catch (_) {
        if (!mounted) return;
        setState(() => _sending = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.chatEditFailed)));
      }
      return;
    }
    if ((text.isEmpty && (photoPath == null || photoPath.isEmpty)) || _sending) {
      return;
    }
    setState(() => _sending = true);
    try {
      final msg = await widget.auth.sendChatRoomMessage(
        widget.roomId,
        body: text.isNotEmpty ? text : null,
        photoPath: photoPath,
        replyToMessageId: _replyToMessageId,
      );
      if (!mounted) return;
      _controller.clear();
      setState(() {
        _clearReplyDraft();
        _messages.add(msg);
        _sending = false;
        _pickedPhotoPath = null;
      });
      _scrollToBottom();
    } catch (_) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.chatSendFailed)));
    }
  }

  Future<void> _deleteMessage(ClientChatMessage m) async {
    final l10n = AppLocalizations.of(context)!;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B1B1B),
          title: Text(
            l10n.chatDeleteTitle,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            l10n.chatDeleteMessageConfirm,
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.chatReplyCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(
                l10n.chatDelete,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
    if (shouldDelete != true) {
      return;
    }
    setState(() => _sending = true);
    try {
      await widget.auth.deleteChatRoomMessage(widget.roomId, m.id);
      if (!mounted) return;
      setState(() {
        _messages.removeWhere((x) => x.id == m.id);
        if (_replyToMessageId == m.id) {
          _clearReplyDraft();
        }
        if (_editingMessageId == m.id) {
          _clearEditDraft();
          _controller.clear();
        }
        _sending = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.chatDeleteFailed)));
    }
  }

  Future<void> _pickPhoto() async {
    if (_sending) return;
    try {
      final xFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (xFile == null || !mounted) return;
      setState(() {
        _pickedPhotoPath = xFile.path;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.chatCouldNotPickPhoto)),
      );
    }
  }

  Future<void> _openMessageLink(String rawLink) async {
    final normalized = rawLink.toLowerCase().startsWith('http')
        ? rawLink
        : 'https://$rawLink';
    final uri = Uri.tryParse(normalized);
    if (uri == null) {
      return;
    }
    final ok = await canLaunchUrl(uri);
    if (!ok) {
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _buildMessageBodyText(String text, {required bool mine}) {
    final baseStyle = TextStyle(
      color: mine ? const Color(0xFF3C2F00) : Colors.white,
      fontSize: 14,
      height: 1.3,
    );
    final linkStyle = baseStyle.copyWith(
      decoration: TextDecoration.underline,
      color: mine ? const Color(0xFF2E5AAC) : const Color(0xFF7CC4FF),
      fontWeight: FontWeight.w500,
    );
    final spans = <InlineSpan>[];
    var cursor = 0;
    final matches = _urlPattern.allMatches(text).toList();
    for (final match in matches) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, match.start)));
      }
      final raw = text.substring(match.start, match.end);
      spans.add(
        TextSpan(
          text: raw,
          style: linkStyle,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _openMessageLink(raw);
            },
        ),
      );
      cursor = match.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }
    if (spans.isEmpty) {
      return Text(text, style: baseStyle);
    }
    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: spans,
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _replyQuoteBlock(ClientChatReplyRef r, {required bool mine}) {
    final l10n = AppLocalizations.of(context)!;
    final preview = r.bodyPreview.isNotEmpty
        ? r.bodyPreview
        : (r.hasImage ? l10n.chatReplyPreviewPhoto : '');
    final bar = Container(
      width: 3,
      constraints: const BoxConstraints(minHeight: 32),
      decoration: BoxDecoration(
        color: mine
            ? const Color(0xFF8B6914).withValues(alpha: 0.85)
            : _kChatPrimary.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(2),
      ),
    );
    final inner = Column(
      crossAxisAlignment:
          mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          r.senderName,
          style: TextStyle(
            color: mine ? const Color(0xFF5C4800) : _kChatPrimary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (preview.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            preview,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: mine ? const Color(0xFF4C3A00) : Colors.white70,
              fontSize: 12,
              height: 1.25,
            ),
          ),
        ],
      ],
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!mine) ...[bar, const SizedBox(width: 6)],
          Expanded(child: inner),
          if (mine) ...[const SizedBox(width: 6), bar],
        ],
      ),
    );
  }

  Widget _messageActionsMenu(ClientChatMessage m) {
    final l10n = AppLocalizations.of(context)!;
    final mine = m.isMine;
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.more_vert,
            size: 22,
            color: mine ? const Color(0xFF5C4800) : Colors.white54,
          ),
          onSelected: (value) {
            if (value == 'reply') {
              _beginReplyTo(m);
              return;
            }
            if (value == 'edit') {
              _beginEdit(m);
              return;
            }
            if (value == 'delete') {
              _deleteMessage(m);
            }
          },
          itemBuilder: (context) {
            final items = <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'reply',
                child: Text(l10n.chatReply),
              ),
            ];
            if (mine && m.body.trim().isNotEmpty) {
              items.add(
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Text(l10n.chatEdit),
                ),
              );
            }
            if (mine) {
              items.add(
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Text(l10n.chatDelete),
                ),
              );
            }
            return items;
          },
        ),
      ),
    );
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final d = dt.toLocal();
    return AppSettings.formatTime(d.hour, d.minute);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _kChatBg,
      appBar: AppBar(
        backgroundColor: _kChatBg,
        foregroundColor: _kChatPrimary,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 16),
            ),
            if (widget.subtitle.trim().isNotEmpty)
              Text(
                widget.subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.white54),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: _kChatPrimary),
                  )
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            l10n.chatLoadFailed,
                            style: const TextStyle(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final m = _messages[index];
                          final mine = m.isMine;
                          final bubble = Container(
                            padding: const EdgeInsets.fromLTRB(12, 9, 12, 8),
                            decoration: BoxDecoration(
                              color: mine ? _kChatOutgoing : _kChatIncoming,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(14),
                                topRight: const Radius.circular(14),
                                bottomLeft: Radius.circular(mine ? 14 : 3),
                                bottomRight: Radius.circular(mine ? 3 : 14),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!mine)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      m.senderName,
                                      style: const TextStyle(
                                        color: _kChatPrimary,
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                if (m.replyTo != null)
                                  _replyQuoteBlock(m.replyTo!, mine: mine),
                                if (m.hasImage)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      m.imageUrl!,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, progress) {
                                            if (progress == null) {
                                              return child;
                                            }
                                            return Container(
                                              width: 220,
                                              height: 140,
                                              color: Colors.black26,
                                              alignment: Alignment.center,
                                              child:
                                                  const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: _kChatPrimary,
                                                  ),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 220,
                                              height: 140,
                                              color: Colors.black26,
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.broken_image_outlined,
                                                color: Colors.white54,
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                if (m.body.trim().isNotEmpty) ...[
                                  if (m.hasImage) const SizedBox(height: 8),
                                  _buildMessageBodyText(m.body, mine: mine),
                                ],
                                const SizedBox(height: 4),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    _formatTime(m.createdAt),
                                    style: TextStyle(
                                      color: mine
                                          ? const Color(0xFF4C3A00)
                                          : Colors.white54,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                          return Align(
                            alignment: mine
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (mine) _messageActionsMenu(m),
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 280),
                                    child: bubble,
                                  ),
                                  if (!mine) _messageActionsMenu(m),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_replyToMessageId != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.fromLTRB(10, 8, 6, 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1B1B),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _kChatPrimary.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.chatReplyingTo(_replyToSenderName),
                                    style: const TextStyle(
                                      color: _kChatPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (_replyToPreview.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      _replyToPreview,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: _sending
                                  ? null
                                  : () => setState(_clearReplyDraft),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white54,
                                size: 20,
                              ),
                              tooltip: l10n.chatReplyCancel,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_editingMessageId != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.fromLTRB(10, 8, 6, 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1B1B),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.lightBlueAccent.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                l10n.chatEditingLabel,
                                style: const TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: _sending
                                  ? null
                                  : () => setState(() {
                                      _clearEditDraft();
                                      _controller.clear();
                                    }),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white54,
                                size: 20,
                              ),
                              tooltip: l10n.chatCancelEdit,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_pickedPhotoPath != null && _pickedPhotoPath!.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1B1B),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                File(_pickedPhotoPath!),
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 52,
                                    height: 52,
                                    color: Colors.white12,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.image,
                                      color: Colors.white54,
                                    ),
                                  );
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: _sending
                                  ? null
                                  : () => setState(() => _pickedPhotoPath = null),
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white70,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _sending ? null : _pickPhoto,
                        icon: const Icon(
                          Icons.photo,
                          color: _kChatPrimary,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          minLines: 1,
                          maxLines: 4,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: l10n.chatMessagePlaceholder,
                            hintStyle: const TextStyle(color: Colors.white38),
                            filled: true,
                            fillColor: const Color(0xFF1B1B1B),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.fromLTRB(
                              12,
                              10,
                              12,
                              10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Material(
                        color: _kChatPrimary,
                        borderRadius: BorderRadius.circular(22),
                        child: InkWell(
                          onTap: _sending ? null : _send,
                          borderRadius: BorderRadius.circular(22),
                          child: SizedBox(
                            width: 44,
                            height: 44,
                            child: _sending
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF3C2F00),
                                    ),
                                  )
                                : const Icon(
                                    Icons.send,
                                    color: Color(0xFF3C2F00),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
