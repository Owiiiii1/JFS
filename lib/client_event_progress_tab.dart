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
    final milestones = _buildMilestones(a);

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
            onTap: (m) => _showMilestoneDetails(context, m),
          ),
        ],
      ),
    );
  }

  static List<_JourneyMilestone> _buildMilestones(ActiveAssignment a) {
    final items = <_JourneyMilestone>[];
    final parentDots = _parentDotsCount(a);
    final parentCompletedTotal = a.parentProgress?.completedStages ?? 0;
    var mainIndex = 0;

    for (final prep in a.preparatoryStages) {
      final subtitleParts = <String>[];
      if (prep.address != null && prep.address!.isNotEmpty) {
        subtitleParts.add(prep.address!);
      }
      if (prep.scheduledAt != null) {
        subtitleParts.add(_formatDateTime(prep.scheduledAt!));
      }
      items.add(
        _JourneyMilestone(
          title: prep.name.isEmpty ? 'Stage' : prep.name,
          subtitle: subtitleParts.join(' • '),
          rawDate: prep.scheduledAt,
          address: prep.address,
          isMainStage: false,
          parentDots: 0,
          parentDotsCompleted: 0,
          mainSequenceIndex: null,
        ),
      );
    }

    for (final stage in a.mainStages) {
      if (stage.name.trim().isEmpty) {
        continue;
      }
      items.add(
        _JourneyMilestone(
          title: stage.name,
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

    final totalStages = math.max(
      1,
      a.totalMainStages + a.totalPreparatoryStages,
    );
    final missing = math.max(0, totalStages - items.length);
    for (var i = 0; i < missing; i++) {
      final isLast = i == missing - 1;
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

    final completed = a.completedStages;
    for (var i = 0; i < items.length; i++) {
      final status = completed >= items.length
          ? _MilestoneStatus.completed
          : i < completed
          ? _MilestoneStatus.completed
          : (i == completed
                ? _MilestoneStatus.current
                : _MilestoneStatus.upcoming);
      items[i] = items[i].copyWith(status: status);
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
                if (m.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    m.subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
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

class _JourneyTimeline extends StatelessWidget {
  const _JourneyTimeline({required this.milestones, required this.onTap});

  final List<_JourneyMilestone> milestones;
  final ValueChanged<_JourneyMilestone> onTap;

  @override
  Widget build(BuildContext context) {
    final height = milestones.length * 244.0 + 80.0;
    const timelineShiftLeft = 24.0;

    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final points = <Offset>[];
          for (var i = 0; i < milestones.length; i++) {
            final isLeft = i.isEven;
            final x = isLeft
                ? constraints.maxWidth * 0.3
                : constraints.maxWidth * 0.74;
            final y = 64.0 + i * 228.0;

            // Deterministic random drift: nodes look less "stuck" to path.
            final rnd = math.Random((i + 1) * 9173 + milestones.length * 37);
            final driftX = (rnd.nextDouble() - 0.5) * 16; // -8..8
            final driftY = (rnd.nextDouble() - 0.5) * 24; // -12..12

            final clampedX = (x + driftX - timelineShiftLeft).clamp(
              100.0,
              constraints.maxWidth - 104.0,
            );
            points.add(Offset(clampedX, y + driftY));
          }

          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _TimelinePathPainter(points: points),
                ),
              ),
              for (var i = 0; i < milestones.length; i++)
                _MilestoneButton(
                  milestone: milestones[i],
                  center: points[i],
                  onTap: () => onTap(milestones[i]),
                ),
            ],
          );
        },
      ),
    );
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
              width: 140,
              child: Column(
                children: [
                  Text(
                    milestone.title.toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isCurrent
                          ? Colors.white
                          : (isUpcoming
                                ? Colors.white.withOpacity(0.32)
                                : Colors.white.withOpacity(0.5)),
                      fontSize: isCurrent ? 28 : 11,
                      fontWeight: isCurrent ? FontWeight.w500 : FontWeight.w700,
                      fontStyle: isCurrent
                          ? FontStyle.italic
                          : FontStyle.normal,
                      letterSpacing: isCurrent ? -0.3 : 1.1,
                    ),
                  ),
                  if (milestone.subtitle.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        milestone.subtitle,
                        textAlign: TextAlign.center,
                        maxLines: 2,
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
                        ),
                      ),
                    ),
                ],
              ),
            ),
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

class _JourneyMilestone {
  const _JourneyMilestone({
    required this.title,
    required this.subtitle,
    required this.rawDate,
    required this.address,
    required this.isMainStage,
    required this.parentDots,
    required this.parentDotsCompleted,
    required this.mainSequenceIndex,
    this.status = _MilestoneStatus.upcoming,
  });

  final String title;
  final String subtitle;
  final DateTime? rawDate;
  final String? address;
  final bool isMainStage;
  final int parentDots;
  final int parentDotsCompleted;
  final int? mainSequenceIndex;
  final _MilestoneStatus status;

  _JourneyMilestone copyWith({
    String? title,
    String? subtitle,
    DateTime? rawDate,
    String? address,
    bool? isMainStage,
    int? parentDots,
    int? parentDotsCompleted,
    int? mainSequenceIndex,
    _MilestoneStatus? status,
  }) {
    return _JourneyMilestone(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      rawDate: rawDate ?? this.rawDate,
      address: address ?? this.address,
      isMainStage: isMainStage ?? this.isMainStage,
      parentDots: parentDots ?? this.parentDots,
      parentDotsCompleted: parentDotsCompleted ?? this.parentDotsCompleted,
      mainSequenceIndex: mainSequenceIndex ?? this.mainSequenceIndex,
      status: status ?? this.status,
    );
  }
}
