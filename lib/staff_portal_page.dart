import 'dart:async';

import 'package:flutter/material.dart';
import 'api/auth_service.dart';
import 'push/push_token_service.dart';
import 'app_settings.dart';
import 'gen_l10n/app_localizations.dart';
import 'login_page.dart';
import 'staff_child_detail_page.dart';
import 'staff_scan_page.dart';
import 'staff_settings_page.dart';
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
  StaffRole? _selectedRole;
  List<SupervisorStageItem> _supervisorStages = [];
  int? _selectedSupervisorStageId;
  bool _showAllSupervisorChildren = false;
  List<SupervisorChildItem>? _supervisorChildren;
  bool _supervisorChildrenLoading = false;
  String? _supervisorChildrenError;
  int? _supervisorChildrenEventId;
  int _unreadNotifications = 0;

  @override
  void initState() {
    super.initState();
    _initSelectedRole();
    _refreshUnreadSilently();
  }

  Future<void> _refreshUnreadSilently() async {
    try {
      final count = await widget.auth.getUnreadNotificationsCount();
      if (!mounted) return;
      setState(() => _unreadNotifications = count);
    } catch (_) {
      // Silent badge refresh intentionally ignores transient errors.
    }
  }

  Future<void> _openNotifications() async {
    final changed = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => NotificationsPage(auth: widget.auth)));
    if (!mounted) return;
    if (changed == true) {
      _refreshUnreadSilently();
    }
  }

  void _initSelectedRole() {
    final roles = widget.status.staffRoles;
    if (roles.isEmpty) return;
    final savedRoleCode = AppSettings.staffSelectedRoleCode?.toLowerCase();
    final roleFromApi = widget.status.role;
    final match = roles.cast<StaffRole?>().firstWhere((r) {
      final role = r!;
      if (savedRoleCode != null && savedRoleCode.isNotEmpty) {
        return role.code.toLowerCase() == savedRoleCode;
      }
      return _matchesRoleToken(role, roleFromApi);
    }, orElse: () => null);
    setState(() {
      _selectedRole = match ?? roles.first;
    });
  }

  void _onRoleChanged(StaffRole role) {
    AppSettings.setStaffSelectedRoleCode(role.code);
    setState(() => _selectedRole = role);
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

  String get _userName =>
      (widget.user['name'] ?? '').toString().trim().isNotEmpty
      ? (widget.user['name']).toString().trim()
      : 'Staff';

  bool get _isHostess {
    final role = _selectedRole;
    if (role == null) return false;
    return _matchesAnyToken(role, const ['hostess', 'hs', 'хостесс']);
  }

  bool get _isSupervisor {
    final role = _selectedRole;
    if (role == null) return false;
    return _matchesAnyToken(role, const ['supervisor', 'sv', 'супервайзер']);
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
                  _isHostess
                      ? _buildHostessStub()
                      : _isSupervisor
                      ? _buildSupervisorHomeTab(accent)
                      : _buildHomeTab(accent),
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
              const Text(
                'STAFF PORTAL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: _openNotifications,
                  ),
                  if (_unreadNotifications > 0)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$_userName • ${_selectedRole?.name.toUpperCase() ?? 'STAFF'}',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF121212),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.white70),
              title: Text(
                AppLocalizations.of(context)!.aboutTheApp,
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AboutAppPage(),
                  ),
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
                await PushTokenServiceHolder.instance?.deactivateCurrentOnBackend();
                widget.auth.clearToken();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
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

  /// Домашняя вкладка (общее окно): зона, скан, live updates, карточка команды.
  Widget _buildHomeTab(Color accent) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Select Working Zone
          Text(
            'SELECT WORKING ZONE',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Zone 1 - Main Stage Backstage',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: accent, size: 24),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Scan button
          Center(
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _openScanner(context),
                    borderRadius: BorderRadius.circular(96),
                    child: Container(
                      width: 192,
                      height: 192,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [accent, accent.withOpacity(0.8)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withOpacity(0.3),
                            blurRadius: 40,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.qr_code_scanner,
                              color: Colors.white,
                              size: 56,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'SCAN',
                              style: TextStyle(
                                color: Colors.white,
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
                  'TAP TO SCAN MODEL LANYARD',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Live Updates
          Text(
            'LIVE UPDATES',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border(left: BorderSide(color: accent, width: 4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Current Task',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'ACTIVE',
                        style: TextStyle(
                          color: accent,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Hair & Makeup for Group A - Spring Collection.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(0.05)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule, color: accent, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        'Next rotation in 14:00 mins',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Team card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.groups_outlined,
                    color: Colors.white54,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Team Alpha',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '4 Stylists • 12 Models Assigned',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: accent, size: 24),
              ],
            ),
          ),
        ],
      ),
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
                'Select an event in Staff Settings',
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
            'UTILITIES & TOOLS',
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
            title: 'Scan for Info',
            subtitle: 'General purpose assets & ID scanner',
            accent: accent,
            large: true,
            onTap: () => _openScanner(context, scanForInfo: true),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MoreCard(
                  icon: Icons.child_care,
                  title: 'Toilet Request',
                  subtitle: 'RESTROOM LOG',
                  accent: accent,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _MoreCard(
                  icon: Icons.settings,
                  title: 'Staff Settings',
                  subtitle: 'PREFERENCES',
                  accent: accent,
                  onTap: () => _openStaffSettings(context, accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Shift in Progress
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          'SHIFT IN PROGRESS',
                          style: TextStyle(
                            color: accent,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Shift ends in 2h 15m',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Remember to clock out at the kiosk.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    Icons.schedule,
                    size: 120,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openScanner(BuildContext context, {bool scanForInfo = false}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StaffScanPage(
          auth: widget.auth,
          accent: _kPrimary,
          backgroundColor: _kBgDark,
          scanForInfo: scanForInfo,
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
              staffRoles: widget.status.staffRoles,
              currentRole: _selectedRole,
              onRoleChanged: _onRoleChanged,
            ),
          ),
        )
        .then((_) {
          if (mounted) setState(() {});
        });
  }

  /// Домашняя вкладка для роли Supervisor: карточка роли и реестр детей.
  Widget _buildSupervisorHomeTab(Color accent) {
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
          // Supervisor Role card
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
                Text(
                  'Supervisor Role',
                  style: TextStyle(
                    color: accent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage event flow, oversee photographers, and ensure all children are captured effectively. Track progress in real-time.',
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
                      hint: const Text(
                        'Current stage',
                        style: TextStyle(color: Colors.white54),
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
                'No main stages available for this event.',
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
                'Child Registry',
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
                    '${_supervisorChildren!.length} Children Listed',
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
                'Select an active event in Settings to see the child registry.',
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
                'No children assigned for this event.',
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
                'PROFILE',
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
                'NAME',
                style: TextStyle(
                  color: accent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'STATUS',
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
                'ACTION',
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
              child: const Text(
                'Details',
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
        return (color: Colors.green, label: 'Yes');
      default:
        return (color: Colors.red, label: 'No');
    }
  }

  Widget _buildHostessStub() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.badge_outlined, size: 64, color: Colors.white38),
            const SizedBox(height: 24),
            Text(
              'Выбрана роль хостесс',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Экран для роли хостесс будет добавлен позже.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      ),
    );
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
            label: 'Home',
            active: _currentTab == 0,
            accent: accent,
            onTap: () => setState(() => _currentTab = 0),
          ),
          _NavItem(
            icon: Icons.calendar_month,
            label: 'Event',
            active: _currentTab == 1,
            accent: accent,
            onTap: () => setState(() => _currentTab = 1),
          ),
          _NavItem(
            icon: Icons.more_horiz,
            label: 'More',
            active: _currentTab == 2,
            accent: accent,
            onTap: () => setState(() => _currentTab = 2),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(large ? 24 : 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: large ? 20 : 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
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
                _error ?? 'Unknown error',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextButton(onPressed: _load, child: Text(AppLocalizations.of(context)!.retry)),
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
          const SizedBox(height: 24),
          _buildShiftSchedule(accent),
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
                        'STAFF ACCESS',
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
    return '${d.day} ${_month(d.month)} ${d.year} • ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  String _month(int m) {
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
    return months[m - 1];
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
              const Text(
                'Venue & Contact',
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
                              title: 'Main Office',
                              subtitle: '(555) 012-3456',
                              accent: accent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ContactChip(
                              icon: Icons.security,
                              title: 'Security',
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

  Widget _buildShiftSchedule(Color accent) {
    final stages = _event!.stages;
    if (stages.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'No schedule',
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, color: accent, size: 22),
              const SizedBox(width: 8),
              const Text(
                'Shift Schedule',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...stages.asMap().entries.map((entry) {
            final i = entry.key;
            final s = entry.value;
            final isFirst = i == 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isFirst ? accent : Colors.white24,
                          shape: BoxShape.circle,
                          boxShadow: isFirst
                              ? [
                                  BoxShadow(
                                    color: accent.withOpacity(0.3),
                                    blurRadius: 6,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      if (i < stages.length - 1)
                        Container(
                          width: 2,
                          height: 48,
                          color: accent.withOpacity(0.2),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatTime(s.scheduledAt),
                          style: TextStyle(
                            color: isFirst ? accent : Colors.white54,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          s.title ?? '—',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        if (s.address != null && s.address!.isNotEmpty)
                          Text(
                            s.address!,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatTime(DateTime? d) {
    if (d == null) return '—';
    final hour = d.hour > 12 ? d.hour - 12 : (d.hour == 0 ? 12 : d.hour);
    final ampm = d.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')} $ampm';
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
