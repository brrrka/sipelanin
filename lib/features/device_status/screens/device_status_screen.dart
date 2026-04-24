import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sipelanin/core/models/device_health_model.dart';
import 'package:sipelanin/core/providers/device_health_provider.dart';
import 'package:sipelanin/core/theme/app_colors.dart';
import 'package:sipelanin/shared/widgets/custom_app_bar.dart';
import 'package:sipelanin/shared/widgets/status_badge.dart';

class DeviceStatusScreen extends ConsumerWidget {
  const DeviceStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthAsync = ref.watch(deviceHealthProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Status Perangkat'),
      body: healthAsync.when(
        loading: () => _buildShimmer(),
        error: (e, _) => _buildError(),
        data: (health) {
          if (health == null) return _buildError();

          final sensingType =
              DeviceHealthModel.toStatusType(health.sensingUnitStatus);
          final cameraType =
              DeviceHealthModel.toStatusType(health.cameraUnitStatus);
          final actuatorType =
              DeviceHealthModel.toStatusType(health.actuatorUnit);

          final allHealthy = health.isAllHealthy;

          final components = [
            {
              'name': 'Perangkat Sensing',
              'status': health.sensingUnitStatus,
              'type': sensingType,
              'icon': Icons.sensors,
              'description': health.sensingUnitDetail,
            },
            {
              'name': 'Kamera',
              'status': health.cameraUnitStatus,
              'type': cameraType,
              'icon': Icons.camera_alt_outlined,
              'description': health.cameraUnitDetail,
            },
            {
              'name': 'Perangkat Actuator',
              'status': health.actuatorUnit,
              'type': actuatorType,
              'icon': Icons.settings_remote_outlined,
              'description': health.actuatorUnit == 'Aktif'
                  ? 'Actuator aktif dan siap mengoperasikan palang pintu.'
                  : 'Actuator mengalami gangguan.',
            },
          ];

          return SingleChildScrollView(
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
                    border: Border.all(
                      color: (allHealthy ? AppColors.safe : AppColors.danger)
                          .withValues(alpha: 0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (allHealthy ? AppColors.safe : AppColors.danger)
                            .withValues(alpha: 0.08),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: allHealthy
                              ? AppColors.safeDim
                              : AppColors.dangerDim,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          allHealthy
                              ? Icons.verified_outlined
                              : Icons.warning_amber_rounded,
                          color: allHealthy ? AppColors.safe : AppColors.danger,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              allHealthy
                                  ? 'Sistem beroperasi dengan baik'
                                  : 'Ada komponen bermasalah',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              allHealthy
                                  ? 'Semua komponen berfungsi normal'
                                  : 'Periksa komponen yang error',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      allHealthy
                          ? StatusBadge.safe()
                          : StatusBadge.danger(),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Mini Component Summary Cards ──
                Row(
                  children: components.asMap().entries.map((entry) {
                    final i = entry.key;
                    final comp = entry.value;
                    final statusType = comp['type'] as StatusType;
                    final statusColor = _colorForType(statusType);
                    final statusDim = _dimForType(statusType);
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
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
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 6),
                            StatusBadge(
                              label: comp['status'] as String,
                              type: statusType,
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
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                ...components.map((comp) => _ComponentDetailCard(
                  name: comp['name'] as String,
                  status: comp['status'] as String,
                  statusType: comp['type'] as StatusType,
                  icon: comp['icon'] as IconData,
                  description: comp['description'] as String,
                )),

                const SizedBox(height: 8),

                // ── Footer scan time ──
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.access_time,
                          size: 14, color: AppColors.textSecondary),
                      SizedBox(width: 6),
                      Text(
                        'Data diperbarui secara real-time',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Color _colorForType(StatusType t) {
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

  static Color _dimForType(StatusType t) {
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

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: AppColors.surface,
        highlightColor: AppColors.surfaceLight,
        child: Column(
          children: List.generate(
            4,
            (_) => Container(
              width: double.infinity,
              height: 80,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, color: AppColors.danger, size: 40),
          const SizedBox(height: 12),
          const Text(
            'Gagal memuat status perangkat',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
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
    required this.name,
    required this.status,
    required this.statusType,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = DeviceStatusScreen._colorForType(statusType);
    final statusDim = DeviceStatusScreen._dimForType(statusType);

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
                    color: statusDim,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: statusColor, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(name, style: const TextStyle(
                    fontFamily: 'Poppins', fontSize: 14,
                    fontWeight: FontWeight.w600, color: AppColors.textPrimary,
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
