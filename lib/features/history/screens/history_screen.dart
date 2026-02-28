import 'package:flutter/material.dart';
import 'package:sipelanin/core/constants/app_routes.dart';
import 'package:sipelanin/core/theme/app_colors.dart';
import 'package:sipelanin/shared/widgets/custom_app_bar.dart';
import 'package:sipelanin/shared/widgets/history_list_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _selectedFilter;

  static const List<Map<String, dynamic>> _historyData = [
    {'event': 'Kereta melintas', 'date': 'Senin, 00/00/0000', 'time': '08.32 WIB', 'isSafe': true},
    {'event': 'Kereta melintas', 'date': 'Senin, 00/00/0000', 'time': '07.15 WIB', 'isSafe': true},
    {'event': 'Sistem gagal deteksi', 'date': 'Senin, 00/00/0000', 'time': '06.55 WIB', 'isSafe': false},
    {'event': 'Kereta melintas', 'date': 'Senin, 00/00/0000', 'time': '05.40 WIB', 'isSafe': true},
    {'event': 'Kereta melintas', 'date': 'Senin, 00/00/0000', 'time': '04.20 WIB', 'isSafe': true},
  ];

  static const List<String> _filterOptions = [
    'Semua', 'SAFE', 'DANGER', 'Kereta melintas', 'Sistem gagal deteksi',
  ];

  Future<void> _pickDate() async {
    // Placeholder: akan diimplementasikan dengan filter data
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.cyan,
              onPrimary: AppColors.background,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Riwayat'),
      body: Column(
        children: [
          // ── Filter Bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                const Text(
                  'Filter Berdasarkan:',
                  style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        dropdownColor: AppColors.surface,
                        hint: const Text('Pilih filter',
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 12,
                              color: AppColors.textHint)),
                        icon: const Icon(Icons.keyboard_arrow_down,
                            size: 18, color: AppColors.textSecondary),
                        style: const TextStyle(fontFamily: 'Poppins',
                            fontSize: 12, color: AppColors.textPrimary),
                        items: _filterOptions.map((f) => DropdownMenuItem(
                          value: f,
                          child: Text(f),
                        )).toList(),
                        onChanged: (val) => setState(() => _selectedFilter = val),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: const Icon(Icons.calendar_today_outlined,
                        size: 17, color: AppColors.cyan),
                  ),
                ),
              ],
            ),
          ),

          // ── History List ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _historyData.length,
              itemBuilder: (context, index) {
                final item = _historyData[index];
                return HistoryListTile(
                  eventName: item['event'] as String,
                  dateLocation: item['date'] as String,
                  time: item['time'] as String,
                  isSafe: item['isSafe'] as bool,
                  onTap: () =>
                      Navigator.pushNamed(context, AppRoutes.historyDetail),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
