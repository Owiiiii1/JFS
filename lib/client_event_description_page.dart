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
    this.showGeolocation = false,
  });

  final AuthService auth;
  final int eventId;
  final bool showGeolocation;

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
    final eventName = (_data?.eventName ?? '').trim();
    final city = (_data?.city ?? '').trim();
    final location = (_data?.location ?? '').trim();
    final geolocationTitle = [city, location]
        .where((s) => s.isNotEmpty)
        .join(', ');
    final showGeolocation =
        widget.showGeolocation && geolocationTitle.isNotEmpty;
    return RefreshIndicator(
      color: _kGold,
      onRefresh: _load,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl != null)
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, error, stackTrace) => Container(
                        color: const Color(0xFF1A1A1A),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.white38,
                          size: 38,
                        ),
                      ),
                    )
                  else
                    Container(color: const Color(0xFF1A1A1A)),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 28,
                    child: Text(
                      eventName.isNotEmpty ? eventName : l10n.eventDescriptionTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -18),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showGeolocation)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: InkWell(
                            onTap: _openGeolocation,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: _kGold.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _kGold.withOpacity(0.35),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_rounded,
                                    color: _kGold,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      geolocationTitle,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
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
                      if (desc.isNotEmpty)
                        SelectableText(
                          desc,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        )
                      else
                        Text(
                          l10n.eventDescriptionEmpty,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
