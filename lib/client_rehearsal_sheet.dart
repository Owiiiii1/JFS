import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_settings.dart';
import 'api/auth_service.dart';
import 'gen_l10n/app_localizations.dart';
import 'schedule_wall_clock.dart';
import 'rehearsal_map_util.dart';

const Color _kPrimary = Color(0xFFF2CA50);
const Color _kOnPrimary = Color(0xFF3C2F00);
const Color _kSurface = Color(0xFF131313);
const Color _kSurfaceHigh = Color(0xFF2A2A2A);
const Color _kOnSurface = Color(0xFFE2E2E2);
const Color _kTertiary = Color(0xFFCECECE);
const Color _kOutline = Color(0xFF4D4635);

/// Как в Stitch code.html — подложка шапки модалки.
const String _kRehearsalHeroImageUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCPHDD-yk8wDkm4sxxx7oA0uIXqHxRTZ8lH-rbgpW4aKaOq7WMgiU94QxIbT5H5Ow3zh8UXDgttSMlaTkHfeNt3e-ohE6DAw_KjUDRTaAPu-Bt5y818M3xFf3rCy51r8ONWUNFdImNaouQjGslehnTyP48hMa3OYZBILv6HuiAly3MardP-DikhLJHZexyIUu7NiFQ7Fsb-1MtrHqNOcEZ78MZon2lKL_TSz5ejxd5sx-jm8U00-RMcZPt0NdbG6MF90wJiBQo00co';

/// Venue caption under rehearsal details; opens [mapUrl] when the API provided a valid HTTP(S) link.
Widget _rehearsalVenueCaptionRow({
  required String caption,
  String? mapUrl,
  required TextStyle style,
  IconData leadingIcon = Icons.schedule_rounded,
  Color leadingColor = _kPrimary,
}) {
  final raw = mapUrl?.trim();
  final canOpen =
      raw != null && raw.isNotEmpty && rehearsalMapLaunchUri(raw) != null;
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(leadingIcon, color: leadingColor, size: 18),
      const SizedBox(width: 6),
      Expanded(
        child: canOpen
            ? GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => openRehearsalMapExternal(raw),
                child: Text(
                  caption,
                  style: style.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: style.color,
                  ),
                ),
              )
            : Text(caption, style: style),
      ),
    ],
  );
}

String _rehearsalDateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Aligned with server: slot start in local wall time vs now (rehearsal cut-off is start time).
bool rehearsalSlotWallStartIsPast(RehearsalSlotOption s) {
  return _rehearsalWallStartIsPast(
    dateYmd: s.slotDate,
    timeHm: s.slotTime,
  );
}

bool rehearsalBookingWallStartIsPast(RehearsalBookingInfo b) {
  final iso = b.startsAt;
  if (iso != null) {
    return iso.isBefore(DateTime.now());
  }
  return _rehearsalWallStartIsPast(
    dateYmd: b.slotDate,
    timeHm: b.slotTime,
  );
}

bool _rehearsalWallStartIsPast({
  required String dateYmd,
  required String timeHm,
}) {
  final t = timeHm.trim();
  if (dateYmd.isEmpty || t.isEmpty) {
    return false;
  }
  final norm = t.length > 5 ? t.substring(0, 5) : t;
  final p = DateTime.tryParse('${dateYmd}T$norm:00');
  if (p == null) {
    return false;
  }
  return p.isBefore(DateTime.now());
}

String? _defaultSelectedDateKeyForSlots(List<RehearsalSlotOption> list) {
  DateTime? maxD;
  for (final s in list) {
    final d = DateTime.tryParse(s.slotDate);
    if (d != null) {
      final n = DateTime(d.year, d.month, d.day);
      if (maxD == null || n.isAfter(maxD)) {
        maxD = n;
      }
    }
  }
  if (maxD == null) {
    return null;
  }
  final start = DateTime(
    maxD.year,
    maxD.month,
    maxD.day,
  ).subtract(const Duration(days: 6));
  for (var i = 6; i >= 0; i--) {
    final day = start.add(Duration(days: i));
    final key = _rehearsalDateKey(day);
    if (list.any((s) => s.slotDate == key)) {
      return key;
    }
  }
  return null;
}

