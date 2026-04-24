import 'package:flutter/material.dart';
import 'api/auth_service.dart';
import 'gen_l10n/app_localizations.dart';

const _kPrimary = Color(0xFFec5b13);
const _kBgDark = Color(0xFF000000);

class StaffChildDetailPage extends StatefulWidget {
  const StaffChildDetailPage({
    super.key,
    required this.auth,
    required this.assignmentId,
  });

  final AuthService auth;
  final int assignmentId;

  @override
  State<StaffChildDetailPage> createState() => _StaffChildDetailPageState();
}

class _StaffChildDetailPageState extends State<StaffChildDetailPage> {
  SupervisorChildDetail? _detail;
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
      final data = await widget.auth.getSupervisorChildDetail(
        widget.assignmentId,
      );
      if (!mounted) return;
      setState(() {
        _detail = data;
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

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    return Scaffold(
      backgroundColor: _kBgDark,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: _kPrimary))
            : _error != null || detail == null
            ? _buildError()
            : _buildContent(detail),
      ),
    );
  }

  Widget _buildError() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error ?? l10n.staffLoadFailed,
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: _load, child: Text(l10n.retry)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(SupervisorChildDetail d) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              _roundIcon(
                Icons.arrow_back,
                onTap: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.staffChildProfileTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26 / 1.4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _roundIcon(Icons.more_vert, onTap: () {}),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 64,
                            backgroundColor: Colors.white12,
                            backgroundImage:
                                d.photoUrl != null && d.photoUrl!.isNotEmpty
                                ? NetworkImage(d.photoUrl!)
                                : null,
                            child: d.photoUrl == null || d.photoUrl!.isEmpty
                                ? Text(
                                    d.firstName.isNotEmpty
                                        ? d.firstName[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 36,
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        d.fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 38 / 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (d.assignedBrandNames.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          '${l10n.staffAssignedBrand}: ${d.assignedBrandNames.join(', ')}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if ((d.packageName ?? '').trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          d.packageName!.trim(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () => _openEventTimeline(d),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      l10n.staffEventTimelineButton,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (d.familyLookEnabled && d.familyLookParentsCount >= 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => _openParentTimeline(d, 1),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _parentTimelineButtonText(
                            l10n.staffParentTimelineButton1,
                            d.parentTimelineBrandName1,
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (d.familyLookEnabled && d.familyLookParentsCount >= 2)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => _openParentTimeline(d, 2),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _parentTimelineButtonText(
                            l10n.staffParentTimelineButton2,
                            d.parentTimelineBrandName2,
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 18),
                _sectionTitle(Icons.info, l10n.staffSectionCoreDetails),
                ..._buildCoreDetailsRows(d),
                const SizedBox(height: 18),
                _sectionTitle(
                  Icons.family_restroom,
                  l10n.staffSectionParentContact,
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _kPrimary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: _kPrimary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              d.parentName ?? '—',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              d.parentRole ?? l10n.staffParentRoleDefault,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _roundAction(Icons.call, filled: true, onTap: () {}),
                      const SizedBox(width: 8),
                      _roundAction(Icons.chat_bubble_outline, onTap: () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: _kPrimary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30 / 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.white.withOpacity(0.08))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCoreDetailsRows(SupervisorChildDetail d) {
    final l10n = AppLocalizations.of(context)!;
    final rows = <MapEntry<String, String>>[];
    if (d.gender != null && d.gender!.isNotEmpty) {
      rows.add(
        MapEntry(
          l10n.gender,
          d.gender == 'female' ? l10n.genderGirl : l10n.genderBoy,
        ),
      );
    }
    if (d.age != null)
      rows.add(MapEntry(l10n.ageLabel, l10n.staffAgeYearsOld(d.age!)));
    if (d.birthdate != null)
      rows.add(MapEntry(l10n.birthdate, _formatBirthdate(d.birthdate!)));
    if (d.heightValue != null)
      rows.add(MapEntry(l10n.height, _formatHeight(d)));
    final notes = d.notes?.trim();
    if (notes != null && notes.isNotEmpty)
      rows.add(MapEntry(l10n.staffNotesLabel, notes));

    if (rows.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            l10n.staffChildDetailEmpty,
            style: const TextStyle(color: Colors.white54),
          ),
        ),
      ];
    }

    return List<Widget>.generate(rows.length, (i) {
      final row = rows[i];
      return _detailRow(row.key, row.value, isLast: i == rows.length - 1);
    });
  }

  String _formatHeight(SupervisorChildDetail d) {
    if (d.heightValue == null) return '—';
    final unit = (d.heightUnit?.trim().isNotEmpty ?? false)
        ? d.heightUnit!.toLowerCase() == 'imperial'
              ? 'in'
              : 'cm'
        : 'cm';
    return '${d.heightValue!.toStringAsFixed(0)} $unit';
  }

  String _formatBirthdate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd.$mm.${d.year}';
  }

  String _parentTimelineButtonText(String base, String? brandName) {
    final brand = (brandName ?? '').trim();
    if (brand.isEmpty) return base;
    return '$base ($brand)';
  }

  void _openEventTimeline(SupervisorChildDetail d) {
    final l10n = AppLocalizations.of(context)!;
    final rows = _timelineRows(d);
    _openTimelineSheet(l10n.staffEventTimelineTitle, rows);
  }

  void _openParentTimeline(SupervisorChildDetail d, int parentSlot) {
    final l10n = AppLocalizations.of(context)!;
    final tabKey = parentSlot == 2 ? 'parent_dad' : 'parent_mom';
    StaffProgressTabData? sourceTab;
    for (final tab in d.progressTabs) {
      if (tab.key == tabKey) {
        sourceTab = tab;
        break;
      }
    }
    final rows = sourceTab == null
        ? const <_TimelineRow>[]
        : sourceTab.mainProgressStages
              .where((s) => !s.isService)
              .map((s) => _TimelineRow(name: s.name.trim(), status: s.status))
              .where((row) => row.name.isNotEmpty)
              .toList();
    final title = parentSlot == 2
        ? l10n.staffParentTimelineTitle2
        : l10n.staffParentTimelineTitle1;
    _openTimelineSheet(title, rows);
  }

  void _openTimelineSheet(String title, List<_TimelineRow> rows) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0f0f0f),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
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
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        l10n.staffTableName,
                        style: const TextStyle(
                          color: _kPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        l10n.staffTableStatus,
                        style: const TextStyle(
                          color: _kPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: rows.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            l10n.staffNoMainStagesInPlan,
                            style: const TextStyle(color: Colors.white54),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: rows.length,
                          separatorBuilder: (_, __) =>
                              Divider(height: 12, color: Colors.transparent),
                          itemBuilder: (_, i) {
                            final row = rows[i];
                            final statusLabel = _timelineStatusLabel(
                              row.status,
                              l10n,
                            );
                            final statusColor = _timelineStatusColor(
                              row.status,
                            );
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      row.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: statusColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            statusLabel,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<_TimelineRow> _timelineRows(SupervisorChildDetail d) {
    if (d.mainProgressStages.isEmpty) {
      return const <_TimelineRow>[];
    }
    final brandLabel = _timelineBrandLabelForMainFlow(d);
    return d.mainProgressStages
        .where((s) => !s.isService)
        .map((s) {
          final baseName = s.name.trim();
          if (baseName.isEmpty) return null;
          final useBrandPrefix =
              brandLabel != null &&
              brandLabel.isNotEmpty &&
              (s.brandSlot ?? 0) > 0;
          final name = useBrandPrefix ? '$baseName ($brandLabel)' : baseName;
          return _TimelineRow(name: name, status: s.status);
        })
        .whereType<_TimelineRow>()
        .toList();
  }

  String? _timelineBrandLabelForMainFlow(SupervisorChildDetail d) {
    final preferredKey = (d.preferredProgressTabKey ?? '').trim();
    StaffProgressTabData? sourceTab;
    if (preferredKey.isNotEmpty) {
      for (final tab in d.progressTabs) {
        if (tab.key == preferredKey) {
          sourceTab = tab;
          break;
        }
      }
    }
    sourceTab ??= d.progressTabs.firstWhere(
      (tab) => tab.key.startsWith('child_brand_'),
      orElse: () => d.progressTabs.isNotEmpty
          ? d.progressTabs.first
          : StaffProgressTabData(
              key: '',
              title: '',
              mainProgressStages: const [],
              progressPercent: 0,
              completedStages: 0,
              totalStages: 0,
            ),
    );
    final label = sourceTab.title.trim();
    return label.isEmpty ? null : label;
  }

  String _timelineStatusLabel(String status, AppLocalizations l10n) {
    switch (status) {
      case 'done':
      case 'completed':
        return l10n.staffStatusDone;
      case 'in_progress':
        return l10n.staffStatusInProgress;
      default:
        return l10n.staffStatusPending;
    }
  }

  Color _timelineStatusColor(String status) {
    switch (status) {
      case 'done':
      case 'completed':
        return Colors.greenAccent.shade200;
      case 'in_progress':
        return Colors.orangeAccent.shade100;
      default:
        return Colors.white60;
    }
  }

  Widget _roundIcon(IconData icon, {required VoidCallback onTap}) {
    return Material(
      color: _kPrimary.withOpacity(0.14),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: _kPrimary),
        ),
      ),
    );
  }

  Widget _roundAction(
    IconData icon, {
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return Material(
      color: filled ? _kPrimary : Colors.white.withOpacity(0.12),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            color: filled ? Colors.white : Colors.white70,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _TimelineRow {
  const _TimelineRow({required this.name, required this.status});

  final String name;
  final String status;
}
