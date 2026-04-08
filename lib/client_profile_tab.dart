import 'package:flutter/material.dart';
import 'account_settings_page.dart';
import 'api/auth_service.dart';
import 'child_edit_page.dart';
import 'create_child_page.dart';
import 'gen_l10n/app_localizations.dart';

const _kGold = Color(0xFFD4AF37);
const _kCardBg = Color(0xFF121212);

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
          const SizedBox(height: 24),
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
