import 'package:flutter/material.dart';
import 'package:sipelanin/core/constants/app_routes.dart';
import 'package:sipelanin/core/theme/app_colors.dart';
import 'package:sipelanin/shared/widgets/custom_app_bar.dart';
import 'package:sipelanin/shared/widgets/history_list_tile.dart';
import 'package:sipelanin/shared/widgets/status_badge.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const bool _isSafe = true;
  static const String _systemLocation =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras scelerisque metus a quam ultricies, vitae tempor augue dapibus.';
  static const String _lastDetection = 'Lorem Ipsum';
  static const String _lastScan = 'Lorem Ipsum';
  static const String _currentStatus = 'Tidak ada kereta melintas';

  static const List<Map<String, dynamic>> _todayHistory = [
    {'event': 'Kereta melintas', 'time': '08.32 WIB', 'isSafe': true},
    {'event': 'Sistem gagal deteksi', 'time': '07.15 WIB', 'isSafe': false},
    {'event': 'Kereta melintas', 'time': '06.55 WIB', 'isSafe': true},
    {'event': 'Kereta melintas', 'time': '05.40 WIB', 'isSafe': true},
  ];

  @override
  Widget build(BuildContext context) {
    final statusColor = _isSafe ? AppColors.safe : AppColors.danger;
    final statusDimColor = _isSafe ? AppColors.safeDim : AppColors.dangerDim;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Home'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Status Terkini Header ──
            const Text(
              'Status Terkini',
              style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),

            // ── Main Status Card ──
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header row
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: statusDimColor,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Sistem beroperasi dengan baik',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                        _isSafe ? StatusBadge.safe() : StatusBadge.danger(),
                      ],
                    ),
                  ),
                  // Info rows
                  _InfoRow(label: 'Lokasi Sistem', value: _systemLocation),
                  Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.divider),
                  _InfoRow(label: 'Deteksi Terakhir', value: _lastDetection),
                  Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.divider),
                  _InfoRow(label: 'Scan Terakhir', value: _lastScan),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Current Train Status Card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.safe.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.directions_railway,
                        color: AppColors.safe, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _currentStatus,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Riwayat Hari Ini ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Riwayat Hari Ini',
                  style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Lihat semua',
                  style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 12,
                    color: AppColors.cyan,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ..._todayHistory.map((item) => HistoryListTile(
              eventName: item['event'] as String,
              dateLocation: '',
              time: item['time'] as String,
              isSafe: item['isSafe'] as bool,
              onTap: () => Navigator.pushNamed(context, AppRoutes.historyDetail),
            )),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 12, color: AppColors.textSecondary,
            )),
          ),
          const Text(': ', style: TextStyle(
            fontSize: 12, color: AppColors.textSecondary, fontFamily: 'Poppins',
          )),
          Expanded(
            child: Text(value, style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 12, color: AppColors.textPrimary,
            )),
          ),
        ],
      ),
    );
  }
}
