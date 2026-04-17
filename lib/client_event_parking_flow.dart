import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api/auth_service.dart';
import 'gen_l10n/app_localizations.dart';

/// «Midnight Runway» — те же токены, что и на странице «Мой ивент».
const Color _kSurfaceLowest = Color(0xFF0E0E0E);
const Color _kSurfaceLow = Color(0xFF1B1B1B);
const Color _kSurfaceHigh = Color(0xFF2A2A2A);
const Color _kPrimary = Color(0xFFF2CA50);
const Color _kTertiary = Color(0xFFCECECE);
const Color _kOnSurface = Color(0xFFE2E2E2);
const Color _kOutlineVariant = Color(0xFF4D4635);

const String _kFont = 'HelveticaNeueCyr';

/// Неактивная парковка (референс 18, без верхней шапки и нижней навигации).
class ClientParkingInactiveScreen extends StatefulWidget {
  const ClientParkingInactiveScreen({
    super.key,
    required this.l10n,
    required this.eventName,
    required this.accountName,
    required this.auth,
    required this.eventId,
    required this.canBuy,
    required this.vipMode,
  });

  final AppLocalizations l10n;
  final String eventName;
  final String accountName;
  final AuthService auth;
  final int eventId;
  final bool canBuy;
  final bool vipMode;

  @override
  State<ClientParkingInactiveScreen> createState() =>
      _ClientParkingInactiveScreenState();
}

