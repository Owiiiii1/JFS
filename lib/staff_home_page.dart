import 'package:flutter/material.dart';
import 'api/auth_service.dart';
import 'account_settings_page.dart';
import 'login_page.dart';

class StaffHomePage extends StatefulWidget {
  const StaffHomePage({super.key, required this.auth, required this.user});

  final AuthService auth;
  final Map<String, dynamic> user;

  @override
  State<StaffHomePage> createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  WorkerStatus? _status;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    try {
      final status = await widget.auth.getWorkerStatus();
      if (!mounted) return;
      setState(() {
        _status = status;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = (widget.user['name'] ?? '').toString().trim();
    final displayName = name.isNotEmpty ? name : 'Account';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(displayName),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            color: Colors.grey[900],
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => AccountSettingsPage(user: widget.user, auth: widget.auth),
                  ),
                );
              } else if (value == 'sign_out') {
                widget.auth.clearToken();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginPage(auth: widget.auth)),
                  (route) => false,
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
              const PopupMenuItem(value: 'sign_out', child: Text('Sign out')),
            ],
          ),
        ],
      ),
      body: _buildBody(name),
    );
  }

  Widget _buildBody(String name) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white54, size: 48),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loadStatus,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final status = _status!;
    if (status.staffRoles.isEmpty) {
      return _buildNoRoles(name);
    }
    return _buildWithRoles(name, status.staffRoles);
  }

  /// Экран при отсутствии назначенных ролей
  Widget _buildNoRoles(String name) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_off_outlined, color: Colors.white54, size: 64),
            const SizedBox(height: 24),
            Text(
              name.isNotEmpty ? 'Hello, $name' : 'Hello',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You have not been assigned any roles yet. Please contact the administration.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  /// Роли сверху — динамические подписи с иконками
  Widget _buildWithRoles(String name, List<StaffRole> roles) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: roles.map((role) => _RoleChip(role: role)).toList(),
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                name.isNotEmpty ? 'Signed in as $name' : 'Staff',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Иконка по коду роли (расширяемо), иначе дефолт
IconData _iconForRoleCode(String code) {
  switch (code.toLowerCase()) {
    case 'hs':
      return Icons.badge_outlined;
    case 'hostess':
      return Icons.badge_outlined;
    case 'waiter':
      return Icons.restaurant;
    case 'bartender':
      return Icons.local_bar;
    case 'chef':
      return Icons.restaurant_menu;
    case 'manager':
      return Icons.manage_accounts;
    default:
      return Icons.work_outline;
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.role});

  final StaffRole role;

  @override
  Widget build(BuildContext context) {
    final icon = _iconForRoleCode(role.code);
    return Chip(
      avatar: Icon(icon, color: Colors.black, size: 20),
      label: Text(role.name),
      backgroundColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
    );
  }
}
