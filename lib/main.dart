import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'api/auth_service.dart';
import 'app_route_observer.dart';
import 'app_settings.dart';
import 'gen_l10n/app_localizations.dart';
import 'intro_video_page.dart';

/// Базовый URL API без завершающего «/». Не читается из Laravel `.env` — только из сборки
/// (`--dart-define=API_BASE_URL=...`). Если на сервере просто добавили вход по домену, а по IP
/// всё тот же Laravel, приложение с [defaultValue] по-прежнему ходит на IP, пока вы явно не
/// соберёте его с другим `API_BASE_URL`.
/// Пример: `flutter run --dart-define=API_BASE_URL=https://api.example.com`
const String _kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://178.156.234.23',
);

String _normalizeApiBase(String raw) {
  var s = raw.trim();
  while (s.endsWith('/')) {
    s = s.substring(0, s.length - 1);
  }
  return s;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.load();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static const _supportedLocaleLanguages = ['en', 'ru', 'uk', 'es'];
  static const _fontFamily = 'HelveticaNeueCyr';

  @override
  void initState() {
    super.initState();
    AppSettings.onLocaleChanged = () {
      if (mounted) setState(() {});
    };
  }

  @override
  void dispose() {
    AppSettings.onLocaleChanged = null;
    super.dispose();
  }

  ThemeData _buildTheme() {
    final baseDark = ThemeData(brightness: Brightness.dark, useMaterial3: true);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      textTheme: baseDark.textTheme.apply(fontFamily: _fontFamily),
      primaryTextTheme: baseDark.primaryTextTheme.apply(fontFamily: _fontFamily),
    );
  }

  Locale? _resolveLocale() {
    final lang = AppSettings.language;
    if (lang == AppLanguage.system) return null;
    switch (lang) {
      case AppLanguage.en:
        return const Locale('en');
      case AppLanguage.ru:
        return const Locale('ru');
      case AppLanguage.uk:
        return const Locale('uk');
      case AppLanguage.esUs:
        return const Locale('es', 'US');
      case AppLanguage.system:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService(_normalizeApiBase(_kApiBaseUrl));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [appRouteObserver],
      locale: _resolveLocale(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        final override = _resolveLocale();
        if (override != null) return override;
        if (locale != null) {
          final languageCode = locale.languageCode.toLowerCase();
          if (languageCode == 'es') {
            return const Locale('es', 'US');
          }
          if (_supportedLocaleLanguages.contains(languageCode)) {
            return Locale(languageCode);
          }
        }
        return const Locale('en');
      },
      theme: _buildTheme(),
      home: IntroVideoPage(auth: auth),
    );
  }
}
