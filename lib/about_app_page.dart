import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'gen_l10n/app_localizations.dart';

const Color _kGoldPrimary = Color(0xFFF2CA50);
const Color _kGoldDeep = Color(0xFFD4AF37);
const Color _kMuted = Color(0xFF9A9A9A);
const Color _kPublisherMuted = Color(0xFFD0C5AF);

/// Дата релиза для экрана «О приложении» (месяц/год показываются по локали).
/// Обновляйте при публикации новой версии в сторах.
final DateTime kAboutStoreReleaseDate = DateTime(2026, 4, 1);

final Uri _kOwlSolutionsUri = Uri.parse('https://owlsolutions.net/');

/// Экран «О приложении»: версия из [PackageInfo], дата релиза из [kAboutStoreReleaseDate].
class AboutAppPage extends StatefulWidget {
  const AboutAppPage({super.key});

  @override
  State<AboutAppPage> createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  PackageInfo? _info;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _info = info;
      _loading = false;
    });
  }

  Future<void> _openOwlSolutions() async {
    if (!await canLaunchUrl(_kOwlSolutionsUri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.aboutLinkCouldNotOpen)),
        );
      }
      return;
    }
    await launchUrl(_kOwlSolutionsUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    String versionLine = '—';
    if (_info != null) {
      final b = _info!.buildNumber;
      versionLine = b.isEmpty || b == '0'
          ? _info!.version
          : '${_info!.version} ($b)';
    }

    String releaseLine = '—';
    if (!_loading) {
      releaseLine = DateFormat.yMMMM(locale).format(kAboutStoreReleaseDate);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.close, color: _kGoldPrimary, size: 22),
                    tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  ),
                  const Expanded(
                    child: Text(
                      'YFS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _kGoldPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: _kGoldPrimary,
                        strokeWidth: 2,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        children: [
                          const SizedBox(height: 32),
                          Text(
                            l10n.aboutAppDisplayName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: _kGoldDeep,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              height: 1.15,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.aboutPublisherLine,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: _kPublisherMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2.4,
                            ),
                          ),
                          const SizedBox(height: 56),
                          Text(
                            l10n.aboutVersionLabel,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: _kGoldPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            versionLine,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 48),
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            l10n.aboutReleaseDateLabel,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: _kGoldPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            releaseLine,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.aboutDevelopedByPrefix,
                        style: const TextStyle(
                          color: _kMuted,
                          fontSize: 11,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: _openOwlSolutions,
                        child: Text(
                          l10n.aboutDeveloperBrand,
                          style: const TextStyle(
                            color: _kGoldPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        size: 22,
                        color: Colors.white.withValues(alpha: 0.28),
                      ),
                      const SizedBox(width: 28),
                      Icon(
                        Icons.workspace_premium_outlined,
                        size: 22,
                        color: Colors.white.withValues(alpha: 0.28),
                      ),
                      const SizedBox(width: 28),
                      Icon(
                        Icons.shield_outlined,
                        size: 22,
                        color: Colors.white.withValues(alpha: 0.28),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
