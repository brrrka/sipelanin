import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipelanin/core/providers/notification_settings_provider.dart';
import 'package:sipelanin/core/providers/theme_provider.dart';
import 'package:sipelanin/core/router/app_router.dart';
import 'package:sipelanin/core/services/fcm_service.dart';
import 'package:sipelanin/core/services/local_notification_service.dart';
import 'package:sipelanin/core/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sipelanin/firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Daftarkan handler FCM background sebelum runApp
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Inisialisasi channel notifikasi lokal
  await LocalNotificationService().initialize();
  await initializeDateFormatting('id', null);
  runApp(
    const ProviderScope(
      child: SipelaninApp(),
    ),
  );
}

class SipelaninApp extends ConsumerWidget {
  const SipelaninApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final prefsReady = ref.watch(sharedPreferencesProvider).hasValue;
    final themeMode =
        prefsReady ? ref.watch(themeModeProvider) : ThemeMode.light;

    return MaterialApp.router(
      title: 'Sistem Peringatan Dini Perlintasan Sebidang',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
