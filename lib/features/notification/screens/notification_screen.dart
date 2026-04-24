import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sipelanin/core/models/notification_model.dart';
import 'package:sipelanin/core/providers/firebase_providers.dart';
import 'package:sipelanin/core/providers/notification_provider.dart';
import 'package:sipelanin/core/theme/app_colors.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifsAsync = ref.watch(notificationsProvider);
    final uid = ref.watch(authStateProvider).valueOrNull?.uid;

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
        title: const Text('Notifikasi', style: TextStyle(
          fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        )),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: AppColors.divider),
        ),
      ),
      body: notifsAsync.when(
        loading: () => _buildShimmer(),
        error: (_, _) => _buildError(),
        data: (notifs) {
          final newNotifs = notifs.where((n) => !n.isRead).toList();
          final historyNotifs = notifs.where((n) => n.isRead).toList();

          // Tandai semua sebagai dibaca saat layar dibuka
          if (newNotifs.isNotEmpty && uid != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref
                  .read(notificationRepositoryProvider(uid))
                  .markAllRead();
            });
          }

          if (notifs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      color: AppColors.textHint, size: 48),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada notifikasi',
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

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              // Badge count header
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.cyanDim,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.cyan.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications_active,
                        color: AppColors.cyan, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      newNotifs.isEmpty
                          ? 'Tidak ada notifikasi baru'
                          : '${newNotifs.length} notifikasi baru',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: AppColors.cyan,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              if (newNotifs.isNotEmpty) ...[
                const SizedBox(height: 18),
                _SectionLabel(label: 'Notifikasi Baru'),
                const SizedBox(height: 10),
                ...newNotifs.map((n) => _NotifCard(notif: n, isNew: true)),
              ],

              if (historyNotifs.isNotEmpty) ...[
                const SizedBox(height: 20),
                _SectionLabel(label: 'Histori Notifikasi'),
                const SizedBox(height: 10),
                ...historyNotifs
                    .map((n) => _NotifCard(notif: n, isNew: false)),
              ],
            ],
          );
        },
      ),
    );
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
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: AppColors.danger, size: 40),
          SizedBox(height: 12),
          Text(
            'Gagal memuat notifikasi',
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

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label, style: const TextStyle(
      fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ));
  }
}

class _NotifCard extends StatelessWidget {
  final NotificationModel notif;
  final bool isNew;

  const _NotifCard({required this.notif, required this.isNew});

  @override
  Widget build(BuildContext context) {
    final statusColor = notif.isSafe ? AppColors.safe : AppColors.danger;
    final statusDim = notif.isSafe ? AppColors.safeDim : AppColors.dangerDim;
    final icon =
        notif.isSafe ? Icons.train_rounded : Icons.warning_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isNew
              ? statusColor.withValues(alpha: 0.3)
              : AppColors.surfaceBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(notif.title,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          )),
                    ),
                    if (isNew)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.cyan,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(notif.body,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    )),
                const SizedBox(height: 6),
                Text(notif.formattedTime,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      color: AppColors.textHint,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
