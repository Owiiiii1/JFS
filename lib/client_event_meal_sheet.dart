import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api/auth_service.dart';
import 'gen_l10n/app_localizations.dart';

const Color _kGold = Color(0xFFD4AF37);
const Color _kSurface = Color(0xFF131313);
const Color _kOnSurface = Color(0xFFE2E2E2);
const Color _kTertiary = Color(0xFFCECECE);

/// Полноэкранная страница: выбор ребёнка (если несколько) и блюда для назначения на ивент.
Future<void> showClientEventMealSheet({
  required BuildContext context,
  required AuthService auth,
  required List<ChildWithAssignment> children,
  required VoidCallback onSaved,
}) async {
  final usable = children.where((c) => c.activeAssignment != null).toList();
  if (usable.isEmpty) {
    return;
  }
  await Navigator.of(context, rootNavigator: true).push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (ctx) => _ClientEventMealSheetBody(
        auth: auth,
        children: usable,
        onSaved: onSaved,
      ),
    ),
  );
}

class _ClientEventMealSheetBody extends StatefulWidget {
  const _ClientEventMealSheetBody({
    required this.auth,
    required this.children,
    required this.onSaved,
  });

  final AuthService auth;
  final List<ChildWithAssignment> children;
  final VoidCallback onSaved;

  @override
  State<_ClientEventMealSheetBody> createState() =>
      _ClientEventMealSheetBodyState();
}

