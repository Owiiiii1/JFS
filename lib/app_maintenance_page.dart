import 'dart:async';

import 'package:flutter/material.dart';

import 'api/auth_service.dart';
import 'client_home_page.dart';
import 'login_page.dart';
import 'push/push_token_service.dart';

/// English maintenance copy (shown regardless of app locale).
const String kAppMaintenanceMessage =
    'The app is temporarily unavailable while scheduled maintenance is in progress. Please try again later.';

const _kMaintenanceStillInactiveMessage =
    'The app is still unavailable. Please try again later.';
const _kMaintenanceCheckFailedMessage =
    'Could not check app status. Check your connection and try again.';

/// Full-screen maintenance gate styled like the client login page.
class ClientAppMaintenancePage extends StatefulWidget {
  const ClientAppMaintenancePage({super.key, required this.auth});

  final AuthService auth;

  @override
  State<ClientAppMaintenancePage> createState() =>
      _ClientAppMaintenancePageState();
}

class _ClientAppMaintenancePageState extends State<ClientAppMaintenancePage> {
  bool _refreshing = false;

  bool _isClientRole(Map<String, dynamic> user) {
    final role = (user['role'] ?? '').toString().trim().toLowerCase();
    return role == 'client';
  }

  Future<void> _resumeApp() async {
    try {
      final user = await widget.auth.restoreSessionIfPossible();
      if (!mounted) return;
      if (user != null && _isClientRole(user)) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(
            builder: (_) => ClientHomePage(auth: widget.auth, user: user),
          ),
          (_) => false,
        );
        unawaited(PushTokenServiceHolder.instance?.syncWithBackendIfLoggedIn());
        return;
      }
      if (user != null) {
        await widget.auth.clearToken();
      }
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => LoginPage(auth: widget.auth),
        ),
        (_) => false,
      );
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => LoginPage(auth: widget.auth),
        ),
        (_) => false,
      );
    }
  }

  Future<void> _onRefresh() async {
    if (_refreshing) return;
    setState(() => _refreshing = true);
    try {
      final active = await widget.auth.checkAppActive();
      if (!mounted) return;
      if (active) {
        await _resumeApp();
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(_kMaintenanceStillInactiveMessage)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(_kMaintenanceCheckFailedMessage)),
      );
    } finally {
      if (mounted) {
        setState(() => _refreshing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              flex: isWide ? 3 : 2,
                              child: Center(
                                child: SizedBox(
                                  width: 180,
                                  height: 180,
                                  child: Image.asset(
                                    'assets/logo.png',
                                    fit: BoxFit.contain,
                                    filterQuality: FilterQuality.high,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: isWide ? 3 : 2,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.12,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    kAppMaintenanceMessage,
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            disabledBackgroundColor: Colors.white38,
                            disabledForegroundColor: Colors.black54,
                          ),
                          onPressed: _refreshing ? null : _onRefresh,
                          child: _refreshing
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Text(
                                  'Refresh',
                                  style: TextStyle(fontWeight: FontWeight.w700),
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
    );
  }
}

/// Navigates to [ClientAppMaintenancePage] and clears the stack.
void openClientAppMaintenanceScreen(
  BuildContext context, {
  required AuthService auth,
}) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(
      builder: (_) => ClientAppMaintenancePage(auth: auth),
    ),
    (_) => false,
  );
}
