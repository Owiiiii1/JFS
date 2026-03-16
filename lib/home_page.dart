import 'package:flutter/material.dart';
import 'gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.user});

  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final role = (user['role'] ?? 'unknown').toString();
    final name = (user['name'] ?? '').toString();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(l10n.homePageTitle),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          '${l10n.youAreSignedIn(name.isNotEmpty ? ", $name" : "")}\n${l10n.yourRole(role)}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
