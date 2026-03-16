import 'package:flutter/material.dart';
import 'api/auth_service.dart';

const _kPrimary = Color(0xFFec5b13);
const _kBgDark = Color(0xFF000000);

class StaffChildDetailPage extends StatefulWidget {
  const StaffChildDetailPage({
    super.key,
    required this.auth,
    required this.assignmentId,
  });

  final AuthService auth;
  final int assignmentId;

  @override
  State<StaffChildDetailPage> createState() => _StaffChildDetailPageState();
}

class _StaffChildDetailPageState extends State<StaffChildDetailPage> {
  SupervisorChildDetail? _detail;
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
      final data = await widget.auth.getSupervisorChildDetail(widget.assignmentId);
      if (!mounted) return;
      setState(() {
        _detail = data;
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

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    return Scaffold(
      backgroundColor: _kBgDark,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: _kPrimary))
            : _error != null || detail == null
                ? _buildError()
                : _buildContent(detail),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error ?? 'Failed to load', style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(SupervisorChildDetail d) {
    final progress = (d.progressPercent.clamp(0, 100)) / 100.0;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              _roundIcon(Icons.arrow_back, onTap: () => Navigator.of(context).pop()),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Child Profile', style: TextStyle(color: Colors.white, fontSize: 26 / 1.4, fontWeight: FontWeight.bold)),
              ),
              _roundIcon(Icons.more_vert, onTap: () {}),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 64,
                            backgroundColor: Colors.white12,
                            backgroundImage: d.photoUrl != null && d.photoUrl!.isNotEmpty ? NetworkImage(d.photoUrl!) : null,
                            child: d.photoUrl == null || d.photoUrl!.isEmpty
                                ? Text(d.firstName.isNotEmpty ? d.firstName[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white70, fontSize: 36))
                                : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(d.fullName, style: const TextStyle(color: Colors.white, fontSize: 38 / 1.5, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a0f0b),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Text('CURRENT STAGE', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                          const Spacer(),
                          Text('${d.progressPercent}% Complete', style: const TextStyle(color: _kPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(value: progress, minHeight: 8, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation(_kPrimary)),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        d.currentStageName != null && d.currentStageName!.isNotEmpty
                            ? 'Phase: ${d.currentStageName}'
                            : 'No current stage',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _sectionTitle(Icons.info, 'Core Details'),
                ..._buildCoreDetailsRows(d),
                const SizedBox(height: 18),
                _sectionTitle(Icons.family_restroom, 'Parent Contact'),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(color: _kPrimary.withOpacity(0.2), shape: BoxShape.circle),
                        child: const Icon(Icons.person, color: _kPrimary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.parentName ?? '—', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text(d.parentRole ?? 'Parent', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                      ),
                      _roundAction(Icons.call, filled: true, onTap: () {}),
                      const SizedBox(width: 8),
                      _roundAction(Icons.chat_bubble_outline, onTap: () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: _kPrimary, size: 20),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 30 / 1.5, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(border: isLast ? null : Border(bottom: BorderSide(color: Colors.white.withOpacity(0.08)))),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white54, fontSize: 16))),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  List<Widget> _buildCoreDetailsRows(SupervisorChildDetail d) {
    final rows = <MapEntry<String, String>>[];
    if (d.age != null) rows.add(MapEntry('Age', '${d.age} years old'));
    if (d.birthdate != null) rows.add(MapEntry('Birthdate', _formatBirthdate(d.birthdate!)));
    if (d.heightValue != null) rows.add(MapEntry('Height', _formatHeight(d)));
    if (d.weightValue != null) rows.add(MapEntry('Weight', _formatWeight(d)));
    final notes = d.notes?.trim();
    if (notes != null && notes.isNotEmpty) rows.add(MapEntry('Notes', notes));

    if (rows.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('No child details in DB', style: TextStyle(color: Colors.white54)),
        ),
      ];
    }

    return List<Widget>.generate(rows.length, (i) {
      final row = rows[i];
      return _detailRow(row.key, row.value, isLast: i == rows.length - 1);
    });
  }

  String _formatHeight(SupervisorChildDetail d) {
    if (d.heightValue == null) return '—';
    final unit = (d.heightUnit?.trim().isNotEmpty ?? false)
        ? d.heightUnit!.toLowerCase() == 'imperial'
            ? 'in'
            : 'cm'
        : 'cm';
    return '${d.heightValue!.toStringAsFixed(0)} $unit';
  }

  String _formatWeight(SupervisorChildDetail d) {
    if (d.weightValue == null) return '—';
    final unit = (d.weightUnit?.trim().isNotEmpty ?? false)
        ? d.weightUnit!.toLowerCase() == 'imperial'
            ? 'lb'
            : 'kg'
        : 'kg';
    return '${d.weightValue!.toStringAsFixed(0)} $unit';
  }

  String _formatBirthdate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd.$mm.${d.year}';
  }

  Widget _roundIcon(IconData icon, {required VoidCallback onTap}) {
    return Material(
      color: _kPrimary.withOpacity(0.14),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(width: 40, height: 40, child: Icon(icon, color: _kPrimary)),
      ),
    );
  }

  Widget _roundAction(IconData icon, {required VoidCallback onTap, bool filled = false}) {
    return Material(
      color: filled ? _kPrimary : Colors.white.withOpacity(0.12),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: filled ? Colors.white : Colors.white70, size: 20),
        ),
      ),
    );
  }
}
