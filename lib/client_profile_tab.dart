import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter/services.dart';
import 'account_settings_page.dart';
import 'api/auth_service.dart';
import 'child_edit_page.dart';
import 'create_child_page.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'gen_l10n/app_localizations.dart';

const _kGold = Color(0xFFD4AF37);
const _kCardBg = Color(0xFF121212);
const _kPastShowDialogShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(6)),
);
const _kPastShowDialogTitleStyle = TextStyle(
  color: _kGold,
  fontSize: 15,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.4,
  height: 1.2,
);
const _kPastShowDialogTitlePadding = EdgeInsets.fromLTRB(20, 18, 20, 6);
const _kPastShowDialogContentPadding = EdgeInsets.fromLTRB(20, 0, 20, 4);
const _kPastShowDialogActionsPadding = EdgeInsets.fromLTRB(16, 0, 16, 10);

class ClientProfileTab extends StatefulWidget {
  const ClientProfileTab({
    super.key,
    required this.auth,
    required this.user,
  });

  final AuthService auth;
  final Map<String, dynamic> user;

  @override
  State<ClientProfileTab> createState() => _ClientProfileTabState();
}

class _ClientProfileTabState extends State<ClientProfileTab> {
  ClientProfile? _profile;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final profile = await widget.auth.getClientProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _loading = false;
      });
    } catch (e) {
      debugPrint('[ClientProfile] ERROR: $e');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAccountSection(),
          const SizedBox(height: 36),
          _buildChildrenSection(),
          const SizedBox(height: 20),
          _buildPastShowPhotosButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPastShowPhotosButton() {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: _onPastShowPhotosTap,
        style: FilledButton.styleFrom(
          backgroundColor: _kGold,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.pastShowPhotosButtonTitle.toUpperCase(),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.pastShowPhotosButtonSubtitle.toLowerCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onPastShowPhotosTap() async {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(color: _kGold),
      ),
    );
    try {
      final result = await widget.auth.getClientPhotoServiceChildrenEvents();
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      if (!result.hasAnyParticipation) {
        await _showPastShowPhotosMessageDialog(
          l10n.pastShowPhotosNotParticipatedMessage,
        );
        return;
      }

      final children = result.children.where((c) => c.hasParticipation).toList();
      if (children.isEmpty) {
        await _showPastShowPhotosMessageDialog(
          l10n.pastShowPhotosNotParticipatedMessage,
        );
        return;
      }

      ClientPhotoServiceChildEntry? selectedChild;
      if (children.length == 1) {
        selectedChild = children.first;
      } else {
        selectedChild = await _showPhotoServiceChildPicker(children);
      }

      if (selectedChild == null || !mounted) {
        return;
      }

      if (selectedChild.events.isEmpty) {
        await _showPastShowPhotosMessageDialog(l10n.pastShowPhotosPendingMessage);
        return;
      }

      ClientPhotoServiceEventEntry? selectedEvent;
      if (selectedChild.events.length == 1) {
        selectedEvent = selectedChild.events.first;
      } else {
        selectedEvent = await _showPhotoServiceEventPicker(selectedChild.events);
      }

      if (selectedEvent == null || !mounted) {
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => _PhotoServiceEntryPage(
            auth: widget.auth,
            childEntry: selectedChild!,
            eventEntry: selectedEvent!,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _showPastShowPhotosMessageDialog(String message) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _kCardBg,
        shape: _kPastShowDialogShape,
        titlePadding: _kPastShowDialogTitlePadding,
        contentPadding: _kPastShowDialogContentPadding,
        actionsPadding: _kPastShowDialogActionsPadding,
        actionsAlignment: MainAxisAlignment.end,
        title: Center(
          child: Text(
            l10n.pastShowPhotosTitle.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: _kPastShowDialogTitleStyle,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              l10n.close,
              style: const TextStyle(color: _kGold),
            ),
          ),
        ],
      ),
    );
  }

  Future<ClientPhotoServiceChildEntry?> _showPhotoServiceChildPicker(
    List<ClientPhotoServiceChildEntry> children,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<ClientPhotoServiceChildEntry>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _kCardBg,
        shape: _kPastShowDialogShape,
        titlePadding: _kPastShowDialogTitlePadding,
        contentPadding: _kPastShowDialogContentPadding,
        actionsPadding: _kPastShowDialogActionsPadding,
        actionsAlignment: MainAxisAlignment.end,
        title: Center(
          child: Text(
            l10n.pastShowPhotosChooseChildTitle.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: _kPastShowDialogTitleStyle,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: children.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final child = children[index];
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(ctx).pop(child),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              child.childName.isNotEmpty ? child.childName : '—',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.photoServiceParticipationsCount(
                                child.assignmentCount,
                              ),
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right,
                        color: _kGold,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              l10n.close,
              style: const TextStyle(color: _kGold),
            ),
          ),
        ],
      ),
    );
  }

  Future<ClientPhotoServiceEventEntry?> _showPhotoServiceEventPicker(
    List<ClientPhotoServiceEventEntry> events,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    return showDialog<ClientPhotoServiceEventEntry>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _kCardBg,
        shape: _kPastShowDialogShape,
        titlePadding: _kPastShowDialogTitlePadding,
        contentPadding: _kPastShowDialogContentPadding,
        actionsPadding: _kPastShowDialogActionsPadding,
        actionsAlignment: MainAxisAlignment.end,
        title: Center(
          child: Text(
            l10n.pastShowPhotosChooseEventTitle.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: _kPastShowDialogTitleStyle,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final event = events[index];
              final dateLine = event.eventStartsAt != null
                  ? DateFormat('d MMM yyyy', locale).format(
                      event.eventStartsAt!.toLocal(),
                    )
                  : null;
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(ctx).pop(event),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.eventName.isNotEmpty ? event.eventName : '—',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              [
                                if (dateLine != null) dateLine,
                              ].join(' • '),
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.chevron_right,
                        color: _kGold,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              l10n.close,
              style: const TextStyle(color: _kGold),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Account section
  // ---------------------------------------------------------------------------

  Widget _buildAccountSection() {
    final name =
        _profile?.user.name ?? (widget.user['name'] ?? '').toString();
    final email =
        _profile?.user.email ?? (widget.user['email'] ?? '').toString();
    final phone =
        _profile?.user.phone ?? (widget.user['phone'] ?? '').toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppLocalizations.of(context)!.account,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: _openSettings,
              child: Text(
                AppLocalizations.of(context)!.editInfo,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoField(label: AppLocalizations.of(context)!.fullName, value: name),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _InfoField(label: AppLocalizations.of(context)!.email, value: email)),
                  const SizedBox(width: 16),
                  Expanded(child: _InfoField(label: AppLocalizations.of(context)!.phone, value: phone)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AccountSettingsPage(
          user: widget.user,
          auth: widget.auth,
        ),
      ),
    );
    _loadProfile();
  }

  void _openCreateChild() async {
    final created = await Navigator.of(context).push<ProfileChild>(
      MaterialPageRoute<ProfileChild>(
        builder: (_) => CreateChildPage(auth: widget.auth),
      ),
    );
    if (created != null && mounted) {
      _loadProfile();
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ChildEditPage(
            child: created,
            auth: widget.auth,
            onChildUpdated: _loadProfile,
          ),
        ),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Children section
  // ---------------------------------------------------------------------------

  Widget _buildChildrenSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.myChildren,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: _openCreateChild,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, size: 16, color: Colors.black),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)!.addChild,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildChildrenContent(),
      ],
    );
  }

  Widget _buildChildrenContent() {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(color: _kGold),
        ),
      );
    }

    if (_error != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _kCardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 32),
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                foregroundColor: Colors.white,
              ),
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      );
    }

    if (_profile == null || _profile!.children.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Icon(Icons.child_care, color: Colors.grey[600], size: 48),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.noChildrenAddedYet,
              style: TextStyle(color: Colors.grey[500], fontSize: 15),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _profile!.children
          .map((child) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ChildCard(
                  child: child,
                  auth: widget.auth,
                  onProfileRefresh: _loadProfile,
                ),
              ))
          .toList(),
    );
  }
}

