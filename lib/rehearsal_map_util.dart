import 'package:url_launcher/url_launcher.dart';

/// Parses admin-provided map links (HTTPS Google Maps, etc.).
Uri? rehearsalMapLaunchUri(String? raw) {
  final t = raw?.trim() ?? '';
  if (t.isEmpty) return null;
  final u = Uri.tryParse(t);
  if (u != null && u.hasScheme && (u.scheme == 'http' || u.scheme == 'https')) {
    return u;
  }
  final withScheme = Uri.tryParse('https://$t');
  if (withScheme != null &&
      withScheme.hasScheme &&
      (withScheme.scheme == 'http' || withScheme.scheme == 'https')) {
    return withScheme;
  }
  return null;
}

Future<void> openRehearsalMapExternal(String? raw) async {
  final uri = rehearsalMapLaunchUri(raw);
  if (uri == null) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
