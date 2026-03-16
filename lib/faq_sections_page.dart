import 'package:flutter/material.dart';
import 'api/auth_service.dart';
import 'faq_articles_page.dart';

// Как в разделе Info: чёрный фон, золотой акцент
const _kGold = Color(0xFFD4AF37);
const _kCardBg = Color(0xFF121212);

/// Экран разделов FAQ: карточки-картинки с названием (референс Concierge).
/// Фото разделов из админки (photo_url по разделу).
class FaqSectionsPage extends StatefulWidget {
  const FaqSectionsPage({super.key, required this.auth});

  final AuthService auth;

  @override
  State<FaqSectionsPage> createState() => _FaqSectionsPageState();
}

class _FaqSectionsPageState extends State<FaqSectionsPage> {
  List<FaqSectionItem>? _sections;
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
      final sections = await widget.auth.getFaqSections();
      if (!mounted) return;
      setState(() {
        _sections = sections;
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

  String? _sectionPhotoUrl(FaqSectionItem section) {
    final u = section.photoUrl;
    if (u == null || u.isEmpty) return null;
    if (u.startsWith('http')) return u;
    final base = widget.auth.baseUrl;
    return base.endsWith('/') ? '$base${u.replaceFirst(RegExp(r'^/'), '')}' : '$base$u';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'YFS',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _kGold,
                letterSpacing: -0.5,
              ),
            ),
            Container(
              width: 1,
              height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.white38,
            ),
            Text(
              'FAQ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: _kGold),
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
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          children: [
                            const TextSpan(
                              text: 'How can we\n',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'assist you today?',
                              style: TextStyle(color: _kGold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Curated support for your little one\'s wardrobe.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      if (_sections != null && _sections!.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: Text(
                            'No sections yet',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        )
                      else if (_sections != null) ...[
                        const SizedBox(height: 24),
                        for (final section in _sections!) _SectionCard(
                          section: section,
                          photoUrl: _sectionPhotoUrl(section),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => FaqArticlesPage(
                                  auth: widget.auth,
                                  sectionId: section.id,
                                  sectionName: section.name,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}

class _SectionCard extends StatefulWidget {
  const _SectionCard({
    required this.section,
    required this.photoUrl,
    required this.onTap,
  });

  final FaqSectionItem section;
  final String? photoUrl;
  final VoidCallback onTap;

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 192,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.photoUrl != null)
                    Image.network(
                      widget.photoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  else
                    _placeholder(),
                  // Затемнение снизу для читаемости текста
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.85),
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.section.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Tap to view articles',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
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

  Widget _placeholder() {
    return Container(
      color: _kCardBg,
      child: Icon(
        Icons.folder_outlined,
        size: 48,
        color: Colors.white24,
      ),
    );
  }
}
