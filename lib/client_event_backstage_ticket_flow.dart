import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api/auth_service.dart';
import 'client_ticket_service_ui.dart';
import 'gen_l10n/app_localizations.dart';

const Color _kBackstageSurfaceLowest = Color(0xFF0E0E0E);
const Color _kBackstageSurfaceHigh = Color(0xFF2A2A2A);
const Color _kBackstagePrimary = Color(0xFFF2CA50);
const Color _kBackstageTertiary = Color(0xFFCECECE);
const Color _kBackstageOnSurface = Color(0xFFE2E2E2);
const Color _kBackstageOutlineVariant = Color(0xFF4D4635);

const String _kBackstageFont = 'HelveticaNeueCyr';

class ClientBackstageTicketInactiveScreen extends StatefulWidget {
  const ClientBackstageTicketInactiveScreen({
    super.key,
    required this.l10n,
    required this.eventName,
    required this.auth,
    required this.eventId,
    required this.canBuy,
  });

  final AppLocalizations l10n;
  final String eventName;
  final AuthService auth;
  final int eventId;
  final bool canBuy;

  @override
  State<ClientBackstageTicketInactiveScreen> createState() =>
      _ClientBackstageTicketInactiveScreenState();
}

class _ClientBackstageTicketInactiveScreenState
    extends State<ClientBackstageTicketInactiveScreen>
    with WidgetsBindingObserver {
  late bool _canBuy;
  bool _checking = false;
  bool _navigating = false;
  bool _submitting = false;
  MealPaymentStatusPayload? _stripeCheckoutStatus;
  bool _stripeCheckoutActionsBusy = false;

  bool get _stripeCheckoutRecoveryVisible {
    final s = _stripeCheckoutStatus;
    return s != null &&
        (s.canContinuePayment ||
            s.canCancelPayment ||
            s.canStartNewCheckout);
  }

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
      final payload = await widget.auth.getEventBackstageTickets(widget.eventId);
      if (!mounted) return;

      MealPaymentStatusPayload? stripeSt;
      if (!payload.hasActiveTickets && payload.paymentRequired) {
        try {
          stripeSt = await widget.auth.getEventBackstageTicketPaymentStatus(
            widget.eventId,
          );
        } catch (_) {
          stripeSt = null;
        }
      }

      setState(() {
        _canBuy = payload.canBuy;
        _stripeCheckoutStatus = stripeSt;
      });

      if (!mounted) return;
      if (payload.hasActiveTickets) {
        _navigating = true;
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => ClientBackstageTicketActiveScreen(
              eventName: widget.eventName,
              l10n: widget.l10n,
              auth: widget.auth,
              eventId: widget.eventId,
              canBuy: payload.canBuy,
              tickets: payload.tickets,
            ),
          ),
        );
      }
    } catch (_) {
      // Keep silent on passive refresh.
    } finally {
      if (mounted) {
        setState(() => _checking = false);
      }
    }
  }

  Future<void> _continuePendingStripeBackstage() async {
    if (_stripeCheckoutActionsBusy || _checking) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    final l10n = AppLocalizations.of(context)!;
    setState(() => _stripeCheckoutActionsBusy = true);
    try {
      final url = await widget.auth.resumeEventBackstageTicketPayment(
        widget.eventId,
      );
      final uri = Uri.parse(url);
      if (!await canLaunchUrl(uri)) {
        throw Exception('Cannot open checkout');
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!mounted) return;
      messenger?.showSnackBar(
        SnackBar(content: Text(l10n.backstageTicketCheckoutInBrowser)),
      );
    } catch (_) {
      if (!mounted) return;
      messenger?.showSnackBar(
        SnackBar(content: Text(l10n.backstageTicketCheckoutError)),
      );
    } finally {
      if (mounted) {
        setState(() => _stripeCheckoutActionsBusy = false);
      }
    }
    if (mounted) {
      await _refreshAndOpenActiveIfNeeded();
    }
  }

  Future<void> _cancelPendingStripeBackstage() async {
    if (_stripeCheckoutActionsBusy || _checking) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    final l10n = AppLocalizations.of(context)!;
    setState(() => _stripeCheckoutActionsBusy = true);
    try {
      await widget.auth.cancelEventBackstageTicketPayment(widget.eventId);
      if (!mounted) return;
      messenger?.showSnackBar(SnackBar(content: Text(l10n.mealPaymentCanceled)));
    } catch (_) {
      if (!mounted) return;
      messenger?.showSnackBar(
        SnackBar(content: Text(l10n.backstageTicketCheckoutError)),
      );
    } finally {
      if (mounted) {
        setState(() => _stripeCheckoutActionsBusy = false);
      }
    }
    if (mounted) {
      await _refreshAndOpenActiveIfNeeded();
    }
  }

  Future<void> _buyTicket() async {
    if (_submitting || !_canBuy) return;
    setState(() => _submitting = true);
    final l10n = widget.l10n;
    try {
      final checkout = await widget.auth.createBackstageCheckoutSession(
        eventId: widget.eventId,
      );
      if (checkout.purchased) {
        if (!mounted) return;
        await _refreshAndOpenActiveIfNeeded();
        return;
      }

      final url = checkout.checkoutUrl;
      if (url == null || url.isEmpty) {
        throw Exception('No checkout URL in response');
      }
      final uri = Uri.parse(url);
      final ok = await canLaunchUrl(uri);
      if (!ok) {
        throw Exception('Cannot open checkout');
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.backstageTicketCheckoutInBrowser)),
      );
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
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
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
            Positioned.fill(child: CustomPaint(painter: _BackstageAccentPainter())),
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
                        color: _kBackstageTertiary.withValues(alpha: 0.9),
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 132,
                            height: 132,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _kBackstageSurfaceLowest,
                              border: Border.all(
                                color: _kBackstageOutlineVariant.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            child: Icon(
                              Icons.qr_code_2,
                              size: 74,
                              color: _kBackstageTertiary.withValues(alpha: 0.24),
                            ),
                          ),
                          const SizedBox(height: 26),
                          Text(
                            l10n.backstageTicketNoActiveHeadline,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: _kBackstageFont,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: _kBackstageOnSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_stripeCheckoutRecoveryVisible) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.backstageTicketCheckoutInBrowser,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: _kBackstageFont,
                              fontSize: 12,
                              height: 1.45,
                              letterSpacing: 1.4,
                              color: _kBackstageOnSurface.withValues(alpha: 0.78),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              if (_stripeCheckoutStatus!.canContinuePayment)
                                OutlinedButton(
                                  onPressed: (_checking ||
                                          _stripeCheckoutActionsBusy ||
                                          _submitting)
                                      ? null
                                      : _continuePendingStripeBackstage,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: _kBackstagePrimary,
                                    side: const BorderSide(
                                      color: _kBackstagePrimary,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: Text(l10n.mealPaymentContinue),
                                ),
                              if (_stripeCheckoutStatus!.canCancelPayment)
                                TextButton(
                                  onPressed: (_checking ||
                                          _stripeCheckoutActionsBusy ||
                                          _submitting)
                                      ? null
                                      : _cancelPendingStripeBackstage,
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        _kBackstageTertiary.withValues(
                                      alpha: 0.9,
                                    ),
                                  ),
                                  child: Text(l10n.mealPaymentCancel),
                                ),
                              if (_stripeCheckoutStatus!.canStartNewCheckout)
                                FilledButton(
                                  onPressed: (_checking ||
                                          _stripeCheckoutActionsBusy ||
                                          _submitting ||
                                          !_canBuy)
                                      ? null
                                      : _buyTicket,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: _kBackstagePrimary,
                                    foregroundColor: const Color(0xFF3C2F00),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: Text(l10n.mealPaymentStartAgain),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  FilledButton(
                    onPressed: (_canBuy && !_submitting) ? _buyTicket : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: _kBackstagePrimary,
                      foregroundColor: const Color(0xFF3C2F00),
                      minimumSize: const Size.fromHeight(58),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(
                      l10n.backstageTicketBuyCta,
                      style: const TextStyle(
                        fontFamily: _kBackstageFont,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ),
                  if (_checking || _submitting) ...[
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
}

class ClientBackstageTicketActiveScreen extends StatefulWidget {
  const ClientBackstageTicketActiveScreen({
    super.key,
    required this.eventName,
    required this.l10n,
    required this.auth,
    required this.eventId,
    required this.canBuy,
    required this.tickets,
  });

  final String eventName;
  final AppLocalizations l10n;
  final AuthService auth;
  final int eventId;
  final bool canBuy;
  final List<BackstageTicketInfo> tickets;

  @override
  State<ClientBackstageTicketActiveScreen> createState() =>
      _ClientBackstageTicketActiveScreenState();
}

class _ClientBackstageTicketActiveScreenState
    extends State<ClientBackstageTicketActiveScreen> {
  late int _ticketId;
  late List<BackstageTicketInfo> _tickets;

  BackstageTicketInfo _selectedTicketData() {
    for (final ticket in _tickets) {
      if (ticket.id == _ticketId) {
        return ticket;
      }
    }
    return _tickets.first;
  }

  String _localizedTicketLabel(
    AppLocalizations l10n,
    BackstageTicketInfo ticket,
  ) {
    return '${l10n.backstageTicketButton} #${ticket.id}';
  }

  @override
  void initState() {
    super.initState();
    _tickets = List<BackstageTicketInfo>.from(widget.tickets);
    _ticketId = _tickets.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final selected = _selectedTicketData();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _BackstageAccentPainter())),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: _kBackstageOnSurface,
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
                            fontFamily: _kBackstageFont,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _kBackstageOnSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48, height: 48),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.backstageTicketAccessOpen,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: _kBackstageFont,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: _kBackstagePrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_tickets.length > 1) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: _kBackstageSurfaceHigh.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _kBackstageOutlineVariant),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: _ticketId,
                          dropdownColor: _kBackstageSurfaceHigh,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: _kBackstagePrimary,
                          ),
                          style: const TextStyle(
                            color: _kBackstageOnSurface,
                            fontFamily: _kBackstageFont,
                            fontSize: 14,
                          ),
                          items: _tickets
                              .map(
                                (t) => DropdownMenuItem<int>(
                                  value: t.id,
                                  child: Text(
                                    _localizedTicketLabel(l10n, t),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (id) {
                            if (id == null) return;
                            setState(() => _ticketId = id);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.black.withValues(alpha: 0.28),
                          border: Border.all(color: _kBackstagePrimary, width: 2),
                        ),
                        child: QrImageView(
                          data: selected.qrData,
                          version: QrVersions.auto,
                          size: 260,
                          backgroundColor: Colors.white,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Colors.black,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Colors.black,
                          ),
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

class _BackstageAccentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF141414), Colors.black],
      ).createShader(rect);
    canvas.drawRect(rect, bg);

    final center = Offset(size.width * 0.5, size.height * 0.28);
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = _kBackstageOutlineVariant.withValues(alpha: 0.22);
    canvas.drawCircle(center, size.width * 0.30, ring);
    canvas.drawCircle(center, size.width * 0.40, ring);

    final glow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              _kBackstagePrimary.withValues(alpha: 0.16),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(center: center, radius: size.width * 0.32),
          );
    canvas.drawCircle(center, size.width * 0.32, glow);
  }

  @override
  bool shouldRepaint(covariant _BackstageAccentPainter oldDelegate) => false;
}

