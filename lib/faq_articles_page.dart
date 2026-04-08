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
  });

  final AuthService auth;
  final int sectionId;
  final String sectionName;

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
              : _articles == null || _articles!.isEmpty
                  ? Center(
                      child: Text(
                        'No articles yet',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _articles!.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: _kGold.withOpacity(0.2),
                        thickness: 1,
                      ),
                      itemBuilder: (context, i) {
                        final article = _articles![i];
                        return _ArticleRow(
                          title: article.title,
                          preview: _articlePreview(article.body),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => FaqArticleDetailPage(
                                  article: article,
                                  baseUrl: widget.auth.baseUrl,
                                ),
                              ),
                            );
                          },
                        );
                      },
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
