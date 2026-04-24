import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'api/auth_service.dart';
import 'app_settings.dart';
import 'staff_meal_issue_page.dart';
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
    this.extraZoneScan = false,
    this.backstageScan = false,
    this.rehearsalCheckinScan = false,
    this.rehearsalSlotId,
    this.qrCheck = false,
    this.mealHandoutScan = false,
    this.staffRoleId,
    this.hostessMode = false,
    this.hostessExitMode = false,
    this.hostessEventId,
    this.hostessStageId,
    this.hostessStageType,
    this.hostessRoleCode,
    this.contextEventId,
    this.contextStageId,
    this.contextStageType,
    this.contextRoleCode,
  });

  final AuthService auth;
  final Color accent;
  final Color backgroundColor;

  /// Режим «Прочее» → Scan for Info (без выбранного этапа).
  final bool scanForInfo;

  /// Режим парковщика: lookup парковочного QR и окно результата.
  final bool parkingScan;

  /// Режим входа в extra-зону: lookup extra ticket QR и окно результата.
  final bool extraZoneScan;

  /// Режим входа в бекстейдж: lookup backstage ticket QR и окно результата.
  final bool backstageScan;

  /// Режим чекина репетиций: скан check-in QR и закрытие preparatory rehearsal этапа.
  final bool rehearsalCheckinScan;
  final int? rehearsalSlotId;

  /// Режим «QR check»: как универсальный скан (этап из настроек), после успеха — модалка, затем карточка ребёнка как Scan for Info.
  final bool qrCheck;

  /// Режим выдачи обедов: скан бейджа → список заказов, подтверждение is_issued.
  final bool mealHandoutScan;

  /// [mealHandoutScan]: id роли воркера (связь этапов в staff_role_stages).
  final int? staffRoleId;

  /// Режим хостесс: отдельные сценарии вход/выход.
  final bool hostessMode;
  final bool hostessExitMode;
  final int? hostessEventId;
  final int? hostessStageId;
  final String? hostessStageType;
  final String? hostessRoleCode;
  final int? contextEventId;
  final int? contextStageId;
  final String? contextStageType;
  final String? contextRoleCode;

  @override
  State<StaffScanPage> createState() => _StaffScanPageState();
}