Future<void> showClientRehearsalSheet({
  required BuildContext context,
  required AuthService auth,
  required int eventId,
  DateTime? eventStartsAt,
  required List<ChildWithAssignment> childrenInEvent,
  VoidCallback? onSaved,
}) async {
  final usable = childrenInEvent
      .where((c) => c.activeAssignment?.event.id == eventId)
      .toList();
  if (usable.isEmpty) {
    return;
  }
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.98,
      expand: false,
      builder: (context, scrollController) => _ClientRehearsalSheetBody(
        auth: auth,
        eventId: eventId,
        eventStartsAt: eventStartsAt,
        children: usable,
        scrollController: scrollController,
        onSaved: onSaved,
      ),
    ),
  );
}

class _ClientRehearsalSheetBody extends StatefulWidget {
  const _ClientRehearsalSheetBody({
    required this.auth,
    required this.eventId,
    required this.eventStartsAt,
    required this.children,
    required this.scrollController,
    this.onSaved,
  });

  final AuthService auth;
  final int eventId;
  final DateTime? eventStartsAt;
  final List<ChildWithAssignment> children;
  final ScrollController scrollController;
  final VoidCallback? onSaved;

  @override
  State<_ClientRehearsalSheetBody> createState() =>
      _ClientRehearsalSheetBodyState();
}

class _ClientRehearsalSheetBodyState extends State<_ClientRehearsalSheetBody> {
  late int _childIndex;
  late List<ChildWithAssignment> _children;
  List<RehearsalSlotOption> _slots = [];
  bool _loading = true;
  String? _loadError;
  String? _selectedDate;
  final Set<int> _selectedSlotIds = <int>{};
  bool _booking = false;
  bool _isChangingBooking = false;

  ChildWithAssignment get _current => _children[_childIndex];

  ActiveAssignment? get _assignment => _current.activeAssignment;

  List<RehearsalBookingInfo> get _bookings =>
      _assignment?.rehearsalBookings ?? const [];

  int get _maxMainRehearsals {
    final a = _assignment;
    final value = a?.effectiveMaxMainRehearsals ?? a?.maxMainRehearsals ?? 1;
    return value < 0 ? 0 : value;
  }

  bool get _canBookMore => _bookings.length < _maxMainRehearsals;
  Set<int> get _alreadyBookedSlotIds => _bookings.map((b) => b.slotId).toSet();

  /// Брони на уже прошедшее время — в лимит входят, снять/поменять нельзя (сервер тоже держит).
  Set<int> get _lockedPastBookedIds => {
    for (final b in _bookings)
      if (rehearsalBookingWallStartIsPast(b)) b.slotId,
  };

  bool get _currentChildHasAssignedBrand {
    final a = _assignment;
    if (a == null) return false;
    final hasKnownBrandFields = a.brandId != null || a.secondBrandId != null;
    if (!hasKnownBrandFields) {
      return true;
    }
    return (a.brandId ?? 0) > 0 || (a.secondBrandId ?? 0) > 0;
  }

  /// Репетиции бренда из таймлайна — только просмотр (без брони в этом окне).
  List<PreparatoryStageInfo> get _brandRehearsalStages {
    final a = _assignment;
    if (a == null || a.event.id != widget.eventId) {
      return const [];
    }
    return [
      for (final p in a.preparatoryStages)
        if (p.isBrandRehearsalMilestone) p,
    ];
  }

  @override
  void initState() {
    super.initState();
    _children = List<ChildWithAssignment>.from(widget.children);
    _childIndex = 0;
    _loadSlots();
  }

  Future<void> _syncChildrenFromDashboard() async {
    try {
      final dash = await widget.auth.getClientDashboard();
      if (!mounted) {
        return;
      }
      final next = dash.children
          .where((c) => c.activeAssignment?.event.id == widget.eventId)
          .toList();
      if (next.isEmpty) {
        return;
      }
      setState(() {
        _children = next;
        if (_childIndex >= _children.length) {
          _childIndex = 0;
        }
      });
    } catch (_) {
      /* ignore */
    }
  }

