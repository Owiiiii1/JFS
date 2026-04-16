import 'package:flutter/material.dart';
import 'api/auth_service.dart';
import 'app_settings.dart';
import 'gen_l10n/app_localizations.dart';

/// Страница настроек: язык приложения, единицы измерения, аккаунт.
class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.auth,
    required this.user,
  });

  final AuthService auth;
  final Map<String, dynamic> user;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    AppSettings.load();
  }

  Future<void> _reloadAndRebuild() async {
    await AppSettings.load();
    if (context.mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          _SettingsTile(
            title: l10n.appLanguage,
            subtitle: _languageSubtitle(l10n),
            onTap: () => _showLanguagePicker(context),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            title: l10n.unitsOfMeasurement,
            subtitle: AppSettings.measurementUnit == MeasurementUnit.metric
                ? l10n.metricUnits
                : l10n.imperialUnits,
            onTap: () => _showUnitsPicker(context),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            title: l10n.timeDisplayFormat,
            subtitle: AppSettings.timeDisplayFormat == TimeDisplayFormat.h24
                ? l10n.timeFormat24Hour
                : l10n.timeFormat12Hour,
            onTap: () => _showTimeFormatPicker(context),
          ),
        ],
      ),
    );
  }

  String _languageSubtitle(AppLocalizations l10n) {
    switch (AppSettings.language) {
      case AppLanguage.system:
        return l10n.systemLanguage;
      case AppLanguage.en:
        return l10n.languageEnglish;
      case AppLanguage.ru:
        return l10n.languageRussian;
      case AppLanguage.uk:
        return l10n.languageUkrainian;
      case AppLanguage.esUs:
        return l10n.languageSpanishUS;
    }
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final chosen = await showModalBottomSheet<AppLanguage>(
      context: context,
      backgroundColor: const Color(0xFF121212),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                l10n.systemLanguage,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.of(ctx).pop(AppLanguage.system),
            ),
            ListTile(
              title: Text(
                l10n.languageEnglish,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.of(ctx).pop(AppLanguage.en),
            ),
            ListTile(
              title: Text(
                l10n.languageRussian,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.of(ctx).pop(AppLanguage.ru),
            ),
            ListTile(
              title: Text(
                l10n.languageUkrainian,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.of(ctx).pop(AppLanguage.uk),
            ),
            ListTile(
              title: Text(
                l10n.languageSpanishUS,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.of(ctx).pop(AppLanguage.esUs),
            ),
          ],
        ),
      ),
    );
    if (chosen != null) {
      await AppSettings.setLanguage(chosen);
      AppSettings.onLocaleChanged?.call();
      _reloadAndRebuild();
    }
  }

  Future<void> _showUnitsPicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final chosen = await showModalBottomSheet<MeasurementUnit>(
      context: context,
      backgroundColor: const Color(0xFF121212),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                l10n.metricUnits,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.of(ctx).pop(MeasurementUnit.metric),
            ),
            ListTile(
              title: Text(
                l10n.imperialUnits,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.of(ctx).pop(MeasurementUnit.imperial),
            ),
          ],
        ),
      ),
    );
    if (chosen != null) {
      await AppSettings.setMeasurementUnit(chosen);
      _reloadAndRebuild();
    }
  }

  Future<void> _showTimeFormatPicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final chosen = await showModalBottomSheet<TimeDisplayFormat>(
      context: context,
      backgroundColor: const Color(0xFF121212),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                l10n.timeFormat24Hour,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.of(ctx).pop(TimeDisplayFormat.h24),
            ),
            ListTile(
              title: Text(
                l10n.timeFormat12Hour,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.of(ctx).pop(TimeDisplayFormat.h12),
            ),
          ],
        ),
      ),
    );
    if (chosen != null) {
      await AppSettings.setTimeDisplayFormat(chosen);
      _reloadAndRebuild();
    }
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.06),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[600], size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
