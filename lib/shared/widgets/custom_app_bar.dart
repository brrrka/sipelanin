import 'package:flutter/material.dart';
import 'package:sipelanin/core/constants/app_routes.dart';
import 'package:sipelanin/core/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.surfaceBorder),
          ),
          child: const Icon(Icons.train, size: 20, color: AppColors.cyan),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined,
              color: AppColors.textSecondary, size: 24),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.notification),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 14.0),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: const Icon(Icons.person_outline,
                  size: 18, color: AppColors.textSecondary),
            ),
          ),
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: AppColors.divider),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
