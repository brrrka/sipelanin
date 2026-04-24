import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (_) => SharedPreferences.getInstance(),
);

class NotificationSettingsNotifier extends StateNotifier<bool> {
  final SharedPreferences _prefs;
  static const _key = 'notification_enabled';

  NotificationSettingsNotifier(this._prefs)
      : super(_prefs.getBool(_key) ?? true);

  /// Toggle notifikasi: subscribe/unsubscribe FCM topic + simpan ke prefs
  Future<void> toggle(bool value) async {
    state = value;
    await _prefs.setBool(_key, value);
    if (value) {
      await FirebaseMessaging.instance.subscribeToTopic('sistem_peringatan');
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic('sistem_peringatan');
    }
  }
}

final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).requireValue;
  return NotificationSettingsNotifier(prefs);
});
