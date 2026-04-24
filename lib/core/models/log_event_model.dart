import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SnapshotStatusModel {
  final String sensingUnitStatus;
  final String sensingUnitDetail;
  final String cameraUnitStatus;
  final String cameraUnitDetail;
  final String actuatorUnit;

  const SnapshotStatusModel({
    required this.sensingUnitStatus,
    required this.sensingUnitDetail,
    required this.cameraUnitStatus,
    required this.cameraUnitDetail,
    required this.actuatorUnit,
  });

  factory SnapshotStatusModel.fromMap(Map<String, dynamic> map) {
    return SnapshotStatusModel(
      sensingUnitStatus: (map['sensing_unit_status'] as String?) ?? 'Aktif',
      sensingUnitDetail: (map['sensing_unit_detail'] as String?) ?? '-',
      cameraUnitStatus: (map['camera_unit_status'] as String?) ?? 'Standby',
      cameraUnitDetail: (map['camera_unit_detail'] as String?) ?? '-',
      actuatorUnit: (map['actuator_unit'] as String?) ?? 'Aktif',
    );
  }
}

class LogEventModel {
  final String eventId;
  final String eventType;
  final Timestamp timestamp;
  final SnapshotStatusModel snapshotStatus;

  const LogEventModel({
    required this.eventId,
    required this.eventType,
    required this.timestamp,
    required this.snapshotStatus,
  });

  bool get isSafe => eventType == 'Kereta Melintas';

  String get formattedDate {
    final dt = timestamp.toDate();
    // Format: Senin, 24/04/2026
    return DateFormat('EEEE, dd/MM/yyyy', 'id').format(dt);
  }

  String get formattedTime {
    final dt = timestamp.toDate();
    return '${DateFormat('HH.mm').format(dt)} WIB';
  }

  factory LogEventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LogEventModel(
      eventId: doc.id,
      eventType: (data['event_type'] as String?) ?? 'Kereta Melintas',
      timestamp: (data['timestamp'] as Timestamp?) ?? Timestamp.now(),
      snapshotStatus: SnapshotStatusModel.fromMap(
        (data['snapshot_status'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }
}
