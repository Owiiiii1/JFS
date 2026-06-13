import 'package:flutter/material.dart';
import 'api/auth_service.dart';
import 'faq_article_detail_page.dart';
import 'gen_l10n/app_localizations.dart';

// Как в разделе Info: чёрный фон, золотой акцент
const _kGold = Color(0xFFD4AF37);

/// Список статей раздела FAQ в стиле референса (Shows & Runway): заголовок + N Articles, строки с заголовком и превью.
class FaqArticlesPage extends StatefulWidget {
  const FaqArticlesPage({
    super.key,
    required this.auth,
    required this.sectionId,
    required this.sectionName,
    this.sectionPhotoUrl,
  });

  final AuthService auth;
  final int sectionId;
  final String sectionName;
  final String? sectionPhotoUrl;

  @override
  State<FaqArticlesPage> createState() => _FaqArticlesPageState();
}

class _FaqArticlesPageState extends State<FaqArticlesPage> {
  List<FaqArticleItem>? _articles;
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
      final articles = await widget.auth.getFaqSectionArticles(widget.sectionId);
      if (!mounted) return;
      setState(() {
        _articles = articles;
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

  /// Краткое превью текста статьи (без HTML), одна строка.
  static String _articlePreview(String? body) {
    if (body == null || body.isEmpty) return '';
    final stripped = body
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (stripped.length <= 60) return stripped;
    return '${stripped.substring(0, 60)}...';
  }

  String? _absoluteMediaUrl(String? u) {
    if (u == null || u.isEmpty) return null;
    if (u.startsWith('http')) return u;
    final base = widget.auth.baseUrl;
    return base.endsWith('/')
        ? '$base${u.replaceFirst(RegExp(r'^/'), '')}'
        : '$base$u';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: _kGold,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.sectionName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (_articles != null)
              Text(
                '${_articles!.length} ${_articles!.length == 1 ? 'Article' : 'Articles'}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _kGold,
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
                      SizedBox(
                        height: 250,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (_absoluteMediaUrl(widget.sectionPhotoUrl) != null)
                              Image.network(
                                _absoluteMediaUrl(widget.sectionPhotoUrl)!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: const Color(0xFF161616),
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.article_outlined,
                                    color: Colors.white24,
                                    size: 40,
                                  ),
                                ),
                              )
                            else
                              Container(
                                color: const Color(0xFF161616),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.article_outlined,
                                  color: Colors.white24,
                                  size: 40,
                                ),
                              ),
                            Positioned(
                              left: 20,
                              right: 20,
                              bottom: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.sectionName,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      height: 1.12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${_articles?.length ?? 0} ${(_articles?.length ?? 0) == 1 ? 'Article' : 'Articles'}',
                                    style: TextStyle(
                                      color: _kGold.withOpacity(0.95),
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.0,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
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
                            decoration: BoxDecoration(
                              color: const Color(0xFF131313),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.04),
                              ),
                            ),
                            child: _articles == null || _articles!.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Text(
                                      'No articles yet',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.65),
                                        fontSize: 14,
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      for (int i = 0; i < _articles!.length; i++) ...[
                                        if (i > 0)
                                          Divider(
                                            height: 1,
                                            color: _kGold.withOpacity(0.2),
                                            thickness: 1,
                                          ),
                                        _ArticleRow(
                                          title: _articles![i].title,
                                          preview: _articlePreview(
                                            _articles![i].body,
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute<void>(
                                                builder: (_) =>
                                                    FaqArticleDetailPage(
                                                  article: _articles![i],
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
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
    );
  }
}

class _ArticleRow extends StatefulWidget {
  const _ArticleRow({
    required this.title,
    required this.preview,
    required this.onTap,
  });

  final String title;
  final String preview;
  final VoidCallback onTap;

  @override
  State<_ArticleRow> createState() => _ArticleRowState();
}

class _ArticleRowState extends State<_ArticleRow> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  if (widget.preview.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.chevron_right,
              color: _kGold,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
