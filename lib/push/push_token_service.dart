import 'dart:async';
import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../api/auth_service.dart';
import 'jfs_push_dispatch.dart';

/// Registered from [App] so login / intro / logout can sync without extra props.
class PushTokenServiceHolder {
  PushTokenServiceHolder._();

  static PushTokenService? instance;
}

/// FCM token lifecycle + backend registration. No widget dependencies.
class PushTokenService {
  PushTokenService(this._auth);

  final AuthService _auth;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  StreamSubscription<String>? _tokenRefreshSub;

  /// Permission, foreground/open listeners, token refresh. Safe to call once per app start.
  Future<void> installMessagingPipeline() async {
    if (kIsWeb) {
      return;
    }

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (Platform.isIOS) {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final h = JfsPushDispatch.onForeground;
      if (h != null) {
        h(message);
      } else if (kDebugMode) {
        debugPrint(
          'JFS FCM foreground: title=${message.notification?.title} '
          'data=${message.data}',
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final h = JfsPushDispatch.onOpenedFromBackground;
      if (h != null) {
        h(message);
      } else if (kDebugMode) {
        debugPrint('JFS FCM opened from background: data=${message.data}');
      }
    });

    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      final h = JfsPushDispatch.onOpenedFromTerminated;
      if (h != null) {
        h(initial);
      } else if (kDebugMode) {
        debugPrint('JFS FCM launch from terminated: data=${initial.data}');
      }
    }

    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = _messaging.onTokenRefresh.listen((String token) {
      unawaited(registerTokenWithBackend(token));
    });

    await syncWithBackendIfLoggedIn();
  }

  /// After login, register, or restored session (Bearer available).
  Future<void> syncWithBackendIfLoggedIn() async {
    if (kIsWeb) {
      return;
    }
    var token = await _messaging.getToken();
    if (token != null && token.isNotEmpty) {
      await registerTokenWithBackend(token);
      return;
    }
    // iOS: FCM token часто приходит только после регистрации APNs — первый getToken()
    // сразу после логина даёт null, из‑за чего строка в app_push_tokens не создаётся.
    if (Platform.isIOS) {
      await _syncFcmTokenWithRetries();
    }
  }

  /// Пытаемся получить FCM token и отправить на бэкенд, пока пользователь залогинен.
  Future<void> _syncFcmTokenWithRetries() async {
    for (var attempt = 0; attempt < 20; attempt++) {
      await Future<void>.delayed(Duration(milliseconds: 250 + attempt * 150));
      final bearer = await _auth.getToken();
      if (bearer == null || bearer.isEmpty) {
        return;
      }
      final fcm = await _messaging.getToken();
      if (fcm != null && fcm.isNotEmpty) {
        await registerTokenWithBackend(fcm);
        return;
      }
    }
  }

  Future<void> registerTokenWithBackend(String fcmToken) async {
    if (kIsWeb) {
      return;
    }
    final bearer = await _auth.getToken();
    if (bearer == null || bearer.isEmpty) {
      return;
    }

    final platform = Platform.isAndroid ? 'android' : 'ios';

    String? deviceId;
    try {
      final plugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final a = await plugin.androidInfo;
        deviceId = a.id;
      } else if (Platform.isIOS) {
        final ios = await plugin.iosInfo;
        deviceId = ios.identifierForVendor;
      }
    } catch (_) {}

    String? appVersion;
    try {
      final pkg = await PackageInfo.fromPlatform();
      appVersion = '${pkg.version}+${pkg.buildNumber}';
    } catch (_) {}

    await _auth.registerPushToken(
      fcmToken: fcmToken,
      platform: platform,
      deviceId: deviceId,
      appVersion: appVersion,
    );
  }

  /// Call while Sanctum token is still valid (before [AuthService.clearToken]).
  Future<void> deactivateCurrentOnBackend() async {
    if (kIsWeb) {
      return;
    }
    final bearer = await _auth.getToken();
    if (bearer == null || bearer.isEmpty) {
      return;
    }
    final t = await _messaging.getToken().timeout(
      const Duration(seconds: 2),
      onTimeout: () => null,
    );
    if (t == null || t.isEmpty) {
      return;
    }
    await _auth
        .deactivatePushToken(fcmToken: t)
        .timeout(const Duration(seconds: 2), onTimeout: () {});
  }

  Future<void> dispose() async {
    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
  }
}
