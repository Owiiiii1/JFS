import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api/auth_service.dart';
import 'client_ticket_service_ui.dart';
import 'client_event_backstage_ticket_flow.dart';
import 'client_event_extra_ticket_flow.dart';
import 'client_ticket_pdf_page.dart';
import 'gen_l10n/app_localizations.dart';

const _kGold = Color(0xFFD4AF37);
const _kBg = Color(0xFF050505);
const _kCard = Color(0xFF1A1A1A);

/// Модальное окно «Мои билеты»: выбор ивента, список билетов, кнопка покупки.
Future<void> showMyTicketsSheet(
  BuildContext context, {
  required AuthService auth,

  /// Покупка билета только если клиент записан хотя бы на один активный ивент.
  required bool canPurchaseTickets,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) =>
        _MyTicketsSheet(auth: auth, canPurchaseTickets: canPurchaseTickets),
  );
}

class _MyTicketsSheet extends StatefulWidget {
  const _MyTicketsSheet({required this.auth, required this.canPurchaseTickets});

  final AuthService auth;
  final bool canPurchaseTickets;

  @override
  State<_MyTicketsSheet> createState() => _MyTicketsSheetState();
}

class _MyTicketsSheetState extends State<_MyTicketsSheet> {
  String? _buyUrlFromSettings;

  List<ClientTicketEventRef>? _events;
  String? _eventsError;
  bool _eventsLoading = true;

