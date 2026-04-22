import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import 'api/auth_service.dart';
import 'client_brand_requirements_page.dart';
import 'client_event_chat_rooms_page.dart';
import 'client_event_packing_page.dart';
import 'client_event_meal_sheet.dart';
import 'client_rehearsal_sheet.dart';
import 'gen_l10n/app_localizations.dart';

/// Сколько заказов обеда показать на карточке; при старом API или без счётчика, но с выполненным заказом — ≥1.
int _eventMealOrdersDisplayCount(ActiveAssignment? a) {
  if (a == null) {
    return 0;
  }
  final n = a.eventMealFulfilledOrdersCount;
  if (n > 0) {
    return n;
  }
  if (a.mealPaid || a.mealFulfillmentStatus == 'fulfilled') {
    return 1;
  }
  return 0;
}

/// Цвета «Midnight Runway» / Stitch-референс.
const Color _kSurface = Color(0xFF131313);
const Color _kSurfaceLow = Color(0xFF1B1B1B);
const Color _kSurfaceHigh = Color(0xFF2A2A2A);
const Color _kPrimary = Color(0xFFF2CA50);
const Color _kTertiary = Color(0xFFCECECE);
const Color _kOnSurface = Color(0xFFE2E2E2);

const String _kChatAvatar1Url =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCzpV-9ZfIP9oxtO_LrytxLPjmIt-8QrBB0GiKO8GN7Wqecrq1ndK6xKUR1rqjuTBls4B5JFeCWsZDpep5r6JVH6Lts8fkUu4Z3MMw4NWaiJHVYEBr-mmTyDYcJzorL-2ZneIOYB6Jlk3DfJEiPS0HeAkVX1kZ2DjpH7KS1COwUQsBQwWEunZSVTdAoXHWrvyYXidgd0Adoz8iV9hE3qdOBYJV9MfiOz9OOYgrxgBgKQx0WtgFm82BFV69pAL0uNhj7_Hylx86y3Oo';

const String _kChatAvatar2Url =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCDkz0GAGJxjIKixPoEyKKMQEpSjQwqCbewCZX8t_jkz63WCsW1goz0rJ2hb746RDJxlJOzjga5BcGRld88TEI2_MW5c-7qjIsDghhDS8ITr62tub0vJwn3owI1sGbOJosCoW8ZT9eJd-NZarm6uSbjBKU6RgfcFxrzsXJHYRrKnWofnvmmEySZRuQOT-KIeePo2Yf5mhHZ8uq14ByJdhGo886Z2cQ4utLn_l99yFWMthv1ME5xOX9ZquYAom1p_oFp-8akaagI5Uc';

const double _kCardPad = 20;
const double _kCardGap = 12;
const double _kIconTitleGap = 10;
const double _kTitleSubtitleGap = 6;
const double _kBeforeCtaGap = 14;

bool _l10nLineNotEmpty(String s) => s.trim().isNotEmpty;

/// Порядок: основной бренд → второй → family look; без дубликатов.
List<int> _orderedBrandIdsForAssignment(ActiveAssignment? a) {
  if (a == null) return [];
  final ids = <int>[];
  void add(int? id) {
    final v = id ?? 0;
    if (v > 0 && !ids.contains(v)) ids.add(v);
  }

  add(a.brandId);
  add(a.secondBrandId);
  add(a.familyLookBrandId);
  return ids;
}

BrandRequirementInfo _brandRequirementRowForId(
  int brandId,
  List<BrandRequirementInfo> fromApi,
) {
  for (final i in fromApi) {
    if (i.brandId == brandId) return i;
  }
  return BrandRequirementInfo(
    brandId: brandId,
    brandName: '',
    imageUrl: null,
    bodyHtml: null,
    description: null,
  );
}

void _openMealChoiceSheet(
  BuildContext context, {
  required AuthService auth,
  required List<ChildWithAssignment> childrenInEvent,
  VoidCallback? onMealChoiceSaved,
}) {
  final l10n = AppLocalizations.of(context)!;
  if (childrenInEvent.isEmpty) {
    return;
  }
  final anyMeals = childrenInEvent.any(
    (c) => c.activeAssignment?.eventMeals.isNotEmpty ?? false,
  );
  if (!anyMeals) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.mealNoMealsConfigured)));
    return;
  }
  showClientEventMealSheet(
    context: context,
    auth: auth,
    children: childrenInEvent,
    onSaved: () => onMealChoiceSaved?.call(),
  );
}

