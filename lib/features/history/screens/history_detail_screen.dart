import 'package:flutter/material.dart';
import 'package:sipelanin/core/theme/app_colors.dart';
import 'package:sipelanin/shared/widgets/status_badge.dart';

class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({super.key});

  static const List<Map<String, dynamic>> _components = [
    {'name': 'Perangkat Sensing', 'status': 'Aktif', 'type': StatusType.active, 'icon': Icons.sensors},
    {'name': 'Kamera', 'status': 'Standby', 'type': StatusType.standby, 'icon': Icons.camera_alt_outlined},
    {'name': 'Perangkat Actuator', 'status': 'Aktif', 'type': StatusType.active, 'icon': Icons.settings_remote_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Riwayat', style: TextStyle(
          fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        )),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: AppColors.divider),
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
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.safe.withValues(alpha: 0.4)),
                boxShadow: [BoxShadow(
                  color: AppColors.safe.withValues(alpha: 0.08),
                  blurRadius: 20, spreadRadius: 2,
                )],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.safeDim,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Status Umum', style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        )),
                        StatusBadge.safe(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _DetailRow(icon: Icons.warning_amber_rounded, label: 'Kejadian', value: 'Kereta melintas'),
                        const SizedBox(height: 10),
                        _DetailRow(icon: Icons.calendar_today_outlined, label: 'Tanggal', value: '00/00/0000'),
                        const SizedBox(height: 10),
                        _DetailRow(icon: Icons.access_time, label: 'Waktu', value: '00.00 WIB'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text('Status Komponen', style: TextStyle(
              fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            )),
            const SizedBox(height: 12),

            ..._components.map((comp) {
              final statusType = comp['type'] as StatusType;
              final statusColor = statusType == StatusType.standby
                  ? AppColors.standby : AppColors.safe;
              final statusDim = statusType == StatusType.standby
                  ? AppColors.standbyDim : AppColors.safeDim;
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: statusDim, borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(comp['icon'] as IconData,
                          color: statusColor, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(comp['name'] as String, style: const TextStyle(
                        fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      )),
                    ),
                    StatusBadge(label: comp['status'] as String, type: statusType),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.cyan),
        const SizedBox(width: 10),
        SizedBox(
          width: 72,
          child: Text(label, style: const TextStyle(
            fontFamily: 'Poppins', fontSize: 12, color: AppColors.textSecondary,
          )),
        ),
        const Text(': ', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Text(value, style: const TextStyle(
          fontFamily: 'Poppins', fontSize: 12,
          fontWeight: FontWeight.w600, color: AppColors.textPrimary,
        )),
      ],
    );
  }
}
