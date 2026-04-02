/// Filament RichEditor часто даёт `<figcaption>` и `alt="file.jpg (12 KB)"` у `<img>`.
/// [HtmlWidget] выводит это как подпись под картинкой — убираем для чистого вида.
///
/// Ссылка `<a href="полный_размер"><img></a>` открывается во внешнем браузере (fwfh_url_launcher) —
/// снимаем обёртку, оставляя только `<img>`.
String richEditorHtmlForDisplay(String html) {
  var s = html;
  String prev;
  do {
    prev = s;
    s = s.replaceAllMapped(
      RegExp(r'<a\b[^>]*>\s*(<img\b[^>]*>)\s*</a>', caseSensitive: false),
      (m) => m[1]!,
    );
  } while (s != prev);

  s = s.replaceAll(
    RegExp(r'<figcaption\b[^>]*>[\s\S]*?</figcaption>', caseSensitive: false),
    '',
  );
  s = s.replaceAllMapped(RegExp(r'<img\b[^>]*>', caseSensitive: false), (
    Match m,
  ) {
    var tag = m[0]!;
    tag = tag.replaceAll(
      RegExp(r'\s+alt\s*=\s*"[^"]*"', caseSensitive: false),
      '',
    );
    tag = tag.replaceAll(
      RegExp(r"\s+alt\s*=\s*'[^']*'", caseSensitive: false),
      '',
    );
    tag = tag.replaceAll(
      RegExp(r'\s+title\s*=\s*"[^"]*"', caseSensitive: false),
      '',
    );
    tag = tag.replaceAll(
      RegExp(r"\s+title\s*=\s*'[^']*'", caseSensitive: false),
      '',
    );
    return tag;
  });
  return s;
}

/// Возвращает `true`, если тап по ссылке не должен открывать [url_launcher] (прямые ссылки на файлы картинок).
/// Обычные страницы и `mailto:` / `tel:` по-прежнему открываются.
bool shouldSuppressImageUrlLaunchForHtml(String url) {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return false;
  if (trimmed.startsWith('#')) return false;
  final lower = trimmed.toLowerCase();
  if (lower.startsWith('mailto:') || lower.startsWith('tel:')) return false;
  if (lower.startsWith('data:image/')) return true;

  var uri = Uri.tryParse(trimmed);
  if (uri == null) return false;
  if (trimmed.startsWith('//')) {
    uri = Uri.tryParse('https:$trimmed');
  }
  if (uri == null) return false;

  final path = uri.path.toLowerCase();
  const extensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.webp',
    '.svg',
    '.bmp',
    '.avif',
    '.heic',
    '.ico',
  ];
  for (final ext in extensions) {
    if (path.endsWith(ext)) return true;
  }
  return false;
}