/// Настройки активного ивента (макет Stitch / The Couture Canvas).
class ClientEventSettingsPage extends StatefulWidget {
  const ClientEventSettingsPage({
    super.key,
    required this.auth,
    required this.eventName,
    required this.accountName,
    required this.eventId,
    required this.childrenInEvent,

    /// Ребёнок, выбранный на главной (над карточкой ивента); для требований брендов.
    this.contextChildId,
    this.onMealChoiceSaved,
  });

  final AuthService auth;
  final String eventName;
  final String accountName;
  final int eventId;
  final List<ChildWithAssignment> childrenInEvent;
  final int? contextChildId;
  final VoidCallback? onMealChoiceSaved;

  static const String _fontFamily = 'HelveticaNeueCyr';

  @override
  State<ClientEventSettingsPage> createState() =>
      _ClientEventSettingsPageState();
}

class _ClientEventSettingsPageState extends State<ClientEventSettingsPage>
    with WidgetsBindingObserver {
  late List<ChildWithAssignment> _childrenInEvent;

  @override
  void initState() {
    super.initState();
    _childrenInEvent = List<ChildWithAssignment>.from(widget.childrenInEvent);
    WidgetsBinding.instance.addObserver(this);
    // Сразу тянем дашборд, иначе после правок в админке (например, бесплатный обед) пока
    // нет смены фокуса / открытия листа останутся старые counts из parent.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_refreshChildrenFromServer());
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshChildrenFromServer();
    }
  }

  int _totalEventMealFulfilledOrdersInEvent() {
    var n = 0;
    for (final c in _childrenInEvent) {
      n += _eventMealOrdersDisplayCount(c.activeAssignment);
    }
    return n;
  }

  Future<void> _refreshChildrenFromServer() async {
    try {
      final dash = await widget.auth.getClientDashboard();
      if (!mounted) return;
      final filtered = dash.children
          .where((c) => c.activeAssignment?.event.id == widget.eventId)
          .toList();
      setState(() {
        _childrenInEvent = filtered;
      });
    } catch (_) {
      // Тихо при фоновом обновлении (сеть / таймаут).
    }
  }

  void _onMealChoiceSaved() {
    widget.onMealChoiceSaved?.call();
    _refreshChildrenFromServer();
  }

  Future<void> _openMealSheet() async {
    await _refreshChildrenFromServer();
    if (!mounted) return;
    _openMealChoiceSheet(
      context,
      auth: widget.auth,
      childrenInEvent: _childrenInEvent,
      onMealChoiceSaved: _onMealChoiceSaved,
    );
  }

  Future<void> _openRehearsalSheet() async {
    await _refreshChildrenFromServer();
    if (!mounted) return;
    final inEvent = _childrenInEvent
        .where((c) => c.activeAssignment?.event.id == widget.eventId)
        .toList();
    if (inEvent.isEmpty) {
      return;
    }
    final startsAt = inEvent.first.activeAssignment?.event.startsAt;
    await showClientRehearsalSheet(
      context: context,
      auth: widget.auth,
      eventId: widget.eventId,
      eventStartsAt: startsAt,
      childrenInEvent: inEvent,
      onSaved: () {
        _refreshChildrenFromServer();
        widget.onMealChoiceSaved?.call();
      },
    );
  }

  Future<void> _openPackingPage() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final info = await widget.auth.getEventPackingInfo(widget.eventId);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ClientEventPackingPage(
            packing: info,
            baseUrl: widget.auth.baseUrl,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.eventPackingLoadFailed)));
    }
  }

  ChildWithAssignment? _resolveChildForBrands() {
    if (_childrenInEvent.isEmpty) return null;
    final id = widget.contextChildId;
    if (id != null) {
      for (final c in _childrenInEvent) {
        if (c.id == id) return c;
      }
    }
    return _childrenInEvent.first;
  }

  Future<void> _openBrandRequirementsFlow() async {
    final l10n = AppLocalizations.of(context)!;
    if (widget.eventId <= 0) return;

    final child = _resolveChildForBrands();
    if (child == null) return;

    final brandIds = _orderedBrandIdsForAssignment(child.activeAssignment);
    if (brandIds.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.rehearsalBrandNotAssigned)));
      return;
    }

    List<BrandRequirementInfo> apiItems;
    try {
      apiItems = await widget.auth.getEventBrandRequirements(widget.eventId);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.brandRequirementsLoadFailed)));
      return;
    }

    if (!mounted) return;

    final rows = brandIds
        .map((id) => _brandRequirementRowForId(id, apiItems))
        .toList();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: _kSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.brandRequirementsPickBrandTitle,
                  style: const TextStyle(
                    fontFamily: ClientEventSettingsPage._fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _kOnSurface,
                  ),
                ),
                const SizedBox(height: 18),
                for (final row in rows) ...[
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: _kPrimary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      final title = row.brandName.trim().isEmpty
                          ? l10n.brandRequirementsBrandNumber(row.brandId)
                          : row.brandName.trim();
                      Navigator.of(sheetCtx).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ClientBrandRequirementsPage(
                            items: [row],
                            baseUrl: widget.auth.baseUrl,
                            appBarTitle: title,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      row.brandName.trim().isEmpty
                          ? l10n.brandRequirementsBrandNumber(row.brandId)
                          : row.brandName.trim(),
                      style: const TextStyle(
                        fontFamily: ClientEventSettingsPage._fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openChatRoomsPage() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final rooms = await widget.auth.getEventChatRooms(widget.eventId);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              ClientEventChatRoomsPage(auth: widget.auth, rooms: rooms),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.chatRoomsLoadFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: _kSurface,
      appBar: AppBar(
        backgroundColor: _kSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: _kPrimary,
        centerTitle: false,
      ),
      body: DefaultTextStyle.merge(
        style: const TextStyle(
          color: _kOnSurface,
          fontFamily: ClientEventSettingsPage._fontFamily,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleBlock(l10n),
              if (widget.eventName.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  widget.eventName,
                  style: const TextStyle(
                    fontFamily: ClientEventSettingsPage._fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _kTertiary,
                    height: 1.2,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 600;
                  if (wide) {
                    return Column(
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 2,
                                child: _MealCard(
                                  l10n: l10n,
                                  orderedPcs: _totalEventMealFulfilledOrdersInEvent(),
                                  onOpenMealChoice: widget.eventId > 0
                                      ? () {
                                          _openMealSheet();
                                        }
                                      : null,
                                ),
                              ),
                              SizedBox(width: _kCardGap),
                              Expanded(
                                flex: 1,
                                child: _RehearsalCard(
                                  l10n: l10n,
                                  onOpen: widget.eventId > 0
                                      ? _openRehearsalSheet
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: _kCardGap),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 1,
                                child: _PackingCard(
                                  l10n: l10n,
                                  onOpen: widget.eventId > 0
                                      ? _openPackingPage
                                      : null,
                                ),
                              ),
                              SizedBox(width: _kCardGap),
                              Expanded(
                                flex: 2,
                                child: _BrandCard(
                                  l10n: l10n,
                                  onOpen: widget.eventId > 0
                                      ? _openBrandRequirementsFlow
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _MealCard(
                        l10n: l10n,
                        orderedPcs: _totalEventMealFulfilledOrdersInEvent(),
                        onOpenMealChoice: widget.eventId > 0
                            ? () {
                                _openMealSheet();
                              }
                            : null,
                      ),
                      SizedBox(height: _kCardGap),
                      _RehearsalCard(
                        l10n: l10n,
                        onOpen: widget.eventId > 0 ? _openRehearsalSheet : null,
                      ),
                      SizedBox(height: _kCardGap),
                      _PackingCard(
                        l10n: l10n,
                        onOpen: widget.eventId > 0 ? _openPackingPage : null,
                      ),
                      SizedBox(height: _kCardGap),
                      _BrandCard(
                        l10n: l10n,
                        onOpen: widget.eventId > 0
                            ? _openBrandRequirementsFlow
                            : null,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: _kCardGap),
              _ChatCard(
                l10n: l10n,
                onOpen: widget.eventId > 0 ? _openChatRoomsPage : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBlock(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.eventSettingsMainHeadline,
          style: const TextStyle(
            fontFamily: ClientEventSettingsPage._fontFamily,
            fontSize: 30,
            fontWeight: FontWeight.w800,
            height: 1.12,
            letterSpacing: -0.5,
            color: _kOnSurface,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 88,
          height: 3,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [_kPrimary, Colors.transparent]),
          ),
        ),
      ],
    );
  }
}

class _CtaRow extends StatelessWidget {
  const _CtaRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: ClientEventSettingsPage._fontFamily,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
            color: _kPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.arrow_forward, size: 15, color: _kPrimary),
      ],
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({
    required this.l10n,
    this.orderedPcs = 0,
    this.onOpenMealChoice,
  });

  final AppLocalizations l10n;
  final int orderedPcs;
  final VoidCallback? onOpenMealChoice;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: _kSurfaceLow,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: -8,
            right: -8,
            child: Opacity(
              opacity: 0.08,
              child: Icon(Icons.lunch_dining, size: 100, color: _kPrimary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(_kCardPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lunch_dining, size: 36, color: _kPrimary),
                SizedBox(height: _kIconTitleGap),
                Text(
                  l10n.eventSettingsMealTitle,
                  style: const TextStyle(
                    fontFamily: ClientEventSettingsPage._fontFamily,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                    color: _kOnSurface,
                  ),
                ),
                if (_l10nLineNotEmpty(l10n.eventSettingsMealSubtitle)) ...[
                  SizedBox(height: _kTitleSubtitleGap),
                  Text(
                    l10n.eventSettingsMealSubtitle,
                    style: const TextStyle(
                      fontFamily: ClientEventSettingsPage._fontFamily,
                      fontSize: 13,
                      height: 1.3,
                      color: _kTertiary,
                    ),
                  ),
                ],
                SizedBox(height: _kBeforeCtaGap),
                Text(
                  l10n.eventSettingsMealOrderedPcs(orderedPcs),
                  style: const TextStyle(
                    fontFamily: ClientEventSettingsPage._fontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    color: _kTertiary,
                  ),
                ),
                const SizedBox(height: 6),
                _CtaRow(label: l10n.eventSettingsMealCta),
              ],
            ),
          ),
        ],
      ),
    );

    if (onOpenMealChoice == null) {
      return card;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onOpenMealChoice,
        borderRadius: BorderRadius.circular(16),
        splashColor: _kPrimary.withValues(alpha: 0.12),
        child: card,
      ),
    );
  }
}

