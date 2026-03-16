import 'package:flutter/material.dart';
import 'api/auth_service.dart';
import 'app_settings.dart';
import 'gen_l10n/app_localizations.dart';

// Стиль как в разделе персонала: коричневый акцент
const _kPrimary = Color(0xFFec5b13);
const _kBgDark = Color(0xFF000000);

/// Настройки сотрудника: профиль, смена роли (карточки из API), выбор языка (выпадающий список).
/// Язык сохраняется в AppSettings и восстанавливается при следующем запуске.
class StaffSettingsPage extends StatefulWidget {
  const StaffSettingsPage({
    super.key,
    required this.auth,
    required this.user,
    required this.staffRoles,
    required this.currentRole,
    required this.onRoleChanged,
  });

  final AuthService auth;
  final Map<String, dynamic> user;
  final List<StaffRole> staffRoles;
  final StaffRole? currentRole;
  final ValueChanged<StaffRole> onRoleChanged;

  @override
  State<StaffSettingsPage> createState() => _StaffSettingsPageState();
}

class _StaffSettingsPageState extends State<StaffSettingsPage> {
  StaffRole? _selectedRole;
  List<UpcomingEvent> _upcomingEvents = [];
  List<WorkerEventStage> _eventStages = [];
  bool _eventsLoading = true;
  bool _stagesLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRole =
        widget.currentRole ??
        (widget.staffRoles.isNotEmpty ? widget.staffRoles.first : null);
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() => _eventsLoading = true);
    try {
      final list = await widget.auth.getWorkerUpcomingEvents();
      if (!mounted) return;
      setState(() {
        _upcomingEvents = list;
        _eventsLoading = false;
      });
      await _loadStagesForActiveEvent();
    } catch (_) {
      if (!mounted) return;
      setState(() => _eventsLoading = false);
    }
  }

  Future<void> _loadStagesForActiveEvent() async {
    final eventId = _effectiveActiveEventId();
    if (eventId == null || eventId <= 0) {
      if (!mounted) return;
      setState(() {
        _eventStages = [];
        _stagesLoading = false;
      });
      return;
    }

    setState(() => _stagesLoading = true);
    try {
      final list = await widget.auth.getWorkerEventStages(eventId);
      if (!mounted) return;
      final currentStageId = AppSettings.staffActiveStageId;
      final currentStageType = AppSettings.staffActiveStageType;
      final validStageId =
          currentStageId != null &&
              list.any(
                (s) => s.id == currentStageId && s.type == currentStageType,
              )
          ? currentStageId
          : null;
      if (validStageId == null && currentStageId != null) {
        await AppSettings.setStaffActiveStageId(null);
        await AppSettings.setStaffActiveStageType(null);
      }
      setState(() {
        _eventStages = list;
        _stagesLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _eventStages = [];
        _stagesLoading = false;
      });
    }
  }

  String get _userName =>
      (widget.user['name'] ?? '').toString().trim().isNotEmpty
      ? (widget.user['name']).toString().trim()
      : 'Staff';

  String get _staffId {
    final id = widget.user['staff_id'] ?? widget.user['id'];
    if (id == null) return '—';
    return id.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _kBgDark,
      appBar: AppBar(
        backgroundColor: _kBgDark,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Staff Portal',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: _kPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfile(l10n),
            const SizedBox(height: 24),
            _buildActiveEventSection(),
            const SizedBox(height: 20),
            _buildActiveStageSection(),
            const SizedBox(height: 24),
            _buildSwitchRole(l10n),
            const SizedBox(height: 24),
            _buildLanguageSection(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveEventSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active event',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        if (_eventsLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _kPrimary,
                ),
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int?>(
                value: _effectiveActiveEventId(),
                isExpanded: true,
                dropdownColor: const Color(0xFF2a1a14),
                icon: Icon(Icons.keyboard_arrow_down, color: _kPrimary),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                hint: Text(
                  'Select event',
                  style: TextStyle(color: Colors.white54),
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('— None —'),
                  ),
                  ..._upcomingEvents.map(
                    (e) => DropdownMenuItem<int?>(
                      value: e.id,
                      child: Text(e.name, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
                onChanged: (int? value) async {
                  await AppSettings.setStaffActiveEventId(value);
                  await AppSettings.setStaffActiveStageId(null);
                  await AppSettings.setStaffActiveStageType(null);
                  await _loadStagesForActiveEvent();
                  if (mounted) setState(() {});
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActiveStageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active stage',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        if (_stagesLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _kPrimary,
                ),
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int?>(
                value: _effectiveActiveStageId(),
                isExpanded: true,
                dropdownColor: const Color(0xFF2a1a14),
                icon: Icon(Icons.keyboard_arrow_down, color: _kPrimary),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                hint: Text(
                  'Select stage',
                  style: TextStyle(color: Colors.white54),
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('— None —'),
                  ),
                  ..._eventStages.map(
                    (s) => DropdownMenuItem<int?>(
                      value: s.id,
                      child: Text(
                        s.type == 'preparatory' ? 'Prep: ${s.name}' : s.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                onChanged: (int? value) async {
                  if (value == null) {
                    await AppSettings.setStaffActiveStageId(null);
                    await AppSettings.setStaffActiveStageType(null);
                  } else {
                    final stage = _eventStages
                        .cast<WorkerEventStage?>()
                        .firstWhere((s) => s?.id == value, orElse: () => null);
                    await AppSettings.setStaffActiveStageId(value);
                    await AppSettings.setStaffActiveStageType(
                      stage?.type ?? 'main',
                    );
                  }
                  if (mounted) setState(() {});
                },
              ),
            ),
          ),
      ],
    );
  }

  int? _effectiveActiveEventId() {
    final current = AppSettings.staffActiveEventId;
    if (current == null) return null;
    final exists = _upcomingEvents.any((e) => e.id == current);
    return exists ? current : null;
  }

  int? _effectiveActiveStageId() {
    final current = AppSettings.staffActiveStageId;
    final currentType = AppSettings.staffActiveStageType;
    if (current == null) return null;
    final exists = _eventStages.any(
      (e) => e.id == current && e.type == (currentType ?? 'main'),
    );
    return exists ? current : null;
  }

  Widget _buildProfile(AppLocalizations l10n) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.white12,
              child: Icon(Icons.person, size: 48, color: Colors.white54),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _kPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          _userName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          (_selectedRole?.name ?? 'STAFF').toUpperCase(),
          style: TextStyle(
            color: _kPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Staff ID: $_staffId',
          style: TextStyle(color: Colors.white54, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSwitchRole(AppLocalizations l10n) {
    if (widget.staffRoles.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Switch Role',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'CURRENT: ${(_selectedRole?.name ?? '').toUpperCase()}',
              style: TextStyle(
                color: _kPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...widget.staffRoles.map(
          (role) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _RoleCard(
              role: role,
              isSelected: _selectedRole?.id == role.id,
              onTap: () async {
                await AppSettings.setStaffSelectedRoleCode(role.code);
                if (!mounted) return;
                setState(() => _selectedRole = role);
                widget.onRoleChanged(role);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Language',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<AppLanguage>(
              value: AppSettings.language,
              isExpanded: true,
              dropdownColor: const Color(0xFF2a1a14),
              icon: Icon(Icons.keyboard_arrow_down, color: _kPrimary),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              items: [
                DropdownMenuItem(
                  value: AppLanguage.system,
                  child: Text(l10n.systemLanguage),
                ),
                DropdownMenuItem(
                  value: AppLanguage.en,
                  child: Text(l10n.languageEnglish),
                ),
                DropdownMenuItem(
                  value: AppLanguage.ru,
                  child: Text(l10n.languageRussian),
                ),
                DropdownMenuItem(
                  value: AppLanguage.uk,
                  child: Text(l10n.languageUkrainian),
                ),
                DropdownMenuItem(
                  value: AppLanguage.esUs,
                  child: Text(l10n.languageSpanishUS),
                ),
              ],
              onChanged: (AppLanguage? value) async {
                if (value == null) return;
                await AppSettings.setLanguage(value);
                AppSettings.onLocaleChanged?.call();
                if (mounted) setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  final StaffRole role;
  final bool isSelected;
  final VoidCallback onTap;

  static IconData _iconForCode(String code) {
    switch (code.toLowerCase()) {
      case 'supervisor':
        return Icons.manage_accounts;
      case 'photographer':
        return Icons.photo_camera;
      case 'stylist':
        return Icons.checkroom;
      case 'hostess':
      case 'hs':
        return Icons.badge_outlined;
      default:
        return Icons.work_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? _kPrimary.withOpacity(0.5)
                  : Colors.white.withOpacity(0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _kPrimary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _iconForCode(role.code),
                  color: _kPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _subtitleForCode(role.code),
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitleForCode(String code) {
    switch (code.toLowerCase()) {
      case 'supervisor':
        return 'Full access & management';
      case 'photographer':
        return 'Media capture & uploads';
      case 'stylist':
        return 'Wardrobe & makeup logs';
      case 'hostess':
      case 'hs':
        return 'Guest & zone support';
      default:
        return role.name;
    }
  }
}