  Future<void> _loadSlots() async {
    final wasChanging = _isChangingBooking;
    setState(() {
      _loading = true;
      _loadError = null;
      if (!wasChanging) {
        _selectedDate = null;
        _selectedSlotIds.clear();
      }
    });
    try {
      final aid = _assignment?.id;
      if (aid == null || aid <= 0) {
        if (!mounted) {
          return;
        }
        setState(() {
          _loading = false;
          _slots = [];
          _loadError = null;
        });
        return;
      }
      final payload = await widget.auth.getEventRehearsalSlots(
        widget.eventId,
        assignmentId: aid,
      );
      if (!mounted) return;
      setState(() {
        _slots = payload.slots;
        _loading = false;
        if (!wasChanging) {
          _selectedDate = _defaultSelectedDateKeyForSlots(payload.slots);
          _selectedSlotIds.clear();
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = e.toString();
      });
    }
  }

  void _startChangeBooking() {
    final preselected = _alreadyBookedSlotIds;
    String? dateKey;
    if (_bookings.isNotEmpty) {
      dateKey = _bookings.first.slotDate;
    } else {
      dateKey = _defaultSelectedDateKeyForSlots(_slots);
    }
    setState(() {
      _isChangingBooking = true;
      _selectedSlotIds
        ..clear()
        ..addAll(preselected);
      _selectedDate = dateKey;
    });
    _loadSlots();
  }

  void _cancelChangeBooking() {
    setState(() {
      _isChangingBooking = false;
      _selectedSlotIds.clear();
      _selectedDate = _defaultSelectedDateKeyForSlots(_slots);
    });
  }

  DateTime _monthRef() {
    if (widget.eventStartsAt != null) {
      return widget.eventStartsAt!;
    }
    if (_slots.isNotEmpty) {
      final d = DateTime.tryParse(_slots.first.slotDate);
      if (d != null) {
        return d;
      }
    }
    return DateTime.now();
  }

  /// 7 подряд идущих календарных дней, последний — самая поздняя дата со слотом
  /// (как «15–21», если слоты только на 21-е).
  List<DateTime> _calendarWeekStrip() {
    DateTime? maxD;
    void considerDate(String? ymd) {
      final d = DateTime.tryParse(ymd ?? '');
      if (d != null) {
        final n = DateTime(d.year, d.month, d.day);
        if (maxD == null || n.isAfter(maxD!)) {
          maxD = n;
        }
      }
    }
    for (final s in _slots) {
      considerDate(s.slotDate);
    }
    for (final b in _bookings) {
      considerDate(b.slotDate);
    }
    final anchor = maxD;
    if (anchor == null) {
      return [];
    }
    final end = DateTime(anchor.year, anchor.month, anchor.day);
    final start = end.subtract(const Duration(days: 6));
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  List<RehearsalSlotOption> _slotsForDate(String dateKey) {
    final list = _slots.where((s) => s.slotDate == dateKey).toList();
    list.sort((a, b) => a.slotTime.compareTo(b.slotTime));
    return list;
  }

  Future<void> _onConfirm() async {
    final selectedIds = _selectedSlotIds.toList();
    final a = _assignment;
    if (a == null) {
      return;
    }
    if (selectedIds.isEmpty && !_isChangingBooking) {
      return;
    }
    setState(() => _booking = true);
    try {
      final desiredIds = selectedIds.toSet();
      if (desiredIds.length > _maxMainRehearsals) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context)!.rehearsalBookingError} '
              'Selected ${desiredIds.length}/$_maxMainRehearsals.',
            ),
          ),
        );
        return;
      }
      if (_isChangingBooking) {
        await widget.auth.replaceRehearsalBookings(
          assignmentId: a.id,
          slotIds: desiredIds.toList(),
        );
      } else {
        for (final slotId in selectedIds) {
          await widget.auth.bookRehearsalSlot(
            assignmentId: a.id,
            slotId: slotId,
          );
        }
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.rehearsalBookingSaved),
        ),
      );
      widget.onSaved?.call();
      await _syncChildrenFromDashboard();
      if (!mounted) return;
      setState(() {
        _isChangingBooking = false;
        _selectedSlotIds.clear();
        _selectedDate = _defaultSelectedDateKeyForSlots(_slots);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(context)!.rehearsalBookingError} $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _booking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final scheduleLocale = Localizations.localeOf(context).toString();

    return Container(
      decoration: const BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SizedBox(
            height: 192,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  _kRehearsalHeroImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => ColoredBox(
                    color: _kSurfaceHigh,
                    child: Center(
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: 56,
                        color: _kPrimary.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _kSurface.withValues(alpha: 0.15),
                        _kSurface.withValues(alpha: 0.92),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Material(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: _kOnSurface,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.eventSettingsConfigurationPortal,
                        style: const TextStyle(
                          color: _kPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.rehearsalModalTitle,
                        style: const TextStyle(
                          color: _kOnSurface,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'HelveticaNeueCyr',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                if (_children.length > 1) ...[
                  Text(
                    l10n.rehearsalSelectChild,
                    style: const TextStyle(
                      color: _kTertiary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: _kSurfaceHigh,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _kOutline.withValues(alpha: 0.25),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _childIndex,
                        isExpanded: true,
                        dropdownColor: _kSurfaceHigh,
                        style: const TextStyle(
                          color: _kOnSurface,
                          fontSize: 15,
                        ),
                        items: List.generate(
                          _children.length,
                          (i) => DropdownMenuItem(
                            value: i,
                            child: Text(_children[i].firstName),
                          ),
                        ),
                        onChanged: (v) {
                          if (v == null) {
                            return;
                          }
                          setState(() {
                            _childIndex = v;
                            _isChangingBooking = false;
                            _selectedDate = _defaultSelectedDateKeyForSlots(
                              _slots,
                            );
                            _selectedSlotIds.clear();
                          });
                          _loadSlots();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                if (_loading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(color: _kPrimary),
                    ),
                  )
                else if (_loadError != null)
                  Column(
                    children: [
                      Text(
                        l10n.rehearsalLoadError,
                        style: const TextStyle(color: _kTertiary),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: _loadSlots,
                        child: Text(
                          l10n.rehearsalLoadError,
                          style: const TextStyle(color: _kPrimary),
                        ),
                      ),
                    ],
                  )
                else if (!_currentChildHasAssignedBrand)
                  Text(
                    l10n.rehearsalBrandNotAssigned,
                    style: const TextStyle(color: _kTertiary),
                  )
                else if (_bookings.isNotEmpty && !_isChangingBooking)
                  _BookedPanel(
                    bookings: _bookings,
                    maxMainRehearsals: _maxMainRehearsals,
                    locale: locale,
                    bookingBusy: _booking,
                    canEdit: true,
                    lockedHint: _canBookMore
                        ? l10n.rehearsalChangeBookingLockedHint
                        : l10n.rehearsalBookingFooterNote,
                    onAddMore: _startChangeBooking,
                  )
                else if (_slots.isEmpty)
                  Text(
                    l10n.rehearsalNoSlotsConfigured,
                    style: const TextStyle(color: _kTertiary),
                  )
                else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          l10n.rehearsalSelectDate,
                          style: const TextStyle(
                            color: _kOnSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'HelveticaNeueCyr',
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_left_rounded,
                        color: _kPrimary.withValues(alpha: 0.35),
                        size: 22,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Text(
                          DateFormat.yMMMM(
                            locale,
                          ).format(_monthRef()).toUpperCase(),
                          style: const TextStyle(
                            color: _kPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: _kPrimary.withValues(alpha: 0.35),
                        size: 22,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cw = constraints.maxWidth;
                      final usable = cw.isFinite && cw > 0
                          ? cw
                          : MediaQuery.sizeOf(context).width - 40;
                      return _CalendarDayStrip(
                        maxWidth: usable,
                        weekDays: _calendarWeekStrip(),
                        hasSlotsForKey: (key) =>
                            _slots.any((s) => s.slotDate == key) ||
                            _bookings.any((b) => b.slotDate == key),
                        locale: locale,
                        selectedKey: _selectedDate,
                        onSelectDayWithSlots: (key) {
                          setState(() {
                            _selectedDate = key;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  if (_selectedDate != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.rehearsalAvailableSlots,
                          style: const TextStyle(
                            color: _kOnSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'HelveticaNeueCyr',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_isChangingBooking && _lockedPastBookedIds.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final b in _bookings)
                            if (rehearsalBookingWallStartIsPast(b))
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _kSurfaceHigh.withValues(alpha: 0.55),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _kOutline.withValues(alpha: 0.25),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.lock_outline_rounded,
                                      size: 14,
                                      color: _kTertiary.withValues(alpha: 0.85),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${AppSettings.formatTimeLabel(b.slotTime)} · ${l10n.rehearsalBookedTitle}',
                                      style: TextStyle(
                                        color: _kTertiary.withValues(alpha: 0.9),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    _TimeSlotGrid(
                      slots: _slotsForDate(_selectedDate!),
                      selectedIds: _selectedSlotIds,
                      bookedSlotIds: _alreadyBookedSlotIds,
                      lockedSlotIds: _isChangingBooking ? _lockedPastBookedIds : const {},
                      selectionLimit: _maxMainRehearsals,
                      editableBooked: _isChangingBooking,
                      onToggle: (id) {
                        setState(() {
                          if (_isChangingBooking &&
                              _lockedPastBookedIds.contains(id)) {
                            return;
                          }
                          if (_selectedSlotIds.contains(id)) {
                            _selectedSlotIds.remove(id);
                            return;
                          }
                          if (_selectedSlotIds.length < _maxMainRehearsals) {
                            _selectedSlotIds.add(id);
                          }
                        });
                      },
                      l10n: l10n,
                    ),
                    if (_selectedSlotIds.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      ..._slots
                          .where((s) => _selectedSlotIds.contains(s.id))
                          .map(
                            (s) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _DescriptionPanel(slot: s, l10n: l10n),
                            ),
                          ),
                      const SizedBox(height: 16),
                      if (_isChangingBooking) ...[
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: _booking ? null : _cancelChangeBooking,
                            child: Text(
                              l10n.rehearsalCancelChange,
                              style: const TextStyle(color: _kTertiary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _booking || _selectedSlotIds.isEmpty
                              ? null
                              : _onConfirm,
                          style: FilledButton.styleFrom(
                            backgroundColor: _kPrimary,
                            foregroundColor: _kOnPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: _booking
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: _kOnPrimary,
                                  ),
                                )
                              : Text(
                                  l10n.rehearsalConfirmBooking.toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2,
                                    fontSize: 12,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 16),
                  Text(
                    l10n.rehearsalBookingFooterNote,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _kOutline.withValues(alpha: 0.9),
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
                if (_assignment != null && !_loading) ...[
                  const SizedBox(height: 24),
                  _RehearsalSheetBrandRehearsalsSection(
                    l10n: l10n,
                    stages: _brandRehearsalStages,
                    locale: scheduleLocale,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String? _rehearsalSheetFormatBrandRehearsalWhen(
  PreparatoryStageInfo p,
  String locale,
) {
  final w = parseScheduleWallToDateTime(p.scheduledAtWall);
  if (w != null) {
    final d = DateFormat.yMMMMd(locale).format(w);
    final t = AppSettings.formatTime(w.hour, w.minute);
    return '$d · $t';
  }
  final s = p.scheduledAt;
  if (s != null) {
    final loc = s.toLocal();
    final d = DateFormat.yMMMMd(locale).format(loc);
    final t = AppSettings.formatTime(loc.hour, loc.minute);
    return '$d · $t';
  }
  return null;
}

class _RehearsalSheetBrandRehearsalsSection extends StatelessWidget {
  const _RehearsalSheetBrandRehearsalsSection({
    required this.l10n,
    required this.stages,
    required this.locale,
  });

  final AppLocalizations l10n;
  final List<PreparatoryStageInfo> stages;
  final String locale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.eventSettingsBrandRehearsalsHeading,
          style: const TextStyle(
            fontFamily: 'HelveticaNeueCyr',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: _kOnSurface,
          ),
        ),
        if (stages.isNotEmpty) const SizedBox(height: 10),
        for (var i = 0; i < stages.length; i++) ...[
          if (i > 0) const SizedBox(height: 8),
          _RehearsalSheetBrandRehearsalCard(
            prep: stages[i],
            l10n: l10n,
            locale: locale,
          ),
        ],
      ],
    );
  }
}

class _RehearsalSheetBrandRehearsalCard extends StatelessWidget {
  const _RehearsalSheetBrandRehearsalCard({
    required this.prep,
    required this.l10n,
    required this.locale,
  });

  final PreparatoryStageInfo prep;
  final AppLocalizations l10n;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final title = prep.displayTitle(l10n);
    final when = _rehearsalSheetFormatBrandRehearsalWhen(prep, locale);
    final addr = prep.address?.trim();
    final desc = prep.description?.trim();
    return Semantics(
      readOnly: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _kSurfaceHigh.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _kTertiary.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'HelveticaNeueCyr',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _kOnSurface,
                      height: 1.25,
                    ),
                  ),
                ),
                if (prep.isCompleted) ...[
                  const SizedBox(width: 6),
                  ExcludeSemantics(
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: _kPrimary.withValues(alpha: 0.95),
                    ),
                  ),
                ],
              ],
            ),
            if (when != null && when.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                when,
                style: TextStyle(
                  fontFamily: 'HelveticaNeueCyr',
                  fontSize: 13,
                  color: _kTertiary.withValues(alpha: 0.95),
                  height: 1.25,
                ),
              ),
            ],
            if (addr != null && addr.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                addr,
                style: TextStyle(
                  fontFamily: 'HelveticaNeueCyr',
                  fontSize: 12,
                  color: _kTertiary.withValues(alpha: 0.88),
                  height: 1.3,
                ),
              ),
            ],
            if (desc != null && desc.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                desc,
                style: TextStyle(
                  fontFamily: 'HelveticaNeueCyr',
                  fontSize: 12,
                  color: _kTertiary.withValues(alpha: 0.9),
                  height: 1.35,
                ),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 7 колонок фиксированной ширины (календарная полоса), как в Stitch.
class _CalendarDayStrip extends StatelessWidget {
  const _CalendarDayStrip({
    required this.maxWidth,
    required this.weekDays,
    required this.hasSlotsForKey,
    required this.locale,
    required this.selectedKey,
    required this.onSelectDayWithSlots,
  });

  final double maxWidth;
  final List<DateTime> weekDays;
  final bool Function(String dateKey) hasSlotsForKey;
  final String locale;
  final String? selectedKey;
  final void Function(String dateKey) onSelectDayWithSlots;

  @override
  Widget build(BuildContext context) {
    if (weekDays.length != 7) {
      return const SizedBox.shrink();
    }
    final gap = 8.0;
    final w = maxWidth.isFinite && maxWidth > 0
        ? maxWidth
        : MediaQuery.sizeOf(context).width - 40;
    final cell = (w - gap * 6) / 7;

    Widget dayCell(int i) {
      final d = weekDays[i];
      final key = _rehearsalDateKey(d);
      final has = hasSlotsForKey(key);
      final selected = selectedKey == key;
      final wd = DateFormat.E(locale).format(d);
      final letter = wd.isNotEmpty ? wd.substring(0, 1).toUpperCase() : wd;

      return SizedBox(
        width: cell,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              letter,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: _kOutline.withValues(alpha: 0.9),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 6),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: has ? () => onSelectDayWithSlots(key) : null,
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: cell,
                  height: cell,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: !has
                          ? Colors.transparent
                          : (selected ? _kPrimary : _kSurfaceHigh),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected
                            ? _kPrimary
                            : (has
                                  ? _kOutline.withValues(alpha: 0.12)
                                  : Colors.transparent),
                      ),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: _kPrimary.withValues(alpha: 0.28),
                                blurRadius: 14,
                                spreadRadius: 0,
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '${d.day}',
                          style: TextStyle(
                            color: !has
                                ? _kOnSurface.withValues(alpha: 0.38)
                                : (selected ? _kOnPrimary : _kOnSurface),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        if (has && !selected)
                          Positioned(
                            bottom: 6,
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: _kPrimary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (var i = 0; i < 7; i++) ...[
          dayCell(i),
          if (i < 6) SizedBox(width: gap),
        ],
      ],
    );
  }
}

class _TimeSlotGrid extends StatelessWidget {
  const _TimeSlotGrid({
    required this.slots,
    required this.selectedIds,
    required this.bookedSlotIds,
    this.lockedSlotIds = const {},
    required this.selectionLimit,
    required this.editableBooked,
    required this.onToggle,
    required this.l10n,
  });

  final List<RehearsalSlotOption> slots;
  final Set<int> selectedIds;
  final Set<int> bookedSlotIds;
  final Set<int> lockedSlotIds;
  final int selectionLimit;
  final bool editableBooked;
  final void Function(int id) onToggle;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.15,
      ),
      itemCount: slots.length,
      itemBuilder: (context, i) {
        final s = slots[i];
        final locked = lockedSlotIds.contains(s.id);
        final booked = bookedSlotIds.contains(s.id);
        final full = s.freeSpots <= 0 && !booked;
        final sel = selectedIds.contains(s.id);
        final canSelectMore = sel || selectedIds.length < selectionLimit;
        final disabledByLimit = !sel && !canSelectMore;
        final disableBookedTap = booked && !editableBooked && !sel;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (full ||
                    disableBookedTap ||
                    disabledByLimit ||
                    locked)
                ? null
                : () => onToggle(s.id),
            borderRadius: BorderRadius.circular(12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: full
                    ? _kSurfaceHigh.withValues(alpha: 0.35)
                    : booked
                    ? _kSurfaceHigh.withValues(alpha: 0.45)
                    : (sel ? _kPrimary.withValues(alpha: 0.15) : _kSurfaceHigh),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: sel ? _kPrimary : _kOutline.withValues(alpha: 0.2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppSettings.formatTimeLabel(s.slotTime),
                      style: TextStyle(
                        color: full
                            ? _kTertiary.withValues(alpha: 0.4)
                            : (sel ? _kPrimary : _kOnSurface),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (locked || booked)
                          ? l10n.rehearsalBookedTitle.toUpperCase()
                          : full
                          ? l10n.rehearsalFull.toUpperCase()
                          : '${l10n.rehearsalFreeLabel} ${s.freeSpots}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        color: full
                            ? _kTertiary.withValues(alpha: 0.45)
                            : _kTertiary.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DescriptionPanel extends StatelessWidget {
  const _DescriptionPanel({required this.slot, required this.l10n});

  final RehearsalSlotOption slot;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kSurfaceHigh.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kOutline.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _kPrimary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.dry_cleaning_rounded, color: _kPrimary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.rehearsalProgramLabel,
                  style: const TextStyle(
                    color: _kOnSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'HelveticaNeueCyr',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  slot.description,
                  style: const TextStyle(
                    color: _kTertiary,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                _rehearsalVenueCaptionRow(
                  caption: slot.place,
                  mapUrl: slot.mapUrl,
                  style: const TextStyle(
                    color: _kOnSurface,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookedPanel extends StatelessWidget {
  const _BookedPanel({
    required this.bookings,
    required this.maxMainRehearsals,
    required this.locale,
    required this.bookingBusy,
    required this.canEdit,
    required this.lockedHint,
    required this.onAddMore,
  });

  final List<RehearsalBookingInfo> bookings;
  final int maxMainRehearsals;
  final String locale;
  final bool bookingBusy;
  final bool canEdit;
  final String lockedHint;
  final VoidCallback onAddMore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_rounded, color: _kPrimary, size: 44),
        const SizedBox(height: 10),
        Text(
          '${l10n.rehearsalBookedTitle} (${bookings.length}/$maxMainRehearsals)',
          textAlign: TextAlign.left,
          style: const TextStyle(
            color: _kOnSurface,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            fontFamily: 'HelveticaNeueCyr',
          ),
        ),
        const SizedBox(height: 12),
        ...bookings.asMap().entries.map((entry) {
          final idx = entry.key;
          final booking = entry.value;
          final d = DateTime.tryParse(booking.slotDate);
          final dateStr = d != null
              ? DateFormat.yMMMMd(locale).format(d)
              : booking.slotDate;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _kSurfaceHigh,
                borderRadius: BorderRadius.circular(12),
                border: const Border(
                  left: BorderSide(color: _kPrimary, width: 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${idx + 1} · $dateStr, ${AppSettings.formatTimeLabel(booking.slotTime)}',
                    style: const TextStyle(
                      color: _kPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    booking.description,
                    style: const TextStyle(color: _kOnSurface, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  _rehearsalVenueCaptionRow(
                    caption: booking.place,
                    mapUrl: booking.mapUrl,
                    leadingIcon: Icons.place_outlined,
                    leadingColor: _kTertiary,
                    style: const TextStyle(color: _kTertiary, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: (bookingBusy || !canEdit) ? null : onAddMore,
          style: OutlinedButton.styleFrom(
            foregroundColor: canEdit ? _kPrimary : _kTertiary,
            side: BorderSide(
              color: canEdit
                  ? _kOutline.withValues(alpha: 0.35)
                  : _kOutline.withValues(alpha: 0.15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          child: bookingBusy
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _kPrimary,
                  ),
                )
              : Text(
                  l10n.rehearsalUpdateBooking.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),
        ),
        if (!canEdit) ...[
          const SizedBox(height: 12),
          Text(
            lockedHint,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kTertiary.withValues(alpha: 0.75),
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(
              Icons.info_outline,
              color: _kTertiary.withValues(alpha: 0.6),
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.rehearsalArriveEarly,
                style: TextStyle(
                  color: _kTertiary.withValues(alpha: 0.65),
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