class _RehearsalCard extends StatelessWidget {
  const _RehearsalCard({required this.l10n, this.onOpen});

  final AppLocalizations l10n;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: _kSurfaceLow,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(_kCardPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.event_available, size: 36, color: _kPrimary),
          SizedBox(height: _kIconTitleGap),
          Text(
            l10n.eventSettingsRehearsalTitle,
            style: const TextStyle(
              fontFamily: ClientEventSettingsPage._fontFamily,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.15,
              color: _kOnSurface,
            ),
          ),
          if (_l10nLineNotEmpty(l10n.eventSettingsRehearsalSubtitle)) ...[
            SizedBox(height: _kTitleSubtitleGap),
            Text(
              l10n.eventSettingsRehearsalSubtitle,
              style: const TextStyle(
                fontFamily: ClientEventSettingsPage._fontFamily,
                fontSize: 13,
                height: 1.3,
                color: _kTertiary,
              ),
            ),
          ],
          SizedBox(height: _kBeforeCtaGap),
          _CtaRow(label: l10n.eventSettingsRehearsalCta),
        ],
      ),
    );
    if (onOpen == null) {
      return card;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(16),
        splashColor: _kPrimary.withValues(alpha: 0.12),
        child: card,
      ),
    );
  }
}

class _PackingCard extends StatelessWidget {
  const _PackingCard({required this.l10n, this.onOpen});

