import 'package:flutter/material.dart';
import 'package:sipelanin/core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusBadge({super.key, required this.label, required this.type});

  factory StatusBadge.safe() =>
      const StatusBadge(label: 'SAFE', type: StatusType.safe);
  factory StatusBadge.danger() =>
      const StatusBadge(label: 'DANGER', type: StatusType.danger);
  factory StatusBadge.standby() =>
      const StatusBadge(label: 'Standby', type: StatusType.standby);
  factory StatusBadge.active() =>
      const StatusBadge(label: 'Aktif', type: StatusType.active);

  Color get _color {
    switch (type) {
      case StatusType.safe:   return AppColors.safe;
      case StatusType.danger: return AppColors.danger;
      case StatusType.standby:return AppColors.standby;
      case StatusType.active: return AppColors.safe;
    }
  }

  Color get _bgColor {
    switch (type) {
      case StatusType.safe:   return AppColors.safeDim;
      case StatusType.danger: return AppColors.dangerDim;
      case StatusType.standby:return AppColors.standbyDim;
      case StatusType.active: return AppColors.safeDim;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _color,
          letterSpacing: 0.5,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}

enum StatusType { safe, danger, standby, active }
