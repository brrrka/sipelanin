import 'package:flutter/material.dart';
import 'package:sipelanin/core/theme/app_colors.dart';
import 'package:sipelanin/features/home/screens/home_screen.dart';
import 'package:sipelanin/features/device_status/screens/device_status_screen.dart';
import 'package:sipelanin/features/history/screens/history_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    DeviceStatusScreen(),
    HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: AppColors.navActive,
          unselectedItemColor: AppColors.navInactive,
          backgroundColor: AppColors.background,
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
      ),
    );
  }
}
