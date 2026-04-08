import 'package:firebase_messaging/firebase_messaging.dart';

/// Hooks for app-level handling of FCM. Assign from your shell (e.g. after first frame).
/// Do not navigate directly here without a [BuildContext] / router — use a navigator key or go_router.
class JfsPushDispatch {
  JfsPushDispatch._();

  /// App in foreground — notification may be null for data-only messages.
  static void Function(RemoteMessage message)? onForeground;

  /// User opened notification from background (app process alive).
  static void Function(RemoteMessage message)? onOpenedFromBackground;

  /// Cold start: app opened from terminated state via notification tap.
  static void Function(RemoteMessage message)? onOpenedFromTerminated;
}
