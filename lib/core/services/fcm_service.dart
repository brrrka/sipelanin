import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sipelanin/core/repositories/notification_repository.dart';
import 'package:sipelanin/core/services/local_notification_service.dart';

/// Handler untuk pesan FCM saat app di background/terminated.
/// Harus top-level function, bukan method.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase sudah diinisialisasi sebelum handler ini dipanggil
}

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final LocalNotificationService _localNotif;
  NotificationRepository? _notifRepo;

  FcmService(this._localNotif);

  void setNotificationRepository(NotificationRepository repo) {
    _notifRepo = repo;
  }

  /// Inisialisasi FCM: minta izin, subscribe topic, dan pasang handler
  Future<void> initialize(String uid, NotificationRepository notifRepo) async {
    _notifRepo = notifRepo;

    // Minta izin notifikasi (Android 13+, iOS)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    // Subscribe ke topic sistem peringatan
    await _messaging.subscribeToTopic('sistem_peringatan');

    // Handler pesan FCM saat app foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notif = message.notification;
      if (notif == null) return;

      // Tampilkan sebagai notifikasi lokal
      await _localNotif.show(
        id: message.hashCode,
        title: notif.title ?? 'Peringatan Sistem',
        body: notif.body ?? '',
      );

      // Simpan ke Firestore agar muncul di NotificationScreen
      await _notifRepo?.saveIncomingNotification(message);
    });

    // Simpan juga jika pesan datang saat background (tap notifikasi)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await _notifRepo?.saveIncomingNotification(message);
    });

    // Cek pesan yang membuka app dari state terminated
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      await _notifRepo?.saveIncomingNotification(initial);
    }
  }

  /// Unsubscribe dari semua topic (dipakai saat notifikasi dinonaktifkan)
  Future<void> unsubscribe() async {
    await _messaging.unsubscribeFromTopic('sistem_peringatan');
  }
}
