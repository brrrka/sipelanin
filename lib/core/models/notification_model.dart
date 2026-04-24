import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationModel {
  final String notifId;
  final String title;
  final String body;
  final Timestamp timestamp;
  final bool isRead;
  final String type;

  const NotificationModel({
    required this.notifId,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.isRead,
    required this.type,
  });

  // Notif dianggap aman jika bukan jenis gangguan
  bool get isSafe => type != 'Gagal Deteksi' && !title.toLowerCase().contains('gagal');

  String get formattedTime {
    final dt = timestamp.toDate();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final notifDay = DateTime(dt.year, dt.month, dt.day);

    if (notifDay == today) {
      return '${DateFormat('HH.mm').format(dt)} WIB';
    } else if (notifDay == today.subtract(const Duration(days: 1))) {
      return 'Kemarin, ${DateFormat('HH.mm').format(dt)} WIB';
    }
    return '${DateFormat('dd/MM/yyyy, HH.mm').format(dt)} WIB';
  }

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      notifId: doc.id,
      title: (data['title'] as String?) ?? '',
      body: (data['body'] as String?) ?? '',
      timestamp: (data['timestamp'] as Timestamp?) ?? Timestamp.now(),
      isRead: (data['is_read'] as bool?) ?? false,
      type: (data['type'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'timestamp': timestamp,
      'is_read': isRead,
      'type': type,
    };
  }
}
