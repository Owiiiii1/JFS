// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

void main() {
  final dir = Directory('lib/l10n');
  final enPath = File('${dir.path}/app_en.arb');
  final en = jsonDecode(enPath.readAsStringSync()) as Map<String, dynamic>;

  for (final name in [
    'app_es.arb',
    'app_es_US.arb',
    'app_ru.arb',
    'app_uk.arb',
  ]) {
    final loc =
        jsonDecode(File('${dir.path}/$name').readAsStringSync())
            as Map<String, dynamic>;
    final same = <String>[];
    for (final e in loc.entries) {
      final k = e.key;
      if (k.startsWith('@') || k == '@@locale') continue;
      final v = e.value;
      if (v is! String) continue;
      if (en[k] == v) same.add(k);
    }
    print('=== $name: ${same.length} keys identical to app_en.arb ===');
    same.sort();
    for (final k in same) {
      final s = en[k] as String;
      final preview = s.length > 72 ? '${s.substring(0, 72)}…' : s;
      print('  $k: $preview');
    }
    print('');
  }
}
