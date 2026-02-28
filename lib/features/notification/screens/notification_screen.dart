import 'package:flutter/material.dart';
import 'package:sipelanin/core/theme/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const List<Map<String, dynamic>> _newNotifs = [
    {
      'title': 'Kereta Terdeteksi',
      'body': 'Kereta terdeteksi melintas di perlintasan. Status sistem: SAFE.',
      'time': '08.32 WIB',
      'isSafe': true,
      'icon': Icons.train_rounded,
    },
    {
      'title': 'Gagal Deteksi',
      'body': 'Sistem gagal mendeteksi kereta. Periksa perangkat sensing segera.',
      'time': '07.15 WIB',
      'isSafe': false,
      'icon': Icons.warning_rounded,
    },
  ];

  static const List<Map<String, dynamic>> _historyNotifs = [
    {
      'title': 'Kereta Terdeteksi',
      'body': 'Kereta terdeteksi melintas. Status: SAFE.',
      'time': 'Kemarin, 14.20 WIB',
      'isSafe': true,
      'icon': Icons.train_rounded,
    },
    {
      'title': 'Kereta Terdeteksi',
      'body': 'Kereta terdeteksi melintas. Status: SAFE.',
      'time': 'Kemarin, 10.05 WIB',
      'isSafe': true,
      'icon': Icons.train_rounded,
    },
    {
      'title': 'Perangkat Standby',
      'body': 'Kamera beralih ke mode standby otomatis.',
      'time': 'Kemarin, 09.00 WIB',
      'isSafe': true,
      'icon': Icons.camera_alt_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18,
              color: AppColors.textPrimary),
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // Badge count header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.cyanDim,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cyan.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.notifications_active, color: AppColors.cyan, size: 18),
                const SizedBox(width: 8),
                Text('${_newNotifs.length} notifikasi baru',
                  style: const TextStyle(
                    fontFamily: 'Poppins', fontSize: 13,
                    color: AppColors.cyan, fontWeight: FontWeight.w500,
                  )),
              ],
            ),
          ),

          const SizedBox(height: 18),
          _SectionLabel(label: 'Notifikasi Baru'),
          const SizedBox(height: 10),
          ..._newNotifs.map((n) => _NotifCard(notif: n, isNew: true)),

          const SizedBox(height: 20),
          _SectionLabel(label: 'Histori Notifikasi'),
          const SizedBox(height: 10),
          ..._historyNotifs.map((n) => _NotifCard(notif: n, isNew: false)),
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
  final Map<String, dynamic> notif;
  final bool isNew;

  const _NotifCard({required this.notif, required this.isNew});

  @override
  Widget build(BuildContext context) {
    final isSafe = notif['isSafe'] as bool;
    final statusColor = isSafe ? AppColors.safe : AppColors.danger;
    final statusDim = isSafe ? AppColors.safeDim : AppColors.dangerDim;

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
              color: statusDim, borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(notif['icon'] as IconData,
                color: statusColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(notif['title'] as String,
                        style: const TextStyle(
                          fontFamily: 'Poppins', fontSize: 13,
                          fontWeight: FontWeight.w600, color: AppColors.textPrimary,
                        )),
                    ),
                    if (isNew)
                      Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.cyan, shape: BoxShape.circle),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(notif['body'] as String, style: const TextStyle(
                  fontFamily: 'Poppins', fontSize: 11,
                  color: AppColors.textSecondary, height: 1.5,
                )),
                const SizedBox(height: 6),
                Text(notif['time'] as String, style: const TextStyle(
                  fontFamily: 'Poppins', fontSize: 10, color: AppColors.textHint,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
