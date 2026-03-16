import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'api/auth_service.dart';
import 'app_settings.dart';

/// Окно сканера QR: референс — тёмный фон, оранжевая рамка и кнопки.
/// Открывается с главной (кнопка Scan) и из «Прочее» (Scan for Info).
class StaffScanPage extends StatefulWidget {
  const StaffScanPage({
    super.key,
    required this.auth,
    required this.accent,
    required this.backgroundColor,
  });

  final AuthService auth;
  final Color accent;
  final Color backgroundColor;

  @override
  State<StaffScanPage> createState() => _StaffScanPageState();
}

class _StaffScanPageState extends State<StaffScanPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  bool _torchOn = false;
  bool _processing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accent;
    final bg = widget.backgroundColor;
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(accent),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRect(
                    child: MobileScanner(
                      controller: _controller,
                      onDetect: (capture) {
                        if (_processing) return;
                        final barcodes = capture.barcodes;
                        if (barcodes.isEmpty) return;
                        final code = barcodes.first.rawValue;
                        if (code != null && code.isNotEmpty) {
                          _onScanned(code);
                        }
                      },
                    ),
                  ),
                  _buildFrameOverlay(accent),
                ],
              ),
            ),
            _buildHint(accent),
            _buildActions(accent),
            SizedBox(height: 16 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Future<void> _onScanned(String code) async {
    final eventId = AppSettings.staffActiveEventId;
    final stageId = AppSettings.staffActiveStageId;
    final stageType = AppSettings.staffActiveStageType ?? 'main';
    final roleCode = AppSettings.staffSelectedRoleCode;
    if (eventId == null || stageId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Select active event and stage in Staff Settings before scanning.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    setState(() => _processing = true);
    await _controller.stop();
    try {
      final result = await widget.auth.submitStageScan(
        badgeCode: code,
        eventId: eventId,
        stageId: stageId,
        stageType: stageType,
        roleCode: roleCode,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.message.isNotEmpty ? result.message : 'Scan processed',
          ),
          backgroundColor: result.isSuccess ? widget.accent : Colors.redAccent,
        ),
      );
      if (result.isSuccess) {
        Navigator.of(context).pop();
      } else {
        setState(() => _processing = false);
        await _controller.start();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scan failed: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
      setState(() => _processing = false);
      await _controller.start();
    }
  }

  Widget _buildHeader(Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => Navigator.of(context).pop(),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),
          const Text(
            'Scan QR Code',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Material(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                setState(() => _torchOn = !_torchOn);
                _controller.toggleTorch();
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  _torchOn ? Icons.flash_on : Icons.flashlight_on_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrameOverlay(Color accent) {
    return IgnorePointer(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  _corner(accent, Alignment.topLeft),
                  _corner(accent, Alignment.topRight),
                  _corner(accent, Alignment.bottomLeft),
                  _corner(accent, Alignment.bottomRight),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _corner(Color accent, Alignment align) {
    final isTop = align.y <= 0;
    final isLeft = align.x <= 0;
    return Align(
      alignment: align,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? BorderSide(color: accent, width: 4) : BorderSide.none,
            bottom: !isTop
                ? BorderSide(color: accent, width: 4)
                : BorderSide.none,
            left: isLeft
                ? BorderSide(color: accent, width: 4)
                : BorderSide.none,
            right: !isLeft
                ? BorderSide(color: accent, width: 4)
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: align == Alignment.topLeft
                ? const Radius.circular(20)
                : Radius.zero,
            topRight: align == Alignment.topRight
                ? const Radius.circular(20)
                : Radius.zero,
            bottomLeft: align == Alignment.bottomLeft
                ? const Radius.circular(20)
                : Radius.zero,
            bottomRight: align == Alignment.bottomRight
                ? const Radius.circular(20)
                : Radius.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildHint(Color accent) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        'Align QR Code within the frame',
        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
      ),
    );
  }

  Widget _buildActions(Color accent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _actionButton(Icons.photo_library_outlined, onTap: () {}),
        const SizedBox(width: 32),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: const Icon(
            Icons.qr_code_scanner,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(width: 32),
        _actionButton(Icons.history, onTap: () {}),
      ],
    );
  }

  Widget _actionButton(IconData icon, {VoidCallback? onTap}) {
    return Material(
      color: Colors.black.withOpacity(0.4),
      shape: const CircleBorder(side: BorderSide(color: Colors.white12)),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
