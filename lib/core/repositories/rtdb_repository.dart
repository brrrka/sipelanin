import 'package:firebase_database/firebase_database.dart';
import 'package:sipelanin/core/models/current_status_model.dart';
import 'package:sipelanin/core/models/device_health_model.dart';

class RtdbRepository {
  final FirebaseDatabase _db;

  const RtdbRepository(this._db);

  /// Stream real-time node /current_status/
  Stream<CurrentStatusModel?> watchCurrentStatus() {
    return _db.ref('current_status').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return null;
      return CurrentStatusModel.fromMap(data as Map<dynamic, dynamic>);
    });
  }

  /// Stream real-time node /device_health/
  Stream<DeviceHealthModel?> watchDeviceHealth() {
    return _db.ref('device_health').onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) return null;
      return DeviceHealthModel.fromMap(data as Map<dynamic, dynamic>);
    });
  }

  /// Stream status koneksi ke RTDB (.info/connected)
  Stream<bool> watchConnectivity() {
    return _db.ref('.info/connected').onValue.map((event) {
      return (event.snapshot.value as bool?) ?? false;
    });
  }
}
