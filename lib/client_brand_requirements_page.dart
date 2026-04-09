import 'package:flutter/material.dart';

import 'api/auth_service.dart';
import 'app_rich_html_body.dart';
import 'gen_l10n/app_localizations.dart';

const _kBrandReqBg = Color(0xFF131313);
const _kBrandReqPrimary = Color(0xFFF2CA50);

class ClientBrandRequirementsPage extends StatelessWidget {
  const ClientBrandRequirementsPage({
    super.key,
    required this.items,
    required this.baseUrl,
    this.appBarTitle,
  });

  final List<BrandRequirementInfo> items;
  final String baseUrl;

  /// Если задан — заголовок AppBar вместо общего «Brand Requirements».
  final String? appBarTitle;

  String? _resolveImageUrl(String? raw) {
    final v = raw?.trim();
    if (v == null || v.isEmpty) {
      return null;
    }
    if (v.startsWith('http://') || v.startsWith('https://')) {
      return v;
    }
    if (v.startsWith('/')) {
      return '$baseUrl$v';
    }
    return '$baseUrl/$v';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _kBrandReqBg,
      appBar: AppBar(
        backgroundColor: _kBrandReqBg,
        foregroundColor: _kBrandReqPrimary,
        elevation: 0,
        title: Text(
          (appBarTitle != null && appBarTitle!.trim().isNotEmpty)
              ? appBarTitle!.trim()
              : l10n.eventSettingsBrandTitle,
        ),
      ),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.brandRequirementsEmpty,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: items.length,
              separatorBuilder: (_, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final item = items[index];
                final imageUrl = _resolveImageUrl(item.imageUrl);
                final html = (item.bodyHtml ?? '').trim();
                final desc = (item.description ?? '').trim();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        item.brandName.isEmpty ? l10n.eventSettingsBrandTitle : item.brandName,
                        style: const TextStyle(
                          color: _kBrandReqPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (desc.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: Text(
                          desc,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
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
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                              l10n.brandRequirementsEmptyItem,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
