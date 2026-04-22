import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'gen_l10n/app_localizations.dart';
import 'api/auth_service.dart'
    show StaffMainProgressStage, StaffProgressTabData, SupervisorChildDetail;

/// Карточка профиля ребёнка после «Scan for Info»: компоновка по референсу, палитра — как у персонала.
const _surfaceLow = Color(0xFF1B1B1B);
const _surfaceHigh = Color(0xFF2A2A2A);
const _tertiary = Color(0xFFCECECE);
const _onSurface = Color(0xFFE2E2E2);
const _outlineVariant = Color(0xFF4D4635);

class StaffInfoChildProfilePage extends StatefulWidget {
  const StaffInfoChildProfilePage({
    super.key,
    required this.detail,
    required this.baseUrl,
    required this.accent,
    required this.backgroundColor,
  });

  /// Уже загружено ответом scan-info-lookup (второй запрос не нужен).
  final SupervisorChildDetail detail;
  final String baseUrl;
  final Color accent;
  final Color backgroundColor;

  @override
  State<StaffInfoChildProfilePage> createState() =>
      _StaffInfoChildProfilePageState();
}

class _StaffInfoChildProfilePageState extends State<StaffInfoChildProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String? _resolveUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    final base = widget.baseUrl;
    if (base.endsWith('/') && path.startsWith('/')) {
      return '$base${path.substring(1)}';
    }
    if (!base.endsWith('/') && !path.startsWith('/')) {
      return '$base/$path';
    }
    return '$base$path';
  }

  List<StaffProgressTabData> _progressTabs(SupervisorChildDetail d) {
    final l10n = AppLocalizations.of(context)!;
    if (d.progressTabs.isNotEmpty) {
      return d.progressTabs;
    }
    return [
      StaffProgressTabData(
        key: 'all',
        title: l10n.staffShowProgressTitle,
        mainProgressStages: d.mainProgressStages,
        progressPercent: d.progressPercent,
        currentStageName: d.currentStageName,
        completedStages: d.completedStages,
        totalStages: d.totalStages,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    final tabs = _progressTabs(widget.detail);
    final n = tabs.length;
    _tabController = TabController(length: n > 0 ? n : 1, vsync: this);
    final preferredKey = widget.detail.preferredProgressTabKey;
    if (preferredKey != null && tabs.isNotEmpty) {
      final idx = tabs.indexWhere((t) => t.key == preferredKey);
      if (idx >= 0) {
        _tabController.index = idx;
      }
    }
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _dial(String? raw) async {
    if (raw == null) {
      return;
    }
    final t = raw.trim();
    if (t.isEmpty || t == '—') {
      return;
    }
    final digits = t.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return;
    }
    final uri = Uri.parse('tel:$digits');
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.staffCouldNotOpenDialer,
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.staffCouldNotOpenDialer,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accent;
    final bg = widget.backgroundColor;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(child: _buildBody(context, widget.detail, accent)),
    );
  }

  Widget _buildBody(
    BuildContext context,
    SupervisorChildDetail d,
    Color accent,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final profileTitle = d.isParentScan
        ? (((d.parentRole ?? '').trim().isNotEmpty)
              ? '${d.parentRole} Profile'
              : 'Parent Profile')
        : l10n.staffChildProfileTitle;
    final photo = d.isParentScan ? null : _resolveUrl(d.photoUrl);
    final supPhoto = _resolveUrl(d.supervisorPhotoUrl);
    final tabs = _progressTabs(d);
    final tabIndex = _tabController.index.clamp(0, tabs.length - 1);
    final activeTab = tabs[tabIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(Icons.arrow_back, color: accent, size: 24),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  profileTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: accent,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'HelveticaNeueCyr',
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(Icons.more_vert, color: accent, size: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 4 / 5,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (photo != null)
                          Image.network(
                            photo,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                _photoFallback(d, accent),
                          )
                        else
                          _photoFallback(d, accent),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: 160,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.88),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 24,
                          right: 24,
                          bottom: 28,
                          child: Text(
                            d.fullName,
                            style: const TextStyle(
                              fontFamily: 'HelveticaNeueCyr',
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              color: _onSurface,
                              height: 1.05,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _guardianCard(context, d, accent),
                const SizedBox(height: 24),
                _brandCard(context, d, accent, supPhoto),
                const SizedBox(height: 28),
                _showProgressHeader(accent, activeTab),
                const SizedBox(height: 12),
                if (tabs.length > 1)
                  Material(
                    color: _surfaceLow,
                    borderRadius: BorderRadius.circular(16),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      indicatorColor: accent,
                      labelColor: accent,
                      unselectedLabelColor: _tertiary.withValues(alpha: 0.65),
                      labelStyle: const TextStyle(
                        fontFamily: 'HelveticaNeueCyr',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontFamily: 'HelveticaNeueCyr',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: tabs.map((t) => Tab(text: t.title)).toList(),
                    ),
                  ),
                if (tabs.length > 1) const SizedBox(height: 16),
                _showProgressTimeline(activeTab.mainProgressStages, accent),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _showProgressHeader(Color accent, StaffProgressTabData tab) {
    final l10n = AppLocalizations.of(context)!;
    final pct = tab.progressPercent.clamp(0, 100);
    final completionLabel = tab.totalStages > 0 ? '$pct%' : '—';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.staffRealtimeTracking,
                style: TextStyle(
                  color: accent,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontFamily: 'HelveticaNeueCyr',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.staffShowProgressTitle,
                style: const TextStyle(
                  color: _onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'HelveticaNeueCyr',
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              l10n.staffEstimatedCompletion,
              style: _labelGrey.copyWith(fontSize: 9, letterSpacing: 1.4),
            ),
            const SizedBox(height: 4),
            Text(
              completionLabel,
              style: TextStyle(
                color: accent.withValues(alpha: 0.85),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                fontFamily: 'HelveticaNeueCyr',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _showProgressTimeline(
    List<StaffMainProgressStage> stages,
    Color accent,
  ) {
    if (stages.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: _surfaceHigh,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Text(
          AppLocalizations.of(context)!.staffNoMainStagesInPlan,
          style: TextStyle(
            color: _tertiary.withValues(alpha: 0.85),
            fontSize: 15,
            fontWeight: FontWeight.w500,
            fontFamily: 'HelveticaNeueCyr',
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: _surfaceHigh,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
      child: Column(
        children: [
          for (var i = 0; i < stages.length; i++)
            _timelineStageRow(
              stages[i],
              accent,
              isLast: i == stages.length - 1,
            ),
        ],
      ),
    );
  }

  Widget _timelineStageRow(
    StaffMainProgressStage s,
    Color accent, {
    required bool isLast,
  }) {
    final st = s.status.toLowerCase();
    final isPending = st == 'pending';
    final lineToNext = !isLast
        ? (st == 'done' ? accent : _outlineVariant.withValues(alpha: 0.4))
        : null;

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _stageNode(s, accent),
              if (lineToNext != null)
                Container(
                  width: 2,
                  height: 22,
                  margin: const EdgeInsets.only(left: 19),
                  color: lineToNext,
                ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.name,
                style: TextStyle(
                  color: isPending
                      ? _onSurface.withValues(alpha: 0.45)
                      : (st == 'in_progress' ? accent : _onSurface),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'HelveticaNeueCyr',
                ),
              ),
              if (s.subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  s.subtitle,
                  style: TextStyle(
                    color: isPending
                        ? _tertiary.withValues(alpha: 0.45)
                        : _tertiary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'HelveticaNeueCyr',
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        _statusPill(s, accent),
      ],
    );

    if (!isPending) return row;
    return Opacity(opacity: 0.72, child: row);
  }

  Widget _stageNode(StaffMainProgressStage s, Color accent) {
    final st = s.status.toLowerCase();
    const size = 40.0;
    if (st == 'done') {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: accent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.check_rounded, color: Colors.black, size: 22),
      );
    }
    if (st == 'in_progress') {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: accent, width: 2),
          color: Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: accent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: accent.withValues(alpha: 0.4), blurRadius: 8),
            ],
          ),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _outlineVariant.withValues(alpha: 0.55),
          width: 2,
        ),
        color: _surfaceLow,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.straighten_rounded,
        color: _tertiary.withValues(alpha: 0.5),
        size: 20,
      ),
    );
  }

  Widget _statusPill(StaffMainProgressStage s, Color accent) {
    final st = s.status.toLowerCase();
    late final String label;
    late final Color fg;
    late final Color bg;
    late final Color border;
    if (st == 'done') {
      label = AppLocalizations.of(context)!.staffStatusDone;
      fg = Colors.black;
      bg = accent;
      border = accent;
    } else if (st == 'in_progress') {
      label = AppLocalizations.of(context)!.staffStatusInProgress;
      fg = accent;
      bg = Colors.transparent;
      border = accent.withValues(alpha: 0.85);
    } else {
      label = AppLocalizations.of(context)!.staffStatusPending;
      fg = _tertiary.withValues(alpha: 0.65);
      bg = _surfaceLow;
      border = _outlineVariant.withValues(alpha: 0.45);
    }
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: border, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            fontFamily: 'HelveticaNeueCyr',
          ),
        ),
      ),
    );
  }

  Widget _photoFallback(SupervisorChildDetail d, Color accent) {
    final displayName = d.fullName.trim();
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
    return ColoredBox(
      color: _surfaceLow,
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.w200,
            color: accent.withValues(alpha: 0.5),
            fontFamily: 'HelveticaNeueCyr',
          ),
        ),
      ),
    );
  }

  TextStyle _labelGold(Color accent) => TextStyle(
    color: accent,
    fontSize: 10,
    fontWeight: FontWeight.w800,
    letterSpacing: 2,
    fontFamily: 'HelveticaNeueCyr',
  );

  TextStyle get _labelGrey => const TextStyle(
    color: _tertiary,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    fontFamily: 'HelveticaNeueCyr',
  );

  Widget _guardianCard(
    BuildContext context,
    SupervisorChildDetail d,
    Color accent,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: _surfaceLow,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Icon(
              Icons.family_restroom_rounded,
              size: 72,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.staffGuardianLiaison, style: _labelGold(accent)),
              const SizedBox(height: 6),
              Text(
                l10n.staffContactDetails,
                style: TextStyle(
                  fontFamily: 'HelveticaNeueCyr',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _onSurface,
                ),
              ),
              const SizedBox(height: 20),
              _contactRow(
                accent,
                Icons.person_rounded,
                l10n.staffPrimaryParent,
                d.parentName ?? '—',
              ),
              const SizedBox(height: 16),
              _contactRow(
                accent,
                Icons.call_rounded,
                l10n.phone.toUpperCase(),
                d.parentPhone ?? '—',
                onValueTap:
                    (d.parentPhone != null && d.parentPhone!.trim().isNotEmpty)
                    ? () => _dial(d.parentPhone)
                    : null,
              ),
              const SizedBox(height: 16),
              _contactRow(
                accent,
                Icons.mail_rounded,
                l10n.email.toUpperCase(),
                d.parentEmail ?? '—',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactRow(
    Color accent,
    IconData icon,
    String label,
    String value, {
    VoidCallback? onValueTap,
  }) {
    final canTap =
        onValueTap != null && value.trim().isNotEmpty && value != '—';
    final valueWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelGrey),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: _onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: 'HelveticaNeueCyr',
          ),
        ),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: _surfaceHigh,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: accent, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: canTap
              ? Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onValueTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: valueWidget),
                          Icon(
                            Icons.phone_in_talk_rounded,
                            color: accent,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : valueWidget,
        ),
      ],
    );
  }

  Widget _brandCard(
    BuildContext context,
    SupervisorChildDetail d,
    Color accent,
    String? supPhoto,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final name = d.supervisorName ?? '—';
    return Container(
      decoration: BoxDecoration(
        color: _surfaceHigh,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _outlineVariant.withValues(alpha: 0.25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.staffAssignedBrand, style: _labelGrey),
                const SizedBox(height: 6),
                Text(
                  d.brandName ?? '—',
                  style: TextStyle(
                    fontFamily: 'HelveticaNeueCyr',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: accent,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.staffSupervisor, style: _labelGrey),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: const TextStyle(
                        color: _onSurface,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'HelveticaNeueCyr',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _supervisorThumb(supPhoto, name, accent),
            ],
          ),
          if (d.supervisorPhone != null &&
              d.supervisorPhone!.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            _contactRow(
              accent,
              Icons.call_rounded,
              l10n.phone.toUpperCase(),
              d.supervisorPhone!,
              onValueTap: () => _dial(d.supervisorPhone),
            ),
          ],
        ],
      ),
    );
  }

  Widget _supervisorThumb(String? url, String name, Color accent) {
    const size = 52.0;
    if (url != null && url.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accent.withValues(alpha: 0.25), width: 2),
        ),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _supervisorPlaceholder(name, accent, size),
        ),
      );
    }
    return _supervisorPlaceholder(name, accent, size);
  }

  Widget _supervisorPlaceholder(String name, Color accent, double size) {
    final initial = name.isNotEmpty && name != '—'
        ? name.trim()[0].toUpperCase()
        : '?';
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _surfaceLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.25), width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: accent,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: 'HelveticaNeueCyr',
        ),
      ),
    );
  }
}
