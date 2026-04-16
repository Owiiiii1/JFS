import 'package:flutter/material.dart';

import 'app_settings.dart';
import 'api/auth_service.dart';
import 'gen_l10n/app_localizations.dart';

class NotificationDetailPage extends StatefulWidget {
  const NotificationDetailPage({
    super.key,
    required this.auth,
    required this.recipientId,
  });

  final AuthService auth;
  final int recipientId;

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  AppNotificationDetails? _details;
  bool _loading = true;
  String? _error;
  bool _becameRead = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final details = await widget.auth.getNotificationDetails(widget.recipientId);
      if (!mounted) return;
      setState(() {
        _details = details;
        _loading = false;
        _error = null;
        _becameRead = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    final d = dt.toLocal();
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd.$mm.${d.year} ${AppSettings.formatTime(d.hour, d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Navigator.of(context).pop(_becameRead);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text(l10n.notificationDetailsTitle),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        l10n.notificationsLoadFailed,
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : _details == null
                    ? Center(
                        child: Text(
                          l10n.notificationsLoadFailed,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _details!.senderName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _formatDate(_details!.sentAt),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  _details!.body,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    height: 1.35,
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
