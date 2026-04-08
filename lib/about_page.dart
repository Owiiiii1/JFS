import 'package:flutter/material.dart';
import 'api/auth_service.dart';
import 'block_detail_page.dart';
import 'gen_l10n/app_localizations.dart';

const _kCardBg = Color(0xFF121212);
const _kAccentGray = Color(0xFF8E8E93);

/// Экран «О нас»: в AppBar тот же логотип, что в шапке клиентского приложения (`assets/logo.png`).
/// По нажатию на блок открывается экран с названием и текстом блока.
class AboutPage extends StatefulWidget {
  const AboutPage({super.key, required this.auth});

  final AuthService auth;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  AppAboutData? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await widget.auth.getAppAbout();
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String _photoUrl(AppAboutData d) {
    final u = d.photoUrl;
    if (u == null || u.isEmpty) return '';
    final base = widget.auth.baseUrl;
    return u.startsWith('http') ? u : '$base$u';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/logo.png',
          height: 32,
          filterQuality: FilterQuality.high,
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white54),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _load,
                          child: Text(AppLocalizations.of(context)!.retry),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ABOUT US',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.bold,
                            color: _kAccentGray,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_data != null) ...[
                        // Photo
                        if (_photoUrl(_data!).isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.network(
                                _photoUrl(_data!),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: _kCardBg,
                                  child: const Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 48,
                                    color: Colors.white24,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: _kCardBg,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.image_outlined,
                              size: 48,
                              color: Colors.white24,
                            ),
                          ),
                        const SizedBox(height: 24),
                        // Main text
                        if (_data!.mainText != null && _data!.mainText!.isNotEmpty)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _data!.mainText!,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.5,
                                color: Colors.white.withOpacity(0.85),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        const SizedBox(height: 32),
                        // Common Inquiries
                        if (_data!.blocks.isNotEmpty) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'COMMON INQUIRIES',
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.bold,
                                color: _kAccentGray,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A0A0A),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.05),
                              ),
                            ),
                            child: Column(
                              children: [
                                for (int i = 0; i < _data!.blocks.length; i++) ...[
                                  if (i > 0)
                                    Divider(
                                      height: 1,
                                      color: Colors.white.withOpacity(0.05),
                                    ),
                                  _InquiryRow(
                                    label: _data!.blocks[i].name,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) => BlockDetailPage(
                                            title: _data!.blocks[i].name,
                                            text: _data!.blocks[i].text,
                                            baseUrl: widget.auth.baseUrl,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
    );
  }
}

class _InquiryRow extends StatelessWidget {
  const _InquiryRow({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: _kAccentGray,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
