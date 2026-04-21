// Helpers for schedule times that must match admin grid wall clock (no device TZ shift).

/// Parses `Y-m-dTHH:mm:ss` or `Y-m-d HH:mm:ss` into a [DateTime] with those **literal** components
/// (constructor form; not interpreted as UTC).
DateTime? parseScheduleWallToDateTime(String? wall) {
  final s = wall?.trim();
  if (s == null || s.isEmpty) {
    return null;
  }
  final n = s.replaceFirst('T', ' ');
  final m = RegExp(
    r'^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2})(?::(\d{2}))?',
  ).firstMatch(n);
  if (m == null) {
    return null;
  }
  final y = int.parse(m[1]!);
  final mo = int.parse(m[2]!);
  final d = int.parse(m[3]!);
  final h = int.parse(m[4]!);
  final mi = int.parse(m[5]!);
  final sec = m[6] != null ? int.parse(m[6]!) : 0;
  return DateTime(y, mo, d, h, mi, sec);
}
