import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sipelanin/core/models/notification_model.dart';

class NotificationRepository {
  final FirebaseFirestore _firestore;
  final String _uid;

  const NotificationRepository(this._firestore, this._uid);

  CollectionReference get _col =>
      _firestore.collection('notifications').doc(_uid).collection('items');

  /// Stream real-time daftar notifikasi milik user, terbaru di atas
  Stream<List<NotificationModel>> watchNotifications() {
    return _col
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snap) => snap.docs.map(NotificationModel.fromFirestore).toList());
  }

  /// Simpan notifikasi FCM yang masuk ke subcollection Firestore
  Future<void> saveIncomingNotification(RemoteMessage message) async {
    final notif = message.notification;
    if (notif == null) return;

    final type = message.data['type'] as String? ?? '';
    await _col.add({
      'title': notif.title ?? '',
      'body': notif.body ?? '',
      'timestamp': FieldValue.serverTimestamp(),
      'is_read': false,
      'type': type,
    });
  }

  /// Tandai semua notifikasi sebagai sudah dibaca
  Future<void> markAllRead() async {
    final snap = await _col.where('is_read', isEqualTo: false).get();
    final batch = _firestore.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'is_read': true});
    }
    await batch.commit();
  }
}
