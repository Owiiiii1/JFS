import 'package:flutter/material.dart';
import 'account_settings_page.dart';
import 'api/auth_service.dart';
import 'child_edit_page.dart';
import 'create_child_page.dart';
import 'package:intl/intl.dart';
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
      final result = await widget.auth.getClientPastShowPhotos();
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      if (!result.hasAnyAssignment) {
        await _showPastShowPhotosMessageDialog(
          l10n.pastShowPhotosNotParticipatedMessage,
        );
        return;
      }

      final photos = result.photos;
      if (photos.isEmpty) {
        await _showPastShowPhotosMessageDialog(
          l10n.pastShowPhotosPendingMessage,
        );
        return;
      }

      final byEvent = _groupPastShowPhotosByEvent(photos);
      final eventEntries = _sortedPastShowEventEntries(byEvent);

      int? eventId;
      if (eventEntries.length == 1) {
        eventId = eventEntries.first.key;
      } else {
        eventId = await _showPastShowEventPicker(eventEntries);
      }
      if (eventId == null || !mounted) {
        return;
      }

      final childrenForEvent = byEvent[eventId] ?? [];
      if (childrenForEvent.isEmpty) {
        return;
      }

      PastShowPhotoItem? selectedItem;
      if (childrenForEvent.length == 1) {
        selectedItem = childrenForEvent.first;
      } else {
        selectedItem = await _showPastShowChildrenPicker(childrenForEvent);
      }

      if (selectedItem == null || !mounted) {
        return;
      }

      await _showPastShowActionsDialog(selectedItem);
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

  Map<int, List<PastShowPhotoItem>> _groupPastShowPhotosByEvent(
    List<PastShowPhotoItem> photos,
  ) {
    final byEvent = <int, List<PastShowPhotoItem>>{};
    for (final photo in photos) {
      byEvent.putIfAbsent(photo.eventId, () => []).add(photo);
    }
    for (final list in byEvent.values) {
      list.sort((a, b) => a.childName.compareTo(b.childName));
    }
    return byEvent;
  }

  List<MapEntry<int, List<PastShowPhotoItem>>> _sortedPastShowEventEntries(
    Map<int, List<PastShowPhotoItem>> byEvent,
  ) {
    return byEvent.entries.toList()
      ..sort((a, b) {
        final aDate =
            a.value.first.eventStartsAt ??
            DateTime.fromMillisecondsSinceEpoch(0);
        final bDate =
            b.value.first.eventStartsAt ??
            DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });
  }

  Future<int?> _showPastShowEventPicker(
    List<MapEntry<int, List<PastShowPhotoItem>>> eventEntries,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    return showDialog<int>(
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
            itemCount: eventEntries.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final sample = eventEntries[index].value.first;
              final count = eventEntries[index].value.length;
              final dateLine = sample.eventStartsAt != null
                  ? DateFormat('d MMM yyyy', locale).format(
                      sample.eventStartsAt!.toLocal(),
                    )
                  : null;
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(ctx).pop(eventEntries[index].key),
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
                              sample.eventName.isNotEmpty ? sample.eventName : '—',
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
                                count == 1
                                    ? '1 item'
                                    : '${count.toString()} items',
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

  Future<PastShowPhotoItem?> _showPastShowChildrenPicker(
    List<PastShowPhotoItem> childrenForEvent,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<PastShowPhotoItem>(
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
            itemCount: childrenForEvent.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = childrenForEvent[index];
              final mediaIcons = <IconData>[
                if (item.hasPhotoLink) Icons.photo_outlined,
                if (item.hasVideoLink) Icons.videocam_outlined,
                if (item.hasPreviewLink) Icons.remove_red_eye_outlined,
                if (item.hasPaidLink) Icons.verified_outlined,
              ];
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(ctx).pop(item),
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
                              item.childName.isNotEmpty ? item.childName : '—',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (mediaIcons.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  for (final icon in mediaIcons) ...[
                                    Icon(icon, color: Colors.grey[400], size: 14),
                                    const SizedBox(width: 6),
                                  ],
                                ],
                              ),
                            ],
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

  Future<void> _showPastShowActionsDialog(PastShowPhotoItem item) async {
    final l10n = AppLocalizations.of(context)!;
    final priceText = item.additionalPhotoPrice?.toStringAsFixed(2);
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
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  item.childName.isNotEmpty ? item.childName : '—',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (item.hasPhotoLink)
                _PastShowMediaLinkTile(
                  label: l10n.pastShowPhotosOpenPhoto,
                  icon: Icons.photo_outlined,
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await _openPastShowPhotoLink(item.photoLink);
                  },
                ),
              if (item.hasVideoLink)
                _PastShowMediaLinkTile(
                  label: l10n.pastShowPhotosOpenVideo,
                  icon: Icons.videocam_outlined,
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await _openPastShowPhotoLink(item.videoLink);
                  },
                ),
              if (item.hasPreviewLink)
                _PastShowMediaLinkTile(
                  label: l10n.pastShowPhotosOpenPreview,
                  icon: Icons.remove_red_eye_outlined,
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await _openPastShowPhotoLink(item.previewLink);
                  },
                ),
              if (item.hasPaidLink)
                _PastShowMediaLinkTile(
                  label: l10n.pastShowPhotosOpenPaid,
                  icon: Icons.verified_outlined,
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await _openPastShowPhotoLink(item.paidLink);
                  },
                ),
              if (item.hasPreviewLink &&
                  item.hasAdditionalPhotoPrice &&
                  !item.hasPaidLink)
                FutureBuilder<MealPaymentStatusPayload>(
                  future: widget.auth.getAssignmentAdditionalPhotoPaymentStatus(
                    item.assignmentId,
                  ),
                  builder: (context, snap) {
                    final st = snap.data;
                    final hasPendingState = st != null &&
                        (st.canContinuePayment || st.canCancelPayment);
                    if (hasPendingState) {
                      return _PastShowMediaLinkTile(
                        label: l10n.pastShowPhotosManagePayment,
                        icon: Icons.manage_accounts_outlined,
                        onTap: () async {
                          Navigator.of(ctx).pop();
                          await _showPastShowManagePaymentSheet(item);
                        },
                      );
                    }

                    return _PastShowMediaLinkTile(
                      label:
                          '${l10n.pastShowPhotosOrderFromPreview}${priceText != null ? ' (${l10n.pastShowPhotosAdditionalPhotoPrice(priceText)})' : ''}',
                      icon: Icons.shopping_cart_checkout_outlined,
                      onTap: () async {
                        Navigator.of(ctx).pop();
                        await _handlePastShowOrderFromPreview(item);
                      },
                    );
                  },
                ),
            ],
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

  Future<void> _openPastShowPhotoLink(String url) async {
    final l10n = AppLocalizations.of(context)!;
    final uri = Uri.tryParse(url);
    if (uri == null || !await canLaunchUrl(uri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pastShowPhotosLinkCouldNotOpen)),
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _handlePastShowOrderFromPreview(PastShowPhotoItem item) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final status = await widget.auth.getAssignmentAdditionalPhotoPaymentStatus(
        item.assignmentId,
      );
      if (status.canContinuePayment || status.canCancelPayment) {
        await _showPastShowManagePaymentSheet(item);
        return;
      }

      final checkoutUrl = await widget.auth
          .createAssignmentAdditionalPhotoCheckoutSession(item.assignmentId);
      await _openPastShowPhotoLink(checkoutUrl);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().isEmpty ? l10n.pastShowPhotosLinkCouldNotOpen : e.toString())),
      );
    }
  }

  Future<void> _showPastShowManagePaymentSheet(PastShowPhotoItem item) async {
    final l10n = AppLocalizations.of(context)!;
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
                      final url = await widget.auth
                          .resumeAssignmentAdditionalPhotoPayment(
                            item.assignmentId,
                          );
                      await _openPastShowPhotoLink(url);
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
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
                      await widget.auth.cancelAssignmentAdditionalPhotoPayment(
                        item.assignmentId,
                      );
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.mealPaymentCanceled)),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
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

class _PastShowMediaLinkTile extends StatelessWidget {
  const _PastShowMediaLinkTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Icon(icon, color: _kGold, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: _kGold, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

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