// =============================================================================
// Private sub-widgets
// =============================================================================

class _InfoField extends StatelessWidget {
  const _InfoField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.isNotEmpty ? value : '—',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _PhotoServiceEntryPage extends StatelessWidget {
  const _PhotoServiceEntryPage({
    required this.auth,
    required this.childEntry,
    required this.eventEntry,
  });

  final AuthService auth;
  final ClientPhotoServiceChildEntry childEntry;
  final ClientPhotoServiceEventEntry eventEntry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(l10n.pastShowPhotosTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                childEntry.childName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                eventEntry.eventName,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 18),
              _PhotoModeButton(
                title: l10n.photoServiceModePhotosTitle,
                subtitle: l10n.photoServiceModePhotosSubtitle,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => _PhotoServiceGalleryPage(
                      auth: auth,
                      childEntry: childEntry,
                      eventEntry: eventEntry,
                      mode: 'available',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _PhotoModeButton(
                title: l10n.photoServiceModeShopTitle,
                subtitle: l10n.photoServiceModeShopSubtitle,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => _PhotoServiceGalleryPage(
                      auth: auth,
                      childEntry: childEntry,
                      eventEntry: eventEntry,
                      mode: 'shop',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoModeButton extends StatelessWidget {
  const _PhotoModeButton({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: _kGold,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle.toLowerCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoServiceGalleryPage extends StatefulWidget {
  const _PhotoServiceGalleryPage({
    required this.auth,
    required this.childEntry,
    required this.eventEntry,
    required this.mode,
  });

  final AuthService auth;
  final ClientPhotoServiceChildEntry childEntry;
  final ClientPhotoServiceEventEntry eventEntry;
  final String mode;

  @override
  State<_PhotoServiceGalleryPage> createState() => _PhotoServiceGalleryPageState();
}

class _PhotoServiceGalleryPageState extends State<_PhotoServiceGalleryPage>
    with WidgetsBindingObserver {
  bool _loading = true;
  String? _error;
  ClientPhotoServiceGalleryResult? _gallery;
  final ScrollController _scroll = ScrollController();
  final Set<int> _selectedPhotoAssetIds = <int>{};
  bool _busy = false;

  bool get _isShopMode => widget.mode == 'shop';

  bool get _selectionLocked {
    final payment = _gallery?.payment;
    return _isShopMode &&
        payment != null &&
        (payment.canContinuePayment || payment.canCancelPayment);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadGallery();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scroll.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadGallery(silent: true);
    }
  }

  Future<void> _loadGallery({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final loaded = await widget.auth.getClientPhotoServiceGallery(
        childId: widget.childEntry.childId,
        eventId: widget.eventEntry.eventId,
        mode: widget.mode,
      );
      if (!mounted) return;
      final availableIds = loaded.photos.map((e) => e.photoAssetId).toSet();
      final lockSelection =
          _isShopMode &&
          (loaded.payment.canContinuePayment ||
              loaded.payment.canCancelPayment);
      setState(() {
        _gallery = loaded;
        _loading = false;
        _error = null;
        if (lockSelection) {
          _selectedPhotoAssetIds
            ..clear()
            ..addAll(loaded.payment.selectedPhotoAssetIds);
        } else {
          _selectedPhotoAssetIds.removeWhere((id) => !availableIds.contains(id));
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _openFullscreen(String? url) async {
    if (url == null || url.isEmpty) return;
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black,
      builder: (ctx) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(child: Image.network(url, fit: BoxFit.contain)),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: IconButton(
                onPressed: () => Navigator.of(ctx).pop(),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openExternalUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null || !await canLaunchUrl(uri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.photoServiceCouldNotOpenLink)),
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _downloadOriginalPhoto(String? url) async {
    if (url == null || url.isEmpty) return;
    if (_busy) return;

    setState(() => _busy = true);
    try {
      final uri = Uri.tryParse(url);
      if (uri == null) {
        throw Exception(AppLocalizations.of(context)!.photoServiceInvalidPhotoUrl);
      }
      final response = await http.get(uri, headers: const {'Accept': '*/*'});
      if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
        throw Exception(
          AppLocalizations.of(context)!.photoServiceDownloadFailed(response.statusCode),
        );
      }

      final cd = response.headers['content-disposition'] ?? '';
      final nameFromHeader = _extractFilenameFromContentDisposition(cd);
      final ext = _extensionFromContentType(response.headers['content-type']);
      final fileName = nameFromHeader ?? 'photo_${DateTime.now().millisecondsSinceEpoch}$ext';

      final savedPath = await FlutterFileDialog.saveFile(
        params: SaveFileDialogParams(
          data: response.bodyBytes,
          fileName: fileName,
          mimeTypesFilter: <String>[
            response.headers['content-type'] ?? 'image/jpeg',
          ],
        ),
      );

      if (!mounted) return;
      if (savedPath == null || savedPath.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.photoServiceSaveCanceled)),
        );
        return;
      }

      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: _kCardBg,
          shape: _kPastShowDialogShape,
          title: const Text(
            '',
            style: TextStyle(color: _kGold),
          ),
          content: Text(
            AppLocalizations.of(context)!.photoServiceSavedToDownloads,
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(AppLocalizations.of(context)!.photoServiceOk, style: const TextStyle(color: _kGold)),
            ),
          ],
        ),
      );
    } on MissingPluginException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.photoServiceRestartRequired)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  String? _extractFilenameFromContentDisposition(String value) {
    final lower = value.toLowerCase();
    final marker = 'filename=';
    final idx = lower.indexOf(marker);
    if (idx < 0) return null;
    var part = value.substring(idx + marker.length).trim();
    if (part.startsWith('"') && part.endsWith('"') && part.length >= 2) {
      part = part.substring(1, part.length - 1);
    }
    final normalized = part.trim();
    if (normalized.isEmpty) return null;
    return normalized;
  }

  String _extensionFromContentType(String? contentType) {
    final ct = (contentType ?? '').toLowerCase();
    if (ct.contains('png')) return '.png';
    if (ct.contains('webp')) return '.webp';
    return '.jpg';
  }

  Future<void> _runCheckout() async {
    if (!_isShopMode || _busy) return;
    final payment = _gallery?.payment;
    if (payment == null) return;
    if (_selectionLocked) {
      await _showManagePaymentSheet();
      return;
    }
    if (_selectedPhotoAssetIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.photoServiceSelectAtLeastOnePhoto)),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      final checkoutUrl = await widget.auth.createPhotoServiceCheckoutSession(
        assignmentId: _gallery!.assignmentId,
        photoAssetIds: _selectedPhotoAssetIds.toList(growable: false),
      );
      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        await _openExternalUrl(checkoutUrl);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (checkoutUrl != null && checkoutUrl.isNotEmpty)
                ? AppLocalizations.of(context)!.photoServiceCheckoutOpenedInBrowser
                : AppLocalizations.of(context)!.photoServicePurchaseCompleted,
          ),
        ),
      );
      await _loadGallery(silent: true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _runBulkCheckout() async {
    if (!_isShopMode || _busy) return;
    final gallery = _gallery;
    final payment = gallery?.payment;
    if (gallery == null || payment == null) return;
    if (_selectionLocked) {
      await _showManagePaymentSheet();
      return;
    }
    final shopCount = gallery.shopPhotoCount ?? gallery.photos.length;
    if (shopCount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.photoServiceNoPhotosAvailableForBulkPurchase)),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      final checkoutUrl = await widget.auth.createPhotoServiceBulkCheckoutSession(
        assignmentId: gallery.assignmentId,
      );
      if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
        await _openExternalUrl(checkoutUrl);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (checkoutUrl != null && checkoutUrl.isNotEmpty)
                ? AppLocalizations.of(context)!.photoServiceBulkCheckoutOpenedInBrowser
                : AppLocalizations.of(context)!.photoServiceBulkPurchaseCompleted,
          ),
        ),
      );
      await _loadGallery(silent: true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _showManagePaymentSheet() async {
    final l10n = AppLocalizations.of(context)!;
    final assignmentId = _gallery?.assignmentId;
    if (assignmentId == null) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: _kCardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.pastShowPhotosManagePaymentTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.pastShowPhotosManagePaymentMessage,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () async {
                    Navigator.of(sheetContext).pop();
                    try {
                      final url = await widget.auth.resumePhotoServicePayment(
                        assignmentId,
                      );
                      await _openExternalUrl(url);
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: _kGold,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(l10n.mealPaymentContinue),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () async {
                    Navigator.of(sheetContext).pop();
                    try {
                      await widget.auth.cancelPhotoServicePayment(assignmentId);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.mealPaymentCanceled)),
                      );
                      await _loadGallery(silent: true);
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: Text(
                    l10n.mealPaymentCancel,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final photos = _gallery?.photos ?? const <ClientPhotoServicePhotoItem>[];
    final title = _isShopMode
        ? l10n.photoServiceGalleryTitleShop
        : l10n.photoServiceGalleryTitlePhotos;
    final buyLabel = _selectionLocked
        ? l10n.pastShowPhotosManagePayment
        : l10n.photoServiceBuy;
    final bulkPrice = _gallery?.bulkPricePerPhoto;
    final bulkCount = _gallery?.shopPhotoCount ?? photos.length;
    final shopHelperText = (_gallery?.shopHelperText ?? '').trim();
    final bulkTotal = (bulkPrice != null && bulkCount > 0)
        ? (bulkPrice * bulkCount)
        : null;
    final bulkBuyLabel = _selectionLocked
        ? l10n.pastShowPhotosManagePayment
        : (bulkTotal == null
              ? l10n.photoServiceBuyAll
              : l10n.photoServiceBuyAllFor('\$${bulkTotal.toStringAsFixed(2)}'));
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.childEntry.childName,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.eventEntry.eventName,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isShopMode)
              if (shopHelperText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      shopHelperText,
                      style: const TextStyle(
                        color: _kGold,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            if (_isShopMode)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.photoServiceSelectedCount(
                          _selectedPhotoAssetIds.length,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_selectionLocked)
                              FilledButton(
                                onPressed: _busy ? null : _runCheckout,
                                style: FilledButton.styleFrom(
                                  backgroundColor: _kGold,
                                  foregroundColor: Colors.black,
                                  minimumSize: const Size(0, 34),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: const VisualDensity(
                                    horizontal: -2,
                                    vertical: -2,
                                  ),
                                ),
                                child: Text(buyLabel),
                              )
                            else ...[
                              FilledButton(
                                onPressed: _busy ? null : _runBulkCheckout,
                                style: FilledButton.styleFrom(
                                  backgroundColor: _kGold,
                                  foregroundColor: Colors.black,
                                  minimumSize: const Size(0, 34),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: const VisualDensity(
                                    horizontal: -2,
                                    vertical: -2,
                                  ),
                                ),
                                child: Text(bulkBuyLabel),
                              ),
                              const SizedBox(width: 6),
                              FilledButton(
                                onPressed: _busy ? null : _runCheckout,
                                style: FilledButton.styleFrom(
                                  backgroundColor: _kGold,
                                  foregroundColor: Colors.black,
                                  minimumSize: const Size(0, 34),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: const VisualDensity(
                                    horizontal: -2,
                                    vertical: -2,
                                  ),
                                ),
                                child: Text(buyLabel),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: _kGold),
                    )
                  : _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    )
                  : photos.isEmpty
                  ? Center(
                      child: Text(
                        l10n.photoServiceNoPhotosYet,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    )
                  : GridView.builder(
                      controller: _scroll,
                      padding: const EdgeInsets.fromLTRB(12, 6, 12, 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.72,
                          ),
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        final photo = photos[index];
                        final selected = _selectedPhotoAssetIds.contains(
                          photo.photoAssetId,
                        );
                        final preview = photo.previewUrl;
                        final openUrl = _isShopMode
                            ? photo.previewUrl
                            : photo.originalUrl;
                        return GestureDetector(
                          onTap: !_isShopMode || _selectionLocked
                              ? null
                              : () {
                                  setState(() {
                                    if (selected) {
                                      _selectedPhotoAssetIds.remove(
                                        photo.photoAssetId,
                                      );
                                    } else {
                                      _selectedPhotoAssetIds.add(
                                        photo.photoAssetId,
                                      );
                                    }
                                  });
                                },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: selected ? _kGold : Colors.white10,
                                width: selected ? 2 : 1,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(9),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  preview == null
                                      ? Container(color: Colors.black26)
                                      : Image.network(
                                          preview,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(color: Colors.black26),
                                        ),
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: _isShopMode
                                        ? IgnorePointer(
                                            ignoring: _selectionLocked,
                                            child: Checkbox(
                                              visualDensity:
                                                  const VisualDensity(
                                                    horizontal: -4,
                                                    vertical: -4,
                                                  ),
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              value: selected,
                                              onChanged: _selectionLocked
                                                  ? null
                                                  : (_) {
                                                      setState(() {
                                                        if (selected) {
                                                          _selectedPhotoAssetIds
                                                              .remove(
                                                                photo.photoAssetId,
                                                              );
                                                        } else {
                                                          _selectedPhotoAssetIds
                                                              .add(
                                                                photo.photoAssetId,
                                                              );
                                                        }
                                                      });
                                                    },
                                              activeColor: _kGold,
                                              side: const BorderSide(
                                                color: Colors.white70,
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () => _downloadOriginalPhoto(
                                              photo.originalUrl,
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                Icons.download_rounded,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                  ),
                                  Positioned(
                                    right: 6,
                                    bottom: 6,
                                    child: FilledButton(
                                      onPressed: () => _openFullscreen(openUrl),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: _kGold,
                                        foregroundColor: Colors.black,
                                        minimumSize: const Size(64, 30),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: const VisualDensity(
                                          horizontal: -2,
                                          vertical: -2,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        l10n.photoServiceView,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChildCard extends StatelessWidget {
  const _ChildCard({
    required this.child,
    required this.auth,
    this.onProfileRefresh,
  });

  final ProfileChild child;
  final AuthService auth;
  final VoidCallback? onProfileRefresh;

  void _openChildEdit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChildEditPage(
          child: child,
          auth: auth,
          onChildUpdated: onProfileRefresh,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openChildEdit(context),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Photo
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 80,
                    height: 104,
                    child: child.mainPhotoUrl != null
                        ? Image.network(
                            child.mainPhotoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _photoPlaceholder(),
                            loadingBuilder: (_, w, progress) {
                              if (progress == null) return w;
                              return _photoPlaceholder(
                                child: const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white24,
                                  ),
                                ),
                              );
                            },
                          )
                        : _photoPlaceholder(),
                  ),
                ),
                const SizedBox(width: 16),
                // Name + age
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child.firstName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      if (child.age != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          '${AppLocalizations.of(context)!.ageLabel}: ${child.age}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _openChildEdit(context),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _photoPlaceholder({Widget? child}) {
    return Container(
      color: const Color(0xFF1A1A1A),
      child: Center(
        child: child ?? Icon(Icons.person, color: Colors.grey[700], size: 32),
      ),
    );
  }
}
