import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'api/auth_service.dart';
import 'gen_l10n/app_localizations.dart';

enum _ContractPreviewAction { cancel, sign, confirm }

Future<bool> ensureContractSignedBeforeTicketPurchase(
  BuildContext context, {
  required AuthService auth,
}) async {
  final l10n = AppLocalizations.of(context)!;
  ClientContractStatus status;
  try {
    status = await auth.getClientContractStatus();
  } catch (e) {
    if (!context.mounted) return false;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(e.toString())));
    return false;
  }

  if (status.hasContract) {
    return true;
  }

  if (!context.mounted) return false;
  final wantsView = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.contractWarningTitle),
      content: Text(
        status.warningText.isNotEmpty
            ? status.warningText
            : l10n.contractWarningFallbackText,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(l10n.contractViewButton),
        ),
      ],
    ),
  );

  if (wantsView != true || !context.mounted) {
    return false;
  }

  Uint8List? signatureBytes;
  while (context.mounted) {
    final action = await showDialog<_ContractPreviewAction>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.contractPreviewTitle),
          content: SizedBox(
            width: 540,
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(14),
                child: _ContractBodyView(
                  templateBody: status.templateBody,
                  displayName: status.displayName,
                  displayDate: status.displayDate,
                  signatureBytes: signatureBytes,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(ctx).pop(_ContractPreviewAction.cancel),
              child: Text(l10n.cancel),
            ),
            if (signatureBytes == null)
              FilledButton(
                onPressed: () =>
                    Navigator.of(ctx).pop(_ContractPreviewAction.sign),
                child: Text(l10n.contractSignButton),
              )
            else
              FilledButton(
                onPressed: () =>
                    Navigator.of(ctx).pop(_ContractPreviewAction.confirm),
                child: const Text('OK'),
              ),
          ],
        );
      },
    );

    if (action == null || action == _ContractPreviewAction.cancel) {
      return false;
    }

    if (action == _ContractPreviewAction.sign) {
      if (!context.mounted) return false;
      final signed = await showDialog<Uint8List>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => _SignatureDialog(),
      );
      if (signed == null || signed.isEmpty) {
        continue;
      }
      signatureBytes = signed;
      continue;
    }

    if (action == _ContractPreviewAction.confirm) {
      if (signatureBytes == null || signatureBytes.isEmpty) {
        continue;
      }
      try {
        await auth.signClientContract(
          signatureDataUrl:
              'data:image/png;base64,${base64Encode(signatureBytes)}',
        );
        if (!context.mounted) return false;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.contractSignedSuccess)));
        return true;
      } catch (e) {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
        return false;
      }
    }
  }

  return false;
}

class _ContractBodyView extends StatelessWidget {
  const _ContractBodyView({
    required this.templateBody,
    required this.displayName,
    required this.displayDate,
    required this.signatureBytes,
  });

  final String templateBody;
  final String displayName;
  final String displayDate;
  final Uint8List? signatureBytes;

  @override
  Widget build(BuildContext context) {
    final text =
        (templateBody.trim().isNotEmpty
                ? templateBody
                : '#name# #date# #signature#')
            .replaceAll('#name#', displayName)
            .replaceAll('#date#', displayDate);

    final parts = text.split('#signature#');
    final spans = <InlineSpan>[];
    for (var i = 0; i < parts.length; i++) {
      final part = parts[i];
      if (part.isNotEmpty) {
        spans.add(
          TextSpan(
            text: part,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              height: 1.45,
            ),
          ),
        );
      }
      if (i < parts.length - 1) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: signatureBytes == null
                  ? Container(
                      width: 360,
                      height: 96,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    )
                  : Image.memory(
                      signatureBytes!,
                      height: 120,
                      width: 440,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
        );
      }
    }

    return SelectableText.rich(TextSpan(children: spans));
  }
}

class _SignatureDialog extends StatefulWidget {
  @override
  State<_SignatureDialog> createState() => _SignatureDialogState();
}

class _SignatureDialogState extends State<_SignatureDialog> {
  final List<Offset?> _points = <Offset?>[];

  bool get _canSubmit => _points.whereType<Offset>().length > 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const padSize = Size(420, 220);

    return AlertDialog(
      title: Text(l10n.contractSignatureTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: padSize.width,
            height: padSize.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black26),
            ),
            child: GestureDetector(
              onPanStart: (details) {
                setState(() => _points.add(details.localPosition));
              },
              onPanUpdate: (details) {
                setState(() => _points.add(details.localPosition));
              },
              onPanEnd: (_) {
                setState(() => _points.add(null));
              },
              child: CustomPaint(
                painter: _SignaturePainter(points: _points),
                size: padSize,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => setState(_points.clear),
              child: Text(l10n.clear),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: !_canSubmit
              ? null
              : () async {
                  final bytes = await _renderSignatureAsPng(padSize);
                  if (!context.mounted || bytes == null || bytes.isEmpty) {
                    return;
                  }
                  Navigator.of(context).pop(bytes);
                },
          child: const Text('OK'),
        ),
      ],
    );
  }

  Future<Uint8List?> _renderSignatureAsPng(Size size) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);
    _SignaturePainter(points: _points).paint(canvas, size);

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}

class _SignaturePainter extends CustomPainter {
  const _SignaturePainter({required this.points});

  final List<Offset?> points;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      if (p1 != null && p2 != null) {
        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) {
    // Points list is mutated in place during pan updates; always repaint.
    return true;
  }
}