  int? _selectedEventId;
  List<ClientTicketItem>? _tickets;
  String? _ticketsError;
  bool _ticketsLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEvents();
    widget.auth
        .getInfoSettings()
        .then((s) {
          if (!mounted) return;
          setState(() => _buyUrlFromSettings = s.websiteUrl);
        })
        .catchError((_) {});
  }

  /// Сначала ссылка выбранного ивента из API, иначе сайт из раздела Info.
  String? get _effectiveBuyUrl {
    final sel = _selectedEventId;
    if (sel != null && _events != null) {
      for (final e in _events!) {
        if (e.id == sel) {
          final u = e.ticketStoreUrl;
          if (u != null && u.isNotEmpty) return u;
          break;
        }
      }
    }
    final f = _buyUrlFromSettings;
    if (f != null && f.isNotEmpty) return f;
    return null;
  }

  String? get _selectedEventName {
    final sel = _selectedEventId;
    if (sel == null || _events == null) return null;
    for (final e in _events!) {
      if (e.id == sel) {
        final name = e.name.trim();
        return name.isEmpty ? null : name;
      }
    }
    return null;
  }

  ClientTicketEventRef? _selectedEventRef() {
    final sel = _selectedEventId;
    final evs = _events;
    if (sel == null || evs == null) return null;
    for (final e in evs) {
      if (e.id == sel) return e;
    }
    return null;
  }

  Future<void> _loadEvents() async {
    setState(() {
      _eventsLoading = true;
      _eventsError = null;
    });
    try {
      final list = await widget.auth.getClientTicketEvents();
      if (!mounted) return;
      setState(() {
        _events = list;
        _eventsLoading = false;
        if (list.length == 1) {
          _selectedEventId = list.first.id;
          _loadTickets(list.first.id);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _eventsError = e.toString();
        _eventsLoading = false;
      });
    }
  }

  Future<void> _loadTickets(int eventId) async {
    setState(() {
      _ticketsLoading = true;
      _ticketsError = null;
      _tickets = null;
    });
    try {
      final list = await widget.auth.getClientEventTickets(eventId);
      if (!mounted) return;
      setState(() {
        _tickets = list;
        _ticketsLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _ticketsError = e.toString();
        _ticketsLoading = false;
      });
    }
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '—';
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd.$mm.${d.year}';
  }

  Future<void> _openPdf(String url) async {
    if (!mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (ctx) => ClientTicketPdfPage(auth: widget.auth, pdfUrl: url),
      ),
    );
  }

  /// Добавляет https:// если админ ввёл домен без схемы.
  String? _normalizeBuyUrl(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return null;
    if (t.startsWith('http://') || t.startsWith('https://')) return t;
    return 'https://$t';
  }

  Future<void> _openBuyUrl() async {
    final l10n = AppLocalizations.of(context)!;
    final raw = _effectiveBuyUrl;
    if (raw == null || raw.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.ticketsBuyNoLink)));
      return;
    }
    final normalized = _normalizeBuyUrl(raw);
    if (normalized == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.ticketsBuyCouldNotOpen)));
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

  Future<void> _openExtraTicketFlow() async {
    final l10n = AppLocalizations.of(context)!;
    final eventId = _selectedEventId;
    if (eventId == null || eventId <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.extraTicketSelectEventFirst)));
      return;
    }

    final eventName = _selectedEventName ?? '—';
    final evRef = _selectedEventRef();
    if (evRef != null &&
        shouldBlockClientTicketPrefetch(
          serviceEnabled: evRef.clientExtraTicketsServiceEnabled,
          userHasTicket: evRef.userHasExtraTicket,
        )) {
      await showClientTicketServiceUnavailableDialog(context, l10n);
      return;
    }
    try {
      final payload = await widget.auth.getEventExtraTickets(eventId);
      if (!mounted) return;
      final page = payload.hasActiveTickets
          ? ClientExtraTicketActiveScreen(
              eventName: eventName,
              l10n: l10n,
              auth: widget.auth,
              eventId: eventId,
              canBuy: payload.canBuy,
              tickets: payload.tickets,
            )
          : ClientExtraTicketInactiveScreen(
              l10n: l10n,
              eventName: eventName,
              auth: widget.auth,
              eventId: eventId,
              canBuy: payload.canBuy,
            );

      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => page));
    } on ApiServiceDisabledException catch (e) {
      if (!mounted) return;
      await showClientTicketServiceUnavailableDialog(context, l10n, message: e.message);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.extraTicketCheckoutError)));
    }
  }

  Future<void> _openBackstageTicketFlow() async {
    final l10n = AppLocalizations.of(context)!;
    final eventId = _selectedEventId;
    if (eventId == null || eventId <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.backstageTicketSelectEventFirst)),
      );
      return;
    }

    final eventName = _selectedEventName ?? '—';
    final evRef = _selectedEventRef();
    if (evRef != null &&
        shouldBlockClientTicketPrefetch(
          serviceEnabled: evRef.clientBackstageTicketsServiceEnabled,
          userHasTicket: evRef.userHasBackstageTicket,
        )) {
      await showClientTicketServiceUnavailableDialog(context, l10n);
      return;
    }
    try {
      final payload = await widget.auth.getEventBackstageTickets(eventId);
      if (!mounted) return;
      final page = payload.hasActiveTickets
          ? ClientBackstageTicketActiveScreen(
              eventName: eventName,
              l10n: l10n,
              auth: widget.auth,
              eventId: eventId,
              canBuy: payload.canBuy,
              tickets: payload.tickets,
            )
          : ClientBackstageTicketInactiveScreen(
              l10n: l10n,
              eventName: eventName,
              auth: widget.auth,
              eventId: eventId,
              canBuy: payload.canBuy,
            );

      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => page));
    } on ApiServiceDisabledException catch (e) {
      if (!mounted) return;
      await showClientTicketServiceUnavailableDialog(context, l10n, message: e.message);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.backstageTicketCheckoutError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final h = MediaQuery.sizeOf(context).height * 0.92;

    return Container(
      height: h,
      decoration: const BoxDecoration(
        color: _kBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        l10n.myTicketsTitle,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontFamily: 'HelveticaNeueCyr',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.selectEventForTickets.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_eventsLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: CircularProgressIndicator(color: _kGold),
                      ),
                    )
                  else if (_eventsError != null)
                    Text(
                      l10n.ticketsEventsLoadError,
                      style: const TextStyle(color: Colors.redAccent),
                    )
                  else if (_events == null || _events!.isEmpty)
                    Text(
                      l10n.ticketsNoEvents,
                      style: TextStyle(color: Colors.grey[500]),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: _kCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2A2A2A)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          dropdownColor: _kCard,
                          icon: const Icon(Icons.expand_more, color: _kGold),
                          value: _selectedEventId,
                          hint: Text(
                            l10n.selectEventForTickets,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          items: _events!
                              .map(
                                (e) => DropdownMenuItem<int>(
                                  value: e.id,
                                  child: Text(
                                    e.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (id) {
                            if (id == null) return;
                            setState(() => _selectedEventId = id);
                            _loadTickets(id);
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: _selectedEventId == null
                  ? const SizedBox.shrink()
                  : _ticketsLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: _kGold),
                    )
                  : _ticketsError != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          l10n.ticketsLoadError,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    )
                  : _tickets == null || _tickets!.isEmpty
                  ? Center(
                      child: Text(
                        l10n.ticketsNoneForEvent,
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: _tickets!.length,
                      itemBuilder: (context, i) {
                        final t = _tickets![i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _TicketCard(
                            dateLabel: l10n.ticketsEventDate,
                            dateText: _formatDate(t.eventStartsAt),
                            parentLabel: l10n.ticketsMomName,
                            parentName: t.parentName.isEmpty
                                ? '—'
                                : t.parentName,
                            openLabel: t.pdfAvailable
                                ? l10n.ticketsOpenPdf
                                : l10n.ticketsPdfUnavailable,
                            openEnabled: t.pdfAvailable && t.pdfUrl != null,
                            onOpen: t.pdfAvailable && t.pdfUrl != null
                                ? () => _openPdf(t.pdfUrl!)
                                : null,
                          ),
                        );
                      },
                    ),
            ),
            if (widget.canPurchaseTickets)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFD4AF37),
                            Color(0xFFF5E6AD),
                            Color(0xFFB8860B),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFFBBF24,
                            ).withValues(alpha: 0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _openBuyUrl,
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.confirmation_number_outlined,
                                  color: Colors.black87,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  l10n.ticketsBuy,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.5,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _openExtraTicketFlow,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: _kGold,
                          side: const BorderSide(color: _kGold),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: _kGold,
                          size: 20,
                        ),
                        label: Text(
                          l10n.extraTicketButton,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _openBackstageTicketFlow,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: _kGold,
                          side: const BorderSide(color: _kGold),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(
                          Icons.workspace_premium_outlined,
                          color: _kGold,
                          size: 20,
                        ),
                        label: Text(
                          l10n.backstageTicketButton,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
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

class _TicketCard extends StatelessWidget {
  const _TicketCard({
    required this.dateLabel,
    required this.dateText,
    required this.parentLabel,
    required this.parentName,
    required this.openLabel,
    required this.openEnabled,
    this.onOpen,
  });

  final String dateLabel;
  final String dateText;
  final String parentLabel;
  final String parentName;
  final String openLabel;
  final bool openEnabled;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF121212).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: openEnabled
              ? const Color(0xFF3D3D3D)
              : const Color(0xFF2A2A2A),
        ),
      ),
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
                      dateLabel.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.5,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            parentLabel.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 1.5,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            parentName,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: openEnabled ? onOpen : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: openEnabled ? _kGold : Colors.grey[600],
                side: BorderSide(
                  color: openEnabled ? _kGold : Colors.grey[700]!,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(
                Icons.description_outlined,
                size: 20,
                color: openEnabled ? _kGold : Colors.grey[600],
              ),
              label: Text(
                openLabel.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
