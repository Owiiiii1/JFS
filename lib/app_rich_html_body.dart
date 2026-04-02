import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'rich_editor_html_for_display.dart';

/// [HtmlWidget] для тел статей из админки: санитизация RichEditor и без открытия картинок в браузере.
Widget buildAppRichHtmlBody({
  required String html,
  required TextStyle textStyle,
  Uri? baseUrl,
}) {
  return HtmlWidget(
    richEditorHtmlForDisplay(html),
    textStyle: textStyle,
    baseUrl: baseUrl,
    onTapUrl: (url) async => shouldSuppressImageUrlLaunchForHtml(url),
  );
}
