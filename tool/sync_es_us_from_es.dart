// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

/// Копирует все строки из app_es.arb в app_es_US.arb, сохраняя порядок ключей из es_US.
void main() {
  final dir = Directory('lib/l10n');
  final es =
      jsonDecode(File('${dir.path}/app_es.arb').readAsStringSync())
          as Map<String, dynamic>;
  final esUsPath = File('${dir.path}/app_es_US.arb');
  final esUs = jsonDecode(esUsPath.readAsStringSync()) as Map<String, dynamic>;

  var changed = 0;
  for (final k in esUs.keys) {
    if (k == '@@locale') {
      esUs[k] = 'es_US';
      continue;
    }
    if (k.startsWith('@')) continue;
    if (!es.containsKey(k)) {
      print('WARN: app_es.arb missing key $k');
      continue;
    }
    final fromEs = es[k];
    if (fromEs is String && esUs[k] != fromEs) {
      esUs[k] = fromEs;
      changed++;
    }
  }

  const encoder = JsonEncoder.withIndent('  ');
  esUsPath.writeAsStringSync('${encoder.convert(esUs)}\n');
  print('Updated $changed string values from app_es.arb → app_es_US.arb');
}
