import 'package:flutter/material.dart';
import 'account_settings_page.dart';
import 'api/auth_service.dart';
import 'login_page.dart';

class ClientHomePage extends StatelessWidget {
  const ClientHomePage({super.key, required this.auth, required this.user});

  final AuthService auth;
  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    final role = (user['role'] ?? 'unknown').toString();
    final name = (user['name'] ?? '').toString().trim();
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
                    builder: (_) => AccountSettingsPage(user: user, auth: auth),
                  ),
                );
              } else if (value == 'sign_out') {
                auth.clearToken();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginPage(auth: auth)),
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
      body: Center(
        child: Text(
          'Client app\n\nSigned in${name.isNotEmpty ? ", $name" : ""}\nRole: $role',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
