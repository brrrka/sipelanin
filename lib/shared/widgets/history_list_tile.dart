import 'package:flutter/material.dart';
import 'package:sipelanin/core/theme/app_colors.dart';
import 'package:sipelanin/shared/widgets/status_badge.dart';

class HistoryListTile extends StatelessWidget {
  final String eventName;
  final String dateLocation;
  final String time;
  final bool isSafe;
  final VoidCallback? onTap;

  const HistoryListTile({
    super.key,
    required this.eventName,
    required this.dateLocation,
    required this.time,
    required this.isSafe,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Row(
          children: [
            isSafe ? StatusBadge.safe() : StatusBadge.danger(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  if (dateLocation.isNotEmpty)
                    Text(
                      dateLocation,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                ],
              ),
            ),
            Text(
              time,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
