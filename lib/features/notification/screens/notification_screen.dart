import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sipelanin/core/models/notification_model.dart';
import 'package:sipelanin/core/providers/firebase_providers.dart';
import 'package:sipelanin/core/providers/notification_provider.dart';
import 'package:sipelanin/core/theme/app_color_scheme.dart';
import 'package:sipelanin/core/theme/app_colors.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final notifsAsync = ref.watch(notificationsProvider);
    final uid = ref.watch(authStateProvider).valueOrNull?.uid;

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
        title: Text('Notifikasi', style: TextStyle(
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
      body: notifsAsync.when(
        loading: () => _buildShimmer(context),
        error: (_, _) => _buildError(context),
        data: (notifs) {
          final newNotifs = notifs.where((n) => !n.isRead).toList();
          final historyNotifs = notifs.where((n) => n.isRead).toList();

          if (newNotifs.isNotEmpty && uid != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref
                  .read(notificationRepositoryProvider(uid))
                  .markAllRead();
            });
          }

          if (notifs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_off_outlined,
                      color: c.textHint, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'Belum ada notifikasi',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: c.accentDim,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: c.accent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.notifications_active,
                        color: c.accent, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      newNotifs.isEmpty
                          ? 'Tidak ada notifikasi baru'
                          : '${newNotifs.length} notifikasi baru',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: c.accent,
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

  Widget _buildShimmer(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: c.surface,
        highlightColor: c.surfaceLight,
        child: Column(
          children: List.generate(
            4,
            (_) => Container(
              width: double.infinity,
              height: 80,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
          const SizedBox(height: 12),
          Text(
            'Gagal memuat notifikasi',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: c.textSecondary,
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
    return Text(label, style: TextStyle(
      fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600,
      color: context.colors.textPrimary,
    ));
  }
}

class _NotifCard extends StatelessWidget {
  final NotificationModel notif;
  final bool isNew;

  const _NotifCard({required this.notif, required this.isNew});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final statusColor = notif.isSafe ? AppColors.safe : AppColors.danger;
    final statusDim = notif.isSafe ? AppColors.safeDim : AppColors.dangerDim;
    final icon =
        notif.isSafe ? Icons.train_rounded : Icons.warning_rounded;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isNew
              ? statusColor.withValues(alpha: 0.3)
              : c.surfaceBorder,
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
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: c.textPrimary,
                          )),
                    ),
                    if (isNew)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: c.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(notif.body,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: c.textSecondary,
                      height: 1.5,
                    )),
                const SizedBox(height: 6),
                Text(notif.formattedTime,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      color: c.textHint,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
