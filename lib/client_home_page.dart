import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api/auth_service.dart';
import 'app_settings.dart';
import 'client_profile_tab.dart';
import 'gen_l10n/app_localizations.dart';
import 'login_page.dart';
import 'about_page.dart';
import 'client_event_checkin_page.dart';
import 'client_event_backstage_ticket_flow.dart';
import 'client_event_description_page.dart';
import 'client_event_extra_ticket_flow.dart';
import 'client_event_parking_flow.dart';
import 'client_event_progress_tab.dart';
import 'contact_manager_page.dart';
import 'client_event_settings_page.dart';
import 'client_ticket_service_ui.dart';
import 'client_contract_flow.dart';
import 'faq_sections_page.dart';
import 'news_detail_page.dart';
import 'about_app_page.dart';
import 'settings_page.dart';
import 'my_tickets_sheet.dart';
import 'notifications_page.dart';
import 'client_youtube_live_page.dart';
import 'youtube_embed_utils.dart';
import 'schedule_wall_clock.dart';
import 'push/in_app_notification_bell_hint.dart';
import 'push/push_token_service.dart';

/// Заголовки ивента на карточке активного события (семейство из pubspec).
const _kFontFamilyLuxenta = 'Luxenta';

const _kGold = Color(0xFFD4AF37);
const _kGoldLight = Color(0xFFF3E5AB);
const _kGoldDark = Color(0xFFC5A028);
const _kBgDark = Color(0xFF050505);
const _kCardBg = Color(0xFF121212);

