import 'package:flutter/material.dart';

import 'app_rich_html_body.dart';

/// Экран с заголовком сверху и текстом снизу (для блока «О нас»).
class BlockDetailPage extends StatelessWidget {
  const BlockDetailPage({
    super.key,
    required this.title,
    required this.text,
    this.baseUrl,
  });

  final String title;
  final String text;
  final String? baseUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }
    final isHtml = text.contains('<') && text.contains('>');
    if (isHtml && baseUrl != null) {
      return buildAppRichHtmlBody(
        html: text,
        textStyle: TextStyle(
          fontSize: 15,
          height: 1.5,
          color: Colors.white.withOpacity(0.85),
        ),
        baseUrl: Uri.tryParse(baseUrl!),
      );
    }
    if (isHtml) {
      return buildAppRichHtmlBody(
        html: text,
        textStyle: TextStyle(
          fontSize: 15,
          height: 1.5,
          color: Colors.white.withOpacity(0.85),
        ),
      );
    }
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        height: 1.5,
        color: Colors.white.withOpacity(0.85),
      ),
    );
  }
}
