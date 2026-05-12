import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sipelanin/core/providers/current_status_provider.dart';
import 'package:sipelanin/core/providers/log_provider.dart';
import 'package:sipelanin/core/theme/app_color_scheme.dart';
import 'package:sipelanin/core/theme/app_colors.dart';
import 'package:sipelanin/shared/widgets/custom_app_bar.dart';
import 'package:sipelanin/shared/widgets/history_list_tile.dart';
import 'package:sipelanin/shared/widgets/status_badge.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final statusAsync = ref.watch(currentStatusProvider);
    final todayAsync = ref.watch(todayLogsProvider);

    return Scaffold(
      backgroundColor: c.background,
      appBar: const CustomAppBar(title: 'Home'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'Status Terkini',
              style: TextStyle(
                fontFamily: 'Poppins', fontSize: 15, fontWeight: FontWeight.w600,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(height: 10),

            // ── Main Status Card ──
            statusAsync.when(
              loading: () => _shimmerCard(context),
              error: (e, _) => _errorCard(context, 'Gagal memuat status sistem'),
              data: (status) {
                if (status == null) {
                  return _errorCard(context, 'Data sistem tidak tersedia');
                }

                final statusColor =
                    status.isSafe ? AppColors.safe : AppColors.danger;
                final statusDimColor =
                    status.isSafe ? AppColors.safeDim : AppColors.dangerDim;
                final headerText = status.isSafe
                    ? 'Sistem beroperasi dengan baik'
                    : 'PERINGATAN: Kereta terdeteksi!';

                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: statusColor.withValues(alpha: 0.3)),
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
                                headerText,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ),
                            status.isSafe
                                ? StatusBadge.safe()
                                : StatusBadge.danger(),
                          ],
                        ),
                      ),
                      _InfoRow(
                          label: 'Lokasi Sistem',
                          value: status.lokasiSistem),
                      Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: c.divider),
                      _InfoRow(
                          label: 'Deteksi Terakhir',
                          value: status.deteksiTerakhir),
                      Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: c.divider),
                      _InfoRow(
                          label: 'Scan Terakhir',
                          value: status.scanTerakhir),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // ── Current Train Status Card ──
            statusAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (status) {
                final isSafe = status?.isSafe ?? true;
                final trainText = isSafe
                    ? 'Tidak ada kereta melintas'
                    : 'Kereta sedang melintas!';
                final iconColor =
                    isSafe ? AppColors.safe : AppColors.danger;
                final bgColor = isSafe
                    ? AppColors.safe.withValues(alpha: 0.1)
                    : AppColors.danger.withValues(alpha: 0.1);

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: c.surfaceBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.directions_railway,
                            color: iconColor, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        trainText,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: c.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // ── Riwayat Hari Ini ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Riwayat Hari Ini',
                  style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 15,
                    fontWeight: FontWeight.w600, color: c.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Lihat semua',
                    style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 12,
                      color: c.accent, fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            todayAsync.when(
              loading: () => Column(
                children: List.generate(
                  3,
                  (_) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _shimmerTile(context),
                  ),
                ),
              ),
              error: (e, _) => _errorCard(context, 'Gagal memuat riwayat hari ini'),
              data: (logs) {
                if (logs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'Belum ada kejadian hari ini',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: c.textSecondary,
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  children: logs.map((log) => HistoryListTile(
                    eventName: log.eventType,
                    dateLocation: log.formattedDate,
                    time: log.formattedTime,
                    isSafe: log.isSafe,
                    onTap: () => context.push('/history-detail', extra: log),
                  )).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerCard(BuildContext context) {
    final c = context.colors;
    return Shimmer.fromColors(
      baseColor: c.surface,
      highlightColor: c.surfaceLight,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _shimmerTile(BuildContext context) {
    final c = context.colors;
    return Shimmer.fromColors(
      baseColor: c.surface,
      highlightColor: c.surfaceLight,
      child: Container(
        width: double.infinity,
        height: 72,
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _errorCard(BuildContext context, String message) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
          const SizedBox(width: 10),
          Text(message, style: TextStyle(
            fontFamily: 'Poppins', fontSize: 13,
            color: c.textSecondary,
          )),
        ],
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
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(
              fontFamily: 'Poppins', fontSize: 12,
              color: c.textSecondary,
            )),
          ),
          Text(': ', style: TextStyle(
            fontSize: 12, color: c.textSecondary, fontFamily: 'Poppins',
          )),
          Expanded(
            child: Text(value, style: TextStyle(
              fontFamily: 'Poppins', fontSize: 12,
              color: c.textPrimary,
            )),
          ),
        ],
      ),
    );
  }
}
