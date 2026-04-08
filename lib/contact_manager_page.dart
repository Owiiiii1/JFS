import 'package:flutter/material.dart';

import 'api/auth_service.dart';
import 'gen_l10n/app_localizations.dart';

const _kGold = Color(0xFFD4AF37);

/// Форма «Связаться с менеджером» из раздела Info.
class ContactManagerPage extends StatefulWidget {
  const ContactManagerPage({super.key, required this.auth});

  final AuthService auth;

  @override
  State<ContactManagerPage> createState() => _ContactManagerPageState();
}

class _ContactManagerPageState extends State<ContactManagerPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();
  bool _sending = false;
  bool _profileLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final p = await widget.auth.getClientProfile();
      if (!mounted) return;
      setState(() {
        _nameController.text = p.user.name.trim();
        _emailController.text = p.user.email.trim();
        _phoneController.text = p.user.phone.trim();
        _profileLoaded = true;
      });
    } catch (_) {
      if (mounted) setState(() => _profileLoaded = true);
    }
  }

  InputDecoration _fieldDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white54),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.28)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _kGold),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _sending = true);
    try {
      await widget.auth.submitContactManager(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        message: _messageController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.contactManagerSent),
          backgroundColor: Colors.green.shade800,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    } on ContactManagerUnavailableException {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.contactManagerServiceUnavailable),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      final msg = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            msg.isNotEmpty ? msg : l10n.contactManagerSendFailed,
          ),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(l10n.infoMenuContactManager),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: !_profileLoaded
          ? const Center(
              child: CircularProgressIndicator(color: _kGold, strokeWidth: 2),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.contactManagerIntro,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 15,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      textInputAction: TextInputAction.next,
                      decoration: _fieldDecoration(l10n.name),
                      validator: (v) {
                        if ((v ?? '').trim().isEmpty) {
                          return l10n.nameRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      decoration: _fieldDecoration(l10n.email),
                      validator: (v) {
                        final t = (v ?? '').trim();
                        if (t.isEmpty) return l10n.emailRequired;
                        if (!t.contains('@')) return l10n.enterValidEmail;
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: _fieldDecoration(l10n.phone),
                      validator: (v) {
                        final t = (v ?? '').trim();
                        if (t.isEmpty) return l10n.phoneRequired;
                        if (!t.startsWith('+')) {
                          return l10n.phoneMustStartWithPlus;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      minLines: 5,
                      maxLines: 10,
                      textInputAction: TextInputAction.newline,
                      decoration: _fieldDecoration(l10n.contactManagerMessageLabel),
                      validator: (v) {
                        if ((v ?? '').trim().isEmpty) {
                          return l10n.contactManagerMessageRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 48,
                      child: FilledButton(
                        onPressed: _sending ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: _kGold,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor: _kGold.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _sending
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : Text(
                                l10n.contactManagerSend,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
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
