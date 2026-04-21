import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// In-app notification pushes from the API include string `notification_id` in FCM data.
///
/// Shown together with [AuthService.getUnreadNotificationsCount] on the home
/// bell until the next successful unread-count sync clears this hint.
class InAppNotificationBellHint {
  InAppNotificationBellHint._();

  static final ValueNotifier<bool> hasPendingHint = ValueNotifier(false);

  static void applyFromPushMessage(RemoteMessage message) {
    final raw = message.data['notification_id'];
    if (raw == null) return;
    final s = raw.toString().trim();
    if (s.isEmpty) return;
    hasPendingHint.value = true;
  }

  static void clearOnUnreadSyncedFromApi() {
    hasPendingHint.value = false;
  }
}
