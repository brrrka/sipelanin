import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipelanin/core/providers/firebase_providers.dart';
import 'package:sipelanin/core/services/fcm_service.dart';
import 'package:sipelanin/core/services/local_notification_service.dart';
import 'package:sipelanin/core/theme/app_color_scheme.dart';
import 'package:sipelanin/features/device_status/screens/device_status_screen.dart';
import 'package:sipelanin/features/history/screens/history_screen.dart';
import 'package:sipelanin/features/home/screens/home_screen.dart';
import 'package:sipelanin/shared/widgets/connectivity_banner.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;
  bool _fcmInitialized = false;

  static const List<Widget> _screens = [
    HomeScreen(),
    DeviceStatusScreen(),
    HistoryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initFcm());
  }

  Future<void> _initFcm() async {
    if (_fcmInitialized) return;
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;

    final notifRepo = ref.read(notificationRepositoryProvider(user.uid));
    final fcm = FcmService(LocalNotificationService());
    await fcm.initialize(user.uid, notifRepo);
    _fcmInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: ConnectivityBanner(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: c.navActive,
        unselectedItemColor: c.navInactive,
        backgroundColor: c.background,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety_outlined),
            activeIcon: Icon(Icons.health_and_safety),
            label: 'Status Perangkat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }
}
