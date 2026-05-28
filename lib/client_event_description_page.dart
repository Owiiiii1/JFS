import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api/auth_service.dart';
import 'gen_l10n/app_localizations.dart';

const _kBg = Color(0xFF131313);
const _kGold = Color(0xFFF2CA50);

/// Описание ивента: первое фото и текст с вкладки «Описание» в админке.
class ClientEventDescriptionPage extends StatefulWidget {
  const ClientEventDescriptionPage({
    super.key,
    required this.auth,
    required this.eventId,
  });

  final AuthService auth;
  final int eventId;

  @override
  State<ClientEventDescriptionPage> createState() =>
      _ClientEventDescriptionPageState();
}

class _ClientEventDescriptionPageState extends State<ClientEventDescriptionPage> {
  EventDescriptionInfo? _data;
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
      final d = await widget.auth.getClientEventDescription(widget.eventId);
      if (!mounted) return;
      setState(() {
        _data = d;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  String? get _resolvedImageUrl {
    final raw = _data?.imageUrl?.trim();
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    if (raw.startsWith('/')) {
      return '${widget.auth.baseUrl}$raw';
    }
    return '${widget.auth.baseUrl}/$raw';
  }

  String? _normalizeHttpUrl(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return null;
    if (t.startsWith('http://') || t.startsWith('https://')) return t;
    if (t.startsWith('/')) return '${widget.auth.baseUrl}$t';
    return 'https://$t';
  }

  Future<void> _openGeolocation() async {
    final l10n = AppLocalizations.of(context)!;
    final normalized = _normalizeHttpUrl(_data?.geolocationUrl ?? '');
    if (normalized == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.aboutLinkCouldNotOpen)),
      );
      return;
    }
    final uri = Uri.tryParse(normalized);
    if (uri == null || !uri.hasScheme) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.aboutLinkCouldNotOpen)),
      );
      return;
    }
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.aboutLinkCouldNotOpen)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kBg,
        foregroundColor: _kGold,
        elevation: 0,
        title: Text(
          l10n.eventDescriptionTitle,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _kGold))
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.eventDescriptionLoadFailed,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _load,
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            )
          : _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    final imageUrl = _resolvedImageUrl;
    final desc = (_data?.description ?? '').trim();
    final city = (_data?.city ?? '').trim();
    final location = (_data?.location ?? '').trim();
    final geolocationTitle = [city, location]
        .where((s) => s.isNotEmpty)
        .join(', ');
    final hasGeolocationLabel = geolocationTitle.isNotEmpty;
    return RefreshIndicator(
      color: _kGold,
      onRefresh: _load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
            if (hasGeolocationLabel)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: InkWell(
                  onTap: _openGeolocation,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: _kGold.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _kGold.withOpacity(0.35)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: _kGold,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            geolocationTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
              child: desc.isNotEmpty
                  ? SelectableText(
                      desc,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.45,
                      ),
                    )
                  : Text(
                      l10n.eventDescriptionEmpty,
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
