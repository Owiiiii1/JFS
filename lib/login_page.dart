import 'package:flutter/material.dart';
import 'api/auth_service.dart';
import 'client_home_page.dart';
import 'gen_l10n/app_localizations.dart';
import 'register_page.dart';
import 'staff_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.auth});

  final AuthService auth;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isLoading = true);

    try {
      final result = await widget.auth.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // сохраняем токен (пригодится позже)
      await widget.auth.saveToken(result.token);

      final role = (result.user['role'] ?? '').toString().toLowerCase();

final next = (role == 'worker')
    ? StaffHomePage(auth: widget.auth, user: result.user)
    : ClientHomePage(auth: widget.auth, user: result.user);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => next),
      );
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      final message = e is ApiEndpointNotFoundException
          ? l10n.apiEndpointNotFoundHint
          : l10n.signInFailed(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RegisterPage(auth: widget.auth),
      ),
    );
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      Expanded(
                        flex: isWide ? 3 : 2,
                        child: _LogoBlock(titleStyle: theme.textTheme.headlineMedium),
                      ),
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.signIn,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: const [AutofillHints.username, AutofillHints.email],
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!.email,
                                    border: const OutlineInputBorder(),
                                  ),
                                  validator: (v) {
                                    final value = (v ?? '').trim();
                                    if (value.isEmpty) return AppLocalizations.of(context)!.emailRequired;
                                    if (!value.contains('@')) return AppLocalizations.of(context)!.enterValidEmail;
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),

                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  autofillHints: const [AutofillHints.password],
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!.password,
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                      icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                                      tooltip: _isPasswordVisible ? AppLocalizations.of(context)!.hidePassword : AppLocalizations.of(context)!.showPassword,
                                    ),
                                  ),
                                  validator: (v) {
                                    final value = v ?? '';
                                    if (value.isEmpty) return AppLocalizations.of(context)!.passwordRequired;
                                    return null;
                                  },
                                  onFieldSubmitted: (_) => _onSignIn(),
                                ),

                                const SizedBox(height: 16),

                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                    ),
                                    onPressed: _isLoading ? null : _onSignIn,
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : Text(AppLocalizations.of(context)!.signIn),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: const BorderSide(color: Colors.white),
                                    ),
                                    onPressed: _isLoading ? null : _onSignUp,
                                    child: Text(AppLocalizations.of(context)!.signUp),
                                  ),
                                ),
                              ],
                            ),
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

class _LogoBlock extends StatelessWidget {
  const _LogoBlock({required this.titleStyle});
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 180,
        height: 180,
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
