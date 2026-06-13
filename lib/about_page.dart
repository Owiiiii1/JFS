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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_data != null) ...[
                        SizedBox(
                          height: 280,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (_photoUrl(_data!).isNotEmpty)
                                Image.network(
                                  _photoUrl(_data!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: _kCardBg,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 42,
                                      color: Colors.white24,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  color: _kCardBg,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.image_outlined,
                                    size: 42,
                                    color: Colors.white24,
                                  ),
                                ),
                              const Positioned(
                                left: 20,
                                right: 20,
                                bottom: 24,
                                child: Text(
                                  'ABOUT US',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0, -16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF131313),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.04),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.35),
                                    blurRadius: 14,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_data!.mainText != null &&
                                      _data!.mainText!.isNotEmpty)
                                    Text(
                                      _data!.mainText!,
                                      style: TextStyle(
                                        fontSize: 15,
                                        height: 1.5,
                                        color: Colors.white.withOpacity(0.85),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  if (_data!.blocks.isNotEmpty) ...[
                                    const SizedBox(height: 26),
                                    Text(
                                      'COMMON INQUIRIES',
                                      style: TextStyle(
                                        fontSize: 11,
                                        letterSpacing: 0.2,
                                        fontWeight: FontWeight.bold,
                                        color: _kAccentGray,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
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
                                          for (int i = 0;
                                              i < _data!.blocks.length;
                                              i++) ...[
                                            if (i > 0)
                                              Divider(
                                                height: 1,
                                                color: Colors.white.withOpacity(
                                                  0.05,
                                                ),
                                              ),
                                            _InquiryRow(
                                              label: _data!.blocks[i].name,
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute<void>(
                                                    builder: (_) =>
                                                        BlockDetailPage(
                                                      title:
                                                          _data!.blocks[i].name,
                                                      text: _data!.blocks[i].text,
                                                      baseUrl:
                                                          widget.auth.baseUrl,
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
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
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
