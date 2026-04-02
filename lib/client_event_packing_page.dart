import 'package:flutter/material.dart';

import 'api/auth_service.dart';
import 'app_rich_html_body.dart';
import 'gen_l10n/app_localizations.dart';

const _kPackingBg = Color(0xFF131313);
const _kPackingPrimary = Color(0xFFF2CA50);

class ClientEventPackingPage extends StatelessWidget {
  const ClientEventPackingPage({
    super.key,
    required this.packing,
    required this.baseUrl,
  });

  final EventPackingInfo packing;
  final String baseUrl;

  String? get _resolvedImageUrl {
    final raw = packing.imageUrl?.trim();
    if (raw == null || raw.isEmpty) {
      return null;
    }
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    if (raw.startsWith('/')) {
      return '$baseUrl$raw';
    }
    return '$baseUrl/$raw';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final imageUrl = _resolvedImageUrl;
    final html = (packing.bodyHtml ?? '').trim();
    return Scaffold(
      backgroundColor: _kPackingBg,
      appBar: AppBar(
        backgroundColor: _kPackingBg,
        foregroundColor: _kPackingPrimary,
        elevation: 0,
        title: Text(l10n.eventSettingsPackingTitle),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imageUrl != null)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, error, stackTrace) => Container(
                    color: Colors.black12,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.white38,
                      size: 38,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              child: html.isNotEmpty
                  ? buildAppRichHtmlBody(
                      html: html,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.45,
                      ),
                      baseUrl: Uri.tryParse(baseUrl),
                    )
                  : Text(
                      l10n.eventPackingEmpty,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
