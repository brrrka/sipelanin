import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipelanin/core/repositories/auth_repository.dart';
import 'package:sipelanin/core/repositories/log_repository.dart';
import 'package:sipelanin/core/repositories/notification_repository.dart';
import 'package:sipelanin/core/repositories/rtdb_repository.dart';

// ── Raw Firebase SDK instances ──────────────────────────────────────────────

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (_) => FirebaseAuth.instance,
);

final firebaseDatabaseProvider = Provider<FirebaseDatabase>(
  (_) => FirebaseDatabase.instance,
);

final firestoreProvider = Provider<FirebaseFirestore>(
  (_) => FirebaseFirestore.instance,
);

// ── Auth state stream — source of truth untuk GoRouter redirect ─────────────

final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(firebaseAuthProvider).authStateChanges(),
);

// ── Repository providers ─────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(firebaseAuthProvider)),
);

final rtdbRepositoryProvider = Provider<RtdbRepository>(
  (ref) => RtdbRepository(ref.watch(firebaseDatabaseProvider)),
);

final logRepositoryProvider = Provider<LogRepository>(
  (ref) => LogRepository(ref.watch(firestoreProvider)),
);

/// NotificationRepository dibuat per-uid agar path Firestore selalu benar
final notificationRepositoryProvider =
    Provider.family<NotificationRepository, String>(
  (ref, uid) => NotificationRepository(ref.watch(firestoreProvider), uid),
);
