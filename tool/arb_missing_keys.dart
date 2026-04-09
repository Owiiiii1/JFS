// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

void main() {
  final dir = Directory('lib/l10n');
  final en =
      jsonDecode(File('${dir.path}/app_en.arb').readAsStringSync())
          as Map<String, dynamic>;
  final enKeys = en.keys
      .where((k) => !k.startsWith('@') && k != '@@locale')
      .toSet();

  for (final name in [
    'app_es.arb',
    'app_es_US.arb',
    'app_ru.arb',
    'app_uk.arb',
  ]) {
    final loc =
        jsonDecode(File('${dir.path}/$name').readAsStringSync())
            as Map<String, dynamic>;
    final locKeys = loc.keys
        .where((k) => !k.startsWith('@') && k != '@@locale')
        .toSet();
    final missing = enKeys.difference(locKeys);
    final extra = locKeys.difference(enKeys);
    if (missing.isNotEmpty) {
      print('$name MISSING vs en: ${missing.join(", ")}');
    }
    if (extra.isNotEmpty) {
      print('$name EXTRA vs en: ${extra.join(", ")}');
    }
    if (missing.isEmpty && extra.isEmpty) {
      print('$name: key set matches en');
    }
  }
}
