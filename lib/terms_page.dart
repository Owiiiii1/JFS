import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'api/auth_service.dart';

const _kCardBg = Color(0xFF121212);

/// Экран «Terms & Conditions»: фото сверху, текст снизу.
class TermsPage extends StatefulWidget {
  const TermsPage({super.key, required this.auth});

  final AuthService auth;

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  AppTermsData? _data;
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
      final data = await widget.auth.getAppTerms();
      if (!mounted) return;
      setState(() {
        _data = data;
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

  String _photoUrl(AppTermsData d) {
    final u = d.photoUrl;
    if (u == null || u.isEmpty) return '';
    final base = widget.auth.baseUrl;
    return u.startsWith('http') ? u : '$base$u';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white54),
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
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: _load,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_data != null) ...[
                        if (_photoUrl(_data!).isNotEmpty)
                          AspectRatio(
                            aspectRatio: 16 / 10,
                            child: Image.network(
                              _photoUrl(_data!),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: _kCardBg,
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 48,
                                  color: Colors.white24,
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
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                          child: _buildBody(),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildBody() {
    final body = _data?.body;
    if (body == null || body.isEmpty) {
      return const SizedBox.shrink();
    }
    final isHtml = body.contains('<') && body.contains('>');
    if (isHtml) {
      return HtmlWidget(
        body,
        textStyle: TextStyle(
          fontSize: 15,
          height: 1.5,
          color: Colors.white.withOpacity(0.85),
        ),
        baseUrl: Uri.tryParse(widget.auth.baseUrl),
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
