import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'api/auth_service.dart';
import 'app_route_observer.dart';
import 'app_settings.dart';
import 'firebase_options.dart';
import 'gen_l10n/app_localizations.dart';
import 'intro_video_page.dart';
import 'push/firebase_background.dart';
import 'push/push_token_service.dart';

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
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

  late final AuthService _auth;
  late final PushTokenService _push;

  @override
  void initState() {
    super.initState();
    _auth = AuthService(_normalizeApiBase(_kApiBaseUrl));
    _push = PushTokenService(_auth);
    PushTokenServiceHolder.instance = _push;
    AppSettings.onLocaleChanged = () {
      if (mounted) setState(() {});
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_push.installMessagingPipeline());
    });
  }

  @override
  void dispose() {
    AppSettings.onLocaleChanged = null;
    PushTokenServiceHolder.instance = null;
    unawaited(_push.dispose());
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
        // Редко locale в колбэке null — тогда берём платформу (как и [AppSettings.contentLocaleForApi]).
        final device = locale ?? PlatformDispatcher.instance.locale;
        final languageCode = device.languageCode.toLowerCase();
        if (languageCode == 'es') {
          return const Locale('es', 'US');
        }
        if (_supportedLocaleLanguages.contains(languageCode)) {
          return Locale(languageCode);
        }
        return const Locale('en');
      },
      theme: _buildTheme(),
      home: IntroVideoPage(auth: _auth),
    );
  }
}
