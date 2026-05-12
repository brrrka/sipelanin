import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sipelanin/core/providers/firebase_providers.dart';
import 'package:sipelanin/core/providers/notification_settings_provider.dart';
import 'package:sipelanin/core/providers/theme_provider.dart';
import 'package:sipelanin/core/theme/app_color_scheme.dart';
import 'package:sipelanin/core/theme/app_colors.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final user = ref.watch(authStateProvider).valueOrNull;
    final notifEnabled = ref.watch(notificationSettingsProvider);
    final prefsReady = ref.watch(sharedPreferencesProvider).hasValue;
    final themeMode =
        prefsReady ? ref.watch(themeModeProvider) : ThemeMode.light;

    final displayName = user?.displayName ?? 'Petugas Perlintasan';
    final email = user?.email ?? 'petugas@email.com';

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
        title: Text('Profil & Pengaturan', style: TextStyle(
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        children: [
          // ── Profile Card ──
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: c.surfaceBorder),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: c.surfaceLight,
                    border: Border.all(
                        color: c.accent.withValues(alpha: 0.5), width: 2),
                    boxShadow: [BoxShadow(
                      color: c.accent.withValues(alpha: 0.15),
                      blurRadius: 16, spreadRadius: 2,
                    )],
                  ),
                  child: Icon(Icons.person, size: 40, color: c.accent),
                ),
                const SizedBox(height: 14),
                Text(displayName, style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                )),
                const SizedBox(height: 4),
                Text(email, style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 12,
                  color: c.textSecondary,
                )),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: c.accentDim,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: c.accent.withValues(alpha: 0.4)),
                  ),
                  child: Text('Petugas Perlintasan', style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 11,
                    fontWeight: FontWeight.w600, color: c.accent,
                  )),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Settings Section ──
          Text('Pengaturan', style: TextStyle(
            fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600,
            color: c.textSecondary,
          )),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: c.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.surfaceBorder),
            ),
            child: Column(
              children: [
                // Notification toggle
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: c.accentDim,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.notifications_outlined,
                            color: c.accent, size: 18),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text('Notifikasi Sistem', style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 14,
                          color: c.textPrimary,
                        )),
                      ),
                      if (prefsReady)
                        Switch(
                          value: notifEnabled,
                          onChanged: (val) => ref
                              .read(notificationSettingsProvider.notifier)
                              .toggle(val),
                          activeThumbColor: c.accent,
                          activeTrackColor: c.accentDim,
                        )
                      else
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: c.accent,
                          ),
                        ),
                    ],
                  ),
                ),

                Divider(height: 1, indent: 52, color: c.divider),

                // Theme toggle
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: c.accentDim,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          themeMode == ThemeMode.dark
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                          color: c.accent,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text('Mode Tampilan', style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 14,
                          color: c.textPrimary,
                        )),
                      ),
                      if (prefsReady)
                        Switch(
                          value: themeMode == ThemeMode.dark,
                          onChanged: (_) =>
                              ref.read(themeModeProvider.notifier).toggle(),
                          activeThumbColor: c.accent,
                          activeTrackColor: c.accentDim,
                        )
                      else
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: c.accent,
                          ),
                        ),
                    ],
                  ),
                ),

                Divider(height: 1, indent: 52, color: c.divider),

                // App version
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: c.surfaceLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.info_outline,
                            color: c.textSecondary, size: 18),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text('Versi Aplikasi', style: TextStyle(
                          fontFamily: 'Poppins', fontSize: 14,
                          color: c.textPrimary,
                        )),
                      ),
                      Text('1.0.0', style: TextStyle(
                        fontFamily: 'Poppins', fontSize: 13,
                        color: c.textHint,
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
            onTap: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) context.go('/login');
            },
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.danger.withValues(alpha: 0.5)),
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
