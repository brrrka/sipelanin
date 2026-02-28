import 'package:flutter/material.dart';
import 'package:sipelanin/core/theme/app_colors.dart';
import 'package:sipelanin/shared/widgets/custom_app_bar.dart';
import 'package:sipelanin/shared/widgets/status_badge.dart';

class DeviceStatusScreen extends StatelessWidget {
  const DeviceStatusScreen({super.key});

  static const List<Map<String, dynamic>> _components = [
    {
      'name': 'Perangkat Sensing',
      'status': 'Aktif',
      'type': StatusType.active,
      'icon': Icons.sensors,
      'description':
          'Perangkat sensing aktif mendeteksi getaran rel dan sinyal kereta secara real-time.',
    },
    {
      'name': 'Kamera',
      'status': 'Standby',
      'type': StatusType.standby,
      'icon': Icons.camera_alt_outlined,
      'description':
          'Kamera dalam mode standby dan akan aktif secara otomatis saat kereta terdeteksi.',
    },
    {
      'name': 'Perangkat Actuator',
      'status': 'Aktif',
      'type': StatusType.active,
      'icon': Icons.settings_remote_outlined,
      'description':
          'Actuator aktif dan siap mengoperasikan palang pintu perlintasan secara otomatis.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Status Perangkat'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Overall System Status Card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.safe.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.safe.withValues(alpha: 0.08),
                    blurRadius: 20, spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.safeDim,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.verified_outlined,
                        color: AppColors.safe, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sistem beroperasi dengan baik',
                          style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 13,
                            fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Semua komponen berfungsi normal',
                          style: TextStyle(
                            fontFamily: 'Poppins', fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge.safe(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Mini Component Summary Cards ──
            Row(
              children: _components.map((comp) {
                final isLast = _components.indexOf(comp) == _components.length - 1;
                final statusColor = comp['type'] == StatusType.standby
                    ? AppColors.standby
                    : AppColors.safe;
                final statusDim = comp['type'] == StatusType.standby
                    ? AppColors.standbyDim
                    : AppColors.safeDim;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: isLast ? 0 : 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: statusDim,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(comp['icon'] as IconData,
                              color: statusColor, size: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          comp['name'] as String,
                          style: const TextStyle(
                            fontFamily: 'Poppins', fontSize: 10,
                            fontWeight: FontWeight.w500, color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 6),
                        StatusBadge(
                          label: comp['status'] as String,
                          type: comp['type'] as StatusType,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // ── Detail Section ──
            const Text(
              'Detail Komponen',
              style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            ..._components.map((comp) => _ComponentDetailCard(
              name: comp['name'] as String,
              status: comp['status'] as String,
              statusType: comp['type'] as StatusType,
              icon: comp['icon'] as IconData,
              description: comp['description'] as String,
            )),

            const SizedBox(height: 8),

            // ── Footer ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                    SizedBox(width: 6),
                    Text(
                      'Scan Terakhir: 00.00 WIB',
                      style: TextStyle(
                        fontFamily: 'Poppins', fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComponentDetailCard extends StatelessWidget {
  final String name;
  final String status;
  final StatusType statusType;
  final IconData icon;
  final String description;

  const _ComponentDetailCard({
    required this.name, required this.status,
    required this.statusType, required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = statusType == StatusType.standby
        ? AppColors.standby : AppColors.safe;
    final statusDim = statusType == StatusType.standby
        ? AppColors.standbyDim : AppColors.safeDim;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusDim, borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: statusColor, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(name, style: const TextStyle(
                    fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  )),
                ),
                StatusBadge(label: status, type: statusType),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: AppColors.divider),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(description, style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 12,
              color: AppColors.textSecondary, height: 1.6,
            )),
          ),
        ],
      ),
    );
  }
}
