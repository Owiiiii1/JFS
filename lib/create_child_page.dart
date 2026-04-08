import 'package:flutter/material.dart';
import 'api/auth_service.dart';
import 'gen_l10n/app_localizations.dart';

/// Экран создания ребёнка для текущего клиента.
class CreateChildPage extends StatefulWidget {
  const CreateChildPage({super.key, required this.auth});

  final AuthService auth;

  @override
  State<CreateChildPage> createState() => _CreateChildPageState();
}

class _CreateChildPageState extends State<CreateChildPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  String? _gender;
  DateTime? _birthdate;
  bool _saving = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final firstName = _firstNameController.text.trim();
    if (firstName.isEmpty) return;

    setState(() => _saving = true);
    try {
      final child = await widget.auth.createChild(
        firstName: firstName,
        gender: _gender,
        birthdate: _birthdate,
      );
      if (!mounted) return;
      Navigator.of(context).pop(child);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red.shade700,
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
        title: Text(l10n.addChildTitle),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: _saving
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _firstNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: '${l10n.firstName} *',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[700]!),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFD4AF37)),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return l10n.enterFirstName;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _gender,
                      dropdownColor: const Color(0xFF121212),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: l10n.gender,
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[700]!),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFD4AF37)),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'male',
                          child: Text(l10n.genderBoy),
                        ),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text(l10n.genderGirl),
                        ),
                      ],
                      onChanged: (value) => setState(() => _gender = value),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          locale: Localizations.localeOf(context),
                          initialDate: _birthdate ?? DateTime.now(),
                          firstDate: DateTime(1990),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => _birthdate = picked);
                        }
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: l10n.birthdate,
                          labelStyle: TextStyle(color: Colors.grey[400]),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[700]!),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFD4AF37)),
                          ),
                        ),
                        child: Text(
                          _birthdate != null
                              ? MaterialLocalizations.of(context)
                                  .formatMediumDate(_birthdate!)
                              : l10n.chooseDate,
                          style: TextStyle(
                            color: _birthdate != null
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(l10n.create),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
