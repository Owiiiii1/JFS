import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'api/auth_service.dart';
import 'push/push_token_service.dart';
import 'app_settings.dart';
import 'gen_l10n/app_localizations.dart';
import 'login_page.dart';
import 'staff_child_detail_page.dart';
import 'staff_scan_page.dart';
import 'staff_settings_page.dart';
import 'staff_workspace.dart';
import 'notifications_page.dart';
import 'about_app_page.dart';

// Референс Event Details: тёмно-коричневый фон, коричневый (primary) для кнопок и виджетов
const _kBgDark = Color(0xFF000000);
const _kPrimary = Color(0xFFec5b13);

/// Портальная оболочка для сотрудников: фиксированные шапка и нижняя навигация, контент переключается по вкладкам.
class StaffPortalPage extends StatefulWidget {
  const StaffPortalPage({
    super.key,
    required this.auth,
    required this.user,
    required this.status,
  });

  final AuthService auth;
  final Map<String, dynamic> user;
  final WorkerStatus status;

  @override
  State<StaffPortalPage> createState() => _StaffPortalPageState();
}

class _StaffPortalPageState extends State<StaffPortalPage> {
  int _currentTab = 0; // 0 Home, 1 Event, 2 More
  /// Актуальный worker/status с сервера (обновляется при табах и перед сканом).
  late WorkerStatus _liveStatus;
  StaffRole? _selectedRole;
  List<SupervisorStageItem> _supervisorStages = [];
  int? _selectedSupervisorStageId;
  bool _showAllSupervisorChildren = false;
  bool _showSupervisorRoleCard = true;
  List<SupervisorChildItem>? _supervisorChildren;
  bool _supervisorChildrenLoading = false;
  String? _supervisorChildrenError;
  int? _supervisorChildrenEventId;
  List<RehearsalAdminSlotItem> _rehearsalAdminSlots = [];
  int? _selectedRehearsalAdminSlotId;
  List<RehearsalAdminChildItem>? _rehearsalAdminChildren;
  bool _rehearsalAdminLoading = false;
  String? _rehearsalAdminError;
  int? _rehearsalAdminEventId;
  List<WorkerEventStage> _giftControlStages = [];
  int? _selectedGiftControlStageId;
  String _giftControlStatusFilter = 'all';
  List<GiftControlChildItem>? _giftControlChildren;
  bool _giftControlLoading = false;
  String? _giftControlError;
  int? _giftControlEventId;
  Timer? _supervisorAutoRefreshTimer;
  // ignore: unused_field
  int _unreadNotifications = 0;
  List<WorkerEventStage> _homeVisibleStages = [];
  bool _homeStagesLoading = false;

