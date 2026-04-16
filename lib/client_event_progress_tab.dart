import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_settings.dart';
import 'api/auth_service.dart';
import 'gen_l10n/app_localizations.dart';

/// Семейство шрифтов для названия ивента (как на главной).
const _kFontFamilyLuxenta = 'Luxenta';

const _kLuxuryBlack = Color(0xFF0A0A0A);
const _kLuxuryGray = Color(0xFF1A1A1A);
const _kProgressGold = Color(0xFFC5A059);

/// One row in the journey timeline (may expand a single API prep stage, e.g. multiple main rehearsals).
class _ExpandedPrepRow {
  const _ExpandedPrepRow({
    required this.prep,
    required this.prepIndex,
    this.booking,
    this.bookingIndex,
    this.bookingTotal,
  });

  final PreparatoryStageInfo prep;
  final int prepIndex;
  final RehearsalBookingInfo? booking;
  final int? bookingIndex;
  final int? bookingTotal;
}

enum _TimelineActor { child, mom, dad }

class ClientEventProgressTab extends StatefulWidget {
  const ClientEventProgressTab({
    super.key,
    required this.assignment,
    required this.childFullName,
    required this.onOpenCheckin,
    required this.onOpenInfo,
    required this.onOpenGallery,
  });

  final ActiveAssignment? assignment;
  final String childFullName;
  final void Function(String checkinCode) onOpenCheckin;
  final VoidCallback onOpenInfo;
  final VoidCallback onOpenGallery;

  @override
  State<ClientEventProgressTab> createState() => _ClientEventProgressTabState();
}

class _ClientEventProgressTabState extends State<ClientEventProgressTab> {
  _TimelineActor _selectedActor = _TimelineActor.child;

