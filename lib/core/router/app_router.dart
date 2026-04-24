import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sipelanin/core/models/log_event_model.dart';
import 'package:sipelanin/core/providers/firebase_providers.dart';
import 'package:sipelanin/features/auth/screens/login_screen.dart';
import 'package:sipelanin/features/history/screens/history_detail_screen.dart';
import 'package:sipelanin/features/main/screens/main_screen.dart';
import 'package:sipelanin/features/notification/screens/notification_screen.dart';
import 'package:sipelanin/features/profile/screens/profile_screen.dart';
import 'package:sipelanin/features/splash/screens/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isSplash = state.matchedLocation == '/splash';

      // Splash menangani routingnya sendiri — jangan di-redirect
      if (isSplash) return null;

      // Belum login → ke halaman login
      if (!isLoggedIn) return '/login';

      // Sudah login tapi mencoba akses /login → ke main
      if (state.matchedLocation == '/login') return '/main';

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: '/main',
        builder: (_, _) => const MainScreen(),
      ),
      GoRoute(
        path: '/history-detail',
        builder: (_, state) {
          final log = state.extra as LogEventModel;
          return HistoryDetailScreen(log: log);
        },
      ),
      GoRoute(
        path: '/notification',
        builder: (_, _) => const NotificationScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (_, _) => const ProfileScreen(),
      ),
    ],
  );
});
