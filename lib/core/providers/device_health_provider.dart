import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipelanin/core/models/device_health_model.dart';
import 'package:sipelanin/core/providers/firebase_providers.dart';

/// Stream real-time health perangkat dari /device_health/ RTDB
final deviceHealthProvider = StreamProvider<DeviceHealthModel?>((ref) {
  return ref.watch(rtdbRepositoryProvider).watchDeviceHealth();
});
