import 'package:flutter/material.dart';
import 'package:sipelanin/core/constants/app_routes.dart';
import 'package:sipelanin/core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationEnabled = true;

  void _onLogout() {
    Navigator.pushNamedAndRemoveUntil(
      context, AppRoutes.login, (route) => false,
    );
  }

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
        title: const Text('Profil & Pengaturan', style: TextStyle(
          fontFamily: 'Poppins', fontSize: 17, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        )),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: AppColors.divider),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        children: [
          // ── Profile Card ──
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Column(
              children: [
                // Avatar with cyan ring
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceLight,
                    border: Border.all(color: AppColors.cyan.withValues(alpha: 0.5), width: 2),
                    boxShadow: [BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.15),
                      blurRadius: 16, spreadRadius: 2,
                    )],
                  ),
                  child: const Icon(Icons.person, size: 40, color: AppColors.cyan),
                ),
                const SizedBox(height: 14),
                const Text('Nama Petugas', style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                )),
                const SizedBox(height: 4),
                const Text('petugas@email.com', style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 12, color: AppColors.textSecondary,
                )),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.cyanDim,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cyan.withValues(alpha: 0.4)),
                  ),
                  child: const Text('Petugas Perlintasan', style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 11, fontWeight: FontWeight.w600,
                    color: AppColors.cyan,
                  )),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Settings Section ──
          const Text('Pengaturan', style: TextStyle(
            fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          )),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Column(
              children: [
                // Notification toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.cyanDim,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.notifications_outlined,
                            color: AppColors.cyan, size: 18),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text('Notifikasi Sistem', style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 14, color: AppColors.textPrimary,
                        )),
                      ),
                      Switch(
                        value: _notificationEnabled,
                        onChanged: (val) =>
                            setState(() => _notificationEnabled = val),
                        activeThumbColor: AppColors.cyan,
                        activeTrackColor: AppColors.cyanDim,
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, indent: 52, color: AppColors.divider),

                // App version
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.info_outline,
                            color: AppColors.textSecondary, size: 18),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text('Versi Aplikasi', style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 14, color: AppColors.textPrimary,
                        )),
                      ),
                      const Text('1.0.0', style: TextStyle(
                        fontFamily: 'Poppins', fontSize: 13, color: AppColors.textHint,
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ── Log Out Button ──
          GestureDetector(
            onTap: _onLogout,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.danger.withValues(alpha: 0.5)),
                color: AppColors.dangerDim,
              ),
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.logout_rounded, color: AppColors.danger, size: 20),
                    SizedBox(width: 8),
                    Text('Log Out', style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 15,
                      fontWeight: FontWeight.w600, color: AppColors.danger,
                    )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
