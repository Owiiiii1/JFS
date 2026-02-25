import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'api/auth_service.dart';

/// Экран настроек: просмотр данных пользователя и режим редактирования (сохранение — заглушка).
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

    // TODO: вызов API сохранения профиля (данные для подключения запроса укажете позже)
    await Future.delayed(const Duration(milliseconds: 300));

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit profile' : 'Account settings'),
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
    final role = (_data['role'] ?? '').toString();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DataRow(label: 'Name', value: name.isNotEmpty ? name : '—'),
          const SizedBox(height: 16),
          _DataRow(label: 'Email', value: email.isNotEmpty ? email : '—'),
          const SizedBox(height: 16),
          _DataRow(label: 'Phone', value: phone.isNotEmpty ? phone : '—'),
          const SizedBox(height: 16),
          _DataRow(label: 'Role', value: role.isNotEmpty ? role : '—'),
          const SizedBox(height: 32),
          SizedBox(
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: _startEditing,
              child: const Text('Edit'),
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
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
              ),
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return 'Name is required';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
              ),
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return 'Email is required';
                if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(value)) return 'Enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [_phoneAllow],
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: '+1234567890',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
              ),
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return 'Phone is required';
                if (!value.startsWith('+')) return 'Phone must start with +';
                final digits = value.replaceAll(RegExp(r'\D'), '');
                if (digits.length < 10) return 'Enter a valid phone number';
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Role только для отображения в режиме редактирования
            TextFormField(
              initialValue: (_data['role'] ?? '').toString(),
              readOnly: true,
              style: const TextStyle(color: Colors.white54),
              decoration: const InputDecoration(
                labelText: 'Role',
                labelStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
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
                    : const Text('Save'),
              ),
            ),
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
