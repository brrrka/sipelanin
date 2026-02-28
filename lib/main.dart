import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sipelanin/core/constants/app_routes.dart';
import 'package:sipelanin/core/theme/app_theme.dart';
import 'package:sipelanin/features/splash/screens/splash_screen.dart';
import 'package:sipelanin/features/auth/screens/login_screen.dart';
import 'package:sipelanin/features/main/screens/main_screen.dart';
import 'package:sipelanin/features/history/screens/history_detail_screen.dart';
import 'package:sipelanin/features/notification/screens/notification_screen.dart';
import 'package:sipelanin/features/profile/screens/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const SipelaninApp());
}

class SipelaninApp extends StatelessWidget {
  const SipelaninApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Peringatan Dini Perlintasan Sebidang',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.main: (context) => const MainScreen(),
        AppRoutes.notification: (context) => const NotificationScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.historyDetail) {
          return MaterialPageRoute(
            builder: (context) => const HistoryDetailScreen(),
          );
        }
        return null;
      },
    );
  }
}
