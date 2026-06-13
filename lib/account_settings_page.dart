import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'api/auth_service.dart';
import 'app_settings.dart';
import 'biometric_auth_service.dart';
import 'push/push_token_service.dart';
import 'gen_l10n/app_localizations.dart';
import 'login_page.dart';

/// Экран настроек: просмотр и редактирование данных пользователя (имя, email, телефон). Сохранение через API.
class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key, required this.user, required this.auth});

  final Map<String, dynamic> user;
  final AuthService auth;

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool _isEditing = false;
  bool _isSaving = false;
  bool _biometricEnabled = false;
  bool _biometricSupported = false;
  bool _biometricConfigured = false;
  String _biometricLabel = 'Biometrics';
  final BiometricAuthService _biometricAuth = BiometricAuthService();

  bool get _isClient =>
      (widget.user['role'] ?? '').toString().toLowerCase() == 'client';

  /// Локальная копия данных для отображения и после сохранения
  late Map<String, dynamic> _data;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  static final _phoneAllow = FilteringTextInputFormatter.allow(RegExp(r'[\d+]'));

  @override
  void initState() {
    super.initState();
    _data = Map<String, dynamic>.from(widget.user);
    _biometricEnabled = AppSettings.biometricLoginEnabled;
    unawaited(_loadBiometricState());
  }

  Future<void> _loadBiometricState() async {
    final supported = await _biometricAuth.isSupported();
    final available = await _biometricAuth.isAvailable();
    final methods = available
        ? await _biometricAuth.availableBiometrics()
        : const <BiometricType>[];
    if (!mounted) return;
    setState(() {
      _biometricSupported = supported;
      _biometricConfigured = available;
      if (available) {
        _biometricLabel = _biometricAuth.preferredBiometricLabel(methods);
      }
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value && !_biometricConfigured) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.biometricNotConfigured),
        ),
      );
      return;
    }
    if (value) {
      final l10n = AppLocalizations.of(context)!;
      final ok = await _biometricAuth.authenticateForLogin(
        reason: l10n.biometricEnableReason,
      );
      if (!ok) return;
    }
    await AppSettings.setBiometricLoginEnabled(value);
    if (!mounted) return;
    setState(() => _biometricEnabled = value);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _startEditing() {
    _nameController.text = (_data['name'] ?? '').toString();
    _emailController.text = (_data['email'] ?? '').toString();
    _phoneController.text = (_data['phone'] ?? '').toString();
    setState(() => _isEditing = true);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    try {
      await widget.auth.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _data = {
          ..._data,
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
        };
        _isEditing = false;
        _isSaving = false;
      });
      if (!mounted) return;
      Navigator.of(context).pop(_data);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  Future<void> _onDeleteAccountPressed() async {
    final l10n = AppLocalizations.of(context)!;
    final first = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          l10n.deleteAccountConfirmTitle,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          l10n.deleteAccountConfirmMessage,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade800),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.deleteAccountContinue),
          ),
        ],
      ),
    );
    if (first != true || !mounted) return;

    final second = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          l10n.deleteAccountSecondTitle,
          style: const TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Text(
            l10n.deleteAccountSecondMessage,
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade900),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.deleteAccountConfirmAction),
          ),
        ],
      ),
    );
    if (second != true || !mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: Colors.grey[900],
          content: Row(
            children: [
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  l10n.deleteAccountWorking,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      await PushTokenServiceHolder.instance?.deactivateCurrentOnBackend();
      await widget.auth.deleteClientAccount();
      await widget.auth.clearToken();
      if (!mounted) return;
      Navigator.of(context).pop();
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => LoginPage(auth: widget.auth),
        ),
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_isEditing ? AppLocalizations.of(context)!.editProfile : AppLocalizations.of(context)!.accountSettings),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: _isEditing ? _buildEditContent() : _buildViewContent(),
    );
  }

  Widget _buildViewContent() {
    final name = (_data['name'] ?? '').toString().trim();
    final email = (_data['email'] ?? '').toString().trim();
    final phone = (_data['phone'] ?? '').toString().trim();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DataRow(label: AppLocalizations.of(context)!.name, value: name.isNotEmpty ? name : '—'),
          const SizedBox(height: 16),
          _DataRow(label: AppLocalizations.of(context)!.email, value: email.isNotEmpty ? email : '—'),
          const SizedBox(height: 16),
          _DataRow(label: AppLocalizations.of(context)!.phone, value: phone.isNotEmpty ? phone : '—'),
          if (_biometricSupported) ...[
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: _biometricEnabled,
              onChanged: _toggleBiometric,
              title: Text(
                AppLocalizations.of(context)!.biometricQuickSignIn,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                _biometricConfigured
                    ? _biometricLabel
                    : AppLocalizations.of(context)!.biometricNotConfigured,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ],
          const SizedBox(height: 32),
          SizedBox(
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: _startEditing,
              child: Text(AppLocalizations.of(context)!.edit),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.name,
                labelStyle: const TextStyle(color: Colors.white70),
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
              ),
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return AppLocalizations.of(context)!.nameRequired;
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.email,
                labelStyle: const TextStyle(color: Colors.white70),
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
              ),
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return AppLocalizations.of(context)!.emailRequired;
                if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(value)) return AppLocalizations.of(context)!.enterValidEmail;
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [_phoneAllow],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.phone,
                hintText: AppLocalizations.of(context)!.phoneHint,
                labelStyle: const TextStyle(color: Colors.white70),
                border: const OutlineInputBorder(),
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
              ),
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return AppLocalizations.of(context)!.phoneRequired;
                if (!value.startsWith('+')) return AppLocalizations.of(context)!.phoneMustStartWithPlus;
                final digits = value.replaceAll(RegExp(r'\D'), '');
                if (digits.length < 10) return AppLocalizations.of(context)!.enterValidPhone;
                return null;
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 48,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(AppLocalizations.of(context)!.save),
              ),
            ),
            if (_isClient) ...[
              const SizedBox(height: 40),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red.shade300,
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: _isSaving ? null : _onDeleteAccountPressed,
                  child: Text(AppLocalizations.of(context)!.deleteAccount),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