  final AppLocalizations l10n;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: _kSurfaceLow,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(_kCardPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _kPrimary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.work_outline, size: 24, color: _kPrimary),
          ),
          SizedBox(height: _kIconTitleGap),
          Text(
            l10n.eventSettingsPackingTitle,
            style: const TextStyle(
              fontFamily: ClientEventSettingsPage._fontFamily,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.1,
              color: _kOnSurface,
            ),
          ),
          if (_l10nLineNotEmpty(l10n.eventSettingsPackingSubtitle)) ...[
            SizedBox(height: _kTitleSubtitleGap),
            Text(
              l10n.eventSettingsPackingSubtitle,
              style: const TextStyle(
                fontFamily: ClientEventSettingsPage._fontFamily,
                fontSize: 13,
                height: 1.3,
                color: _kTertiary,
              ),
            ),
          ],
          SizedBox(height: _kBeforeCtaGap),
          _CtaRow(label: l10n.eventSettingsPackingCta),
        ],
      ),
    );
    if (onOpen == null) {
      return card;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(16),
        splashColor: _kPrimary.withValues(alpha: 0.12),
        child: card,
      ),
    );
  }
}

class _BrandCard extends StatelessWidget {
  const _BrandCard({required this.l10n, this.onOpen});

  final AppLocalizations l10n;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: _kSurfaceLow,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(_kCardPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, size: 36, color: _kPrimary),
          SizedBox(height: _kIconTitleGap),
          Text(
            l10n.eventSettingsBrandTitle,
            style: const TextStyle(
              fontFamily: ClientEventSettingsPage._fontFamily,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.15,
              color: _kOnSurface,
            ),
          ),
          if (_l10nLineNotEmpty(l10n.eventSettingsBrandSubtitle)) ...[
            SizedBox(height: _kTitleSubtitleGap),
            Text(
              l10n.eventSettingsBrandSubtitle,
              style: const TextStyle(
                fontFamily: ClientEventSettingsPage._fontFamily,
                fontSize: 13,
                height: 1.3,
                color: _kTertiary,
              ),
            ),
          ],
          SizedBox(height: _kBeforeCtaGap),
          _CtaRow(label: l10n.eventSettingsBrandCta),
        ],
      ),
    );
    if (onOpen == null) {
      return card;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(16),
        splashColor: _kPrimary.withValues(alpha: 0.12),
        child: card,
      ),
    );
  }
}

