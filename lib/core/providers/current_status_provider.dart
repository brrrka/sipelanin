import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipelanin/core/models/current_status_model.dart';
import 'package:sipelanin/core/providers/firebase_providers.dart';

/// Stream real-time status sistem dari /current_status/ RTDB
final currentStatusProvider = StreamProvider<CurrentStatusModel?>((ref) {
  return ref.watch(rtdbRepositoryProvider).watchCurrentStatus();
});
