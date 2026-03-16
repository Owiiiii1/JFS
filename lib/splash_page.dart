import 'package:flutter/material.dart';
import 'api/auth_service.dart';
import 'gen_l10n/app_localizations.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.auth});
  final AuthService auth;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final token = await widget.auth.getToken();

    if (token != null) {
      final ok = await widget.auth.validateToken(token);
      if (ok) {
        if (!mounted) return;
        // Пока заглушка: просто показываем, что токен валиден.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.tokenValidNext)),
        );
        return;
      } else {
        await widget.auth.clearToken();
      }
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginPage(auth: widget.auth)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          AppLocalizations.of(context)!.loading,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