  @override
  Widget build(BuildContext context) {
    final assignment = widget.assignment;
    if (assignment == null) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noActiveEvents,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
          textAlign: TextAlign.center,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    final a = assignment;
    final availableActors = _availableActors(a);
    if (!availableActors.contains(_selectedActor)) {
      _selectedActor = availableActors.first;
    }

    final milestones = switch (_selectedActor) {
      _TimelineActor.child => _buildMilestones(context, a),
      _TimelineActor.mom => _buildParentMilestones(
        context,
        a,
        participantSlot: 1,
      ),
      _TimelineActor.dad => _buildParentMilestones(
        context,
        a,
        participantSlot: 2,
      ),
    };

    final headerLine = switch (_selectedActor) {
      _TimelineActor.child =>
        widget.childFullName.isEmpty
            ? AppLocalizations.of(context)!.journeyProgress
            : widget.childFullName.toUpperCase(),
      _TimelineActor.mom => _actorLabel(
        context,
        _TimelineActor.mom,
      ).toUpperCase(),
      _TimelineActor.dad => _actorLabel(
        context,
        _TimelineActor.dad,
      ).toUpperCase(),
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            a.event.name,
            style: const TextStyle(
              fontFamily: _kFontFamilyLuxenta,
              color: Colors.white,
              fontSize: 26,
              height: 1.05,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          const SizedBox(height: 4),
          Text(
            headerLine,
            style: const TextStyle(
              color: _kProgressGold,
              fontSize: 12,
              letterSpacing: 3.2,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          if (availableActors.length > 1) ...[
            const SizedBox(height: 14),
            _ActorSwitch(
              selected: _selectedActor,
              actors: availableActors,
              labelFor: (actor) => _actorLabel(context, actor),
              onChanged: (actor) {
                if (_selectedActor == actor) return;
                setState(() => _selectedActor = actor);
              },
            ),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: _TopActionButton(
              icon: Icons.qr_code_scanner_rounded,
              label: AppLocalizations.of(context)!.eventProgressCheckin,
              onTap: () {
                final code = (a.checkinCode ?? '').trim();
                if (code.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(
                          context,
                        )!.eventProgressCheckinUnavailable,
                      ),
                    ),
                  );
                  return;
                }
                widget.onOpenCheckin(code);
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _TopActionButton(
                  icon: Icons.info_outline,
                  label: AppLocalizations.of(context)!.eventDescriptionTitle,
                  onTap: widget.onOpenInfo,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TopActionButton(
                  icon: Icons.photo_library_outlined,
                  label: AppLocalizations.of(context)!.eventProgressShowGallery,
                  onTap: widget.onOpenGallery,
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          _JourneyTimeline(
            milestones: milestones,
            onTap: (m) {
              if (m.rowKind != _JourneyRowKind.milestone) {
                return;
              }
              _showMilestoneDetails(context, m);
            },
          ),
        ],
      ),
    );
  }

  List<_TimelineActor> _availableActors(ActiveAssignment a) {
    final out = <_TimelineActor>[_TimelineActor.child];
    final hasMom = a.parentTimelines.any((t) => t.participantSlot == 1);
    final hasDad = a.parentTimelines.any((t) => t.participantSlot == 2);
    if (hasMom) out.add(_TimelineActor.mom);
    if (hasDad) out.add(_TimelineActor.dad);
    return out;
  }

  String _actorLabel(BuildContext context, _TimelineActor actor) {
    final lang = Localizations.localeOf(context).languageCode.toLowerCase();
    switch (actor) {
      case _TimelineActor.child:
        if (lang == 'ru') return 'Ребенок';
        if (lang == 'uk') return 'Дитина';
        if (lang == 'es') return 'Niño';
        return 'Child';
      case _TimelineActor.mom:
        if (lang == 'ru') return 'Мама';
        if (lang == 'uk') return 'Мама';
        if (lang == 'es') return 'Mamá';
        return 'Mom';
      case _TimelineActor.dad:
        if (lang == 'ru') return 'Папа';
        if (lang == 'uk') return 'Тато';
        if (lang == 'es') return 'Papá';
        return 'Dad';
    }
  }

  static List<_ExpandedPrepRow> _expandedPreparatoryRows(ActiveAssignment a) {
    final out = <_ExpandedPrepRow>[];
    for (var pi = 0; pi < a.preparatoryStages.length; pi++) {
      final prep = a.preparatoryStages[pi];
      final bookings = a.rehearsalBookings;
      if (prep.isRehearsalMilestone && bookings.length > 1) {
        final n = bookings.length;
        for (var i = 0; i < n; i++) {
          out.add(
            _ExpandedPrepRow(
              prep: prep,
              prepIndex: pi,
              booking: bookings[i],
              bookingIndex: i + 1,
              bookingTotal: n,
            ),
          );
        }
      } else {
        out.add(_ExpandedPrepRow(prep: prep, prepIndex: pi));
      }
    }
    return out;
  }

  static bool _isRehearsalTimelineRow(_ExpandedPrepRow row) {
    final p = row.prep;
    return p.isRehearsalMilestone || p.isBrandRehearsalMilestone;
  }

  /// Slot date/time from API (`Y-m-d`, `H:i`) for sorting when [RehearsalBookingInfo.startsAt] is absent.
  static DateTime? _parseSlotDateTimeForSort(String slotDate, String slotTime) {
    final d = slotDate.trim();
    if (d.isEmpty) return null;
    var t = slotTime.trim();
    if (t.length > 5) t = t.substring(0, 5);
    try {
      final dp = d.split('-');
      if (dp.length != 3) return null;
      final year = int.parse(dp[0]);
      final month = int.parse(dp[1]);
      final day = int.parse(dp[2]);
      var hour = 0;
      var minute = 0;
      if (t.isNotEmpty) {
        final tp = t.split(':');
        hour = int.parse(tp[0]);
        if (tp.length > 1) minute = int.parse(tp[1]);
      }
      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  static DateTime? _effectiveSortDateForPrepRow(_ExpandedPrepRow row) {
    final b = row.booking;
    if (b != null) {
      if (b.startsAt != null) return b.startsAt;
      return _parseSlotDateTimeForSort(b.slotDate, b.slotTime);
    }
    return row.prep.scheduledAt;
  }

  static int _compareRehearsalPrepRowsByDate(
    _ExpandedPrepRow a,
    _ExpandedPrepRow b,
  ) {
    final da = _effectiveSortDateForPrepRow(a);
    final db = _effectiveSortDateForPrepRow(b);
    if (da == null && db == null) {
      final byPrep = a.prepIndex.compareTo(b.prepIndex);
      if (byPrep != 0) return byPrep;
      return (a.bookingIndex ?? 0).compareTo(b.bookingIndex ?? 0);
    }
    if (da == null) return 1;
    if (db == null) return -1;
    final byDate = da.compareTo(db);
    if (byDate != 0) return byDate;
    final byPrep = a.prepIndex.compareTo(b.prepIndex);
    if (byPrep != 0) return byPrep;
    return (a.bookingIndex ?? 0).compareTo(b.bookingIndex ?? 0);
  }

  /// Оставляет порядок не‑репетиций как в API; все репетиции (основные слоты + брендовые) — по возрастанию даты.
  static List<_ExpandedPrepRow> _sortRehearsalRowsChronologically(
    List<_ExpandedPrepRow> rows,
  ) {
    final rehearsalIndices = <int>[];
    for (var i = 0; i < rows.length; i++) {
      if (_isRehearsalTimelineRow(rows[i])) {
        rehearsalIndices.add(i);
      }
    }
    if (rehearsalIndices.length <= 1) return rows;
    final sortedRehearsals = rehearsalIndices.map((i) => rows[i]).toList()
      ..sort(_compareRehearsalPrepRowsByDate);
    final out = List<_ExpandedPrepRow>.from(rows);
    for (var k = 0; k < rehearsalIndices.length; k++) {
      out[rehearsalIndices[k]] = sortedRehearsals[k];
    }
    return out;
  }

  /// Один активный этап в предварительной фазе: среди незавершённых — ближайший по времени к «сейчас».
  /// Сначала ближайший с датой ≥ now; если таких нет — самый поздний из уже прошедших (все ещё incomplete).
  /// Без дат — порядок как в таймлайне: [prepIndex], [bookingIndex].
  static int? _pickCurrentExpandedPrepIndex(
    List<_ExpandedPrepRow> expandedPrep,
  ) {
    final now = DateTime.now();
    final incomplete = <int>[];
    for (var ei = 0; ei < expandedPrep.length; ei++) {
      if (!expandedPrep[ei].prep.isCompleted) {
        incomplete.add(ei);
      }
    }
    if (incomplete.isEmpty) return null;

    /// Отрицательное, если [eiA] предпочтительнее [eiB] как «текущий».
    int cmpNearestToNow(int eiA, int eiB) {
      final rowA = expandedPrep[eiA];
      final rowB = expandedPrep[eiB];
      final da = _effectiveSortDateForPrepRow(rowA);
      final db = _effectiveSortDateForPrepRow(rowB);
      if (da == null && db == null) {
        return _compareRehearsalPrepRowsByDate(rowA, rowB);
      }
      if (da == null) return 1;
      if (db == null) return -1;

      final aFuture = !da.isBefore(now);
      final bFuture = !db.isBefore(now);
      if (aFuture && bFuture) {
        return da.compareTo(db);
      }
      if (aFuture != bFuture) {
        return aFuture ? -1 : 1;
      }
      return db.compareTo(da);
    }

    var best = incomplete.first;
    for (var k = 1; k < incomplete.length; k++) {
      final ei = incomplete[k];
      if (cmpNearestToNow(ei, best) < 0) {
        best = ei;
      }
    }
    return best;
  }

  static String _rehearsalBookingSubtitle(RehearsalBookingInfo b) {
    final d = b.slotDate.trim();
    final t = b.slotTime.trim();
    final core = [d, t].where((s) => s.isNotEmpty).join(' • ');
    if (core.isEmpty) return '';
    final p = b.place.trim();
    if (p.isEmpty) return core;
    return '$core · $p';
  }

  static List<_JourneyMilestone> _buildMilestones(
    BuildContext context,
    ActiveAssignment a,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final items = <_JourneyMilestone>[];
    final parentDots = _parentDotsCount(a);
    final parentCompletedTotal = a.parentProgress?.completedStages ?? 0;
    var mainIndex = 0;

    final expandedPrep = _sortRehearsalRowsChronologically(
      _expandedPreparatoryRows(a),
    );
    final prepRowCount = expandedPrep.length;
    final prepListCount = a.preparatoryStages.length;
    final mainCount = a.mainStages.length;
    final totalStages = math.max(
      1,
      a.totalMainStages + a.totalPreparatoryStages,
    );
    final syntheticMainCount = math.max(
      0,
      totalStages - prepListCount - mainCount,
    );
    final hasMainSection = mainCount + syntheticMainCount > 0;

    if (prepRowCount > 0) {
      items.add(
        _JourneyMilestone(
          rowKind: _JourneyRowKind.preparationPhaseLabel,
          title: l10n.journeyPreparationPhase,
          subtitle: '',
          rawDate: null,
          address: null,
          isMainStage: false,
          parentDots: 0,
          parentDotsCompleted: 0,
          mainSequenceIndex: null,
        ),
      );
    }

    final mainRehearsalChronoRankBySlotId = <int, int>{};
    final multiMainByPrep = <int, List<_ExpandedPrepRow>>{};
    for (final row in expandedPrep) {
      if (row.booking != null &&
          row.prep.isRehearsalMilestone &&
          row.bookingTotal != null &&
          row.bookingTotal! > 1) {
        multiMainByPrep.putIfAbsent(row.prepIndex, () => []).add(row);
      }
    }
    for (final list in multiMainByPrep.values) {
      final sorted = List<_ExpandedPrepRow>.from(list)
        ..sort(_compareRehearsalPrepRowsByDate);
      for (var i = 0; i < sorted.length; i++) {
        mainRehearsalChronoRankBySlotId[sorted[i].booking!.slotId] = i + 1;
      }
    }

    for (final row in expandedPrep) {
      final prep = row.prep;
      final b = row.booking;
      final String title;
      if (b != null &&
          row.bookingTotal != null &&
          row.bookingTotal! > 1 &&
          prep.isRehearsalMilestone) {
        final r =
            mainRehearsalChronoRankBySlotId[b.slotId] ?? row.bookingIndex ?? 1;
        title = '${l10n.rehearsalMilestoneTitle} ($r/${row.bookingTotal})';
      } else {
        title = prep.displayTitle(l10n);
      }

      final DateTime? rawDate;
      final String timelineSubtitle;
      final String? address;
      final String? detailDesc;
      if (b != null) {
        // Prefer API slot_date + slot_time so the timeline matches the admin grid (event-local wall clock).
        final wallFromSlot = _rehearsalSlotWallClockLabel(b);
        if (wallFromSlot != null) {
          rawDate = null;
          timelineSubtitle = wallFromSlot;
        } else {
          rawDate = b.startsAt;
          timelineSubtitle = rawDate != null
              ? _formatDateTime(rawDate)
              : _rehearsalBookingSubtitle(b);
        }
        address = b.place.trim().isNotEmpty ? b.place : prep.address;
        final slotDesc = b.description.trim();
        detailDesc = slotDesc.isNotEmpty ? slotDesc : null;
      } else {
        rawDate = prep.scheduledAt;
        timelineSubtitle = prep.scheduledAt != null
            ? _formatDateTime(prep.scheduledAt!)
            : '';
        address = prep.address;
        final desc = prep.description?.trim();
        detailDesc = desc != null && desc.isNotEmpty ? desc : null;
      }

      final rehearsalHint =
          prep.isRehearsalMilestone &&
              !prep.isCompleted &&
              prep.scheduledAt == null &&
              a.rehearsalBookings.isEmpty
          ? l10n.rehearsalNextBookHint
          : null;
      items.add(
        _JourneyMilestone(
          title: title,
          subtitle: timelineSubtitle,
          rawDate: rawDate,
          address: address,
          detailDescription: detailDesc,
          rehearsalBookingHint: rehearsalHint,
          isMainStage: false,
          parentDots: 0,
          parentDotsCompleted: 0,
          mainSequenceIndex: null,
        ),
      );
    }

    if (prepRowCount > 0 && hasMainSection) {
      items.add(
        _JourneyMilestone(
          rowKind: _JourneyRowKind.mainEventDivider,
          title: l10n.journeyMainEventTitle,
          subtitle: l10n.journeyMainEventSubtitle,
          rawDate: null,
          address: null,
          isMainStage: false,
          parentDots: 0,
          parentDotsCompleted: 0,
          mainSequenceIndex: null,
        ),
      );
    }

    for (final stage in a.mainStages) {
      final title = stage.name.trim().isEmpty
          ? (stage.id > 0 ? 'Stage #${stage.id}' : 'Stage')
          : stage.name.trim();
      final mainDesc = stage.description?.trim();
      items.add(
        _JourneyMilestone(
          title: title,
          subtitle: '',
          rawDate: null,
          address: null,
          detailDescription: mainDesc != null && mainDesc.isNotEmpty
              ? mainDesc
              : null,
          isMainStage: true,
          parentDots: parentDots,
          parentDotsCompleted: 0,
          mainSequenceIndex: mainIndex++,
        ),
      );
    }

    for (var i = 0; i < syntheticMainCount; i++) {
      final isLast = i == syntheticMainCount - 1;
      items.add(
        _JourneyMilestone(
          title: isLast ? 'Runway' : 'Stage ${i + 1}',
          subtitle: isLast ? a.event.city : '',
          rawDate: null,
          address: null,
          isMainStage: true,
          parentDots: parentDots,
          parentDotsCompleted: 0,
          mainSequenceIndex: mainIndex++,
        ),
      );
    }

    if (parentDots > 0 && parentCompletedTotal > 0) {
      for (var i = 0; i < items.length; i++) {
        final m = items[i];
        if (!m.isMainStage || m.mainSequenceIndex == null) {
          continue;
        }
        final consumedBefore = m.mainSequenceIndex! * parentDots;
        final completedForStep = (parentCompletedTotal - consumedBefore).clamp(
          0,
          parentDots,
        );
        items[i] = m.copyWith(parentDotsCompleted: completedForStep);
      }
    }

    final currentExpandedPrepIndex = _pickCurrentExpandedPrepIndex(
      expandedPrep,
    );
    var prepSlot = 0;
    for (var i = 0; i < items.length && prepSlot < prepRowCount; i++) {
      final row = items[i];
      if (row.rowKind != _JourneyRowKind.milestone || row.isMainStage) {
        continue;
      }
      final exp = expandedPrep[prepSlot];
      final _MilestoneStatus status;
      if (exp.prep.isCompleted) {
        status = _MilestoneStatus.completed;
      } else if (currentExpandedPrepIndex != null &&
          prepSlot == currentExpandedPrepIndex) {
        status = _MilestoneStatus.current;
      } else {
        status = _MilestoneStatus.upcoming;
      }
      items[i] = row.copyWith(status: status);
      prepSlot++;
    }

    final prepDone = a.preparatoryStages.where((p) => p.isCompleted).length;
    var mainCompleted = a.completedStages - prepDone;
    if (mainCompleted < 0) {
      mainCompleted = 0;
    }
    if (mainCompleted > a.totalMainStages) {
      mainCompleted = a.totalMainStages;
    }

    for (var j = 0; j < items.length; j++) {
      final m = items[j];
      if (!m.isMainStage || m.mainSequenceIndex == null) {
        continue;
      }
      final idx = m.mainSequenceIndex!;
      final status = idx < mainCompleted
          ? _MilestoneStatus.completed
          : (idx == mainCompleted
                ? _MilestoneStatus.current
                : _MilestoneStatus.upcoming);
      items[j] = m.copyWith(status: status);
    }

    return items;
  }

  static List<_JourneyMilestone> _buildParentMilestones(
    BuildContext context,
    ActiveAssignment a, {
    required int participantSlot,
  }) {
    final t = a.parentTimelines.firstWhere(
      (it) => it.participantSlot == participantSlot,
      orElse: () => ParentTimelineInfo(
        participantSlot: participantSlot,
        totalStages: 0,
        completedStages: 0,
        mainStages: const [],
      ),
    );
    final items = <_JourneyMilestone>[];
    var mainIndex = 0;
    for (final stage in t.mainStages) {
      final title = stage.name.trim().isEmpty
          ? (stage.id > 0 ? 'Stage #${stage.id}' : 'Stage')
          : stage.name.trim();
      final mainDesc = stage.description?.trim();
      items.add(
        _JourneyMilestone(
          title: title,
          subtitle: '',
          rawDate: null,
          address: null,
          detailDescription: mainDesc != null && mainDesc.isNotEmpty
              ? mainDesc
              : null,
          isMainStage: true,
          parentDots: 0,
          parentDotsCompleted: 0,
          mainSequenceIndex: mainIndex++,
        ),
      );
    }
    final total = t.totalStages > 0 ? t.totalStages : t.mainStages.length;
    var done = t.completedStages.clamp(0, total);
    for (var i = 0; i < items.length; i++) {
      final status = i < done
          ? _MilestoneStatus.completed
          : (i == done ? _MilestoneStatus.current : _MilestoneStatus.upcoming);
      items[i] = items[i].copyWith(status: status);
    }
    return items;
  }

  static int _parentDotsCount(ActiveAssignment a) {
    if (!a.familyLook || a.parentProgress == null) {
      return 0;
    }
    final explicitParticipants = a.parentParticipantsCount;
    if (explicitParticipants != null && explicitParticipants > 0) {
      return explicitParticipants.clamp(1, 2);
    }
    final parentTotal = a.parentProgress!.totalStages;
    if (parentTotal <= 0) {
      return 0;
    }
    final baseMainStages = a.mainStages.isNotEmpty
        ? a.mainStages.length
        : (a.totalMainStages > 0 ? a.totalMainStages : 1);
    final raw = (parentTotal / baseMainStages).round();
    return raw.clamp(1, 2);
  }

  static const List<String> _timelineMonthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String _formatWallClockParts(
    int year,
    int month,
    int day,
    int hour,
    int minute,
  ) {
    final mon = _timelineMonthNames[month - 1];
    return '$mon $day, $year • ${AppSettings.formatTime(hour, minute)}';
  }

  /// `slot_date` (Y-m-d) + `slot_time` (H:i) from API — same values as in YFS admin.
  static String? _rehearsalSlotWallClockLabel(RehearsalBookingInfo b) {
    final d = b.slotDate.trim();
    var t = b.slotTime.trim();
    if (d.isEmpty || t.isEmpty) return null;
    if (t.length > 5) t = t.substring(0, 5);
    try {
      final dp = d.split('-');
      if (dp.length != 3) return null;
      final year = int.parse(dp[0]);
      final month = int.parse(dp[1]);
      final day = int.parse(dp[2]);
      final tp = t.split(':');
      final hour = int.parse(tp[0]);
      final minute = tp.length > 1 ? int.parse(tp[1]) : 0;
      if (month < 1 || month > 12) return null;
      return _formatWallClockParts(year, month, day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  /// Formats for display in the device timezone. API times are ISO 8601 (often UTC `Z`);
  /// using [DateTime.hour] on a UTC value would show the wrong wall clock (e.g. 22:45 UTC vs 00:45 local).
  static String _formatDateTime(DateTime dt) {
    final local = dt.toLocal();
    return _formatWallClockParts(
      local.year,
      local.month,
      local.day,
      local.hour,
      local.minute,
    );
  }

  static List<Widget> _milestoneDetailBodyWidgets(_JourneyMilestone m) {
    final lines = <String>[];
    if (m.rawDate != null) {
      lines.add(_formatDateTime(m.rawDate!));
    }
    final addr = m.address?.trim();
    if (addr != null && addr.isNotEmpty) {
      lines.add(addr);
    }
    final desc = m.detailDescription?.trim();
    if (desc != null && desc.isNotEmpty) {
      lines.add(desc);
    }
    final hint = m.rehearsalBookingHint?.trim();
    if (hint != null && hint.isNotEmpty) {
      lines.add(hint);
    }
    if (lines.isEmpty && m.subtitle.trim().isNotEmpty) {
      lines.add(m.subtitle.trim());
    }
    if (lines.isEmpty) {
      return const [];
    }
    return [
      const SizedBox(height: 14),
      for (var i = 0; i < lines.length; i++) ...[
        if (i > 0) const SizedBox(height: 10),
        Text(
          lines[i],
          style: const TextStyle(color: Colors.white70, fontSize: 14),
          softWrap: true,
        ),
      ],
    ];
  }

  static Future<void> _showMilestoneDetails(
    BuildContext context,
    _JourneyMilestone m,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: _kLuxuryGray,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        final statusText = switch (m.status) {
          _MilestoneStatus.completed => 'Completed',
          _MilestoneStatus.current => 'In progress',
          _MilestoneStatus.upcoming => 'Upcoming',
        };
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  m.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                const SizedBox(height: 8),
                Text(
                  statusText,
                  style: const TextStyle(
                    color: _kProgressGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
                ..._milestoneDetailBodyWidgets(m),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(
                      l10n.details,
                      style: const TextStyle(color: _kProgressGold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TopActionButton extends StatelessWidget {
  const _TopActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: _kLuxuryGray,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _kProgressGold.withOpacity(0.2)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
              const SizedBox(height: 8),
              Text(
                label.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Narrow gold fade line + label (reference: preparation phase header).
class _PreparationPhaseBand extends StatelessWidget {
  const _PreparationPhaseBand({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kProgressGold.withValues(alpha: 0.72),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.8,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              height: 1,
              width: 96,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _kProgressGold.withValues(alpha: 0),
                    _kProgressGold.withValues(alpha: 0.35),
                    _kProgressGold.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActorSwitch extends StatelessWidget {
  const _ActorSwitch({
    required this.selected,
    required this.actors,
    required this.labelFor,
    required this.onChanged,
  });

  final _TimelineActor selected;
  final List<_TimelineActor> actors;
  final String Function(_TimelineActor actor) labelFor;
  final ValueChanged<_TimelineActor> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _kLuxuryGray,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          for (final actor in actors)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(actor),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selected == actor
                        ? _kProgressGold
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    labelFor(actor),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: selected == actor ? _kLuxuryBlack : Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Full-width gradient rule + main event title (reference: stitch code.html).
class _MainEventSectionBand extends StatelessWidget {
  const _MainEventSectionBand({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 1,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _kProgressGold.withValues(alpha: 0),
                    _kProgressGold.withValues(alpha: 0.32),
                    _kProgressGold.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _kProgressGold,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 4.2,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.38),
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _JourneyTimeline extends StatelessWidget {
  const _JourneyTimeline({required this.milestones, required this.onTap});

  final List<_JourneyMilestone> milestones;
  final ValueChanged<_JourneyMilestone> onTap;

  static double _rowHeight(_JourneyMilestone m) {
    switch (m.rowKind) {
      case _JourneyRowKind.preparationPhaseLabel:
        return 56;
      case _JourneyRowKind.mainEventDivider:
        return 104;
      case _JourneyRowKind.milestone:
        // Текущий этап: до 4 строк заголовка + бейдж + подзаголовок — запас по вертикали.
        return m.status == _MilestoneStatus.current ? 340 : 228;
    }
  }

  @override
  Widget build(BuildContext context) {
    const timelineShiftLeft = 24.0;
    const topPad = 40.0;
    const bottomPad = 48.0;

    var totalHeight = topPad + bottomPad;
    for (final m in milestones) {
      totalHeight += _rowHeight(m);
    }

    return SizedBox(
      height: totalHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final rowLayouts = _computeRowLayouts(
            constraints: constraints,
            timelineShiftLeft: timelineShiftLeft,
            topPad: topPad,
          );
          final pathPoints = rowLayouts.map((e) => e.center).toList();

          final stackW = constraints.maxWidth;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _TimelinePathPainter(points: pathPoints),
                ),
              ),
              for (var i = 0; i < milestones.length; i++)
                _buildRowWidget(
                  milestone: milestones[i],
                  top: rowLayouts[i].top,
                  height: rowLayouts[i].height,
                  center: rowLayouts[i].center,
                  stackWidth: stackW,
                ),
            ],
          );
        },
      ),
    );
  }

  List<({double top, double height, Offset center})> _computeRowLayouts({
    required BoxConstraints constraints,
    required double timelineShiftLeft,
    required double topPad,
  }) {
    final layouts = <({double top, double height, Offset center})>[];
    var y = topPad;
    var pathMilestoneIndex = 0;

    for (var i = 0; i < milestones.length; i++) {
      final m = milestones[i];
      final h = _rowHeight(m);
      final centerY = y + h / 2;

      late Offset c;
      if (m.rowKind != _JourneyRowKind.milestone) {
        c = Offset(constraints.maxWidth * 0.5 - timelineShiftLeft, centerY);
      } else {
        final isLeft = pathMilestoneIndex.isEven;
        pathMilestoneIndex++;
        final baseX = isLeft
            ? constraints.maxWidth * 0.3
            : constraints.maxWidth * 0.74;
        final rnd = math.Random((i + 1) * 9173 + milestones.length * 37);
        final driftX = (rnd.nextDouble() - 0.5) * 16;
        final driftY = (rnd.nextDouble() - 0.5) * 24;
        final cx = (baseX + driftX - timelineShiftLeft).clamp(
          100.0,
          constraints.maxWidth - 104.0,
        );
        c = Offset(cx, centerY + driftY);
      }

      layouts.add((top: y, height: h, center: c));
      y += h;
    }

    return layouts;
  }

  Widget _buildRowWidget({
    required _JourneyMilestone milestone,
    required double top,
    required double height,
    required Offset center,
    required double stackWidth,
  }) {
    switch (milestone.rowKind) {
      case _JourneyRowKind.preparationPhaseLabel:
        return Positioned(
          left: 0,
          right: 0,
          top: top,
          height: height,
          child: _PreparationPhaseBand(title: milestone.title),
        );
      case _JourneyRowKind.mainEventDivider:
        return Positioned(
          left: 0,
          right: 0,
          top: top,
          height: height,
          child: _MainEventSectionBand(
            title: milestone.title,
            subtitle: milestone.subtitle,
          ),
        );
      case _JourneyRowKind.milestone:
        return _MilestoneButton(
          milestone: milestone,
          center: center,
          stackWidth: stackWidth,
          onTap: () => onTap(milestone),
        );
    }
  }
}

class _MilestoneButton extends StatelessWidget {
  const _MilestoneButton({
    required this.milestone,
    required this.center,
    required this.stackWidth,
    required this.onTap,
  });

  final _JourneyMilestone milestone;
  final Offset center;
  final double stackWidth;
  final VoidCallback onTap;

  /// Ширина колонки подписи под узлом: не шире желаемой и не вылезает за края экрана.
  static double _labelColumnWidth({
    required double stackWidth,
    required double centerDx,
    required bool isCurrent,
  }) {
    final desired = isCurrent ? 220.0 : 140.0;
    const edge = 10.0;
    if (stackWidth <= 2 * edge) {
      return 72.0;
    }
    final cx = centerDx.clamp(edge, stackWidth - edge).toDouble();
    final leftSpace = cx - edge;
    final rightSpace = stackWidth - cx - edge;
    final maxByPosition = 2.0 * math.min(leftSpace, rightSpace);
    return math.min(desired, math.max(72.0, maxByPosition));
  }

  @override
  Widget build(BuildContext context) {
    final isCurrent = milestone.status == _MilestoneStatus.current;
    final isCompleted = milestone.status == _MilestoneStatus.completed;
    final isUpcoming = milestone.status == _MilestoneStatus.upcoming;

    final diameter = isCurrent ? 67.0 : 48.0;
    final left = center.dx - (diameter / 2);
    final top = center.dy - (diameter / 2);

    final bgColor = isCompleted
        ? Colors.white
        : (isCurrent ? _kLuxuryGray : Colors.black.withOpacity(0.55));
    final fgColor = isCompleted
        ? Colors.black
        : (isUpcoming ? Colors.white54 : Colors.white);

    final icon = isCompleted
        ? Icons.check
        : (isCurrent ? Icons.tune : Icons.circle_outlined);

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: isCurrent ? -10 : -7,
                  top: isCurrent ? -10 : -7,
                  child: Container(
                    width: diameter + (isCurrent ? 20 : 14),
                    height: diameter + (isCurrent ? 20 : 14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (isCompleted)
                          BoxShadow(
                            color: Colors.white.withOpacity(0.45),
                            blurRadius: 42,
                            spreadRadius: 8,
                          ),
                        if (isCurrent)
                          BoxShadow(
                            color: _kProgressGold.withOpacity(0.45),
                            blurRadius: 36,
                            spreadRadius: 10,
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: diameter,
                  height: diameter,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCurrent ? Colors.white : Colors.white24,
                      width: isCurrent ? 2.2 : 1,
                    ),
                    boxShadow: const [],
                  ),
                  alignment: Alignment.center,
                  child: isCurrent
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: diameter,
                              height: diameter,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.28),
                                  width: 2,
                                ),
                              ),
                            ),
                            Icon(icon, color: fgColor, size: 24),
                            Positioned(
                              bottom: -6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: const Text(
                                  'IN PROGRESS',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 6,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Icon(icon, color: fgColor, size: 20),
                ),
                if (milestone.parentDots > 0 && milestone.isMainStage)
                  Positioned(
                    right: -12,
                    top: -12,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < milestone.parentDots; i++)
                          Container(
                            margin: EdgeInsets.only(left: i == 0 ? 0 : 4),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: i < milestone.parentDotsCompleted
                                  ? Colors.white
                                  : Colors.black.withOpacity(0.62),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: i < milestone.parentDotsCompleted
                                    ? _kLuxuryBlack
                                    : Colors.white30,
                                width: 2,
                              ),
                              boxShadow: [
                                if (i < milestone.parentDotsCompleted)
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.35),
                                    blurRadius: 16,
                                    spreadRadius: 1,
                                  ),
                              ],
                            ),
                            child: Icon(
                              Icons.person,
                              size: 13,
                              color: i < milestone.parentDotsCompleted
                                  ? Colors.black
                                  : Colors.white60,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: _labelColumnWidth(
                stackWidth: stackWidth,
                centerDx: center.dx,
                isCurrent: isCurrent,
              ),
              child: Column(
                children: [
                  if (isCurrent)
                    Text(
                      milestone.title.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.3,
                        height: 1.05,
                      ),
                    )
                  else
                    Text(
                      milestone.title.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                        color: isUpcoming
                            ? Colors.white.withOpacity(0.32)
                            : Colors.white.withOpacity(0.5),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                  if (milestone.subtitle.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: isCurrent ? 10 : 6),
                      child: Text(
                        milestone.subtitle,
                        textAlign: TextAlign.center,
                        maxLines: isCurrent ? 4 : 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(
                          color: isCurrent
                              ? _kProgressGold
                              : (isUpcoming
                                    ? Colors.white.withOpacity(0.30)
                                    : Colors.white54),
                          fontSize: isCurrent ? 11.5 : 10,
                          fontWeight: isCurrent
                              ? FontWeight.w600
                              : FontWeight.w400,
                          height: 1.25,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isCurrent) const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _TimelinePathPainter extends CustomPainter {
  _TimelinePathPainter({required this.points});

  final List<Offset> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final paint = Paint()
      ..color = _kProgressGold.withOpacity(0.35)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final cur = points[i];
      final control1 = Offset(prev.dx, prev.dy + 68);
      final control2 = Offset(cur.dx, cur.dy - 68);
      path.cubicTo(
        control1.dx,
        control1.dy,
        control2.dx,
        control2.dy,
        cur.dx,
        cur.dy,
      );
    }

    _drawDashedPath(canvas, path, paint, dashLength: 8, dashGap: 8);
  }

  @override
  bool shouldRepaint(covariant _TimelinePathPainter oldDelegate) {
    return oldDelegate.points != points;
  }

  static void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    required double dashLength,
    required double dashGap,
  }) {
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = math.min(distance + dashLength, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashLength + dashGap;
      }
    }
  }
}

enum _MilestoneStatus { completed, current, upcoming }

enum _JourneyRowKind { milestone, preparationPhaseLabel, mainEventDivider }

class _JourneyMilestone {
  const _JourneyMilestone({
    required this.title,
    required this.subtitle,
    required this.rawDate,
    required this.address,
    this.detailDescription,
    this.rehearsalBookingHint,
    required this.isMainStage,
    required this.parentDots,
    required this.parentDotsCompleted,
    required this.mainSequenceIndex,
    this.status = _MilestoneStatus.upcoming,
    this.rowKind = _JourneyRowKind.milestone,
  });

  final String title;
  final String subtitle;
  final DateTime? rawDate;
  final String? address;

  /// Shown only in the details modal (e.g. brand rehearsal notes from API).
  final String? detailDescription;

  /// Shown only in the modal when rehearsal is not yet booked.
  final String? rehearsalBookingHint;
  final bool isMainStage;
  final int parentDots;
  final int parentDotsCompleted;
  final int? mainSequenceIndex;
  final _MilestoneStatus status;
  final _JourneyRowKind rowKind;

  _JourneyMilestone copyWith({
    String? title,
    String? subtitle,
    DateTime? rawDate,
    String? address,
    String? detailDescription,
    String? rehearsalBookingHint,
    bool? isMainStage,
    int? parentDots,
    int? parentDotsCompleted,
    int? mainSequenceIndex,
    _MilestoneStatus? status,
    _JourneyRowKind? rowKind,
  }) {
    return _JourneyMilestone(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      rawDate: rawDate ?? this.rawDate,
      address: address ?? this.address,
      detailDescription: detailDescription ?? this.detailDescription,
      rehearsalBookingHint: rehearsalBookingHint ?? this.rehearsalBookingHint,
      isMainStage: isMainStage ?? this.isMainStage,
      parentDots: parentDots ?? this.parentDots,
      parentDotsCompleted: parentDotsCompleted ?? this.parentDotsCompleted,
      mainSequenceIndex: mainSequenceIndex ?? this.mainSequenceIndex,
      status: status ?? this.status,
      rowKind: rowKind ?? this.rowKind,
    );
  }
}
