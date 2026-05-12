import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sipelanin/core/providers/log_provider.dart';
import 'package:sipelanin/core/theme/app_color_scheme.dart';
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(logsProvider.notifier).fetchNextPage();
    }
  }

  Future<void> _pickDate() async {
    final c = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: isDark
                ? ColorScheme.dark(
                    primary: c.accent,
                    onPrimary: c.background,
                    surface: c.surface,
                    onSurface: c.textPrimary,
                  )
                : ColorScheme.light(
                    primary: c.accent,
                    onPrimary: Colors.white,
                    surface: c.surface,
                    onSurface: c.textPrimary,
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
    final c = context.colors;
    final logsState = ref.watch(logsProvider);

    return Scaffold(
      backgroundColor: c.background,
      appBar: const CustomAppBar(title: 'Riwayat'),
      body: Column(
        children: [
          // ── Filter Bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text(
                  'Filter:',
                  style: TextStyle(
                    fontFamily: 'Poppins', fontSize: 12,
                    color: c.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: c.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: c.surfaceBorder),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        dropdownColor: c.surface,
                        hint: Text('Pilih filter',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: c.textHint)),
                        icon: Icon(Icons.keyboard_arrow_down,
                            size: 18, color: c.textSecondary),
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: c.textPrimary),
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
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _selectedDate != null
                          ? c.accentDim
                          : c.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _selectedDate != null
                            ? c.accent.withValues(alpha: 0.5)
                            : c.surfaceBorder,
                      ),
                    ),
                    child: Icon(
                      Icons.calendar_today_outlined,
                      size: 17,
                      color: c.accent,
                    ),
                  ),
                ),
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
                    color: c.accentDim,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: c.accent.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: c.accent,
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
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: c.accent,
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
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Shimmer.fromColors(
        baseColor: c.surface,
        highlightColor: c.surfaceLight,
        child: Column(
          children: List.generate(
            5,
            (_) => Container(
              width: double.infinity,
              height: 72,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    final c = context.colors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history, color: c.textHint, size: 48),
          const SizedBox(height: 12),
          Text(
            'Tidak ada riwayat ditemukan',
            style: TextStyle(
              fontFamily: 'Poppins', fontSize: 14,
              color: c.textSecondary,
            ),
          ),
          if (_selectedFilter != null || _selectedDate != null)
            TextButton(
              onPressed: _clearFilters,
              child: Text('Hapus filter',
                  style: TextStyle(color: c.accent)),
            ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
            const SizedBox(height: 12),
            Text(
              'Gagal memuat riwayat',
              style: TextStyle(
                fontFamily: 'Poppins', fontSize: 14,
                color: c.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins', fontSize: 10,
                color: c.textHint,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () =>
                  ref.read(logsProvider.notifier).fetchInitial(),
              child: Text('Coba lagi',
                  style: TextStyle(color: c.accent)),
            ),
          ],
        ),
      ),
    );
  }
}