class _ClientParkingInactiveScreenState
    extends State<ClientParkingInactiveScreen>
    with WidgetsBindingObserver {
  late bool _canBuy;
  bool _checking = false;
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    _canBuy = widget.canBuy;
    WidgetsBinding.instance.addObserver(this);
    _refreshAndOpenActiveIfNeeded();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshAndOpenActiveIfNeeded();
    }
  }

  Future<void> _refreshAndOpenActiveIfNeeded() async {
    if (_checking || _navigating) return;
    setState(() => _checking = true);

    try {
      final payload = await widget.auth.getEventParkingTickets(widget.eventId);
      if (!mounted) return;

      if (_canBuy != payload.canBuy) {
        setState(() => _canBuy = payload.canBuy);
      }

      if (payload.hasActiveTickets) {
        _navigating = true;
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => ClientParkingActiveScreen(
              eventName: widget.eventName,
              accountName: widget.accountName,
              l10n: widget.l10n,
              auth: widget.auth,
              eventId: widget.eventId,
              canBuy: payload.canBuy,
              vipMode: payload.vipMode,
              entryMapUrl: payload.entryMapUrl,
              entryAppleMapUrl: payload.entryAppleMapUrl,
              tickets: payload.tickets,
            ),
          ),
        );
      }
    } catch (_) {
      // Silent refresh; user already sees inactive state.
    } finally {
      if (mounted) {
        setState(() => _checking = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _RunwayAccentPainter()),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: _kTertiary.withValues(alpha: 0.9),
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: FractionalTranslation(
                          translation: const Offset(0, -0.2),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              _glowBlob(),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 220,
                                        height: 220,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: _kOutlineVariant.withValues(
                                              alpha: 0.12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 180,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: _kOutlineVariant.withValues(
                                              alpha: 0.08,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 148,
                                        height: 148,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _kSurfaceLowest,
                                          border: Border.all(
                                            color: _kOutlineVariant.withValues(
                                              alpha: 0.2,
                                            ),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.45,
                                              ),
                                              blurRadius: 24,
                                              offset: const Offset(0, 12),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.local_parking,
                                          size: 84,
                                          color: _kTertiary.withValues(
                                            alpha: 0.22,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 28),
                                  Text(
                                    l10n.parkingInactiveHeadline,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'serif',
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      height: 1.05,
                                      letterSpacing: -0.5,
                                      color: _kTertiary.withValues(alpha: 0.45),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Container(
                                    width: 48,
                                    height: 1,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          _kPrimary.withValues(alpha: 0.25),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    widget.vipMode
                                        ? l10n.parkingInactiveVipBody
                                        : l10n.parkingInactiveBody,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: _kFont,
                                      fontSize: 12,
                                      height: 1.55,
                                      letterSpacing: 2.1,
                                      color: _kTertiary.withValues(alpha: 0.35),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _canBuy
                        ? () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => ClientParkingCreateTicketScreen(
                                  eventName: widget.eventName,
                                  accountName: widget.accountName,
                                  l10n: l10n,
                                  auth: widget.auth,
                                  eventId: widget.eventId,
                                  vipMode: widget.vipMode,
                                ),
                              ),
                            );
                            if (!mounted) return;
                            await _refreshAndOpenActiveIfNeeded();
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: _kPrimary,
                      foregroundColor: const Color(0xFF3C2F00),
                      minimumSize: const Size.fromHeight(58),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(
                      widget.vipMode
                          ? l10n.parkingInactiveVipBookCta
                          : l10n.parkingInactiveBuyCta,
                      style: const TextStyle(
                        fontFamily: _kFont,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ),
                  if (_checking) ...[
                    const SizedBox(height: 10),
                    const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glowBlob() {
    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Center(
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _kPrimary.withValues(alpha: 0.05),
            ),
          ),
        ),
      ),
    );
  }
}

class ClientParkingCreateTicketScreen extends StatefulWidget {
  const ClientParkingCreateTicketScreen({
    super.key,
    required this.eventName,
    required this.accountName,
    required this.l10n,
    required this.auth,
    required this.eventId,
    required this.vipMode,
  });

  final String eventName;
  final String accountName;
  final AppLocalizations l10n;
  final AuthService auth;
  final int eventId;
  final bool vipMode;

  @override
  State<ClientParkingCreateTicketScreen> createState() =>
      _ClientParkingCreateTicketScreenState();
}

class _ClientParkingCreateTicketScreenState
    extends State<ClientParkingCreateTicketScreen> {
  final _carController = TextEditingController();
  final _plateController = TextEditingController();
  final _plateRepeatController = TextEditingController();
  bool _submitting = false;

  bool get _isPlateMismatch {
    final first = _plateController.text.trim().toUpperCase();
    final second = _plateRepeatController.text.trim().toUpperCase();
    return second.isNotEmpty && first != second;
  }

  bool get _canBuy {
    final hasCar = _carController.text.trim().isNotEmpty;
    final hasPlate = _plateController.text.trim().isNotEmpty;
    final hasRepeat = _plateRepeatController.text.trim().isNotEmpty;
    return hasCar && hasPlate && hasRepeat && !_isPlateMismatch;
  }

  @override
  void dispose() {
    _carController.dispose();
    _plateController.dispose();
    _plateRepeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;

    InputDecoration fieldDecoration(String hint) {
      return InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: _kTertiary.withValues(alpha: 0.55),
          fontFamily: _kFont,
          fontSize: 14,
        ),
        filled: true,
        fillColor: _kSurfaceHigh.withValues(alpha: 0.7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: _kOutlineVariant.withValues(alpha: 0.4),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: _kPrimary.withValues(alpha: 0.75)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: _kOnSurface,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      l10n.parkingCreateTicketTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: _kOnSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48, height: 48),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                '${l10n.parkingCreateEventLabel}: ${widget.eventName.trim().isEmpty ? '—' : widget.eventName}',
                style: TextStyle(
                  fontFamily: _kFont,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _kOnSurface.withValues(alpha: 0.92),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${l10n.parkingCreateAccountNameLabel}: ${widget.accountName.trim().isEmpty ? '—' : widget.accountName}',
                style: TextStyle(
                  fontFamily: _kFont,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _kOnSurface.withValues(alpha: 0.92),
                ),
              ),
              const SizedBox(height: 22),
              if (widget.vipMode) ...[
                Text(
                  l10n.parkingInactiveVipBody,
                  style: TextStyle(
                    fontFamily: _kFont,
                    fontSize: 12,
                    height: 1.45,
                    letterSpacing: 1.6,
                    color: _kTertiary.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                l10n.parkingCreateCarModelLabel,
                style: TextStyle(
                  fontFamily: _kFont,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.2,
                  color: _kPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _carController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(
                  color: _kOnSurface,
                  fontFamily: _kFont,
                  fontSize: 15,
                ),
                decoration: fieldDecoration(l10n.parkingCreateCarModelHint),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.parkingCreatePlateNumberLabel,
                style: TextStyle(
                  fontFamily: _kFont,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.2,
                  color: _kPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _plateController,
                textCapitalization: TextCapitalization.characters,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(
                  color: _kOnSurface,
                  fontFamily: _kFont,
                  fontSize: 15,
                ),
                decoration: fieldDecoration(l10n.parkingCreatePlateNumberHint),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.parkingCreateRepeatPlateNumberLabel,
                style: TextStyle(
                  fontFamily: _kFont,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.2,
                  color: _kPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _plateRepeatController,
                textCapitalization: TextCapitalization.characters,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(
                  color: _kOnSurface,
                  fontFamily: _kFont,
                  fontSize: 15,
                ),
                decoration: fieldDecoration(
                  l10n.parkingCreateRepeatPlateNumberHint,
                ),
              ),
              if (_isPlateMismatch) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.parkingCreatePlateNumberMismatch,
                    style: const TextStyle(
                      fontFamily: _kFont,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF7A7A),
                    ),
                  ),
                ),
              ],
              const Spacer(),
              FilledButton(
                onPressed: (_canBuy && !_submitting)
                    ? () async {
                        final messenger = ScaffoldMessenger.of(context);
                        setState(() => _submitting = true);
                        try {
                          final url = await widget.auth
                              .createParkingCheckoutSession(
                                eventId: widget.eventId,
                                carModel: _carController.text,
                                plateNumber: _plateController.text,
                                plateNumberRepeat: _plateRepeatController.text,
                              );
                          if (url.purchased) {
                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  widget.vipMode
                                      ? l10n.parkingVipBooked
                                      : l10n.parkingPurchasedWithoutPayment,
                                ),
                              ),
                            );
                            return;
                          }
                          final checkoutUrl = url.checkoutUrl;
                          if (checkoutUrl == null || checkoutUrl.isEmpty) {
                            throw Exception('No checkout URL in response');
                          }
                          final uri = Uri.parse(checkoutUrl);
                          final ok = await canLaunchUrl(uri);
                          if (!ok) {
                            throw Exception('Cannot open checkout');
                          }
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(l10n.parkingCheckoutInBrowser),
                            ),
                          );
                        } catch (_) {
                          if (!context.mounted) return;
                          messenger.showSnackBar(
                            SnackBar(content: Text(l10n.parkingCheckoutError)),
                          );
                        } finally {
                          if (mounted) {
                            setState(() => _submitting = false);
                          }
                        }
                      }
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: _kPrimary,
                  foregroundColor: const Color(0xFF3C2F00),
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  widget.vipMode
                      ? l10n.parkingInactiveVipBookCta
                      : l10n.parkingCreateBuyCta,
                  style: const TextStyle(
                    fontFamily: _kFont,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Активная парковка (референс 19 + макет: ивент, билет, P, подписи, один код).
class ClientParkingActiveScreen extends StatefulWidget {
  const ClientParkingActiveScreen({
    super.key,
    required this.eventName,
    required this.accountName,
    required this.l10n,
    required this.auth,
    required this.eventId,
    required this.canBuy,
    required this.vipMode,
    required this.entryMapUrl,
    required this.entryAppleMapUrl,
    required this.tickets,
  });

  final String eventName;
  final String accountName;
  final AppLocalizations l10n;
  final AuthService auth;
  final int eventId;
  final bool canBuy;
  final bool vipMode;
  final String? entryMapUrl;
  final String? entryAppleMapUrl;
  final List<ParkingTicketInfo> tickets;

  @override
  State<ClientParkingActiveScreen> createState() =>
      _ClientParkingActiveScreenState();
}

class _ClientParkingActiveScreenState extends State<ClientParkingActiveScreen> {
  late int _ticketId;
  late List<ParkingTicketInfo> _tickets;
  late bool _canBuy;
  late bool _vipMode;
  late String? _entryMapUrl;
  late String? _entryAppleMapUrl;

  ParkingTicketInfo _selectedTicketData() {
    for (final ticket in _tickets) {
      if (ticket.id == _ticketId) {
        return ticket;
      }
    }
    return _tickets.first;
  }

  String _selectedTicketLabel() {
    return _selectedTicketData().label;
  }

  @override
  void initState() {
    super.initState();
    _tickets = List<ParkingTicketInfo>.from(widget.tickets);
    _canBuy = widget.canBuy;
    _vipMode = widget.vipMode;
    _entryMapUrl = widget.entryMapUrl;
    _entryAppleMapUrl = widget.entryAppleMapUrl;
    _ticketId = _tickets.first.id;
  }

  Future<void> _openCreateTicket() async {
    if (!_canBuy) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ClientParkingCreateTicketScreen(
          eventName: widget.eventName,
          accountName: widget.accountName,
          l10n: widget.l10n,
          auth: widget.auth,
          eventId: widget.eventId,
          vipMode: _vipMode,
        ),
      ),
    );
    if (!mounted) return;
    try {
      final payload = await widget.auth.getEventParkingTickets(widget.eventId);
      if (!mounted || payload.tickets.isEmpty) return;
      setState(() {
        _tickets = payload.tickets;
        _canBuy = payload.canBuy;
        _vipMode = payload.vipMode;
        _entryMapUrl = payload.entryMapUrl;
        _entryAppleMapUrl = payload.entryAppleMapUrl;
        final selectedStillExists = _tickets.any((t) => t.id == _ticketId);
        if (!selectedStillExists) {
          _ticketId = _tickets.first.id;
        }
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(widget.l10n.parkingCheckoutError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final selectedTicket = _selectedTicketData();
    final isIos = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    final preferredMapUrl = isIos
        ? ((_entryAppleMapUrl ?? '').trim().isNotEmpty
              ? _entryAppleMapUrl
              : _entryMapUrl)
        : ((_entryMapUrl ?? '').trim().isNotEmpty
              ? _entryMapUrl
              : _entryAppleMapUrl);
    final hasEntryMapUrl = (preferredMapUrl ?? '').trim().isNotEmpty;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _RunwayAccentPainter())),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _kPrimary.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: _kOnSurface,
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.eventName.trim().isEmpty
                              ? '—'
                              : widget.eventName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: _kOnSurface,
                            height: 1.05,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48, height: 48),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                  child: FilledButton(
                    onPressed: _canBuy ? _openCreateTicket : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: _kPrimary,
                      foregroundColor: const Color(0xFF3C2F00),
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(
                      _vipMode
                          ? l10n.parkingInactiveVipBookCta
                          : l10n.parkingInactiveBuyCta,
                      style: const TextStyle(
                        fontFamily: _kFont,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    l10n.parkingActiveTicketLabel,
                                    style: TextStyle(
                                      fontFamily: _kFont,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.6,
                                      color: _kTertiary.withValues(alpha: 0.75),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                LayoutBuilder(
                                  builder: (context, menuBox) => DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: _kSurfaceHigh.withValues(
                                        alpha: 0.65,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: _kOutlineVariant.withValues(
                                          alpha: 0.35,
                                        ),
                                      ),
                                    ),
                                    child: PopupMenuButton<String>(
                                      initialValue: '$_ticketId',
                                      onSelected: (v) => setState(
                                        () => _ticketId =
                                            int.tryParse(v) ?? _ticketId,
                                      ),
                                      color: _kSurfaceLow,
                                      elevation: 8,
                                      offset: const Offset(0, 52),
                                      constraints: BoxConstraints(
                                        minWidth: menuBox.maxWidth,
                                        maxWidth: menuBox.maxWidth,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        side: BorderSide(
                                          color: _kOutlineVariant.withValues(
                                            alpha: 0.45,
                                          ),
                                        ),
                                      ),
                                      itemBuilder: (context) => [
                                        for (final ticket in _tickets)
                                          PopupMenuItem<String>(
                                            value: '${ticket.id}',
                                            height: 42,
                                            child: Text(
                                              ticket.label,
                                              style: const TextStyle(
                                                fontFamily: _kFont,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: _kOnSurface,
                                              ),
                                            ),
                                          ),
                                      ],
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _selectedTicketLabel(),
                                                style: const TextStyle(
                                                  fontFamily: _kFont,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: _kOnSurface,
                                                ),
                                              ),
                                            ),
                                            const Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: _kPrimary,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 34),
                                SizedBox(
                                  width: 236,
                                  height: 236,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: _kPrimary,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _kPrimary.withValues(
                                            alpha: 0.28,
                                          ),
                                          blurRadius: 24,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: QrImageView(
                                        data: selectedTicket.qrData,
                                        backgroundColor: Colors.white,
                                        eyeStyle: const QrEyeStyle(
                                          eyeShape: QrEyeShape.square,
                                          color: Colors.black,
                                        ),
                                        dataModuleStyle:
                                            const QrDataModuleStyle(
                                              dataModuleShape:
                                                  QrDataModuleShape.square,
                                              color: Colors.black,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 26),
                                Text(
                                  l10n.parkingActiveValetLabel,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: _kFont,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 3.2,
                                    color: _kPrimary,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  l10n.parkingActiveStatusLine,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'serif',
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    height: 0.98,
                                    letterSpacing: -0.8,
                                    color: _kOnSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 42),
                        if (hasEntryMapUrl) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () async {
                                final url = (preferredMapUrl ?? '').trim();
                                if (url.isEmpty) return;
                                try {
                                  final uri = Uri.parse(url);
                                  final ok = await canLaunchUrl(uri);
                                  if (!ok) {
                                    throw Exception('Cannot open maps link');
                                  }
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                } catch (_) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.parkingCheckoutError),
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 4,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.map_outlined,
                                      size: 18,
                                      color: _kPrimary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.parkingActiveShowEntryPointCta,
                                      style: const TextStyle(
                                        fontFamily: _kFont,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.1,
                                        color: _kPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            l10n.parkingActiveCarLabel,
                            style: TextStyle(
                              fontFamily: _kFont,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.8,
                              color: _kPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: _kSurfaceHigh.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _kOutlineVariant.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            selectedTicket.carModel,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: _kFont,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.4,
                              color: _kOnSurface,
                              height: 1.1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            l10n.parkingActiveRegistrationNumberLabel,
                            style: TextStyle(
                              fontFamily: _kFont,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.8,
                              color: _kPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: _kSurfaceHigh.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _kOutlineVariant.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            selectedTicket.plateNumber,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: _kFont,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 3.2,
                              color: _kOnSurface,
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
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

class _RunwayAccentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final left = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          _kPrimary.withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, size.height * 0.35, 4, 96));

    canvas.drawRect(Rect.fromLTWH(0, size.height * 0.35, 4, 96), left);

    final right = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          _kPrimary.withValues(alpha: 0.04),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(size.width - 4, size.height * 0.22, 4, 128));

    canvas.drawRect(
      Rect.fromLTWH(size.width - 4, size.height * 0.22, 4, 128),
      right,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