/// Main → second → family look; duplicates by [ActiveAssignment] brand ids skipped.
String? _childSubscribedBrandsLine(ActiveAssignment a, AppLocalizations l10n) {
  final parts = <String>[];
  final seen = <int>{};
  void add(int? id, String? name) {
    final bid = id ?? 0;
    if (bid <= 0 || seen.contains(bid)) {
      return;
    }
    seen.add(bid);
    final n = name?.trim();
    parts.add(
      n != null && n.isNotEmpty ? n : l10n.brandRequirementsBrandNumber(bid),
    );
  }

  add(a.brandId, a.brandName);
  add(a.secondBrandId, a.secondBrandName);
  add(a.familyLookBrandId, a.familyLookBrandName);
  if (parts.isEmpty) {
    return null;
  }
  return l10n.childSubscribedBrands(parts.join(', '));
}

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key, required this.auth, required this.user});

  final AuthService auth;
  final Map<String, dynamic> user;

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage>
    with WidgetsBindingObserver {
  int _currentTab = 0;
  int? _selectedDashboardChildId;
  ClientDashboard? _dashboard;
  bool _loading = true;
  String? _error;
  Timer? _dashboardRefreshTimer;

  List<UpcomingEvent>? _upcomingEvents;
  bool _upcomingLoading = false;
  String? _upcomingError;

  InfoSettings? _infoSettings;
  bool _infoSettingsLoading = false;
  String? _infoSettingsError;

  List<AppNewsItem>? _news;
  bool _newsLoading = false;
  int _unreadNotifications = 0;

  /// Тег локали для `Accept-Language` (новости, фото Info). Обновляется в [didChangeDependencies].
  String? _homeInfoContentLocaleTag;

  int _newsLoadSeq = 0;
  int _infoSettingsLoadSeq = 0;

  void _bellLocalHintListener() {
    if (mounted) setState(() {});
  }

  bool get _showUnreadBellDot =>
      _unreadNotifications > 0 ||
      InAppNotificationBellHint.hasPendingHint.value;

  bool get _canPurchaseTickets =>
      !_loading &&
      _error == null &&
      _dashboard != null &&
      _dashboard!.activeChild != null;

  ChildWithAssignment? get _selectedDashboardChild {
    final dashboard = _dashboard;
    if (dashboard == null || dashboard.children.isEmpty) return null;
    final selectedId = _selectedDashboardChildId;
    if (selectedId != null) {
      for (final c in dashboard.children) {
        if (c.id == selectedId) return c;
      }
    }
    return dashboard.activeChild ?? dashboard.children.first;
  }

  int? _resolveDashboardChildId(ClientDashboard dashboard) {
    if (dashboard.children.isEmpty) return null;
    final selectedId = _selectedDashboardChildId;
    if (selectedId != null) {
      for (final c in dashboard.children) {
        if (c.id == selectedId) return selectedId;
      }
    }
    return dashboard.activeChild?.id ?? dashboard.children.first.id;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadDashboard();
    _refreshUnreadSilently();
    InAppNotificationBellHint.hasPendingHint.addListener(
      _bellLocalHintListener,
    );
    _dashboardRefreshTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (!mounted) return;
      _refreshDashboardSilently();
      _refreshUnreadSilently();
    });
  }

  @override
  void dispose() {
    InAppNotificationBellHint.hasPendingHint.removeListener(
      _bellLocalHintListener,
    );
    _dashboardRefreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Ключ текущей локали контента API (совпадает с [AppSettings.contentLocaleForApi]).
  static String _tagForContentLocale(Locale loc) {
    final c = loc.countryCode;
    return (c != null && c.isNotEmpty)
        ? '${loc.languageCode}-$c'
        : loc.languageCode;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tag = _tagForContentLocale(AppSettings.contentLocaleForApi());
    if (_homeInfoContentLocaleTag == tag) return;
    _homeInfoContentLocaleTag = tag;
    _loadNews(force: true);
    _loadInfoSettings(force: true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshDashboardSilently();
      _refreshUnreadSilently();
    }
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final dashboard = await widget.auth.getClientDashboard();
      if (!mounted) return;
      debugPrint('[ClientDashboard] children=${dashboard.children.length}');
      for (final c in dashboard.children) {
        debugPrint(
          '[ClientDashboard] child=${c.firstName}, '
          'hasAssignment=${c.activeAssignment != null}',
        );
      }
      setState(() {
        _dashboard = dashboard;
        _selectedDashboardChildId = _resolveDashboardChildId(dashboard);
        _loading = false;
      });
    } catch (e) {
      debugPrint('[ClientDashboard] ERROR: $e');
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _refreshDashboardSilently() async {
    try {
      final dashboard = await widget.auth.getClientDashboard();
      if (!mounted) return;
      setState(() {
        _dashboard = dashboard;
        _selectedDashboardChildId = _resolveDashboardChildId(dashboard);
        _error = null;
      });
    } catch (_) {
      // Silent refresh intentionally ignores transient errors.
    }
  }

  Future<void> _refreshUnreadSilently() async {
    try {
      final count = await widget.auth.getUnreadNotificationsCount();
      if (!mounted) return;
      InAppNotificationBellHint.clearOnUnreadSyncedFromApi();
      setState(() => _unreadNotifications = count);
    } catch (_) {
      // Silent badge refresh intentionally ignores transient errors.
    }
  }

  Future<void> _openNotifications() async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => NotificationsPage(auth: widget.auth)),
    );
    if (!mounted) return;
    if (changed == true) {
      _refreshUnreadSilently();
    }
  }

  Future<void> _loadNews({bool force = false}) async {
    if (!force && _newsLoading) return;
    final seq = ++_newsLoadSeq;
    if (!mounted) return;
    setState(() => _newsLoading = true);
    try {
      final list = await widget.auth.getAppNews(
        contentLocale: AppSettings.contentLocaleForApi(),
      );
      if (!mounted || seq != _newsLoadSeq) return;
      setState(() {
        _news = list;
        _newsLoading = false;
      });
    } catch (e) {
      if (!mounted || seq != _newsLoadSeq) return;
      setState(() => _newsLoading = false);
    }
  }

  Future<void> _loadInfoSettings({bool force = false}) async {
    if (!force && _infoSettingsLoading) return;
    final seq = ++_infoSettingsLoadSeq;
    if (!mounted) return;
    setState(() {
      _infoSettingsLoading = true;
      _infoSettingsError = null;
    });
    try {
      final s = await widget.auth.getInfoSettings(
        contentLocale: AppSettings.contentLocaleForApi(),
      );
      if (!mounted || seq != _infoSettingsLoadSeq) return;
      setState(() {
        _infoSettings = s;
        _infoSettingsLoading = false;
      });
    } catch (e) {
      if (!mounted || seq != _infoSettingsLoadSeq) return;
      setState(() {
        _infoSettingsError = e.toString();
        _infoSettingsLoading = false;
      });
    }
  }

  Future<void> _loadUpcomingEvents() async {
    if (_upcomingLoading) return;
    setState(() {
      _upcomingLoading = true;
      _upcomingError = null;
    });
    try {
      final list = await widget.auth.getClientUpcomingEvents();
      if (!mounted) return;
      setState(() {
        _upcomingEvents = list;
        _upcomingLoading = false;
      });
    } catch (e) {
      debugPrint('[UpcomingEvents] ERROR: $e');
      if (!mounted) return;
      setState(() {
        _upcomingLoading = false;
        _upcomingError = e.toString();
      });
    }
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SettingsPage(user: widget.user, auth: widget.auth),
      ),
    );
  }

  void _openProgressPage(ChildWithAssignment child) {
    final childId = child.id;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _ClientEventProgressPage(
          auth: widget.auth,
          childId: childId,
          title: AppLocalizations.of(context)!.viewProgress,
          onOpenGallery: () {},
        ),
      ),
    );
  }

  Future<void> _openEventSettingsPage(ChildWithAssignment child) async {
    final a = child.activeAssignment;
    final eventId = a?.event.id ?? 0;
    final name = a?.event.name ?? '';
    final childrenInEvent =
        _dashboard?.children
            .where((c) => c.activeAssignment?.event.id == eventId)
            .toList() ??
        [child];
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => ClientEventSettingsPage(
          auth: widget.auth,
          eventName: name,
          accountName: (widget.user['name'] as String? ?? '').trim(),
          eventId: eventId,
          childrenInEvent: childrenInEvent,
          contextChildId: _selectedDashboardChild?.id ?? child.id,
          contextAssignmentId: a?.id,
          canManageFamily: (a?.accessMode ?? 'parent') != 'family',
          canDisconnectFromFamily: (a?.accessMode ?? 'parent') == 'family',
          onMealChoiceSaved: () {
            if (mounted) {
              _refreshDashboardSilently();
            }
          },
        ),
      ),
    );
    if (result == true && mounted) {
      _refreshDashboardSilently();
    }
  }

  Future<void> _openParkingFlow({
    required int eventId,
    required String eventName,
    required bool serviceEnabled,
    required bool? userHasParkingTicket,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    if (eventId <= 0) return;
    if (shouldBlockClientTicketPrefetch(
      serviceEnabled: serviceEnabled,
      userHasTicket: userHasParkingTicket,
    )) {
      await showClientTicketServiceUnavailableDialog(context, l10n);
      return;
    }
    try {
      final payload = await widget.auth.getEventParkingTickets(eventId);
      if (!mounted) return;

      final page = payload.hasActiveTickets
          ? ClientParkingActiveScreen(
              eventName: eventName,
              accountName: (widget.user['name'] as String? ?? '').trim(),
              l10n: l10n,
              auth: widget.auth,
              eventId: eventId,
              canBuy: payload.canBuy,
              vipMode: payload.vipMode,
              paymentRequired: payload.paymentRequired,
              freeParkingQuota: payload.freeParkingQuota,
              freeParkingUsed: payload.freeParkingUsed,
              freeParkingRemaining: payload.freeParkingRemaining,
              entryMapUrl: payload.entryMapUrl,
              entryAppleMapUrl: payload.entryAppleMapUrl,
              tickets: payload.tickets,
            )
          : ClientParkingInactiveScreen(
              l10n: l10n,
              eventName: eventName,
              accountName: (widget.user['name'] as String? ?? '').trim(),
              auth: widget.auth,
              eventId: eventId,
              canBuy: payload.canBuy,
              vipMode: payload.vipMode,
              paymentRequired: payload.paymentRequired,
              freeParkingQuota: payload.freeParkingQuota,
              freeParkingUsed: payload.freeParkingUsed,
              freeParkingRemaining: payload.freeParkingRemaining,
            );

      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => page));
      _refreshDashboardSilently();
    } on ApiServiceDisabledException catch (e) {
      if (!mounted) return;
      await showClientTicketServiceUnavailableDialog(
        context,
        l10n,
        message: e.message,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.parkingCheckoutError)));
    }
  }

  Future<void> _openParkingFlowFromAssignment(ActiveAssignment assignment) {
    final ev = assignment.event;
    return _openParkingFlow(
      eventId: ev.id,
      eventName: ev.name,
      serviceEnabled: ev.clientParkingServiceEnabled,
      userHasParkingTicket: ev.userHasParkingTicket,
    );
  }

  Future<void> _openExtraTicketFlowFromAssignment(
    ActiveAssignment assignment,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final ev = assignment.event;
    if (ev.id <= 0) return;
    if (shouldBlockClientTicketPrefetch(
      serviceEnabled: ev.clientExtraTicketsServiceEnabled,
      userHasTicket: ev.userHasExtraTicket,
    )) {
      await showClientTicketServiceUnavailableDialog(context, l10n);
      return;
    }
    try {
      final payload = await widget.auth.getEventExtraTickets(ev.id);
      if (!mounted) return;
      final page = payload.hasActiveTickets
          ? ClientExtraTicketActiveScreen(
              eventName: ev.name,
              l10n: l10n,
              auth: widget.auth,
              eventId: ev.id,
              canBuy: payload.canBuy,
              tickets: payload.tickets,
            )
          : ClientExtraTicketInactiveScreen(
              l10n: l10n,
              eventName: ev.name,
              auth: widget.auth,
              eventId: ev.id,
              canBuy: payload.canBuy,
            );
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => page));
      _refreshDashboardSilently();
    } on ApiServiceDisabledException catch (e) {
      if (!mounted) return;
      await showClientTicketServiceUnavailableDialog(
        context,
        l10n,
        message: e.message,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.extraTicketCheckoutError)));
    }
  }

  Future<void> _openBackstageTicketFlowFromAssignment(
    ActiveAssignment assignment,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final ev = assignment.event;
    if (ev.id <= 0) return;
    if (shouldBlockClientTicketPrefetch(
      serviceEnabled: ev.clientBackstageTicketsServiceEnabled,
      userHasTicket: ev.userHasBackstageTicket,
    )) {
      await showClientTicketServiceUnavailableDialog(context, l10n);
      return;
    }
    try {
      final payload = await widget.auth.getEventBackstageTickets(ev.id);
      if (!mounted) return;
      final page = payload.hasActiveTickets
          ? ClientBackstageTicketActiveScreen(
              eventName: ev.name,
              l10n: l10n,
              auth: widget.auth,
              eventId: ev.id,
              canBuy: payload.canBuy,
              tickets: payload.tickets,
            )
          : ClientBackstageTicketInactiveScreen(
              l10n: l10n,
              eventName: ev.name,
              auth: widget.auth,
              eventId: ev.id,
              canBuy: payload.canBuy,
            );
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => page));
      _refreshDashboardSilently();
    } on ApiServiceDisabledException catch (e) {
      if (!mounted) return;
      await showClientTicketServiceUnavailableDialog(
        context,
        l10n,
        message: e.message,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.backstageTicketCheckoutError)),
      );
    }
  }

  Future<List<UpcomingEvent>> _ensureUpcomingEventsLoaded() async {
    if (_upcomingEvents != null) {
      return _upcomingEvents!;
    }
    final list = await widget.auth.getClientUpcomingEvents();
    if (!mounted) return list;
    setState(() {
      _upcomingEvents = list;
      _upcomingLoading = false;
      _upcomingError = null;
    });
    return list;
  }

  Future<void> _openBuyTicketForNoActive() async {
    final l10n = AppLocalizations.of(context)!;
    final allowed = await ensureContractSignedBeforeTicketPurchase(
      context,
      auth: widget.auth,
    );
    if (!allowed) {
      return;
    }
    List<UpcomingEvent> source;
    try {
      source = await _ensureUpcomingEventsLoaded();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
      return;
    }
    if (!mounted) return;
    final events = source
        .where((e) => (e.ticketStoreUrl ?? '').trim().isNotEmpty)
        .toList();
    if (events.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.ticketsBuyNoLink)));
      return;
    }

    int? selectedEventId;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          UpcomingEvent? selected;
          for (final event in events) {
            if (event.id == selectedEventId) {
              selected = event;
              break;
            }
          }
          return SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                color: _kBgDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.ticketsBuy,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.selectEventForTickets,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: _kCardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedEventId,
                        isExpanded: true,
                        dropdownColor: _kCardBg,
                        icon: const Icon(Icons.expand_more, color: _kGold),
                        hint: Text(
                          l10n.selectEventForTickets,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        items: events
                            .map(
                              (e) => DropdownMenuItem<int>(
                                value: e.id,
                                child: Text(
                                  e.name,
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (id) {
                          setModalState(() => selectedEventId = id);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.ticketsBuyEmailHint,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  if (selected != null) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final normalized = _normalizeHttpUrl(
                            selected!.ticketStoreUrl ?? '',
                          );
                          if (normalized == null) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.ticketsBuyNoLink)),
                              );
                            }
                            return;
                          }
                          final uri = Uri.tryParse(normalized);
                          if (uri == null || !uri.hasScheme) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.ticketsBuyCouldNotOpen),
                                ),
                              );
                            }
                            return;
                          }
                          final ok = await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                          if (!ctx.mounted) return;
                          Navigator.of(ctx).pop();
                          if (!ok && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.ticketsBuyCouldNotOpen),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kGold,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(l10n.ticketsBuy),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openParkingForNoActive() async {
    final l10n = AppLocalizations.of(context)!;
    List<UpcomingEvent> events;
    try {
      events = await _ensureUpcomingEventsLoaded();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
      return;
    }
    if (!mounted) return;
    if (events.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.ticketsNoEvents)));
      return;
    }

    int? selectedEventId;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          UpcomingEvent? selected;
          for (final event in events) {
            if (event.id == selectedEventId) {
              selected = event;
              break;
            }
          }
          return SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                color: _kBgDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.eventSettingsParkingTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.selectEventForTickets,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: _kCardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedEventId,
                        isExpanded: true,
                        dropdownColor: _kCardBg,
                        icon: const Icon(Icons.expand_more, color: _kGold),
                        hint: Text(
                          l10n.selectEventForTickets,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        items: events
                            .map(
                              (e) => DropdownMenuItem<int>(
                                value: e.id,
                                child: Text(
                                  e.name,
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (id) {
                          setModalState(() => selectedEventId = id);
                        },
                      ),
                    ),
                  ),
                  if (selected != null) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          final selectedEvent = selected;
                          if (selectedEvent == null) {
                            return;
                          }
                          Navigator.of(ctx).pop();
                          await _openParkingFlow(
                            eventId: selectedEvent.id,
                            eventName: selectedEvent.name,
                            serviceEnabled:
                                selectedEvent.clientParkingServiceEnabled,
                            userHasParkingTicket:
                                selectedEvent.userHasParkingTicket,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: _kGold),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.eventSettingsParkingTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await PushTokenServiceHolder.instance?.deactivateCurrentOnBackend();
    } catch (_) {
      // Logout must complete even if FCM/backend deactivation fails (e.g. offline).
    }
    await widget.auth.clearToken();
    if (!mounted) return;
    // rootNavigator: true avoids iOS overlay/menu picking a nested navigator;
    // await clearToken avoids race where Keychain still holds token before next launch.
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => LoginPage(auth: widget.auth)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgDark,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: PopupMenuButton<String>(
          icon: const Icon(Icons.menu, color: Colors.white),
          color: Colors.grey[900],
          onSelected: (v) {
            if (v == 'about_app') {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const AboutAppPage()),
              );
            }
            if (v == 'settings') _openSettings();
            if (v == 'sign_out') _signOut();
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'about_app',
              child: Text(AppLocalizations.of(context)!.aboutTheApp),
            ),
            PopupMenuItem(
              value: 'settings',
              child: Text(AppLocalizations.of(context)!.settings),
            ),
            PopupMenuItem(
              value: 'sign_out',
              child: Text(AppLocalizations.of(context)!.signOut),
            ),
          ],
        ),
        centerTitle: true,
        title: Image.asset(
          'assets/logo.png',
          height: 32,
          filterQuality: FilterQuality.high,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                  ),
                  onPressed: _openNotifications,
                ),
                if (_showUnreadBellDot)
                  const Positioned(right: 12, top: 12, child: _GoldDot()),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.white10),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ---------------------------------------------------------------------------
  // Body
  // ---------------------------------------------------------------------------

  Widget _buildBody() {
    switch (_currentTab) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildEventsContent();
      case 2:
        return ClientProfileTab(auth: widget.auth, user: widget.user);
      case 3:
        return _buildInfoContent();
      default:
        return Center(
          child: Text(
            AppLocalizations.of(context)!.comingSoon,
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        );
    }
  }

  // ---------------------------------------------------------------------------
  // Info tab (Information Hub)
  // ---------------------------------------------------------------------------

  Widget _buildInfoContent() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header: title + info icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.infoHubTitle,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildInfoPhotoPlaceholder(),
                const SizedBox(height: 40),
                _InfoMenuRow(
                  icon: Icons.history_edu,
                  label: AppLocalizations.of(context)!.infoMenuAboutYfs,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => AboutPage(auth: widget.auth),
                      ),
                    );
                  },
                ),
                Divider(height: 1, color: Colors.white.withOpacity(0.05)),
                _InfoMenuRow(
                  icon: Icons.help_outline,
                  label: AppLocalizations.of(context)!.infoMenuGeneralFaq,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => FaqSectionsPage(auth: widget.auth),
                      ),
                    );
                  },
                ),
                Divider(height: 1, color: Colors.white.withOpacity(0.05)),
                _InfoMenuRow(
                  icon: Icons.contact_support,
                  label: AppLocalizations.of(context)!.infoMenuContactManager,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ContactManagerPage(auth: widget.auth),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildInfoFooterSocials(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoPhotoPlaceholder() {
    if (_infoSettingsLoading) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _kCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: const Center(
          child: SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(color: _kGold, strokeWidth: 2),
          ),
        ),
      );
    }
    final photoUrl = _infoSettings?.infoPhotoUrl;
    final fullUrl = photoUrl != null && !photoUrl.startsWith('http')
        ? '${widget.auth.baseUrl}$photoUrl'
        : photoUrl;
    if (fullUrl != null && fullUrl.isNotEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.network(
                fullUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _infoPhotoPlaceholderBox(),
              ),
            ),
          ),
          if (_infoSettingsError != null) _buildInfoSettingsErrorRow(),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _infoPhotoPlaceholderBox(),
        if (_infoSettingsError != null) _buildInfoSettingsErrorRow(),
      ],
    );
  }

  Widget _buildInfoSettingsErrorRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Text(
            _infoSettingsError!,
            style: TextStyle(color: Colors.red[300], fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          TextButton(
            onPressed: _loadInfoSettings,
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }

  Widget _infoPhotoPlaceholderBox() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Icon(Icons.image_outlined, size: 48, color: Colors.white24),
    );
  }

  Widget _buildInfoFooterSocials() {
    final s = _infoSettings;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _infoSocialIconButton(
          icon: FontAwesomeIcons.instagram,
          rawUrl: s?.socialInstagram,
        ),
        const SizedBox(width: 20),
        _infoSocialIconButton(
          icon: FontAwesomeIcons.youtube,
          rawUrl: s?.socialYoutube,
        ),
        const SizedBox(width: 20),
        _infoSocialIconButton(
          icon: FontAwesomeIcons.facebookF,
          rawUrl: s?.socialFacebook,
        ),
        const SizedBox(width: 20),
        _infoSocialIconButton(
          icon: FontAwesomeIcons.tiktok,
          rawUrl: s?.socialTiktok,
        ),
      ],
    );
  }

  /// Открывает ссылку из админки; относительные пути к API — через baseUrl; иначе https:// при отсутствии схемы.
  Widget _infoSocialIconButton({
    required IconData icon,
    required String? rawUrl,
  }) {
    return IconButton(
      icon: FaIcon(icon, color: Colors.white38, size: 22),
      onPressed: () {
        if (rawUrl == null || rawUrl.trim().isEmpty) return;
        final t = rawUrl.trim();
        final String resolved;
        if (t.startsWith('http://') || t.startsWith('https://')) {
          resolved = t;
        } else if (t.startsWith('/')) {
          resolved = '${widget.auth.baseUrl}$t';
        } else {
          final n = _normalizeHttpUrl(t);
          if (n == null) return;
          resolved = n;
        }
        _openUrl(resolved);
      },
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String? _normalizeHttpUrl(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return null;
    if (t.startsWith('http://') || t.startsWith('https://')) return t;
    return 'https://$t';
  }

  /// Ссылка из админки «Ссылка на форму» (общие настройки приложения).
  Future<void> _openContactFormUrl() async {
    final l10n = AppLocalizations.of(context)!;
    final raw = _infoSettings?.contactFormUrl;
    if (raw == null || raw.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.contactFormLinkMissing)));
      return;
    }
    final normalized = _normalizeHttpUrl(raw);
    if (normalized == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.contactFormLinkMissing)));
      return;
    }
    final uri = Uri.tryParse(normalized);
    if (uri == null || !uri.hasScheme) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.ticketsBuyCouldNotOpen)));
      return;
    }
    try {
      if (!await canLaunchUrl(uri)) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.ticketsBuyCouldNotOpen)));
        return;
      }
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.ticketsBuyCouldNotOpen)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.ticketsBuyCouldNotOpen)));
      }
    }
  }

  Future<void> _openJoinFamilyDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    var submitting = false;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            Future<void> submit() async {
              if (submitting) {
                return;
              }
              final code = controller.text.trim();
              if (!RegExp(r'^\d{6}$').hasMatch(code)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.familyJoinInvalidCode)),
                );
                return;
              }
              setModalState(() => submitting = true);
              try {
                await widget.auth.joinFamilyByCode(code);
                if (!mounted || !ctx.mounted) {
                  return;
                }
                Navigator.of(ctx).pop();
                await _loadDashboard();
                if (!mounted) {
                  return;
                }
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.familyJoinSuccess)));
              } catch (e) {
                if (!mounted) {
                  return;
                }
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.toString())));
              } finally {
                if (mounted) {
                  setModalState(() => submitting = false);
                }
              }
            }

            return AlertDialog(
              backgroundColor: _kCardBg,
              title: Text(
                l10n.familyJoinButton,
                style: const TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.familyJoinDialogHint,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '000000',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.black45,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: _kGold),
                      ),
                    ),
                    onSubmitted: (_) => submit(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: submitting ? null : () => Navigator.of(ctx).pop(),
                  child: Text(l10n.cancel),
                ),
                ElevatedButton(
                  onPressed: submitting ? null : submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kGold,
                    foregroundColor: Colors.black,
                  ),
                  child: submitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.familyJoinAction),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Events tab
  // ---------------------------------------------------------------------------

  /// Текущее назначение + предстоящие ивенты; без дубликатов по id.
  List<({String url, String title})> _youtubeLiveEntriesForEventsTab() {
    final out = <({String url, String title})>[];
    final seen = <int>{};
    void push(int id, String name, String? url, bool active) {
      if (!active) {
        return;
      }
      final u = url?.trim();
      if (u == null || u.isEmpty) {
        return;
      }
      if (seen.contains(id)) {
        return;
      }
      seen.add(id);
      out.add((url: u, title: name));
    }

    final ev = _selectedDashboardChild?.activeAssignment?.event;
    if (ev != null) {
      push(ev.id, ev.name, ev.youtubeLiveUrl, ev.youtubeLiveActive);
    }
    for (final e in _upcomingEvents ?? const <UpcomingEvent>[]) {
      push(e.id, e.name, e.youtubeLiveUrl, e.youtubeLiveActive);
    }
    return out;
  }

  void _openYoutubeLiveInApp(String rawUrl, String titleText) {
    final id = extractYoutubeVideoId(rawUrl);
    final l10n = AppLocalizations.of(context)!;
    if (id == null || id.isEmpty) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text(l10n.eventsYoutubeLiveInvalidUrl)),
      );
      return;
    }
    final openUri = youtubeWatchUriFromAnyYoutubeUrl(rawUrl);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ClientYoutubeLivePage(
          videoId: id,
          titleText: titleText,
          fallbackOpenUri: openUri,
        ),
      ),
    );
  }

  Widget _buildYoutubeLiveEventsBanner() {
    final entries = _youtubeLiveEntriesForEventsTab();
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    final multi = entries.length > 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final e in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FilledButton(
              onPressed: () => _openYoutubeLiveInApp(e.url, e.title),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                multi
                    ? '${l10n.eventsYoutubeLiveButton} · ${e.title}'
                    : l10n.eventsYoutubeLiveButton,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildEventsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildYoutubeLiveEventsBanner(),
          _buildCurrentParticipationForEventsTab(),
          const SizedBox(height: 36),
          _buildNextShowsSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildNextShowsSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                l10n.nextShowsTitle,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Text(
                  l10n.nextShowsSeason,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (_upcomingLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator(color: _kGold)),
          )
        else if (_upcomingError != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Column(
                children: [
                  Text(
                    _upcomingError!,
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _loadUpcomingEvents,
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          )
        else if (_upcomingEvents == null || _upcomingEvents!.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                l10n.comingSoon,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
          )
        else
          ..._upcomingEvents!.map((event) {
            final imageUrl =
                event.imageUrl != null && !event.imageUrl!.startsWith('http')
                ? '${widget.auth.baseUrl}${event.imageUrl}'
                : event.imageUrl;
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _UpcomingEventCard(
                imageUrl: imageUrl,
                label: l10n.registrationOpen,
                title: event.name,
                subtitle: _formatUpcomingEventSubtitle(event),
                onDetails: () {},
                onContact: _openContactFormUrl,
              ),
            );
          }),
      ],
    );
  }

  String _formatUpcomingEventSubtitle(UpcomingEvent event) {
    final parts = <String>[];
    if (event.startsAt != null) {
      final s = event.startsAt!;
      if (event.endsAt != null && event.endsAt != s) {
        parts.add(
          '${_formatEventDate(s)} – ${_formatEventDate(event.endsAt!)}',
        );
      } else {
        parts.add(_formatEventDate(s));
      }
    }
    final location = (event.location != null && event.location!.isNotEmpty)
        ? event.location!
        : event.city;
    if (location.isNotEmpty) parts.add(location);
    return parts.join(' • ');
  }

  String _formatEventDate(DateTime d) {
    final loc = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(loc).format(d);
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentParticipation(),
          const SizedBox(height: 36),
          _buildHighlights(),
          const SizedBox(height: 40),
          _buildQuote(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section title
  // ---------------------------------------------------------------------------

  Widget _buildSectionTitle(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.grey[600],
        letterSpacing: 2.5,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
    );
  }

  // ---------------------------------------------------------------------------
  // Current participation
  // ---------------------------------------------------------------------------

  Widget _buildCurrentParticipation() {
    final selectedChild = _selectedDashboardChild;
    final Widget content;
    final Widget? quickActions;
    if (_loading) {
      content = _buildLoadingCard();
      quickActions = null;
    } else if (_error != null) {
      content = _buildErrorCard();
      quickActions = null;
    } else if (selectedChild?.activeAssignment != null) {
      content = _buildEventCard(selectedChild!);
      quickActions = _buildEventActionsCard(selectedChild);
    } else {
      content = _buildBecomeModelButton();
      quickActions = _buildNoActiveActionsCard();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(AppLocalizations.of(context)!.currentParticipation),
        const SizedBox(height: 12),
        content,
        if (quickActions != null) ...[const SizedBox(height: 12), quickActions],
      ],
    );
  }

  /// Текущее участие на вкладке Events: карточка как в референсе (фото фона, ACTIVE, прогресс, кнопка).
  Widget _buildCurrentParticipationForEventsTab() {
    final selectedChild = _selectedDashboardChild;
    final Widget content;
    if (_loading) {
      content = _buildLoadingCard();
    } else if (_error != null) {
      content = _buildErrorCard();
    } else if (selectedChild?.activeAssignment != null) {
      content = _buildCurrentParticipationEventCard(selectedChild!);
    } else {
      content = _buildBecomeModelButton();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(AppLocalizations.of(context)!.currentParticipation),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildEventActionsCard(ChildWithAssignment child) {
    final l10n = AppLocalizations.of(context)!;
    final assignment = child.activeAssignment;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
        color: _kCardBg,
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    showMyTicketsSheet(
                      context,
                      auth: widget.auth,
                      canPurchaseTickets: _canPurchaseTickets,
                      requireContractGate:
                          (assignment?.accessMode ?? 'parent') == 'family',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kGold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.myTicketsButton,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 1.4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: assignment == null
                      ? null
                      : () => _openParkingFlowFromAssignment(assignment),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: _kGold),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.eventSettingsParkingTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 1.4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: assignment == null
                      ? null
                      : () => _openExtraTicketFlowFromAssignment(assignment),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: _kGold),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.extraTicketButton,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 1.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: assignment == null
                      ? null
                      : () =>
                            _openBackstageTicketFlowFromAssignment(assignment),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: _kGold),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.backstageTicketButton,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: 1.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoActiveActionsCard() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
        color: _kCardBg,
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _openBuyTicketForNoActive,
              style: ElevatedButton.styleFrom(
                backgroundColor: _kGold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                l10n.ticketsBuy,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: _openParkingForNoActive,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: _kGold),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.eventSettingsParkingTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<ChildWithAssignment> _childrenForActiveCardDropdown() {
    final all = _dashboard?.children ?? const <ChildWithAssignment>[];
    final withAssignments = all
        .where((c) => c.activeAssignment != null)
        .toList();
    return withAssignments.isNotEmpty ? withAssignments : all;
  }

  Widget _buildInlineChildDropdown({
    required ChildWithAssignment selectedChild,
    required TextStyle textStyle,
    Color? iconColor,
    Color? borderColor,
    Color? backgroundColor,
  }) {
    final options = _childrenForActiveCardDropdown();
    if (options.length <= 1) {
      return SizedBox(
        width: double.infinity,
        child: Text(
          selectedChild.firstName,
          style: textStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      );
    }

    final selectedId = options.any((c) => c.id == selectedChild.id)
        ? selectedChild.id
        : options.first.id;

    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white.withOpacity(0.22),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor ?? Colors.white24),
        ),
        child: DropdownButtonHideUnderline(
          child: SizedBox(
            height: 34,
            child: DropdownButton<int>(
              value: selectedId,
              isDense: true,
              isExpanded: true,
              menuMaxHeight: 220,
              borderRadius: BorderRadius.circular(12),
              dropdownColor: const Color(0xFF1A1A1A),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: iconColor ?? _kGold,
                size: 18,
              ),
              style: textStyle,
              items: options
                  .map(
                    (child) => DropdownMenuItem<int>(
                      value: child.id,
                      child: Text(
                        child.firstName,
                        style: const TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedDashboardChildId = value);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: const Center(child: CircularProgressIndicator(color: _kGold)),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 36),
          const SizedBox(height: 12),
          Text(
            _error ?? AppLocalizations.of(context)!.unknownError,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadDashboard,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white10,
              foregroundColor: Colors.white,
            ),
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(ChildWithAssignment child) {
    final a = child.activeAssignment!;
    final isFamilyAccess = a.accessMode == 'family';
    final totalStages = a.totalMainStages + a.totalPreparatoryStages;
    final completed = a.completedStages;
    final progress = totalStages > 0 ? completed / totalStages : 0.0;
    final parentProgress = a.parentProgress;

    final l10nCard = AppLocalizations.of(context)!;
    final brandsLine = _childSubscribedBrandsLine(a, l10nCard);
    final eventArrivalTime = (a.eventArrivalTime ?? '').trim();
    final nextStageText = _nextPreparatoryHint(a, l10nCard);
    final dateText = a.event.startsAt != null
        ? (a.event.endsAt != null && a.event.endsAt != a.event.startsAt
              ? '${_formatEventDate(a.event.startsAt!)} – ${_formatEventDate(a.event.endsAt!)}'
              : _formatEventDate(a.event.startsAt!))
        : '';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
        ),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  a.event.name,
                  style: const TextStyle(
                    fontFamily: _kFontFamilyLuxenta,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _kGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _kGold.withOpacity(0.25)),
                ),
                child: Text(
                  isFamilyAccess
                      ? AppLocalizations.of(context)!.familyLabel
                      : AppLocalizations.of(context)!.active,
                  style: TextStyle(
                    fontSize: 10,
                    color: _kGold,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (dateText.isNotEmpty) ...[
            Text(
              dateText,
              style: const TextStyle(
                fontSize: 13,
                color: _kGold,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            const SizedBox(height: 8),
          ],
          _buildInlineChildDropdown(
            selectedChild: child,
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1408),
            ),
            iconColor: const Color(0xFF1A1408),
            borderColor: _kGold.withOpacity(0.25),
            backgroundColor: _kGold.withOpacity(0.32),
          ),
          if (brandsLine != null) ...[
            const SizedBox(height: 8),
            Text(
              brandsLine,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey[400],
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ],
          if (eventArrivalTime.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Старт для вас: $eventArrivalTime',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[300],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: 22),

          // Progress header
          Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.journeyProgress,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500],
                    letterSpacing: 2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  AppLocalizations.of(context)!.stepOf(completed, totalStages),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: _kGold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          if (a.familyLook && parentProgress != null) ...[
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.parentProgressLabel(
                parentProgress.completedStages,
                parentProgress.totalStages,
              ),
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ],
          const SizedBox(height: 8),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progress.clamp(0.0, 1.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_kGold, _kGoldLight, _kGoldDark],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (nextStageText != null) ...[
            const SizedBox(height: 8),
            Text(
              nextStageText,
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          ],

          const SizedBox(height: 22),

          // CTA buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _openProgressPage(child),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.homeEventCardRunwayJourney,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 14),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _openEventSettingsPage(child),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: _kGold),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.homeEventCardMyEvent,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.settings_outlined, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Карточка текущего участия в стиле референса: фото фона, градиент, ACTIVE справа сверху, название и дата поверх фото, прогресс и кнопка снизу.
  Widget _buildCurrentParticipationEventCard(ChildWithAssignment child) {
    final a = child.activeAssignment!;
    final isFamilyAccess = a.accessMode == 'family';
    final totalStages = a.totalMainStages + a.totalPreparatoryStages;
    final completed = a.completedStages;
    final progress = totalStages > 0 ? completed / totalStages : 0.0;
    final parentProgress = a.parentProgress;
    final l10n = AppLocalizations.of(context)!;
    final brandsLine = _childSubscribedBrandsLine(a, l10n);
    final eventArrivalTime = (a.eventArrivalTime ?? '').trim();

    final eventImageUrl =
        a.event.imageUrl != null && !a.event.imageUrl!.startsWith('http')
        ? '${widget.auth.baseUrl}${a.event.imageUrl}'
        : a.event.imageUrl;

    final dateText = a.event.startsAt != null
        ? (a.event.endsAt != null && a.event.endsAt != a.event.startsAt
              ? '${_formatEventDate(a.event.startsAt!)} – ${_formatEventDate(a.event.endsAt!)}'
              : _formatEventDate(a.event.startsAt!))
        : '';

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
          color: _kCardBg,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 224,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (eventImageUrl != null && eventImageUrl.isNotEmpty)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(eventImageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF2A2A2A),
                            const Color(0xFF1A1A1A),
                            Colors.black,
                          ],
                        ),
                      ),
                    ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          _kCardBg.withOpacity(0.2),
                          _kCardBg,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _kGold,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        (isFamilyAccess ? l10n.familyLabel : l10n.active)
                            .toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.event.name,
                          style: const TextStyle(
                            fontFamily: _kFontFamilyLuxenta,
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        const SizedBox(height: 8),
                        if (dateText.isNotEmpty) ...[
                          Text(
                            dateText,
                            style: const TextStyle(
                              fontSize: 13,
                              color: _kGold,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                          const SizedBox(height: 8),
                        ],
                        _buildInlineChildDropdown(
                          selectedChild: child,
                          textStyle: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1A1408),
                            fontWeight: FontWeight.w500,
                          ),
                          iconColor: const Color(0xFF1A1408),
                          borderColor: _kGold.withOpacity(0.65),
                          backgroundColor: _kGold.withOpacity(0.32),
                        ),
                        if (brandsLine != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            brandsLine,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.78),
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                        ],
                        if (eventArrivalTime.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Старт для вас: $eventArrivalTime',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.86),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: SizedBox(
                            height: 6,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: progress.clamp(0.0, 1.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: _kGold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(
                          l10n.stepOf(completed, totalStages),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  if (a.familyLook && parentProgress != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      l10n.parentProgressLabel(
                        parentProgress.completedStages,
                        parentProgress.totalStages,
                      ),
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ],
                  ...() {
                    final prepHint = _nextPreparatoryHint(a, l10n);
                    if (prepHint == null) {
                      return <Widget>[];
                    }
                    return [
                      const SizedBox(height: 10),
                      Text(
                        prepHint,
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ];
                  }(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBecomeModelButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
        ),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _kGold.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star_outline, color: _kGold, size: 32),
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.noActiveEvents,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.becomeModelTitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _openContactFormUrl,
              style: ElevatedButton.styleFrom(
                backgroundColor: _kGold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                AppLocalizations.of(context)!.becomeAModel,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _openJoinFamilyDialog,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: _kGold),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.familyJoinButton,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  letterSpacing: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Highlights
  // ---------------------------------------------------------------------------

  Widget _buildHighlights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildSectionTitle(
                AppLocalizations.of(context)!.latestHighlights,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 280,
          child: _newsLoading
              ? const Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      color: _kGold,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : (_news != null && _news!.isNotEmpty)
              ? ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: _news!.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (_, index) {
                    final item = _news![index];
                    final photoUrl =
                        item.photoUrl != null &&
                            !item.photoUrl!.startsWith('http')
                        ? '${widget.auth.baseUrl}${item.photoUrl}'
                        : item.photoUrl;
                    return _NewsHighlightCard(
                      title: item.title,
                      photoUrl: photoUrl,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => NewsDetailPage(
                              news: item,
                              baseUrl: widget.auth.baseUrl,
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      AppLocalizations.of(context)!.comingSoon,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Home tagline
  // ---------------------------------------------------------------------------

  Widget _buildQuote() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          '"The biggest kids and teens fashion tour in the USA"',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.6,
          ),
          maxLines: 6,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom navigation
  // ---------------------------------------------------------------------------

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xF0000000),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: AppLocalizations.of(context)!.navHome,
                  isActive: _currentTab == 0,
                  onTap: () => setState(() => _currentTab = 0),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.event_outlined,
                  activeIcon: Icons.event,
                  label: AppLocalizations.of(context)!.navEvents,
                  isActive: _currentTab == 1,
                  onTap: () {
                    setState(() => _currentTab = 1);
                    _refreshDashboardSilently();
                    _loadInfoSettings();
                    if (_upcomingEvents == null && !_upcomingLoading) {
                      _loadUpcomingEvents();
                    }
                  },
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: AppLocalizations.of(context)!.navProfile,
                  isActive: _currentTab == 2,
                  onTap: () => setState(() => _currentTab = 2),
                ),
              ),
              Expanded(
                child: _NavItem(
                  icon: Icons.info_outline,
                  activeIcon: Icons.info,
                  label: AppLocalizations.of(context)!.navInfo,
                  isActive: _currentTab == 3,
                  onTap: () {
                    setState(() => _currentTab = 3);
                    if (_infoSettings == null && !_infoSettingsLoading) {
                      _loadInfoSettings();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Next incomplete preparatory milestone (including rehearsal booking).
  String? _nextPreparatoryHint(ActiveAssignment a, AppLocalizations l10n) {
    if (a.preparatoryStages.isEmpty) {
      return null;
    }
    final idx = a.preparatoryStages.indexWhere((p) => !p.isCompleted);
    if (idx < 0) {
      return null;
    }
    final p = a.preparatoryStages[idx];
    final scheduleHint =
        parseScheduleWallToDateTime(p.scheduledAtWall) ?? p.scheduledAt;
    if (p.isRehearsalMilestone && scheduleHint == null) {
      return l10n.rehearsalNextBookHint;
    }
    if (scheduleHint != null && scheduleHint.isAfter(DateTime.now())) {
      final name = p.displayTitle(l10n);
      return '${l10n.next(name)} (${_formatShortEventDate(scheduleHint)})';
    }
    final title = p.displayTitle(l10n);
    if (title.isNotEmpty) {
      return l10n.next(title);
    }
    return null;
  }

  String _formatShortEventDate(DateTime date) {
    final loc = Localizations.localeOf(context).toString();
    return DateFormat.MMMd(loc).format(date);
  }
}

// =============================================================================
// Private sub-widgets
// =============================================================================

class _GoldDot extends StatelessWidget {
  const _GoldDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: _kGold,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1.5),
      ),
    );
  }
}

class _ClientEventProgressPage extends StatefulWidget {
  const _ClientEventProgressPage({
    required this.auth,
    required this.childId,
    required this.title,
    required this.onOpenGallery,
  });

  final AuthService auth;
  final int childId;
  final String title;
  final VoidCallback onOpenGallery;

  @override
  State<_ClientEventProgressPage> createState() =>
      _ClientEventProgressPageState();
}

class _ClientEventProgressPageState extends State<_ClientEventProgressPage> {
  ChildWithAssignment? _child;
  bool _loading = true;
  String? _error;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _load();
    _refreshTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (!mounted) return;
      _load(silent: true);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final dashboard = await widget.auth.getClientDashboard();
      ChildWithAssignment? child;
      for (final c in dashboard.children) {
        if (c.id == widget.childId) {
          child = c;
          break;
        }
      }
      child ??= dashboard.activeChild;
      if (!mounted) return;
      setState(() {
        _child = child;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        if (!silent) _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgDark,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? ListView(
                children: [
                  SizedBox(
                    height: 400,
                    child: Center(
                      child: CircularProgressIndicator(color: _kGold),
                    ),
                  ),
                ],
              )
            : (_error != null
                  ? ListView(
                      children: [
                        const SizedBox(height: 120),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ClientEventProgressTab(
                      assignment: _child?.activeAssignment,
                      childFullName: _child == null ? '' : _child!.firstName,
                      onOpenCheckin: (checkinCode) {
                        if (!context.mounted) return;
                        final eventName =
                            _child?.activeAssignment?.event.name ?? '';
                        final childName = _child?.firstName ?? '';
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ClientEventCheckinPage(
                              checkinCode: checkinCode,
                              eventName: eventName,
                              childName: childName,
                            ),
                          ),
                        );
                      },
                      onOpenInfo: () {
                        final a = _child?.activeAssignment;
                        if (a == null || !context.mounted) return;
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ClientEventDescriptionPage(
                              auth: widget.auth,
                              eventId: a.event.id,
                            ),
                          ),
                        );
                      },
                      onOpenGallery: widget.onOpenGallery,
                    )),
      ),
    );
  }
}

/// Карточка новости в блоке «Последние события»: фон — картинка, внизу заголовок.
class _NewsHighlightCard extends StatelessWidget {
  const _NewsHighlightCard({
    required this.title,
    required this.photoUrl,
    required this.onTap,
  });

  final String title;
  final String? photoUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 200,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (photoUrl != null && photoUrl!.isNotEmpty)
                Image.network(
                  photoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholderGradient(),
                )
              else
                _placeholderGradient(),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderGradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2A2A2A), Color(0xFF151515)],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? _kGold : const Color(0xFF666666);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(isActive ? activeIcon : icon, color: color, size: 26),
              const SizedBox(height: 4),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: 1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Events tab: upcoming show card
// -----------------------------------------------------------------------------

class _UpcomingEventCard extends StatelessWidget {
  const _UpcomingEventCard({
    this.imageUrl,
    required this.label,
    required this.title,
    required this.subtitle,
    required this.onDetails,
    required this.onContact,
  });

  final String? imageUrl;
  final String label;
  final String title;
  final String subtitle;
  final VoidCallback onDetails;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
            color: _kCardBg,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 280,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Фото ивента как фон или градиент-заглушка
                    if (imageUrl != null && imageUrl!.isNotEmpty)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF2A2A2A),
                              const Color(0xFF1A1A1A),
                              Colors.black,
                            ],
                          ),
                        ),
                      ),
                    // Градиент поверх фото для читаемости
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.85),
                          ],
                        ),
                      ),
                    ),
                    // Label pill
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Text(
                          label.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    // Title and subtitle at bottom
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontFamily: _kFontFamilyLuxenta,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: onDetails,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(
                                      color: Colors.white24,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    l10n.details.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: onContact,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    l10n.contact.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
}

// -----------------------------------------------------------------------------
// Info tab: menu row (icon + label + chevron)
// -----------------------------------------------------------------------------

class _InfoMenuRow extends StatelessWidget {
  const _InfoMenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white30, size: 24),
          ],
        ),
      ),
    );
  }
}
