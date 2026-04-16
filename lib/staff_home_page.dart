import 'package:flutter/material.dart';
import 'api/auth_service.dart';
import 'app_settings.dart';
import 'gen_l10n/app_localizations.dart';
import 'staff_portal_page.dart';
import 'staff_workspace.dart';

const _kStaffBgDark = Color(0xFF000000);

/// Точка входа для сотрудника: загрузка статуса/ролей, затем портал с шапкой и нижней навигацией.
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
      await AppSettings.load();
      final status = await widget.auth.getWorkerStatus();
      await bootstrapStaffWorkspace(widget.auth, status);
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
    if (_loading) {
      return Scaffold(
        backgroundColor: _kStaffBgDark,
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFFec5b13)),
        ),
      );
    }
    if (_error != null) {
      return Scaffold(
        backgroundColor: _kStaffBgDark,
        appBar: AppBar(
          backgroundColor: _kStaffBgDark,
          foregroundColor: Colors.white,
          title: Text(
            (widget.user['name'] ?? AppLocalizations.of(context)!.staff)
                .toString(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.white54,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _loadStatus,
                  child: Text(AppLocalizations.of(context)!.retry),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final status = _status!;
    if (status.staffRoles.isEmpty) {
      return Scaffold(
        backgroundColor: _kStaffBgDark,
        appBar: AppBar(
          backgroundColor: _kStaffBgDark,
          foregroundColor: Colors.white,
          title: Text(
            (widget.user['name'] ?? AppLocalizations.of(context)!.staff)
                .toString(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_off_outlined,
                  color: Colors.white54,
                  size: 64,
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.helloName(
                    (widget.user['name'] ?? '').toString().trim().isNotEmpty
                        ? widget.user['name'].toString()
                        : AppLocalizations.of(context)!.staff,
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.noRolesAssigned,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return StaffPortalPage(
      auth: widget.auth,
      user: widget.user,
      status: status,
    );
  }
}
