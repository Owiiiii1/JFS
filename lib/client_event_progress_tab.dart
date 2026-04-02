import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'api/auth_service.dart';
import 'gen_l10n/app_localizations.dart';

const _kLuxuryBlack = Color(0xFF0A0A0A);
const _kLuxuryGray = Color(0xFF1A1A1A);
const _kProgressGold = Color(0xFFC5A059);

class ClientEventProgressTab extends StatelessWidget {
  const ClientEventProgressTab({
    super.key,
    required this.assignment,
    required this.childFullName,
    required this.onOpenInfo,
    required this.onOpenGallery,
  });

  final ActiveAssignment? assignment;
  final String childFullName;
  final VoidCallback onOpenInfo;
  final VoidCallback onOpenGallery;

  @override
  Widget build(BuildContext context) {
    if (assignment == null) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noActiveEvents,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    final a = assignment!;
    final milestones = _buildMilestones(context, a);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            a.event.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              height: 1.05,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            childFullName.isEmpty
                ? AppLocalizations.of(context)!.journeyProgress
                : childFullName.toUpperCase(),
            style: const TextStyle(
              color: _kProgressGold,
              fontSize: 10,
              letterSpacing: 3.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _TopActionButton(
                  icon: Icons.info_outline,
                  label: 'Event info',
                  onTap: onOpenInfo,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TopActionButton(
                  icon: Icons.photo_library_outlined,
                  label: 'Show gallery',
                  onTap: onOpenGallery,
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

  static List<_JourneyMilestone> _buildMilestones(
    BuildContext context,
    ActiveAssignment a,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final items = <_JourneyMilestone>[];
    final parentDots = _parentDotsCount(a);
    final parentCompletedTotal = a.parentProgress?.completedStages ?? 0;
    var mainIndex = 0;

    final prepCount = a.preparatoryStages.length;
    final mainCount = a.mainStages.length;
    final totalStages = math.max(
      1,
      a.totalMainStages + a.totalPreparatoryStages,
    );
    final syntheticMainCount = math.max(
      0,
      totalStages - prepCount - mainCount,
    );
    final hasMainSection = mainCount + syntheticMainCount > 0;

    if (prepCount > 0) {
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

    for (final prep in a.preparatoryStages) {
      final timelineSubtitle = prep.scheduledAt != null
          ? _formatDateTime(prep.scheduledAt!)
          : '';
      final desc = prep.description?.trim();
      final prepTitle = prep.displayTitle(l10n);
      final rehearsalHint = prep.isRehearsalMilestone &&
              !prep.isCompleted &&
              prep.scheduledAt == null
          ? l10n.rehearsalNextBookHint
          : null;
      items.add(
        _JourneyMilestone(
          title: prepTitle,
          subtitle: timelineSubtitle,
          rawDate: prep.scheduledAt,
          address: prep.address,
          detailDescription:
              desc != null && desc.isNotEmpty ? desc : null,
          rehearsalBookingHint: rehearsalHint,
          isMainStage: false,
          parentDots: 0,
          parentDotsCompleted: 0,
          mainSequenceIndex: null,
        ),
      );
    }

    if (prepCount > 0 && hasMainSection) {
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
      items.add(
        _JourneyMilestone(
          title: title,
          subtitle: '',
          rawDate: null,
          address: null,
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

    final firstIncompletePrep =
        a.preparatoryStages.indexWhere((p) => !p.isCompleted);
    var prepSlot = 0;
    for (var i = 0; i < items.length && prepSlot < prepCount; i++) {
      final row = items[i];
      if (row.rowKind != _JourneyRowKind.milestone || row.isMainStage) {
        continue;
      }
      final prep = a.preparatoryStages[prepSlot];
      final status = prep.isCompleted
          ? _MilestoneStatus.completed
          : (firstIncompletePrep == prepSlot
                ? _MilestoneStatus.current
                : _MilestoneStatus.upcoming);
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

  static int _parentDotsCount(ActiveAssignment a) {
    if (!a.familyLook || a.parentProgress == null) {
      return 0;
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

  static String _formatDateTime(DateTime dt) {
    const months = [
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
    final month = months[dt.month - 1];
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$month ${dt.day}, ${dt.year} • $hh:$mm';
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _kProgressGold.withValues(alpha: 0.72),
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 3.6,
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

/// Full-width gradient rule + main event title (reference: stitch code.html).
class _MainEventSectionBand extends StatelessWidget {
  const _MainEventSectionBand({
    required this.title,
    required this.subtitle,
  });

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
        // Текущий этап: крупный заголовок + бейдж + подзаголовок — без запаса наезжают на следующую строку.
        return m.status == _MilestoneStatus.current ? 292 : 228;
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
        c = Offset(
          constraints.maxWidth * 0.5 - timelineShiftLeft,
          centerY,
        );
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
          onTap: () => onTap(milestone),
        );
    }
  }
}

class _MilestoneButton extends StatelessWidget {
  const _MilestoneButton({
    required this.milestone,
    required this.center,
    required this.onTap,
  });

  final _JourneyMilestone milestone;
  final Offset center;
  final VoidCallback onTap;

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
              width: isCurrent ? 220 : 140,
              child: Column(
                children: [
                  if (isCurrent)
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        milestone.title.toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        softWrap: false,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          letterSpacing: -0.3,
                          height: 1.05,
                        ),
                      ),
                    )
                  else
                    Text(
                      milestone.title.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                        maxLines: isCurrent ? 3 : 2,
                        overflow: TextOverflow.ellipsis,
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

enum _JourneyRowKind {
  milestone,
  preparationPhaseLabel,
  mainEventDivider,
}

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
