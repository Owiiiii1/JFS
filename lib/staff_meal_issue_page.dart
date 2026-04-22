import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'api/auth_service.dart' show AuthService, WorkerMealIssueLine, WorkerMealIssueLookupResult;
import 'app_settings.dart';
import 'gen_l10n/app_localizations.dart';

const _kSurface = Color(0xFF1B1B1B);
const _kOn = Color(0xFFE2E2E2);
const _kMuted = Color(0xFF9E9E9E);
const _kGold = Color(0xFFD4AF37);

/// После скана: имя владельца бейджа, список блюд, мультивыбор, «Выдать».
class StaffMealIssuePage extends StatefulWidget {
  const StaffMealIssuePage({
    super.key,
    required this.auth,
    required this.payload,
    required this.staffRoleId,
    required this.accent,
    required     this.backgroundColor,
  });

  final AuthService auth;
  final WorkerMealIssueLookupResult payload;
  /// Текущая роль воркера в приложении; этап плана закрывается по staff_role_stages.
  final int staffRoleId;
  final Color accent;
  final Color backgroundColor;

  @override
  State<StaffMealIssuePage> createState() => _StaffMealIssuePageState();
}

class _StaffMealIssuePageState extends State<StaffMealIssuePage> {
  final Set<int> _selected = {};
  bool _submitting = false;

  List<WorkerMealIssueLine> get _selectable {
    return widget.payload.mealPurchases
        .where((m) => !m.isIssued)
        .toList();
  }

  bool get _canSubmit =>
      _selectable.isNotEmpty && _selected.isNotEmpty && !_submitting;

  void _toggleSelection(int id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() => _submitting = true);
    final l10n = AppLocalizations.of(context)!;
    final ctx = AppSettings.staffActiveEventId;
    try {
      await widget.auth.workerMealIssueConfirm(
        purchaseIds: _selected.toList()..sort(),
        staffRoleId: widget.staffRoleId,
        contextEventId: ctx,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.staffMealIssueSuccess),
          backgroundColor: Colors.green.shade800,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.staffMealIssueFailure(e.toString())),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final loc = Localizations.localeOf(context).toString();
    final name = widget.payload.badgeOwnerName.trim();
    final lines = widget.payload.mealPurchases;
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        backgroundColor: widget.backgroundColor,
        surfaceTintColor: Colors.transparent,
        foregroundColor: _kOn,
        title: Text(
          l10n.staffMealIssueTitle,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            if (name.isNotEmpty) ...[
              Text(
                name,
                style: const TextStyle(
                  color: _kOn,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
            if (lines.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    l10n.staffMealIssueNoMeals,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _kMuted, fontSize: 15, height: 1.3),
                  ),
                ),
              )
            else
              for (final m in lines) ...[
                _MealLineTile(
                  m: m,
                  lang: lang,
                  dateLocale: loc,
                  l10n: l10n,
                  selected: _selected,
                  onToggle: _toggleSelection,
                ),
                const SizedBox(height: 10),
              ],
            if (lines.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _canSubmit ? _submit : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: _kGold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    disabledBackgroundColor: const Color(0xFF3D3D3D),
                    disabledForegroundColor: Colors.white38,
                  ),
                  child: _submitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : Text(
                          l10n.staffMealIssueHandOut,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MealLineTile extends StatelessWidget {
  const _MealLineTile({
    required this.m,
    required this.lang,
    required this.dateLocale,
    required this.l10n,
    required this.selected,
    required this.onToggle,
  });

  final WorkerMealIssueLine m;
  final String lang;
  final String dateLocale;
  final AppLocalizations l10n;
  final Set<int> selected;
  final void Function(int id) onToggle;

  @override
  Widget build(BuildContext context) {
    final label = m.labelForLanguageCode(lang);
    String? dateLine;
    if (m.purchasedAt != null) {
      dateLine = DateFormat.yMMMd(dateLocale).add_Hm().format(
        m.purchasedAt!.toLocal(),
      );
    }
    final canPick = !m.isIssued;
    final isChecked = canPick && selected.contains(m.id);
    return Material(
      color: _kSurface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: canPick ? () => onToggle(m.id) : null,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: m.isIssued ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (canPick) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 2, right: 8),
                    child: Icon(
                      isChecked
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: isChecked ? _kGold : _kMuted,
                      size: 24,
                    ),
                  ),
                ] else
                  const Padding(
                    padding: EdgeInsets.only(right: 8, top: 2),
                    child: Icon(
                      Icons.verified,
                      size: 22,
                      color: _kMuted,
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m.isIssued
                            ? '$label · ${l10n.staffMealIssueAlreadyIssued}'
                            : label,
                        style: const TextStyle(
                          color: _kOn,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                        ),
                      ),
                      if (dateLine != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          dateLine,
                          style: const TextStyle(
                            color: _kMuted,
                            fontSize: 11,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ],
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
