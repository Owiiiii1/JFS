import 'package:flutter/material.dart';
import 'api/auth_service.dart';
import 'app_rich_html_body.dart';

const _kCardBg = Color(0xFF121212);

/// Экран детали новости: сверху картинка, ниже заголовок, ниже текст.
class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({super.key, required this.news, required this.baseUrl});

  final AppNewsItem news;
  final String baseUrl;

  String get _photoUrl {
    final u = news.photoUrl;
    if (u == null || u.isEmpty) return '';
    return u.startsWith('http') ? u : '$baseUrl$u';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_photoUrl.isNotEmpty)
                    Image.network(
                      _photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: _kCardBg,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 44,
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
                        size: 44,
                        color: Colors.white24,
                      ),
                    ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 24,
                    child: Text(
                      news.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                        height: 1.15,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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
                    border: Border.all(color: Colors.white.withOpacity(0.04)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: _buildBodyContent(),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent() {
    final body = news.body;
    if (body == null || body.isEmpty) return const SizedBox.shrink();
    // Если в тексте есть HTML-теги — рендерим как HTML (форматирование, картинки из админки).
    final isHtml = body.contains('<') && body.contains('>');
    if (isHtml) {
      return buildAppRichHtmlBody(
        html: body,
        textStyle: TextStyle(
          fontSize: 15,
          height: 1.5,
          color: Colors.white.withOpacity(0.85),
        ),
        baseUrl: Uri.tryParse(baseUrl),
      );
    }
    return Text(
      body,
      style: TextStyle(
        fontSize: 15,
        height: 1.5,
        color: Colors.white.withOpacity(0.85),
      ),
    );
  }
}
