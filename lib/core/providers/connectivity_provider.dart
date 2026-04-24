import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipelanin/core/providers/firebase_providers.dart';

/// Stream status koneksi ke Firebase RTDB (true = online, false = offline)
/// Default true agar tidak muncul false alarm saat startup
final connectivityProvider = StreamProvider<bool>((ref) {
  return ref
      .watch(rtdbRepositoryProvider)
      .watchConnectivity()
      .handleError((_) => true);
});