  @override
  void initState() {
    super.initState();
    _liveStatus = widget.status;
    _initSelectedRole();
    _startSupervisorAutoRefresh();
    _refreshUnreadSilently();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_loadHomeTabStages());
    });
  }

  @override
  void dispose() {
    _supervisorAutoRefreshTimer?.cancel();
    super.dispose();
  }

  bool _isSupervisorHomeActive() {
    return _currentTab == 0 && _resolvedHomeScreenType(_selectedRole) == 'supervisor';
  }

  void _startSupervisorAutoRefresh() {
    _supervisorAutoRefreshTimer?.cancel();
    _supervisorAutoRefreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      if (!_isSupervisorHomeActive()) return;
      if (_supervisorChildrenLoading) return;
      unawaited(_loadSupervisorChildren());
    });
  }

  // ignore: unused_element
  Future<void> _refreshUnreadSilently() async {
    try {
      final count = await widget.auth.getUnreadNotificationsCount();
      if (!mounted) return;
      setState(() => _unreadNotifications = count);
    } catch (_) {
      // Silent badge refresh intentionally ignores transient errors.
    }
  }

  // ignore: unused_element
  Future<void> _openNotifications() async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => NotificationsPage(auth: widget.auth)),
    );
    if (!mounted) return;
    if (changed == true) {
      _refreshUnreadSilently();
    }
  }

  StaffRole? _pickSelectedRoleForStatus(WorkerStatus status) {
    final roles = status.staffRoles;
    if (roles.isEmpty) return null;
    final savedRoleCode = AppSettings.staffSelectedRoleCode?.toLowerCase();
    final roleFromApi = status.role;
    final match = roles.cast<StaffRole?>().firstWhere((r) {
      final role = r!;
      if (savedRoleCode != null && savedRoleCode.isNotEmpty) {
        return role.code.toLowerCase() == savedRoleCode;
      }
      return _matchesRoleToken(role, roleFromApi);
    }, orElse: () => null);
    return match ?? roles.first;
  }

  void _initSelectedRole() {
    _selectedRole = _pickSelectedRoleForStatus(_liveStatus);
  }

  /// Подтягивает [getWorkerStatus] и пересобирает выбранную роль (в т.ч. [StaffRole.isActive]).
  Future<bool> _refreshLiveWorkerStatus({bool showError = false}) async {
    try {
      final fresh = await widget.auth.getWorkerStatus();
      if (!mounted) return false;
      setState(() {
        _liveStatus = fresh;
        _selectedRole = _pickSelectedRoleForStatus(fresh);
      });
      unawaited(_loadHomeTabStages());
      return true;
    } catch (_) {
      if (showError && mounted && context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.staffWorkerStatusRefreshFailed),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return false;
    }
  }

  void _onRoleChanged(StaffRole role) {
    unawaited(AppSettings.setStaffSelectedRoleCode(role.code));
    setState(() => _selectedRole = role);
    unawaited(_loadHomeTabStages());
  }

  /// Те же этапы и prefs, что на экране настроек (фильтр по текущей роли).
  Future<void> _loadHomeTabStages() async {
    final eventId = AppSettings.staffActiveEventId;
    final role = _selectedRole;
    if (eventId == null || eventId <= 0 || role == null) {
      if (mounted) {
        setState(() {
          _homeVisibleStages = [];
          _homeStagesLoading = false;
        });
      }
      return;
    }
    if (mounted) setState(() => _homeStagesLoading = true);
    try {
      final list = await widget.auth.getWorkerEventStages(eventId);
      if (!mounted) return;
      final visible = stagesAllowedForRole(list, role);
      setState(() {
        _homeVisibleStages = visible;
        _homeStagesLoading = false;
      });
      await _ensureHomeStagePrefsValid(visible);
      if (mounted) setState(() {});
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _homeVisibleStages = [];
        _homeStagesLoading = false;
      });
    }
  }

  Future<void> _ensureHomeStagePrefsValid(
    List<WorkerEventStage> visible,
  ) async {
    final sid = AppSettings.staffActiveStageId;
    final stype = AppSettings.staffActiveStageType;
    final ok =
        sid != null &&
        visible.any((s) => s.id == sid && (stype == null || s.type == stype));
    if (ok) {
      return;
    }
    if (visible.isNotEmpty) {
      await AppSettings.setStaffActiveStageId(visible.first.id);
      await AppSettings.setStaffActiveStageType(visible.first.type);
    } else {
      await AppSettings.setStaffActiveStageId(null);
      await AppSettings.setStaffActiveStageType(null);
    }
  }

  int? _homeEffectiveStageDropdownValue() {
    final current = AppSettings.staffActiveStageId;
    final currentType = AppSettings.staffActiveStageType;
    if (current == null) return null;
    final exists = _homeVisibleStages.any(
      (e) => e.id == current && e.type == (currentType ?? 'main'),
    );
    return exists ? current : null;
  }

  Future<void> _loadSupervisorChildren() async {
    final eventId = AppSettings.staffActiveEventId;
    if (eventId == null || eventId <= 0) {
      setState(() {
        _supervisorStages = [];
        _selectedSupervisorStageId = null;
        _showAllSupervisorChildren = false;
        _supervisorChildren = [];
        _supervisorChildrenLoading = false;
        _supervisorChildrenError = null;
        _supervisorChildrenEventId = eventId;
      });
      return;
    }
    setState(() {
      _supervisorChildrenLoading = true;
      _supervisorChildrenError = null;
    });
    try {
      final data = await widget.auth.getSupervisorChildren(
        eventId,
        stageId: _selectedSupervisorStageId,
        showAll: _showAllSupervisorChildren,
      );
      if (!mounted) return;
      setState(() {
        _supervisorStages = data.stages;
        _selectedSupervisorStageId =
            data.currentStageId ?? _selectedSupervisorStageId;
        _supervisorChildren = data.children;
        _supervisorChildrenLoading = false;
        _supervisorChildrenEventId = eventId;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _supervisorChildrenError = e.toString();
        _supervisorChildrenLoading = false;
        _supervisorChildren = null;
      });
    }
  }

  Future<void> _loadRehearsalAdminRoster() async {
    final eventId = AppSettings.staffActiveEventId;
    if (eventId == null || eventId <= 0) {
      setState(() {
        _rehearsalAdminSlots = [];
        _selectedRehearsalAdminSlotId = null;
        _rehearsalAdminChildren = [];
        _rehearsalAdminLoading = false;
        _rehearsalAdminError = null;
        _rehearsalAdminEventId = eventId;
      });
      return;
    }

    setState(() {
      _rehearsalAdminLoading = true;
      _rehearsalAdminError = null;
    });
    try {
      final data = await widget.auth.getWorkerRehearsalAdminRoster(
        eventId,
        slotId: _selectedRehearsalAdminSlotId,
      );
      if (!mounted) return;
      setState(() {
        _rehearsalAdminSlots = data.slots;
        _selectedRehearsalAdminSlotId =
            data.currentSlotId ??
            (data.slots.isNotEmpty ? data.slots.first.id : null);
        _rehearsalAdminChildren = data.children;
        _rehearsalAdminLoading = false;
        _rehearsalAdminEventId = eventId;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _rehearsalAdminError = e.toString();
        _rehearsalAdminLoading = false;
        _rehearsalAdminChildren = null;
      });
    }
  }

  Future<void> _loadGiftControlReport() async {
    final eventId = AppSettings.staffActiveEventId;
    if (eventId == null || eventId <= 0) {
      setState(() {
        _giftControlStages = [];
        _selectedGiftControlStageId = null;
        _giftControlChildren = [];
        _giftControlLoading = false;
        _giftControlError = null;
        _giftControlEventId = eventId;
      });
      return;
    }

    setState(() {
      _giftControlLoading = true;
      _giftControlError = null;
    });
    try {
      final data = await widget.auth.getWorkerGiftControlReport(
        eventId,
        stageId: _selectedGiftControlStageId,
        staffRoleId: _selectedRole?.id,
        statusFilter: _giftControlStatusFilter,
      );
      if (!mounted) return;
      setState(() {
        _giftControlStages = data.stages;
        _selectedGiftControlStageId =
            data.currentStageId ??
            (data.stages.isNotEmpty ? data.stages.first.id : null);
        _giftControlChildren = data.children;
        _giftControlStatusFilter = data.statusFilter;
        _giftControlLoading = false;
        _giftControlEventId = eventId;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _giftControlError = e.toString();
        _giftControlLoading = false;
        _giftControlChildren = null;
      });
    }
  }

  /// Тип главной вкладки: из админки (`home_screen_type`) или legacy по code/name.
  String _resolvedHomeScreenType(StaffRole? role) {
    if (role == null) return 'scan';
    final fromApi = role.homeScreenType.trim().toLowerCase();
    if (fromApi.isNotEmpty) return fromApi;
    if (_matchesAnyToken(role, const ['parking', 'парковка'])) {
      return 'parking';
    }
    if (_matchesAnyToken(role, const ['extra_zone', 'extra zone', 'экстра зона', 'зона экстра'])) {
      return 'extra_zone';
    }
    if (_matchesAnyToken(role, const ['backstage', 'backstage entry', 'бекстейдж', 'бэкстейдж'])) {
      return 'backstage';
    }
    if (_matchesAnyToken(role, const ['rehearsal_admin', 'rehearsal admin', 'админ репетиций'])) {
      return 'rehearsal_admin';
    }
    if (_matchesAnyToken(role, const ['gift_issue', 'gift issue', 'выдача подарков'])) {
      return 'gift_issue';
    }
    if (_matchesAnyToken(role, const ['hostess', 'hs', 'хостесс'])) {
      return 'hostess';
    }
    if (_matchesAnyToken(role, const ['supervisor', 'sv', 'супервайзер'])) {
      return 'supervisor';
    }
    return 'scan';
  }

  Widget _buildHomeTabForSelectedRole(Color accent) {
    switch (_resolvedHomeScreenType(_selectedRole)) {
      case 'supervisor':
        return _buildSupervisorHomeTab(accent);
      case 'hostess':
        return _buildHostessStub();
      case 'parking':
        return _buildHomeTab(accent, parkingMode: true);
      case 'extra_zone':
        return _buildHomeTab(accent, extraZoneMode: true);
      case 'backstage':
        return _buildHomeTab(accent, backstageMode: true);
      case 'rehearsal_admin':
        return _buildRehearsalAdminHomeTab(accent);
      case 'gift_issue':
        return _buildGiftIssueHomeTab(accent);
      case 'interview':
        return _buildInterviewStub();
      case 'lunches':
        return _buildLunchesStub();
      case 'superadmin':
        return _buildSuperadminStub();
      default:
        return _buildHomeTab(accent);
    }
  }

  bool _matchesRoleToken(StaffRole role, String token) {
    final normalized = token.trim().toLowerCase();
    if (normalized.isEmpty) return false;
    final code = role.code.trim().toLowerCase();
    final name = role.name.trim().toLowerCase();
    return code == normalized ||
        name == normalized ||
        code.contains(normalized) ||
        name.contains(normalized);
  }

  bool _matchesAnyToken(StaffRole role, List<String> tokens) {
    for (final token in tokens) {
      if (_matchesRoleToken(role, token)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final accent = _kPrimary;
    return Scaffold(
      backgroundColor: _kBgDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(accent),
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: [
                  _buildHomeTabForSelectedRole(accent),
                  _buildEventTab(accent),
                  _buildMoreTab(accent),
                ],
              ),
            ),
            _buildBottomNav(accent),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color accent) {
    final l10n = AppLocalizations.of(context)!;
    final userName = (widget.user['name'] ?? '').toString().trim().isNotEmpty
        ? (widget.user['name']).toString().trim()
        : l10n.staff;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _kBgDark,
        border: Border(bottom: BorderSide(color: _kPrimary.withOpacity(0.15))),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                onPressed: () => _showMenu(context),
              ),
              Text(
                l10n.staffPortalTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$userName • ${_selectedRole?.name.toUpperCase() ?? l10n.staff.toUpperCase()}',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF121212),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.language, color: Colors.white70),
              title: Text(
                l10n.appLanguage,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () async {
                Navigator.pop(ctx);
                await _showLanguageDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.white70),
              title: Text(
                l10n.aboutTheApp,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const AboutAppPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white70),
              title: Text(
                AppLocalizations.of(context)!.signOut,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () async {
                Navigator.pop(ctx);
                try {
                  await PushTokenServiceHolder.instance
                      ?.deactivateCurrentOnBackend();
                } catch (_) {}
                await widget.auth.clearToken();
                if (!context.mounted) return;
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute<void>(
                    builder: (_) => LoginPage(auth: widget.auth),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLanguageDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final selected = await showDialog<AppLanguage>(
      context: context,
      builder: (ctx) {
        Widget option(AppLanguage value, String label) {
          final selected = AppSettings.language == value;
          return ListTile(
            leading: Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? _kPrimary : Colors.white70,
            ),
            title: Text(label, style: const TextStyle(color: Colors.white)),
            onTap: () => Navigator.of(ctx).pop(value),
          );
        }

        return AlertDialog(
          backgroundColor: const Color(0xFF121212),
          title: Text(
            l10n.appLanguage,
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              option(AppLanguage.system, l10n.systemLanguage),
              option(AppLanguage.en, l10n.languageEnglish),
              option(AppLanguage.ru, l10n.languageRussian),
              option(AppLanguage.uk, l10n.languageUkrainian),
              option(AppLanguage.esUs, l10n.languageSpanishUS),
            ],
          ),
        );
      },
    );
    if (selected == null) return;
    await AppSettings.setLanguage(selected);
    AppSettings.onLocaleChanged?.call();
    if (mounted) setState(() {});
  }

  /// Универсальное сканирование: этап синхронизирован с настройками, описание роли из админки.
  Widget _buildHomeTab(
    Color accent, {
    bool parkingMode = false,
    bool extraZoneMode = false,
    bool backstageMode = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final roleDesc = (_selectedRole?.description ?? '').trim();
    final eventId = AppSettings.staffActiveEventId;
    final roleActive = _selectedRole?.isActive ?? false;
    final scanEnabled = (parkingMode || extraZoneMode || backstageMode)
        ? roleActive
        : (!_homeStagesLoading &&
              roleActive &&
              eventId != null &&
              eventId > 0 &&
              AppSettings.staffActiveStageId != null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!parkingMode && !extraZoneMode && !backstageMode)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.staffActiveStage,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                if (_homeStagesLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
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
                else if (eventId == null || eventId <= 0)
                  Text(
                    l10n.staffSelectEventInSettings,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int?>(
                        value: _homeEffectiveStageDropdownValue(),
                        isExpanded: true,
                        dropdownColor: const Color(0xFF2a1a14),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: accent,
                          size: 24,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        hint: Text(
                          l10n.staffSelectStage,
                          style: TextStyle(color: Colors.white54),
                        ),
                        items: [
                          DropdownMenuItem<int?>(
                            value: null,
                            child: Text(l10n.staffNoneSelected),
                          ),
                          ..._homeVisibleStages.map(
                            (s) => DropdownMenuItem<int?>(
                              value: s.id,
                              child: Text(
                                s.type == 'preparatory'
                                    ? l10n.staffPreparatoryStageLabel(s.name)
                                    : s.name,
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
                            WorkerEventStage? stage;
                            for (final s in _homeVisibleStages) {
                              if (s.id == value) {
                                stage = s;
                                break;
                              }
                            }
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
            ),
          ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: scanEnabled
                        ? () => unawaited(
                            _openScanner(
                              context,
                              parkingScan: parkingMode,
                              extraZoneScan: extraZoneMode,
                              backstageScan: backstageMode,
                            ),
                          )
                        : null,
                    borderRadius: BorderRadius.circular(96),
                    child: Container(
                      width: 192,
                      height: 192,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: scanEnabled
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [accent, accent.withOpacity(0.8)],
                              )
                            : null,
                        color: scanEnabled ? null : const Color(0xFF3D3D3D),
                        boxShadow: scanEnabled
                            ? [
                                BoxShadow(
                                  color: accent.withOpacity(0.3),
                                  blurRadius: 40,
                                  spreadRadius: 0,
                                ),
                              ]
                            : const [],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              parkingMode
                                  ? Icons.local_parking_outlined
                                  : (extraZoneMode
                                      ? Icons.workspace_premium_outlined
                                      : (backstageMode
                                            ? Icons.theater_comedy_outlined
                                            : Icons.qr_code_scanner)),
                              color: scanEnabled
                                  ? Colors.white
                                  : Colors.white38,
                              size: 56,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              parkingMode
                                  ? l10n.staffParkingButton
                                  : (extraZoneMode
                                        ? l10n.staffExtraZoneButton
                                        : (backstageMode
                                              ? l10n.staffBackstageButton
                                              : l10n.staffScanButton)),
                              style: TextStyle(
                                color: scanEnabled
                                    ? Colors.white
                                    : Colors.white38,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  parkingMode
                      ? l10n.staffTapToScanParkingQr
                      : (extraZoneMode
                            ? l10n.staffTapToScanExtraZoneQr
                            : (backstageMode
                                  ? l10n.staffTapToScanBackstageQr
                                  : l10n.staffTapToScanModelLanyard)),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: scanEnabled
                        ? Colors.white.withOpacity(0.4)
                        : Colors.white.withOpacity(0.22),
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(
                  color: roleActive ? accent : Colors.white24,
                  width: 4,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.staffCurrentTask,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  roleDesc.isEmpty ? '—' : roleDesc,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventTab(Color accent) {
    final eventId = AppSettings.staffActiveEventId;
    if (eventId == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 48,
                color: Colors.white38,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.staffSelectEventInSettings,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return _StaffEventDetailContent(
      eventId: eventId,
      auth: widget.auth,
      accent: accent,
    );
  }

  /// Вкладка «Прочее»: утилиты (Scan, Toilet, Staff Settings) + смена.
  Widget _buildMoreTab(Color accent) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.staffUtilitiesAndTools,
            style: TextStyle(
              color: accent,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          // Scan for Info (large card)
          _MoreCard(
            icon: Icons.qr_code_scanner,
            title: AppLocalizations.of(context)!.staffScanForInfoTitle,
            subtitle: AppLocalizations.of(context)!.staffScanForInfoSubtitle,
            accent: accent,
            large: true,
            onTap: () => unawaited(_openScanner(context, scanForInfo: true)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MoreCard(
                  icon: Icons.child_care,
                  title: AppLocalizations.of(context)!.staffToiletRequest,
                  subtitle: AppLocalizations.of(context)!.staffRestroomLog,
                  accent: accent,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _MoreCard(
                  icon: Icons.settings,
                  title: AppLocalizations.of(context)!.staffSettingsCardTitle,
                  subtitle: AppLocalizations.of(context)!.staffPreferences,
                  accent: accent,
                  onTap: () => _openStaffSettings(context, accent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openScanner(
    BuildContext context, {
    bool scanForInfo = false,
    bool parkingScan = false,
    bool extraZoneScan = false,
    bool backstageScan = false,
  }) async {
    final ok = await _refreshLiveWorkerStatus(showError: true);
    if (!ok || !mounted || !context.mounted) return;

    final role = _selectedRole;
    if (role != null && !role.isActive) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.staffScanRoleInactive),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (!mounted || !context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StaffScanPage(
          auth: widget.auth,
          accent: _kPrimary,
          backgroundColor: _kBgDark,
          scanForInfo: scanForInfo,
          parkingScan: parkingScan,
          extraZoneScan: extraZoneScan,
          backstageScan: backstageScan,
        ),
      ),
    );
  }

  void _openStaffSettings(BuildContext context, Color accent) {
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (_) => StaffSettingsPage(
              auth: widget.auth,
              user: widget.user,
              staffRoles: _liveStatus.staffRoles,
              currentRole: _selectedRole,
              onRoleChanged: _onRoleChanged,
            ),
          ),
        )
        .then((_) {
          if (!mounted) return;
          unawaited(_refreshLiveWorkerStatus());
        });
  }

  /// Домашняя вкладка для роли Supervisor: карточка роли и реестр детей.
  Widget _buildSupervisorHomeTab(Color accent) {
    final l10n = AppLocalizations.of(context)!;
    final eventId = AppSettings.staffActiveEventId;
    if (eventId != _supervisorChildrenEventId && !_supervisorChildrenLoading) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _loadSupervisorChildren(),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Supervisor Role card (shown by default on app start, can be closed for current session)
          if (_showSupervisorRoleCard) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          l10n.staffSupervisorRoleTitle,
                          style: TextStyle(
                            color: accent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        iconSize: 18,
                        splashRadius: 18,
                        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                        onPressed: () {
                          setState(() => _showSupervisorRoleCard = false);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.staffSupervisorRoleDescription,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int?>(
                      value: _selectedSupervisorStageId,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF2a1a14),
                      icon: Icon(Icons.keyboard_arrow_down, color: accent),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      hint: Text(
                        l10n.staffCurrentStageLabel,
                        style: const TextStyle(color: Colors.white54),
                      ),
                      items: _supervisorStages
                          .map(
                            (s) => DropdownMenuItem<int?>(
                              value: s.id,
                              child: Text(
                                s.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: _supervisorStages.isEmpty
                          ? null
                          : (value) {
                              if (value == null) return;
                              setState(() {
                                _selectedSupervisorStageId = value;
                                _showAllSupervisorChildren = false;
                              });
                              _loadSupervisorChildren();
                            },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  setState(() => _showAllSupervisorChildren = true);
                  _loadSupervisorChildren();
                },
                style: TextButton.styleFrom(
                  backgroundColor: accent.withOpacity(0.15),
                  foregroundColor: accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                child: Text(AppLocalizations.of(context)!.showAll),
              ),
            ],
          ),
          if (_supervisorStages.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.staffNoMainStagesAvailable,
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          const SizedBox(height: 16),
          // Child Registry
          Row(
            children: [
              Icon(Icons.people_outline, color: accent, size: 22),
              const SizedBox(width: 8),
              Text(
                l10n.staffChildRegistry,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_supervisorChildren != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l10n.staffChildrenListed(_supervisorChildren!.length),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (eventId == null || eventId <= 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                l10n.staffSelectActiveEventForRegistry,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            )
          else if (_supervisorChildrenLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator(color: _kPrimary)),
            )
          else if (_supervisorChildrenError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                _supervisorChildrenError!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade300, fontSize: 14),
              ),
            )
          else if (_supervisorChildren == null || _supervisorChildren!.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                l10n.staffNoChildrenAssigned,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            )
          else
            _buildSupervisorChildrenTable(accent, _supervisorChildren!),
        ],
      ),
    );
  }

  Widget _buildSupervisorChildrenTable(
    Color accent,
    List<SupervisorChildItem> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Table header
        Row(
          children: [
            SizedBox(
              width: 48,
              child: Text(
                AppLocalizations.of(context)!.staffTableProfile,
                style: TextStyle(
                  color: accent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Text(
                AppLocalizations.of(context)!.staffTableName,
                style: TextStyle(
                  color: accent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.staffTableStatus,
                style: TextStyle(
                  color: accent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 80,
              child: Text(
                AppLocalizations.of(context)!.staffTableAction,
                style: TextStyle(
                  color: accent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...children.map((c) => _buildSupervisorChildRow(accent, c)),
      ],
    );
  }

  Widget _buildSupervisorChildRow(Color accent, SupervisorChildItem c) {
    final statusInfo = _supervisorStatusInfo(c.status);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white12,
              backgroundImage: c.photoUrl != null && c.photoUrl!.isNotEmpty
                  ? NetworkImage(c.photoUrl!)
                  : null,
              child: c.photoUrl == null || c.photoUrl!.isEmpty
                  ? Text(
                      (c.firstName.isNotEmpty ? c.firstName[0] : '?')
                          .toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              c.firstName,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusInfo.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    statusInfo.label,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => StaffChildDetailPage(
                      auth: widget.auth,
                      assignmentId: c.assignmentId,
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                AppLocalizations.of(context)!.details,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ({Color color, String label}) _supervisorStatusInfo(String status) {
    switch (status) {
      case 'given':
        return (
          color: Colors.green,
          label: AppLocalizations.of(context)!.staffYes,
        );
      default:
        return (
          color: Colors.red,
          label: AppLocalizations.of(context)!.staffNo,
        );
    }
  }

  Widget _buildPlaceholderHomeTab({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Colors.white38),
            const SizedBox(height: 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHostessStub() {
    return _buildPlaceholderHomeTab(
      icon: Icons.badge_outlined,
      title: AppLocalizations.of(context)!.staffRoleHostessTitle,
      message: AppLocalizations.of(context)!.staffRoleHostessPlaceholder,
    );
  }

  Widget _buildInterviewStub() {
    return _buildPlaceholderHomeTab(
      icon: Icons.mic_outlined,
      title: AppLocalizations.of(context)!.staffRoleInterviewTitle,
      message: AppLocalizations.of(context)!.staffRoleInterviewPlaceholder,
    );
  }

  Widget _buildLunchesStub() {
    return _buildPlaceholderHomeTab(
      icon: Icons.restaurant_outlined,
      title: AppLocalizations.of(context)!.staffRoleLunchesTitle,
      message: AppLocalizations.of(context)!.staffRoleLunchesPlaceholder,
    );
  }

  Widget _buildSuperadminStub() {
    return _buildPlaceholderHomeTab(
      icon: Icons.admin_panel_settings_outlined,
      title: AppLocalizations.of(context)!.staffRoleSuperadminTitle,
      message: AppLocalizations.of(context)!.staffRoleSuperadminPlaceholder,
    );
  }

  Widget _buildRehearsalAdminHomeTab(Color accent) {
    final l10n = AppLocalizations.of(context)!;
    final eventId = AppSettings.staffActiveEventId;
    if (eventId != _rehearsalAdminEventId && !_rehearsalAdminLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadRehearsalAdminRoster());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.staffRehearsalAdminSlotsTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int?>(
                value: _selectedRehearsalAdminSlotId,
                isExpanded: true,
                dropdownColor: const Color(0xFF2a1a14),
                icon: Icon(Icons.keyboard_arrow_down, color: accent),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                hint: Text(
                  l10n.staffRehearsalAdminSelectSlot,
                  style: const TextStyle(color: Colors.white54),
                ),
                items: _rehearsalAdminSlots
                    .map(
                      (slot) => DropdownMenuItem<int?>(
                        value: slot.id,
                        child: Text(
                          _formatRehearsalAdminSlotLabel(slot),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: _rehearsalAdminSlots.isEmpty
                    ? null
                    : (value) {
                        if (value == null) return;
                        setState(() => _selectedRehearsalAdminSlotId = value);
                        _loadRehearsalAdminRoster();
                      },
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Icon(Icons.people_outline, color: accent, size: 22),
              const SizedBox(width: 8),
              Text(
                l10n.staffRehearsalAdminBookedChildrenTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_rehearsalAdminChildren != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l10n.staffChildrenListed(_rehearsalAdminChildren!.length),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (eventId == null || eventId <= 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                l10n.staffSelectActiveEventForRegistry,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
            )
          else if (_rehearsalAdminLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator(color: _kPrimary)),
            )
          else if (_rehearsalAdminError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                _rehearsalAdminError!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade300, fontSize: 14),
              ),
            )
          else if (_rehearsalAdminSlots.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                l10n.staffRehearsalAdminNoSlots,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
            )
          else if (_rehearsalAdminChildren == null || _rehearsalAdminChildren!.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                l10n.staffRehearsalAdminNoChildrenForSlot,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
            )
          else
            ..._rehearsalAdminChildren!.map((c) => _buildRehearsalAdminChildRow(accent, c)),
        ],
      ),
    );
  }

  String _formatRehearsalAdminSlotLabel(RehearsalAdminSlotItem slot) {
    final date = slot.slotDate;
    final dateLabel = date != null ? DateFormat('dd.MM').format(date.toLocal()) : '--.--';
    final timeLabel = AppSettings.formatTimeLabel(slot.slotTime);
    final place = slot.place.trim();
    final capacityPart = '${slot.bookedCount}/${slot.capacity}';
    if (place.isEmpty) {
      return '$dateLabel $timeLabel · $capacityPart';
    }
    return '$dateLabel $timeLabel · $place · $capacityPart';
  }

  Widget _buildRehearsalAdminChildRow(Color accent, RehearsalAdminChildItem child) {
    final checked = child.checkedIn;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white12,
            backgroundImage: child.photoUrl != null && child.photoUrl!.isNotEmpty
                ? NetworkImage(child.photoUrl!)
                : null,
            child: child.photoUrl == null || child.photoUrl!.isEmpty
                ? Text(
                    (child.firstName.isNotEmpty ? child.firstName[0] : '?').toUpperCase(),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              child.firstName,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            checked ? Icons.check_circle : Icons.radio_button_unchecked,
            color: checked ? Colors.greenAccent : Colors.white38,
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildGiftIssueHomeTab(Color accent) {
    final l10n = AppLocalizations.of(context)!;
    final eventId = AppSettings.staffActiveEventId;
    if (eventId != _giftControlEventId && !_giftControlLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadGiftControlReport());
    }
    final roleDesc = (_selectedRole?.description ?? '').trim();
    final roleActive = _selectedRole?.isActive ?? false;
    final scanEnabled =
        !_homeStagesLoading &&
        roleActive &&
        eventId != null &&
        eventId > 0 &&
        AppSettings.staffActiveStageId != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.staffActiveStage,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              if (_homeStagesLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
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
              else if (eventId == null || eventId <= 0)
                Text(
                  l10n.staffSelectEventInSettings,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int?>(
                      value: _homeEffectiveStageDropdownValue(),
                      isExpanded: true,
                      dropdownColor: const Color(0xFF2a1a14),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: accent,
                        size: 24,
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      hint: Text(
                        l10n.staffSelectStage,
                        style: const TextStyle(color: Colors.white54),
                      ),
                      items: [
                        DropdownMenuItem<int?>(
                          value: null,
                          child: Text(l10n.staffNoneSelected),
                        ),
                        ..._homeVisibleStages.map(
                          (s) => DropdownMenuItem<int?>(
                            value: s.id,
                            child: Text(
                              s.type == 'preparatory'
                                  ? l10n.staffPreparatoryStageLabel(s.name)
                                  : s.name,
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
                          WorkerEventStage? stage;
                          for (final s in _homeVisibleStages) {
                            if (s.id == value) {
                              stage = s;
                              break;
                            }
                          }
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
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: scanEnabled ? () => unawaited(_openScanner(context)) : null,
                    borderRadius: BorderRadius.circular(96),
                    child: Container(
                      width: 192,
                      height: 192,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: scanEnabled
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [accent, accent.withOpacity(0.8)],
                              )
                            : null,
                        color: scanEnabled ? null : const Color(0xFF3D3D3D),
                        boxShadow: scanEnabled
                            ? [
                                BoxShadow(
                                  color: accent.withOpacity(0.3),
                                  blurRadius: 40,
                                  spreadRadius: 0,
                                ),
                              ]
                            : const [],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.qr_code_scanner,
                              color: scanEnabled ? Colors.white : Colors.white38,
                              size: 56,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.staffScanButton,
                              style: TextStyle(
                                color: scanEnabled ? Colors.white : Colors.white38,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: eventId == null || eventId <= 0
                      ? null
                      : () => unawaited(_openGiftControlSheet(accent)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: accent.withOpacity(0.7)),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: const Icon(Icons.rule_folder_outlined),
                  label: Text(l10n.staffGiftControlButton),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.staffTapToScanModelLanyard,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: scanEnabled
                        ? Colors.white.withOpacity(0.4)
                        : Colors.white.withOpacity(0.22),
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(
                  color: roleActive ? accent : Colors.white24,
                  width: 4,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.staffCurrentTask,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  roleDesc.isEmpty ? '—' : roleDesc,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openGiftControlSheet(Color accent) async {
    final l10n = AppLocalizations.of(context)!;
    await _loadGiftControlReport();
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121212),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            Future<void> reload() async {
              setModalState(() {});
              await _loadGiftControlReport();
              if (ctx.mounted) setModalState(() {});
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,
                ),
                child: SizedBox(
                  height: MediaQuery.of(ctx).size.height * 0.78,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.staffGiftControlTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withOpacity(0.12)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int?>(
                            value: _selectedGiftControlStageId,
                            isExpanded: true,
                            dropdownColor: const Color(0xFF2a1a14),
                            icon: Icon(Icons.keyboard_arrow_down, color: accent),
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            hint: Text(
                              l10n.staffGiftControlSelectStage,
                              style: const TextStyle(color: Colors.white54),
                            ),
                            items: _giftControlStages
                                .map(
                                  (s) => DropdownMenuItem<int?>(
                                    value: s.id,
                                    child: Text(
                                      s.type == 'preparatory'
                                          ? l10n.staffPreparatoryStageLabel(s.name)
                                          : s.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: _giftControlStages.isEmpty
                                ? null
                                : (value) async {
                                    if (value == null) return;
                                    _selectedGiftControlStageId = value;
                                    await reload();
                                  },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: Text(l10n.staffGiftControlFilterAll),
                            selected: _giftControlStatusFilter == 'all',
                            onSelected: (_) async {
                              _giftControlStatusFilter = 'all';
                              await reload();
                            },
                          ),
                          ChoiceChip(
                            label: Text(l10n.staffGiftControlFilterPassed),
                            selected: _giftControlStatusFilter == 'passed',
                            onSelected: (_) async {
                              _giftControlStatusFilter = 'passed';
                              await reload();
                            },
                          ),
                          ChoiceChip(
                            label: Text(l10n.staffGiftControlFilterNotPassed),
                            selected: _giftControlStatusFilter == 'not_passed',
                            onSelected: (_) async {
                              _giftControlStatusFilter = 'not_passed';
                              await reload();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _giftControlLoading
                            ? const Center(
                                child: CircularProgressIndicator(color: _kPrimary),
                              )
                            : _giftControlError != null
                            ? Center(
                                child: Text(
                                  _giftControlError!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red.shade300),
                                ),
                              )
                            : (_giftControlChildren == null || _giftControlChildren!.isEmpty)
                            ? Center(
                                child: Text(
                                  l10n.staffGiftControlNoChildren,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white54),
                                ),
                              )
                            : ListView.separated(
                                itemCount: _giftControlChildren!.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final c = _giftControlChildren![index];
                                  return _buildGiftControlChildRow(c, accent);
                                },
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

  Widget _buildGiftControlChildRow(GiftControlChildItem child, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white12,
            backgroundImage: child.photoUrl != null && child.photoUrl!.isNotEmpty
                ? NetworkImage(child.photoUrl!)
                : null,
            child: child.photoUrl == null || child.photoUrl!.isEmpty
                ? Text(
                    (child.firstName.isNotEmpty ? child.firstName[0] : '?').toUpperCase(),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              child.firstName,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            child.isPassed ? Icons.check_circle : Icons.cancel_outlined,
            color: child.isPassed ? Colors.greenAccent : Colors.orangeAccent,
            size: 22,
          ),
        ],
      ),
    );
  }

  Future<void> _onBottomNavTap(int index) async {
    await _refreshLiveWorkerStatus();
    if (!mounted) return;
    setState(() => _currentTab = index);
  }

  Widget _buildBottomNav(Color accent) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: 12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: _kBgDark,
        border: Border(top: BorderSide(color: _kPrimary.withOpacity(0.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home,
            label: AppLocalizations.of(context)!.staffNavHome,
            active: _currentTab == 0,
            accent: accent,
            onTap: () => unawaited(_onBottomNavTap(0)),
          ),
          _NavItem(
            icon: Icons.calendar_month,
            label: AppLocalizations.of(context)!.staffNavEvent,
            active: _currentTab == 1,
            accent: accent,
            onTap: () => unawaited(_onBottomNavTap(1)),
          ),
          _NavItem(
            icon: Icons.more_horiz,
            label: AppLocalizations.of(context)!.staffNavMore,
            active: _currentTab == 2,
            accent: accent,
            onTap: () => unawaited(_onBottomNavTap(2)),
          ),
        ],
      ),
    );
  }
}

class _MoreCard extends StatelessWidget {
  const _MoreCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
    this.large = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final centered = large;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          constraints: large ? const BoxConstraints(minHeight: 200) : null,
          padding: EdgeInsets.all(large ? 24 : 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Column(
            crossAxisAlignment: centered
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisAlignment: centered
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: large ? 56 : 48,
                height: large ? 56 : 48,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(large ? 16 : 12),
                ),
                child: Icon(icon, color: accent, size: large ? 28 : 24),
              ),
              SizedBox(height: large ? 16 : 12),
              Text(
                title,
                textAlign: centered ? TextAlign.center : TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: large ? 20 : 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: centered ? TextAlign.center : TextAlign.start,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? accent : Colors.white54;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          if (active)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}

/// Контент вкладки Event: детали выбранного ивента (баннер, venue, shift schedule).
class _StaffEventDetailContent extends StatefulWidget {
  const _StaffEventDetailContent({
    required this.eventId,
    required this.auth,
    required this.accent,
  });

  final int eventId;
  final AuthService auth;
  final Color accent;

  @override
  State<_StaffEventDetailContent> createState() =>
      _StaffEventDetailContentState();
}

class _StaffEventDetailContentState extends State<_StaffEventDetailContent> {
  StaffEventDetail? _event;
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
      final detail = await widget.auth.getWorkerEventDetail(widget.eventId);
      if (!mounted) return;
      setState(() {
        _event = detail;
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

  String? _imageUrl() {
    final u = _event?.imageUrl;
    if (u == null || u.isEmpty) return null;
    if (u.startsWith('http')) return u;
    final base = widget.auth.baseUrl;
    return base.endsWith('/')
        ? '$base${u.replaceFirst(RegExp(r'^/'), '')}'
        : '$base$u';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: _kPrimary));
    }
    if (_error != null || _event == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error ?? AppLocalizations.of(context)!.unknownError,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _load,
                child: Text(AppLocalizations.of(context)!.retry),
              ),
            ],
          ),
        ),
      );
    }
    final accent = widget.accent;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildBanner(accent),
          const SizedBox(height: 24),
          _buildVenueSection(accent),
        ],
      ),
    );
  }

  Widget _buildBanner(Color accent) {
    final url = _imageUrl();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (url != null)
                Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder(),
                )
              else
                _placeholder(),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      _kBgDark.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.staffAccessBadge,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _event!.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatDateTime(_event!.startsAt),
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
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

  Widget _placeholder() => Container(
    color: Colors.white12,
    child: const Icon(Icons.image, size: 48, color: Colors.white24),
  );

  String _formatDateTime(DateTime? d) {
    if (d == null) return '—';
    final locale = Localizations.localeOf(context).toLanguageTag();
    final month = DateFormat.MMM(locale).format(d);
    return '${d.day} $month ${d.year} • ${AppSettings.formatTime(d.hour, d.minute)}';
  }

  Widget _buildVenueSection(Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: accent, size: 22),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.staffVenueAndContact,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: accent.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accent.withOpacity(0.15)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _event!.location ?? _event!.city ?? '—',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (_event!.city != null &&
                                    _event!.location != _event!.city)
                                  Text(
                                    _event!.city!,
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 13,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Material(
                            color: accent,
                            borderRadius: BorderRadius.circular(24),
                            child: IconButton(
                              icon: const Icon(
                                Icons.directions,
                                color: Colors.white,
                                size: 22,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _ContactChip(
                              icon: Icons.call,
                              title: AppLocalizations.of(
                                context,
                              )!.staffMainOffice,
                              subtitle: '(555) 012-3456',
                              accent: accent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ContactChip(
                              icon: Icons.security,
                              title: AppLocalizations.of(
                                context,
                              )!.staffSecurity,
                              subtitle: '(555) 098-7654',
                              accent: accent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.map_outlined,
                      color: accent.withOpacity(0.5),
                      size: 48,
                    ),
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

class _ContactChip extends StatelessWidget {
  const _ContactChip({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _kBgDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accent.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: accent, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
