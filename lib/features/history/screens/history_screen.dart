import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sipelanin/core/providers/log_provider.dart';
import 'package:sipelanin/core/theme/app_colors.dart';
import 'package:sipelanin/shared/widgets/custom_app_bar.dart';
import 'package:sipelanin/shared/widgets/history_list_tile.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  String? _selectedFilter;
  DateTime? _selectedDate;
  final _scrollController = ScrollController();

  static const List<String> _filterOptions = [
    'Semua',
    'Gagal Deteksi',
    'Kamera Error',
    'Kereta Datang',
    'Kereta Selesai',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Muat halaman berikutnya saat 200px dari bawah
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(logsProvider.notifier).fetchNextPage();
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
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
    if (picked != null) {
      setState(() => _selectedDate = picked);
      ref.read(logsProvider.notifier).applyFilter(
            eventType: _selectedFilter == 'Semua' ? null : _selectedFilter,
            date: picked,
          );
    }
  }

  void _onFilterChanged(String? val) {
    setState(() => _selectedFilter = val);
    ref.read(logsProvider.notifier).applyFilter(
          eventType: val == 'Semua' ? null : val,
          date: _selectedDate,
        );
  }

  void _clearFilters() {
    setState(() {
      _selectedFilter = null;
      _selectedDate = null;
    });
    ref.read(logsProvider.notifier).clearFilter();
  }

  @override
  Widget build(BuildContext context) {
    final logsState = ref.watch(logsProvider);

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
                  'Filter:',
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
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: AppColors.textHint)),
                        icon: const Icon(Icons.keyboard_arrow_down,
                            size: 18, color: AppColors.textSecondary),
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: AppColors.textPrimary),
                        items: _filterOptions
                            .map((f) => DropdownMenuItem(
                                  value: f,
                                  child: Text(f),
                                ))
                            .toList(),
                        onChanged: _onFilterChanged,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Tombol date picker
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _selectedDate != null
                          ? AppColors.cyanDim
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _selectedDate != null
                            ? AppColors.cyan.withValues(alpha: 0.5)
                            : AppColors.surfaceBorder,
                      ),
                    ),
                    child: Icon(
                      Icons.calendar_today_outlined,
                      size: 17,
                      color: _selectedDate != null
                          ? AppColors.cyan
                          : AppColors.cyan,
                    ),
                  ),
                ),
                // Tombol clear filter
                if (_selectedFilter != null || _selectedDate != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _clearFilters,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.dangerDim,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.danger.withValues(alpha: 0.4)),
                      ),
                      child: const Icon(Icons.close,
                          size: 17, color: AppColors.danger),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Chip tanggal yang dipilih
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.cyanDim,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.cyan.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: AppColors.cyan,
                    ),
                  ),
                ),
              ),
            ),

          // ── History List ──
          Expanded(
            child: logsState.error != null && logsState.items.isEmpty
                ? _buildError(logsState.error!)
                : logsState.isLoading && logsState.items.isEmpty
                    ? _buildShimmer()
                    : logsState.items.isEmpty
                        ? _buildEmpty()
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            itemCount: logsState.items.length +
                                (logsState.isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == logsState.items.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.cyan,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              }
                              final item = logsState.items[index];
                              return HistoryListTile(
                                eventName: item.eventType,
                                dateLocation: item.formattedDate,
                                time: item.formattedTime,
                                isSafe: item.isSafe,
                                onTap: () => context.push(
                                  '/history-detail',
                                  extra: item,
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: AppColors.surface,
        highlightColor: AppColors.surfaceLight,
        child: Column(
          children: List.generate(
            5,
            (_) => Container(
              width: double.infinity,
              height: 72,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.history, color: AppColors.textHint, size: 48),
          const SizedBox(height: 12),
          const Text(
            'Tidak ada riwayat ditemukan',
            style: TextStyle(
              fontFamily: 'Poppins', fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          if (_selectedFilter != null || _selectedDate != null)
            TextButton(
              onPressed: _clearFilters,
              child: const Text('Hapus filter',
                  style: TextStyle(color: AppColors.cyan)),
            ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat riwayat',
              style: TextStyle(
                fontFamily: 'Poppins', fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins', fontSize: 10,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () =>
                  ref.read(logsProvider.notifier).fetchInitial(),
              child: const Text('Coba lagi',
                  style: TextStyle(color: AppColors.cyan)),
            ),
          ],
        ),
      ),
    );
  }
}
