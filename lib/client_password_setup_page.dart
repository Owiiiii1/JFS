import 'dart:async';

import 'package:flutter/material.dart';

import 'api/auth_service.dart';
import 'client_home_page.dart';
import 'gen_l10n/app_localizations.dart';
import 'push/push_token_service.dart';

class ClientPasswordSetupPage extends StatefulWidget {
  const ClientPasswordSetupPage({
    super.key,
    required this.auth,
    required this.email,
  });

  final AuthService auth;
  final String email;

  @override
  State<ClientPasswordSetupPage> createState() =>
      _ClientPasswordSetupPageState();
}

class _ClientPasswordSetupPageState extends State<ClientPasswordSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isPasswordConfirmVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isLoading = true);

    try {
      final result = await widget.auth.setupClientPassword(
        email: widget.email.trim(),
        password: _passwordController.text,
        passwordConfirmation: _passwordConfirmController.text,
      );

      final token = result.token;
      final user = result.user;
      if (token == null || user == null) {
        throw Exception('Invalid setup response');
      }

      await widget.auth.saveToken(token);
      unawaited(PushTokenServiceHolder.instance?.syncWithBackendIfLoggedIn());

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => ClientHomePage(auth: widget.auth, user: user),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      final message = e is ApiEndpointNotFoundException
          ? l10n.apiEndpointNotFoundHint
          : l10n.passwordSetupFailed(e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(l10n.setPasswordTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.setPasswordSubtitle(widget.email),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible,
                        ),
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        tooltip: _isPasswordVisible
                            ? l10n.hidePassword
                            : l10n.showPassword,
                      ),
                    ),
                    validator: (v) {
                      final value = (v ?? '').trim();
                      if (value.length < 6) return l10n.passwordSetupMinLength;
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordConfirmController,
                    obscureText: !_isPasswordConfirmVisible,
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: InputDecoration(
                      labelText: l10n.confirmPassword,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => _isPasswordConfirmVisible =
                              !_isPasswordConfirmVisible,
                        ),
                        icon: Icon(
                          _isPasswordConfirmVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: (v) {
                      if ((v ?? '') != _passwordController.text) {
                        return l10n.passwordsDoNotMatch;
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _onSubmit(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _onSubmit,
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.savePasswordAndContinue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
