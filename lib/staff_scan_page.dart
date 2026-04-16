import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'api/auth_service.dart';
import 'app_settings.dart';
import 'gen_l10n/app_localizations.dart';
import 'staff_info_child_profile_page.dart';

/// Окно сканера QR: референс — тёмный фон, оранжевая рамка и кнопки.
/// Главная: этап. [scanForInfo]: только ивент → lookup → экран профиля.
class StaffScanPage extends StatefulWidget {
  const StaffScanPage({
    super.key,
    required this.auth,
    required this.accent,
    required this.backgroundColor,
    this.scanForInfo = false,
    this.parkingScan = false,
  });

  final AuthService auth;
  final Color accent;
  final Color backgroundColor;

  /// Режим «Прочее» → Scan for Info (без выбранного этапа).
  final bool scanForInfo;

  /// Режим парковщика: lookup парковочного QR и окно результата.
  final bool parkingScan;

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
    if (_processing) return;

    if (widget.parkingScan) {
      setState(() => _processing = true);
      await _controller.stop();
      try {
        final result = await widget.auth.parkingScanLookup(code: code);
        if (!mounted) return;
        await _showParkingResultDialog(result);
      } catch (e) {
        if (!mounted) return;
        await _showScanErrorDialog(e.toString());
      } finally {
        if (mounted) {
          setState(() => _processing = false);
          await _controller.start();
        }
      }
      return;
    }

    if (widget.scanForInfo) {
      setState(() => _processing = true);
      await _controller.stop();
      try {
        final detail = await widget.auth.scanInfoLookup(badgeCode: code);
        if (!mounted) return;
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => StaffInfoChildProfilePage(
              detail: detail,
              baseUrl: widget.auth.baseUrl,
              accent: widget.accent,
              backgroundColor: widget.backgroundColor,
            ),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.staffScanFailed(e.toString())),
            backgroundColor: Colors.redAccent,
          ),
        );
        setState(() => _processing = false);
        await _controller.start();
      }
      return;
    }

    final eventId = AppSettings.staffActiveEventId;
    final stageId = AppSettings.staffActiveStageId;
    final stageType = AppSettings.staffActiveStageType ?? 'main';
    final roleCode = AppSettings.staffSelectedRoleCode;
    if (eventId == null || stageId == null) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.staffScanSelectEventStageFirst),
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
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.message.isNotEmpty
                ? result.message
                : l10n.staffScanProcessed,
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
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.staffScanFailed(e.toString())),
          backgroundColor: Colors.redAccent,
        ),
      );
      setState(() => _processing = false);
      await _controller.start();
    }
  }

  Widget _buildHeader(Color accent) {
    final l10n = AppLocalizations.of(context)!;
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
          Text(
            widget.parkingScan
                ? l10n.staffScanHeaderParking
                : (widget.scanForInfo
                      ? l10n.staffScanHeaderInfo
                      : l10n.staffScanHeaderQr),
            style: const TextStyle(
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
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        widget.parkingScan
            ? l10n.staffScanHintParking
            : (widget.scanForInfo
                  ? l10n.staffScanHintInfo
                  : l10n.staffScanHintQr),
        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> _showScanErrorDialog(String message) async {
    final l10n = AppLocalizations.of(context)!;
    final cleaned = message.trim().isEmpty
        ? l10n.staffScanErrorUnknown
        : message.trim();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: const Color(0xFF131313),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.staffScanErrorTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      icon: const Icon(Icons.close, color: Colors.white70),
                      tooltip: l10n.close,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  cleaned,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showParkingResultDialog(ParkingScanLookupResult result) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        Widget row(String label, String value) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? '—' : value,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          );
        }

        return Dialog(
          backgroundColor: const Color(0xFF131313),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.staffParkingTicketTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      icon: const Icon(Icons.close, color: Colors.white70),
                      tooltip: l10n.close,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                row(l10n.staffParkingFieldEvent, result.eventName),
                row(l10n.staffParkingFieldClient, result.clientName),
                row(l10n.staffParkingFieldCar, result.carModel),
                row(l10n.staffParkingFieldPlateNumber, result.plateNumber),
                row(
                  l10n.staffParkingFieldVipClient,
                  result.isVipClient ? l10n.staffYes : l10n.staffNo,
                ),
              ],
            ),
          ),
        );
      },
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
