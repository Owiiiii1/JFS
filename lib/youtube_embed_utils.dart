/// Parses YouTube URLs and extracts the 11-character video id.
String? extractYoutubeVideoId(String raw) {
  var s = raw.trim();
  if (s.isEmpty) {
    return null;
  }
  if (!s.contains('://') && !s.toLowerCase().startsWith('http')) {
    s = 'https://$s';
  }
  final uri = Uri.tryParse(s);
  if (uri == null) {
    return null;
  }
  final host = uri.host.toLowerCase();
  if (host == 'youtu.be') {
    final seg = uri.pathSegments.where((x) => x.isNotEmpty).toList();
    return seg.isNotEmpty ? seg.first : null;
  }
  if (host.contains('youtube.com') || host.contains('youtube-nocookie.com')) {
    final v = uri.queryParameters['v'];
    if (v != null && v.isNotEmpty) {
      return v;
    }
    final segs = uri.pathSegments;
    if (segs.isNotEmpty) {
      if (segs.first == 'embed' && segs.length > 1) {
        return segs[1];
      }
      if (segs.first == 'live' && segs.length > 1) {
        return segs[1];
      }
      if (segs.first == 'shorts' && segs.length > 1) {
        return segs[1];
      }
    }
  }
  return null;
}

/// Standard watch URL for opening the same video in the YouTube app or browser.
Uri? youtubeWatchUriFromAnyYoutubeUrl(String raw) {
  final id = extractYoutubeVideoId(raw);
  if (id == null || id.isEmpty) {
    return null;
  }
  return Uri.https('www.youtube.com', '/watch', {'v': id});
}
