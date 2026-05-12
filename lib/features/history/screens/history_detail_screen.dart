import 'package:flutter/material.dart';
import 'package:sipelanin/core/models/device_health_model.dart';
import 'package:sipelanin/core/models/log_event_model.dart';
import 'package:sipelanin/core/theme/app_color_scheme.dart';
import 'package:sipelanin/core/theme/app_colors.dart';
import 'package:sipelanin/shared/widgets/status_badge.dart';

class HistoryDetailScreen extends StatelessWidget {
  final LogEventModel log;

  const HistoryDetailScreen({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final snap = log.snapshotStatus;
    final components = [
      {
        'name': 'Perangkat Sensing',
        'status': snap.sensingUnitStatus,
        'type': DeviceHealthModel.toStatusType(snap.sensingUnitStatus),
        'icon': Icons.sensors,
      },
      {
        'name': 'Kamera',
        'status': snap.cameraUnitStatus,
        'type': DeviceHealthModel.toStatusType(snap.cameraUnitStatus),
        'icon': Icons.camera_alt_outlined,
      },
      {
        'name': 'Perangkat Actuator',
        'status': snap.actuatorUnit,
        'type': DeviceHealthModel.toStatusType(snap.actuatorUnit),
        'icon': Icons.settings_remote_outlined,
      },
    ];

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.appBarBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              size: 18, color: c.appBarForeground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Detail Riwayat', style: TextStyle(
          fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.w600,
          color: c.appBarForeground,
        )),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1, thickness: 1,
            color: c.appBarForeground.withValues(alpha: 0.15),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Main Status Card ──
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (log.isSafe ? AppColors.safe : AppColors.danger)
                      .withValues(alpha: 0.4),
                ),
                boxShadow: [BoxShadow(
                  color: (log.isSafe ? AppColors.safe : AppColors.danger)
                      .withValues(alpha: 0.08),
                  blurRadius: 20, spreadRadius: 2,
                )],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: log.isSafe
                          ? AppColors.safeDim
                          : AppColors.dangerDim,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status Umum', style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: c.textPrimary,
                        )),
                        log.isSafe ? StatusBadge.safe() : StatusBadge.danger(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.warning_amber_rounded,
                          label: 'Kejadian',
                          value: log.eventType,
                        ),
                        const SizedBox(height: 10),
                        _DetailRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Tanggal',
                          value: log.formattedDate,
                        ),
                        const SizedBox(height: 10),
                        _DetailRow(
                          icon: Icons.access_time,
                          label: 'Waktu',
                          value: log.formattedTime,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text('Status Komponen', style: TextStyle(
              fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600,
              color: c.textPrimary,
            )),
            const SizedBox(height: 12),

            ...components.map((comp) {
              final statusType = comp['type'] as StatusType;
              final statusColor = _colorForType(statusType);
              final statusDim = _dimForType(statusType);
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: c.surfaceBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: statusDim,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(comp['icon'] as IconData,
                          color: statusColor, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(comp['name'] as String, style: TextStyle(
                        fontFamily: 'Poppins', fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: c.textPrimary,
                      )),
                    ),
                    StatusBadge(
                      label: comp['status'] as String,
                      type: statusType,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _colorForType(StatusType t) {
    switch (t) {
      case StatusType.active:
      case StatusType.safe:
        return AppColors.safe;
      case StatusType.standby:
        return AppColors.standby;
      case StatusType.danger:
        return AppColors.danger;
    }
  }

  Color _dimForType(StatusType t) {
    switch (t) {
      case StatusType.active:
      case StatusType.safe:
        return AppColors.safeDim;
      case StatusType.standby:
        return AppColors.standbyDim;
      case StatusType.danger:
        return AppColors.dangerDim;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        Icon(icon, size: 16, color: c.accent),
        const SizedBox(width: 10),
        SizedBox(
          width: 72,
          child: Text(label, style: TextStyle(
            fontFamily: 'Poppins', fontSize: 12, color: c.textSecondary,
          )),
        ),
        Text(': ', style: TextStyle(
            color: c.textSecondary, fontSize: 12)),
        Expanded(
          child: Text(value, style: TextStyle(
            fontFamily: 'Poppins', fontSize: 12,
            fontWeight: FontWeight.w600, color: c.textPrimary,
          )),
        ),
      ],
    );
  }
}
