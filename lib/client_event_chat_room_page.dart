import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  void _beginReplyTo(ClientChatMessage m) {
    final l10n = AppLocalizations.of(context)!;
    final t = m.body.trim();
    final preview = t.isNotEmpty
        ? (t.length > 100 ? '${t.substring(0, 100)}…' : t)
        : (m.hasImage ? l10n.chatReplyPreviewPhoto : '');
    setState(() {
      _replyToMessageId = m.id;
      _replyToSenderName = m.senderName;
      _replyToPreview = preview;
    });
  }

  Future<void> _loadInitial() async {
    try {
      final payload = await widget.auth.getChatRoomMessages(widget.roomId);
      if (!mounted) return;
      setState(() {
        _clearReplyDraft();
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
    final afterId = _messages.isNotEmpty ? _messages.last.id : 0;
    try {
      final payload = await widget.auth.getChatRoomMessages(
        widget.roomId,
        afterId: afterId,
      );
      if (!mounted || payload.messages.isEmpty) return;
      setState(() {
        _messages.addAll(payload.messages);
      });
      _scrollToBottom();
    } catch (_) {
      // silent background poll errors
    }
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context)!;
    final text = _controller.text.trim();
    final photoPath = _pickedPhotoPath;
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
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: 'reply',
              child: Text(l10n.chatReply),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final d = dt.toLocal();
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
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
                                  Text(
                                    m.body,
                                    style: TextStyle(
                                      color: mine
                                          ? const Color(0xFF3C2F00)
                                          : Colors.white,
                                      fontSize: 14,
                                      height: 1.3,
                                    ),
                                  ),
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
