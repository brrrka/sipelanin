import 'package:flutter/material.dart';
import 'package:sipelanin/core/theme/app_color_scheme.dart';
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
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.surfaceBorder),
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
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: c.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  if (dateLocation.isNotEmpty)
                    Text(
                      dateLocation,
                      style: TextStyle(
                        fontSize: 11,
                        color: c.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                ],
              ),
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: 11,
                color: c.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