class _ClientEventMealSheetBodyState extends State<_ClientEventMealSheetBody> {
  late int _childIndex;
  int? _mealId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _childIndex = 0;
    _mealId = widget.children[0].activeAssignment?.selectedEventMealId;
  }

  ChildWithAssignment get _current => widget.children[_childIndex];

  List<EventMealOption> get _meals =>
      _current.activeAssignment?.eventMeals ?? [];

  void _onChildChanged(int index) {
    setState(() {
      _childIndex = index;
      _mealId = widget.children[index].activeAssignment?.selectedEventMealId;
    });
  }

  String? _formatMealPrice(double? value, Locale locale) {
    if (value == null) {
      return null;
    }
    try {
      final formatted = NumberFormat.decimalPatternDigits(
        locale: locale.toLanguageTag(),
        decimalDigits: 2,
      ).format(value);
      return '\$$formatted';
    } catch (_) {
      return '\$${value.toStringAsFixed(2)}';
    }
  }

  Widget _selectableRow({
    required bool selected,
    required String label,
    required VoidCallback? onTap,
    bool enabled = true,
    String? trailingPrice,
  }) {
    final lockedChoice = !enabled && selected;
    final mutedDisabled = !enabled && !selected;

    late final Color bg;
    if (mutedDisabled) {
      bg = const Color(0xFF252525);
    } else if (selected) {
      bg = lockedChoice ? _kGold.withValues(alpha: 0.78) : _kGold;
    } else {
      bg = const Color(0xFF1B1B1B);
    }

    final hasPrice = trailingPrice != null && trailingPrice.isNotEmpty;
    final nameAlign = hasPrice || lockedChoice
        ? TextAlign.start
        : TextAlign.center;

    final Color priceColor;
    if (mutedDisabled) {
      priceColor = _kTertiary;
    } else if (lockedChoice) {
      priceColor = Colors.black.withValues(alpha: 0.82);
    } else if (selected) {
      priceColor = Colors.black.withValues(alpha: 0.78);
    } else {
      priceColor = _kTertiary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: lockedChoice
                  ? Border.all(
                      color: Colors.black.withValues(alpha: 0.35),
                      width: 2,
                    )
                  : null,
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                if (lockedChoice) ...[
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.black.withValues(alpha: 0.55),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    label,
                    textAlign: nameAlign,
                    style: TextStyle(
                      color: mutedDisabled
                          ? _kTertiary
                          : (selected ? Colors.black : _kOnSurface),
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
                if (hasPrice) ...[
                  const SizedBox(width: 12),
                  Text(
                    trailingPrice,
                    style: TextStyle(
                      color: priceColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _mealHeroCard({
    required EventMealOption meal,
    required String label,
    required String? priceText,
    required bool selected,
    required bool enabled,
    required VoidCallback? onTap,
  }) {
    final lockedChoice = !enabled && selected;
    final mutedDisabled = !enabled && !selected;
    final opacity = mutedDisabled ? 0.48 : 1.0;

    final borderColor = selected
        ? (lockedChoice ? _kGold.withValues(alpha: 0.65) : _kGold)
        : Colors.white.withValues(alpha: 0.08);
    final borderWidth = selected ? 2.5 : 1.0;

    final imageUrl = meal.imageUrl?.trim();
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    Widget background() {
      if (hasImage) {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Container(
              color: const Color(0xFF1E1E1E),
              alignment: Alignment.center,
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _kGold.withValues(alpha: 0.7),
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (_, _, _) => Container(
            color: const Color(0xFF242424),
            alignment: Alignment.center,
            child: Icon(
              Icons.restaurant_rounded,
              size: 56,
              color: _kTertiary.withValues(alpha: 0.35),
            ),
          ),
        );
      }
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2C2C2C), Color(0xFF141414)],
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.restaurant_rounded,
          size: 64,
          color: _kTertiary.withValues(alpha: 0.22),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Opacity(
        opacity: opacity,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor, width: borderWidth),
                  boxShadow: selected && !lockedChoice
                      ? [
                          BoxShadow(
                            color: _kGold.withValues(alpha: 0.22),
                            blurRadius: 14,
                            spreadRadius: 0,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(child: background()),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.78),
                                Colors.black.withValues(alpha: 0.28),
                                Colors.black.withValues(alpha: 0.06),
                              ],
                              stops: const [0.0, 0.48, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            16,
                            14,
                            lockedChoice ? 52 : 16,
                            8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  label,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black54,
                                        blurRadius: 8,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (priceText != null &&
                                  priceText.trim().isNotEmpty) ...[
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    priceText.trim(),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: _kGold.withValues(alpha: 0.95),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontFeatures: const [
                                        FontFeature.tabularFigures(),
                                      ],
                                      shadows: const [
                                        Shadow(
                                          color: Colors.black87,
                                          blurRadius: 6,
                                          offset: Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (lockedChoice)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              shape: BoxShape.circle,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: _kGold,
                                size: 26,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitOrder() async {
    final a = _current.activeAssignment;
    if (a == null || _mealId == null) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final meals = _meals;
    EventMealOption? meal;
    for (final m in meals) {
      if (m.id == _mealId) {
        meal = m;
        break;
      }
    }
    if (meal == null) {
      return;
    }
    setState(() => _saving = true);
    try {
      await widget.auth.updateClientAssignmentMeal(
        assignmentId: a.id,
        eventMealId: _mealId,
      );
      final needsStripe = meal.price != null && meal.price! > 0 && !a.mealPaid;
      if (needsStripe) {
        final url = await widget.auth.createMealCheckoutSession(
          assignmentId: a.id,
          eventMealId: meal.id,
        );
        final uri = Uri.parse(url);
        final ok = await canLaunchUrl(uri);
        if (!ok) {
          throw Exception('Cannot open checkout');
        }
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!mounted) {
          return;
        }
        widget.onSaved();
        Navigator.of(context).pop();
        messenger.showSnackBar(SnackBar(content: Text(l10n.mealPayInBrowser)));
      } else {
        if (!mounted) {
          return;
        }
        widget.onSaved();
        Navigator.of(context).pop();
        messenger.showSnackBar(SnackBar(content: Text(l10n.mealSaved)));
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(SnackBar(content: Text(l10n.mealCheckoutError)));
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final lang = locale.languageCode;
    final meals = _meals;
    final a = _current.activeAssignment;
    final ordersOpen = a?.mealOrdersAccepting ?? true;
    final mealPaid = a?.mealPaid ?? false;
    final mealLocked = a?.isMealOrderLocked ?? false;
    final selectedFromServer = a?.selectedEventMealId;
    final mealAwaitingPayment =
        a?.mealFulfillmentStatus == 'awaiting_payment' ||
        (mealLocked && !mealPaid && selectedFromServer != null);
    final mealDone = a?.mealFulfillmentStatus == 'fulfilled' || mealPaid;
    final canSelectMeals = ordersOpen && !mealLocked;
    final canSubmitOrder =
        a != null &&
        !mealLocked &&
        meals.isNotEmpty &&
        _mealId != null &&
        (ordersOpen || _mealId == selectedFromServer);

    return Scaffold(
      backgroundColor: _kSurface,
      appBar: AppBar(
        backgroundColor: _kSurface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: _kOnSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: l10n.close,
          onPressed: _saving
              ? null
              : () {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                },
        ),
        title: Text(
          l10n.mealChoiceTitle,
          style: const TextStyle(
            color: _kOnSurface,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (mealDone) ...[
                  const SizedBox(height: 14),
                  Text(
                    l10n.mealPaid,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF81C784),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else if (mealAwaitingPayment) ...[
                  const SizedBox(height: 14),
                  Text(
                    l10n.mealAwaitingPayment,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFFFB74D),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else if (!ordersOpen) ...[
                  const SizedBox(height: 14),
                  Text(
                    l10n.mealOrdersClosed,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFE57373),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (widget.children.length > 1) ...[
                  const SizedBox(height: 16),
                  Text(
                    l10n.mealSelectChildLabel,
                    style: const TextStyle(
                      color: _kTertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (var i = 0; i < widget.children.length; i++)
                    _selectableRow(
                      selected: _childIndex == i,
                      label: widget.children[i].firstName,
                      onTap: _saving ? null : () => _onChildChanged(i),
                      enabled: true,
                    ),
                ],
                const SizedBox(height: 20),
                Text(
                  l10n.mealSelectDishLabel,
                  style: const TextStyle(
                    color: _kTertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                if (meals.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      l10n.mealNoMealsConfigured,
                      style: const TextStyle(color: _kTertiary, fontSize: 14),
                    ),
                  )
                else
                  for (final m in meals)
                    _mealHeroCard(
                      meal: m,
                      label: m.labelForLanguageCode(lang),
                      priceText: _formatMealPrice(m.price, locale),
                      selected: _mealId == m.id,
                      enabled: canSelectMeals,
                      onTap: (_saving || !canSelectMeals)
                          ? null
                          : () => setState(() => _mealId = m.id),
                    ),
                const SizedBox(height: 20),
                if (mealDone)
                  Text(
                    l10n.mealPaidDetail,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _kTertiary, fontSize: 14),
                  )
                else if (mealAwaitingPayment)
                  Text(
                    l10n.mealAwaitingPaymentDetail,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _kTertiary, fontSize: 14),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: (_saving || !canSubmitOrder)
                          ? null
                          : _submitOrder,
                      style: FilledButton.styleFrom(
                        backgroundColor: _kGold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _saving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              l10n.mealSave,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