class _StaffScanPageState extends State<StaffScanPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  final ImagePicker _imagePicker = ImagePicker();
  bool _torchOn = false;
  bool _processing = false;
  bool _pickingImage = false;

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

    if (widget.hostessMode) {
      setState(() => _processing = true);
      await _controller.stop();
      try {
        if (widget.hostessExitMode) {
          final detail = await widget.auth.hostessExitLookup(badgeCode: code);
          if (!mounted) return;
          await _showHostessExitDialog(scannedCode: code, detail: detail);
        } else {
          final eventId = widget.hostessEventId;
          final stageId = widget.hostessStageId;
          final stageType = (widget.hostessStageType ?? 'main').trim().isEmpty
              ? 'main'
              : widget.hostessStageType!.trim();
          if (eventId == null || stageId == null) {
            if (!mounted) return;
            final l10n = AppLocalizations.of(context)!;
            await _showScanErrorDialog(l10n.staffScanSelectEventStageFirst);
          } else {
            final result = await widget.auth.hostessEntryScan(
              badgeCode: code,
              eventId: eventId,
              stageId: stageId,
              stageType: stageType,
              roleCode: widget.hostessRoleCode,
            );
            if (!mounted) return;
            await _showHostessEntryDialog(result.detail, result.message);
          }
        }
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

    if (widget.extraZoneScan) {
      setState(() => _processing = true);
      await _controller.stop();
      try {
        final result = await widget.auth.extraTicketScanLookup(code: code);
        if (!mounted) return;
        await _showExtraZoneResultDialog(result);
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

    if (widget.backstageScan) {
      setState(() => _processing = true);
      await _controller.stop();
      try {
        final result = await widget.auth.backstageTicketScanLookup(code: code);
        if (!mounted) return;
        await _showBackstageResultDialog(result);
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

    if (widget.mealHandoutScan) {
      final rid = widget.staffRoleId;
      if (rid == null || rid <= 0) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.noRolesAssigned),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }
      setState(() => _processing = true);
      await _controller.stop();
      try {
        final ctx = widget.contextEventId ?? AppSettings.staffActiveEventId;
        final payload = await widget.auth.workerMealIssueLookup(
          badgeCode: code,
          contextEventId: ctx,
        );
        if (!mounted) {
          return;
        }
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => StaffMealIssuePage(
              auth: widget.auth,
              payload: payload,
              staffRoleId: rid,
              accent: widget.accent,
              backgroundColor: widget.backgroundColor,
            ),
          ),
        );
      } catch (e) {
        if (!mounted) {
          return;
        }
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

    if (widget.rehearsalCheckinScan) {
      final slotId = widget.rehearsalSlotId;
      if (slotId == null || slotId <= 0) {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.staffRehearsalCheckinSelectSlotFirst),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      setState(() => _processing = true);
      await _controller.stop();
      try {
        final result = await widget.auth.rehearsalCheckinScanLookup(
          code: code,
          slotId: slotId,
        );
        if (!mounted) return;
        await _showRehearsalCheckinResultDialog(result);
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

    if (widget.qrCheck) {
      final eventId = widget.contextEventId ?? AppSettings.staffActiveEventId;
      final stageId = widget.contextStageId ?? AppSettings.staffActiveStageId;
      final stageType =
          widget.contextStageType ?? AppSettings.staffActiveStageType ?? 'main';
      final roleCode =
          widget.contextRoleCode ?? AppSettings.staffSelectedRoleCode;
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
      final l10n = AppLocalizations.of(context)!;
      try {
        final result = await _submitStageScanWithDisambiguation(
          scanCode: code,
          eventId: eventId,
          stageId: stageId,
          stageType: stageType,
          roleCode: roleCode,
        );
        if (!mounted) return;
        if (result.isSuccess) {
          await _showQrCheckSuccessDialog(
            result.message.isNotEmpty
                ? result.message
                : l10n.staffScanProcessed,
          );
          if (!mounted) return;
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.staffScanFailed(e.toString())),
                backgroundColor: Colors.redAccent,
              ),
            );
            setState(() => _processing = false);
            await _controller.start();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.message.isNotEmpty
                    ? result.message
                    : l10n.staffScanErrorUnknown,
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
          setState(() => _processing = false);
          await _controller.start();
        }
      } catch (e) {
        if (!mounted) return;
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

    final eventId = widget.contextEventId ?? AppSettings.staffActiveEventId;
    final stageId = widget.contextStageId ?? AppSettings.staffActiveStageId;
    final stageType =
        widget.contextStageType ?? AppSettings.staffActiveStageType ?? 'main';
    final roleCode =
        widget.contextRoleCode ?? AppSettings.staffSelectedRoleCode;
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
      final result = await _submitStageScanWithDisambiguation(
        scanCode: code,
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

  Future<ScanStageResult> _submitStageScanWithDisambiguation({
    required String scanCode,
    required int eventId,
    required int stageId,
    required String stageType,
    String? roleCode,
  }) async {
    var result = await widget.auth.submitStageScan(
      scanCode: scanCode,
      eventId: eventId,
      stageId: stageId,
      stageType: stageType,
      roleCode: roleCode,
      resolveDuplicates: true,
    );

    while (mounted && result.hasMultipleCandidates) {
      final selected = await _showDuplicateStageSelector(result.candidates);
      if (!mounted) {
        break;
      }
      if (selected == null || selected.stagePlanId <= 0) {
        return ScanStageResult(
          ok: false,
          resultStatus: 'rejected',
          resultCode: 'cancelled',
          message: 'Scan cancelled.',
        );
      }
      result = await widget.auth.submitStageScan(
        scanCode: scanCode,
        eventId: eventId,
        stageId: stageId,
        stageType: stageType,
        roleCode: roleCode,
        stagePlanId: selected.stagePlanId,
        selectedBrandSlot: selected.brandSlot,
        resolveDuplicates: true,
      );
    }

    return result;
  }

  Future<ScanStageCandidate?> _showDuplicateStageSelector(
    List<ScanStageCandidate> candidates,
  ) async {
    if (candidates.isEmpty) {
      return null;
    }

    final sorted = [...candidates]..sort((a, b) {
      final byBrand = a.brandSlot.compareTo(b.brandSlot);
      if (byBrand != 0) return byBrand;
      return a.position.compareTo(b.position);
    });
    var selected = sorted.first;

    return showDialog<ScanStageCandidate>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setStateDialog) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1A1A1A),
              title: const Text(
                'Выберите этап для закрытия',
                style: TextStyle(color: Colors.white),
              ),
              content: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: sorted.map((candidate) {
                      final brandName = (candidate.brandName ?? '').trim();
                      final slotLabel = candidate.brandSlot > 0
                          ? 'Бренд ${candidate.brandSlot}'
                          : 'Основной поток';
                      final title = brandName.isNotEmpty
                          ? '$slotLabel - $brandName'
                          : slotLabel;
                      final blocked = !candidate.canComplete;
                      return RadioListTile<int>(
                        value: candidate.stagePlanId,
                        groupValue: selected.stagePlanId,
                        onChanged: blocked
                            ? null
                            : (value) {
                                if (value == null) return;
                                final picked = sorted.firstWhere(
                                  (c) => c.stagePlanId == value,
                                  orElse: () => selected,
                                );
                                setStateDialog(() => selected = picked);
                              },
                        activeColor: widget.accent,
                        title: Text(
                          title,
                          style: TextStyle(
                            color: blocked ? Colors.white54 : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: blocked
                            ? const Text(
                                'Недоступно: предыдущие обязательные этапы не завершены',
                                style: TextStyle(color: Colors.white54),
                              )
                            : null,
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(null),
                  child: const Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(selected),
                  style: ElevatedButton.styleFrom(backgroundColor: widget.accent),
                  child: const Text('Отметить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildHeader(Color accent) {
    final l10n = AppLocalizations.of(context)!;
    String headerText;
    if (widget.hostessMode) {
      headerText = widget.hostessExitMode
          ? l10n.staffHostessExitMode
          : l10n.staffHostessEntryMode;
    } else if (widget.extraZoneScan) {
      headerText = l10n.staffScanHeaderExtraZone;
    } else if (widget.backstageScan) {
      headerText = l10n.staffScanHeaderBackstage;
    } else if (widget.rehearsalCheckinScan) {
      headerText = l10n.staffScanHeaderRehearsalCheckin;
    } else if (widget.parkingScan) {
      headerText = l10n.staffScanHeaderParking;
    } else if (widget.scanForInfo) {
      headerText = l10n.staffScanHeaderInfo;
    } else if (widget.qrCheck) {
      headerText = l10n.staffScanHeaderQrCheck;
    } else {
      headerText = l10n.staffScanHeaderQr;
    }
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
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          Text(
            headerText,
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
    String hintText;
    if (widget.hostessMode) {
      hintText = widget.hostessExitMode
          ? l10n.staffHostessExitHint
          : l10n.staffHostessEntryHint;
    } else if (widget.extraZoneScan) {
      hintText = l10n.staffScanHintExtraZone;
    } else if (widget.backstageScan) {
      hintText = l10n.staffScanHintBackstage;
    } else if (widget.rehearsalCheckinScan) {
      hintText = l10n.staffScanHintRehearsalCheckin;
    } else if (widget.parkingScan) {
      hintText = l10n.staffScanHintParking;
    } else if (widget.scanForInfo) {
      hintText = l10n.staffScanHintInfo;
    } else if (widget.qrCheck) {
      hintText = l10n.staffScanHintQrCheck;
    } else {
      hintText = l10n.staffScanHintQr;
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        hintText,
        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> _showQrCheckSuccessDialog(String message) async {
    final l10n = AppLocalizations.of(context)!;
    final text = message.trim().isEmpty
        ? l10n.staffScanProcessed
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
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.staffQrCheckSuccessTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  text,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.accent,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(l10n.staffQrCheckSuccessContinue),
                ),
              ],
            ),
          ),
        );
      },
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
                    IconButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white70,
                        size: 18,
                      ),
                      tooltip: l10n.close,
                    ),
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
                    const SizedBox(width: 40),
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
                    IconButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white70,
                        size: 18,
                      ),
                      tooltip: l10n.close,
                    ),
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
                    const SizedBox(width: 40),
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

  Future<void> _showExtraZoneResultDialog(
    ExtraTicketScanLookupResult result,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final statusText = result.isNotFound
        ? l10n.staffExtraZoneResultNotFound
        : (result.isAccessClosed
              ? l10n.staffExtraZoneResultAccessClosed
              : l10n.staffExtraZoneResultAccessGranted);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final navigator = Navigator.of(ctx);
        Future<void>.delayed(const Duration(seconds: 5), () {
          if (navigator.canPop()) {
            navigator.pop();
          }
        });

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
                Text(
                  l10n.staffExtraZoneScanResultTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  statusText,
                  style: TextStyle(
                    color: result.isAccessGranted
                        ? widget.accent
                        : Colors.redAccent.shade100,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                if (!result.isNotFound) ...[
                  row(l10n.staffParkingFieldEvent, result.eventName),
                  row(l10n.staffParkingFieldClient, result.clientName),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showBackstageResultDialog(
    BackstageTicketScanLookupResult result,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final statusText = result.isNotFound
        ? l10n.staffBackstageResultNotFound
        : (result.isAccessClosed
              ? l10n.staffBackstageResultAccessClosed
              : l10n.staffBackstageResultAccessGranted);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final navigator = Navigator.of(ctx);
        Future<void>.delayed(const Duration(seconds: 5), () {
          if (navigator.canPop()) {
            navigator.pop();
          }
        });

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
                Text(
                  l10n.staffBackstageScanResultTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  statusText,
                  style: TextStyle(
                    color: result.isAccessGranted
                        ? widget.accent
                        : Colors.redAccent.shade100,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                if (!result.isNotFound) ...[
                  row(l10n.staffParkingFieldEvent, result.eventName),
                  row(l10n.staffParkingFieldClient, result.clientName),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showRehearsalCheckinResultDialog(
    RehearsalCheckinScanLookupResult result,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final statusText = result.isNotFound
        ? l10n.staffRehearsalCheckinResultNotFound
        : (result.isWrongSlot
              ? l10n.staffRehearsalCheckinResultWrongSlot
              : (result.isAlreadyClosed
                    ? l10n.staffRehearsalCheckinResultAlreadyClosed
                    : l10n.staffRehearsalCheckinResultClosedNow));

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final navigator = Navigator.of(ctx);
        Future<void>.delayed(const Duration(seconds: 5), () {
          if (navigator.canPop()) {
            navigator.pop();
          }
        });

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

        final slotDate = result.slotDate;
        final slotDateLabel = slotDate == null
            ? ''
            : '${slotDate.day.toString().padLeft(2, '0')}.${slotDate.month.toString().padLeft(2, '0')}.${slotDate.year}';

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
                Text(
                  l10n.staffRehearsalCheckinScanResultTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  statusText,
                  style: TextStyle(
                    color: result.isClosedNow
                        ? widget.accent
                        : Colors.redAccent.shade100,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                if (!result.isNotFound) ...[
                  row(l10n.staffRehearsalCheckinFieldChild, result.childName),
                  row(l10n.staffParkingFieldEvent, result.eventName),
                  row(
                    l10n.staffRehearsalCheckinFieldSlot,
                    [
                      slotDateLabel,
                      result.slotTime,
                    ].where((v) => v.trim().isNotEmpty).join(' '),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildHostessBrands(SupervisorChildDetail detail) {
    final widgets = <Widget>[];
    final brands = detail.brands;
    if (brands.isEmpty) {
      return [
        const Text('—', style: TextStyle(color: Colors.white70, fontSize: 15)),
      ];
    }
    for (final brand in brands) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                brand.brandName.isEmpty ? '—' : brand.brandName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                brand.supervisors.isEmpty
                    ? '—'
                    : brand.supervisors
                          .map((s) => s.name.isEmpty ? '—' : s.name)
                          .join(', '),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _hostessInfoRow(String label, Widget value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          value,
        ],
      ),
    );
  }

  Future<void> _showHostessEntryDialog(
    SupervisorChildDetail? detail,
    String message,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final d = detail;
        final photoUrl = d?.photoUrl;
        return Dialog(
          backgroundColor: const Color(0xFF131313),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 760),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.staffHostessEntryResultTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close, color: Colors.white70),
                      ),
                    ],
                  ),
                  if (message.trim().isNotEmpty) ...[
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (photoUrl != null && photoUrl.trim().isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        photoUrl,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  if (photoUrl != null && photoUrl.trim().isNotEmpty)
                    const SizedBox(height: 12),
                  if (d != null) ...[
                    _hostessInfoRow(
                      l10n.staffHostessFieldChildName,
                      Text(
                        d.fullName.trim().isEmpty ? '—' : d.fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    _hostessInfoRow(
                      l10n.staffHostessFieldParent,
                      Text(
                        (d.parentName ?? '').trim().isEmpty
                            ? '—'
                            : (d.parentName ?? ''),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    _hostessInfoRow(
                      l10n.staffHostessFieldBrandsAndSupervisors,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildHostessBrands(d),
                      ),
                    ),
                    if (d.familyLookEnabled)
                      _hostessInfoRow(
                        l10n.staffHostessFieldFamilyLook,
                        Text(
                          d.familyLookLinks.isEmpty
                              ? l10n.staffHostessFamilyLookEnabled
                              : d.familyLookLinks
                                    .map(
                                      (f) =>
                                          '${f.label}${f.brandName == null || f.brandName!.isEmpty ? '' : ' - ${f.brandName}'}',
                                    )
                                    .join('\n'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showHostessExitDialog({
    required String scannedCode,
    required SupervisorChildDetail detail,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final required = detail.requiredProgress;
    final canClose = required?.canCloseEvent ?? false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        var submitting = false;
        Future<void> closeEvent() async {
          if (submitting || !canClose) {
            return;
          }
          final eventId = widget.hostessEventId;
          final stageId = widget.hostessStageId;
          final stageType = widget.hostessStageType ?? 'main';
          if (eventId == null || stageId == null) {
            return;
          }
          submitting = true;
          (ctx as Element).markNeedsBuild();
          try {
            final res = await widget.auth.hostessExitComplete(
              badgeCode: scannedCode,
              eventId: eventId,
              stageId: stageId,
              stageType: stageType,
              roleCode: widget.hostessRoleCode,
            );
            if (!mounted || !ctx.mounted) {
              return;
            }
            Navigator.of(ctx).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  res.message.trim().isEmpty
                      ? l10n.staffScanProcessed
                      : res.message,
                ),
                backgroundColor: widget.accent,
              ),
            );
          } catch (e) {
            if (!mounted || !ctx.mounted) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                backgroundColor: Colors.redAccent,
              ),
            );
          } finally {
            submitting = false;
            if (ctx.mounted) {
              ctx.markNeedsBuild();
            }
          }
        }

        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Dialog(
              backgroundColor: const Color(0xFF131313),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 760),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.staffHostessExitResultTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      if ((detail.photoUrl ?? '').trim().isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            detail.photoUrl!,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                      if ((detail.photoUrl ?? '').trim().isNotEmpty)
                        const SizedBox(height: 12),
                      _hostessInfoRow(
                        l10n.staffHostessFieldChildName,
                        Text(
                          detail.fullName.trim().isEmpty
                              ? '—'
                              : detail.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      _hostessInfoRow(
                        l10n.staffHostessFieldBrandsAndSupervisors,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildHostessBrands(detail),
                        ),
                      ),
                      _hostessInfoRow(
                        l10n.staffHostessFieldStages,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: detail.mainProgressStages
                              .map(
                                (s) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        s.status == 'done'
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        color: s.status == 'done'
                                            ? widget.accent
                                            : Colors.white38,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          s.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      if (required != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            l10n.staffHostessRequiredProgress(
                              required.requiredCompleted,
                              required.requiredTotal,
                            ),
                            style: TextStyle(
                              color: canClose
                                  ? widget.accent
                                  : Colors.orangeAccent,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (canClose && !submitting)
                              ? () async {
                                  setModalState(() => submitting = true);
                                  await closeEvent();
                                  if (ctx.mounted) {
                                    setModalState(() => submitting = false);
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.accent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: submitting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.staffHostessCloseEventAction),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _scanFromGallery() async {
    if (_processing || _pickingImage) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    setState(() => _pickingImage = true);
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null || !mounted) {
        return;
      }

      final capture = await _controller.analyzeImage(image.path);
      if (!mounted) {
        return;
      }

      final code = capture?.barcodes
          .map((barcode) => barcode.rawValue?.trim())
          .whereType<String>()
          .firstWhere((value) => value.isNotEmpty, orElse: () => '');

      if (code == null || code.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.staffScanFailed(l10n.staffScanErrorUnknown)),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      await _onScanned(code);
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.staffScanFailed(e.toString())),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _pickingImage = false);
      }
    }
  }

  Widget _buildActions(Color accent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _actionButton(
          Icons.photo_library_outlined,
          onTap: (_processing || _pickingImage) ? null : _scanFromGallery,
        ),
        const SizedBox(width: 24),
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
        const SizedBox(width: 24),
        const SizedBox(width: 48, height: 48),
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
