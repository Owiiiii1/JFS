import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';

import 'api/auth_service.dart';
import 'gen_l10n/app_localizations.dart';

/// Полноэкранный просмотр PDF билета (локальный рендер через pdfx).
/// На телефоне [PdfViewPinch] — масштаб двумя пальцами (pinch), прокрутка по страницам.
class ClientTicketPdfPage extends StatefulWidget {
  const ClientTicketPdfPage({
    super.key,
    required this.auth,
    required this.pdfUrl,
  });

  final AuthService auth;
  final String pdfUrl;

  @override
  State<ClientTicketPdfPage> createState() => _ClientTicketPdfPageState();
}

class _ClientTicketPdfPageState extends State<ClientTicketPdfPage> {
  Object? _error;
  PdfController? _controller;
  PdfControllerPinch? _pinchController;

  /// PdfViewPinch не поддерживается на Windows (pdfx).
  bool get _usePdfView =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  @override
  void initState() {
    super.initState();
    _initPdf();
  }

  Future<void> _initPdf() async {
    try {
      final doc = await _openPdf();
      if (!mounted) return;
      final docFuture = Future<PdfDocument>.value(doc);
      setState(() {
        if (_usePdfView) {
          _controller = PdfController(document: docFuture);
        } else {
          _pinchController = PdfControllerPinch(document: docFuture);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  Future<PdfDocument> _openPdf() async {
    final uri = Uri.parse(widget.pdfUrl);
    final token = await widget.auth.getToken();
    final res = await http.get(
      uri,
      headers: {
        'Accept': 'application/pdf',
        if (token != null && token.isNotEmpty)
          'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}');
    }
    return PdfDocument.openData(res.bodyBytes);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _pinchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bool ready =
        _usePdfView ? _controller != null : _pinchController != null;

    Widget body;
    if (_error != null) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _error.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      );
    } else if (!ready) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = _usePdfView
          ? PdfView(
              controller: _controller!,
              onDocumentError: (err) => setState(() => _error = err),
            )
          : PdfViewPinch(
              controller: _pinchController!,
              padding: 0,
              minScale: 1.0,
              maxScale: 20.0,
              backgroundDecoration: const BoxDecoration(
                color: Color(0xFF1A1A1A),
              ),
              onDocumentError: (err) => setState(() => _error = err),
            );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(l10n.pdfViewerTitle),
      ),
      body: body,
    );
  }
}
