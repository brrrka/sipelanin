import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipelanin/core/models/notification_model.dart';
import 'package:sipelanin/core/providers/firebase_providers.dart';

/// Stream daftar notifikasi user yang sedang login
final notificationsProvider = StreamProvider<List<NotificationModel>>((ref) {
  final user = ref.watch(authStateProvider).valueOrNull;
  if (user == null) return const Stream.empty();

  return ref
      .watch(notificationRepositoryProvider(user.uid))
      .watchNotifications();
});

/// Jumlah notifikasi yang belum dibaca, untuk badge di AppBar
final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).maybeWhen(
        data: (list) => list.where((n) => !n.isRead).length,
        orElse: () => 0,
      );
});
