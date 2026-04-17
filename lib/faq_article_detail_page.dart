import 'package:flutter/material.dart';
import 'api/auth_service.dart';
import 'app_rich_html_body.dart';

// Как в разделе Info: чёрный фон
const _kCardBg = Color(0xFF121212);

/// Экран статьи FAQ: сверху картинка из админки, под ней контент с форматированием (референс).
class FaqArticleDetailPage extends StatelessWidget {
  const FaqArticleDetailPage({super.key, required this.article, this.baseUrl});

  final FaqArticleItem article;
  final String? baseUrl;

  String? _photoUrl() {
    final u = article.photoUrl;
    if (u == null || u.isEmpty) return null;
    if (u.startsWith('http')) return u;
    final base = baseUrl ?? '';
    if (base.isEmpty) return u;
    return base.endsWith('/')
        ? '$base${u.replaceFirst(RegExp(r'^/'), '')}'
        : '$base$u';
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = _photoUrl();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Блок с картинкой и заголовком поверх
          SizedBox(
            height: 280,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (photoUrl != null)
                  Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                else
                  _placeholder(),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                        Colors.black,
                      ],
                      stops: const [0.3, 0.7, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  child: Material(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => Navigator.of(context).pop(),
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 24,
                  child: Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Контент статьи
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: _kCardBg,
      child: const Icon(Icons.image_outlined, size: 48, color: Colors.white24),
    );
  }

  Widget _buildContent() {
    final raw = article.body ?? '';
    if (raw.isEmpty) {
      return const SizedBox.shrink();
    }
    final isHtml = raw.contains('<') && raw.contains('>');
    if (isHtml && baseUrl != null) {
      return buildAppRichHtmlBody(
        html: raw,
        textStyle: TextStyle(
          fontSize: 15,
          height: 1.6,
          color: Colors.white.withOpacity(0.9),
        ),
        baseUrl: Uri.tryParse(baseUrl!),
      );
    }
    if (isHtml) {
      return buildAppRichHtmlBody(
        html: raw,
        textStyle: TextStyle(
          fontSize: 15,
          height: 1.6,
          color: Colors.white.withOpacity(0.9),
        ),
      );
    }
    return Text(
      raw,
      style: TextStyle(
        fontSize: 15,
        height: 1.6,
        color: Colors.white.withOpacity(0.9),
      ),
    );
  }
}
