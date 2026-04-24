import 'package:sipelanin/shared/widgets/status_badge.dart';

class DeviceHealthModel {
  final String sensingUnitStatus;
  final String sensingUnitDetail;
  final String cameraUnitStatus;
  final String cameraUnitDetail;
  final String actuatorUnit;

  const DeviceHealthModel({
    required this.sensingUnitStatus,
    required this.sensingUnitDetail,
    required this.cameraUnitStatus,
    required this.cameraUnitDetail,
    required this.actuatorUnit,
  });

  factory DeviceHealthModel.fromMap(Map<dynamic, dynamic> map) {
    return DeviceHealthModel(
      sensingUnitStatus: (map['sensing_unit_status'] as String?) ?? 'Aktif',
      sensingUnitDetail: (map['sensing_unit_detail'] as String?) ?? '-',
      cameraUnitStatus: (map['camera_unit_status'] as String?) ?? 'Standby',
      cameraUnitDetail: (map['camera_unit_detail'] as String?) ?? '-',
      actuatorUnit: (map['actuator_unit'] as String?) ?? 'Aktif',
    );
  }

  // Semua komponen harus non-error agar sistem dianggap sehat
  bool get isAllHealthy =>
      sensingUnitStatus != 'Error' &&
      cameraUnitStatus != 'Error' &&
      actuatorUnit != 'Error';

  // Konversi string status RTDB ke StatusType untuk StatusBadge widget
  static StatusType toStatusType(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return StatusType.active;
      case 'standby':
        return StatusType.standby;
      case 'error':
        return StatusType.danger;
      default:
        return StatusType.standby;
    }
  }
}
