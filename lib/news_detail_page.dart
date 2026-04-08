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
            if (_photoUrl.isNotEmpty)
              AspectRatio(
                // Taller than 16:10 so preview photos (often portraits) have more room;
                // BoxFit.contain shows the full image without cropping faces.
                aspectRatio: 4 / 3,
                child: ColoredBox(
                  color: Colors.black,
                  child: Image.network(
                    _photoUrl,
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
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
                height: 200,
                color: _kCardBg,
                child: const Icon(
                  Icons.image_outlined,
                  size: 48,
                  color: Colors.white24,
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Text(
                news.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: _buildBodyContent(),
            ),
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
