import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipelanin/core/providers/connectivity_provider.dart';
import 'package:sipelanin/core/theme/app_colors.dart';

/// Wrapper widget yang menampilkan banner merah di atas child
/// jika koneksi ke Firebase RTDB terputus.
class ConnectivityBanner extends ConsumerWidget {
  final Widget child;

  const ConnectivityBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(connectivityProvider).valueOrNull ?? true;

    return Column(
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: isConnected
              ? const SizedBox.shrink()
              : Container(
                  width: double.infinity,
                  color: AppColors.danger,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 14, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'Koneksi terputus — data mungkin tidak terkini',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