class _ChatCard extends StatelessWidget {
  const _ChatCard({required this.l10n, this.onOpen});

  final AppLocalizations l10n;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: _kSurfaceHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(_kCardPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.chat_bubble_outline, size: 44, color: _kPrimary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.eventSettingsChatTitle,
                      style: const TextStyle(
                        fontFamily: ClientEventSettingsPage._fontFamily,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                        color: _kOnSurface,
                      ),
                    ),
                    if (_l10nLineNotEmpty(l10n.eventSettingsChatSubtitle)) ...[
                      SizedBox(height: _kTitleSubtitleGap),
                      Text(
                        l10n.eventSettingsChatSubtitle,
                        style: const TextStyle(
                          fontFamily: ClientEventSettingsPage._fontFamily,
                          fontSize: 13,
                          height: 1.3,
                          color: _kTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _avatar(_kChatAvatar1Url),
              Transform.translate(
                offset: const Offset(-8, 0),
                child: _avatar(_kChatAvatar2Url),
              ),
              Transform.translate(
                offset: const Offset(-16, 0),
                child: _placeholderPersonAvatar(),
              ),
            ],
          ),
          SizedBox(height: _kBeforeCtaGap),
          _CtaRow(label: l10n.eventSettingsChatCta),
        ],
      ),
    );
    if (onOpen == null) {
      return card;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(16),
        splashColor: _kPrimary.withValues(alpha: 0.12),
        child: card,
      ),
    );
  }

  static Widget _avatar(String url) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _kSurfaceHigh, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Container(color: _kSurfaceLow),
      ),
    );
  }

  /// «Пустой» аватар: силуэт человека.
  static Widget _placeholderPersonAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _kSurfaceLow,
        shape: BoxShape.circle,
        border: Border.all(color: _kSurfaceHigh, width: 2),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.person,
        size: 22,
        color: _kTertiary.withValues(alpha: 0.85),
      ),
    );
  }
}
