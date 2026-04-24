import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sipelanin/core/models/log_event_model.dart';
import 'package:sipelanin/core/providers/firebase_providers.dart';
import 'package:sipelanin/core/repositories/log_repository.dart';

class LogsState {
  final List<LogEventModel> items;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final String? filterEventType;
  final DateTime? filterDate;

  const LogsState({
    required this.items,
    required this.isLoading,
    required this.hasMore,
    this.error,
    this.filterEventType,
    this.filterDate,
  });

  LogsState copyWith({
    List<LogEventModel>? items,
    bool? isLoading,
    bool? hasMore,
    String? error,
    String? filterEventType,
    DateTime? filterDate,
    bool clearError = false,
    bool clearFilter = false,
    bool clearDate = false,
  }) {
    return LogsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : error ?? this.error,
      filterEventType:
          clearFilter ? null : filterEventType ?? this.filterEventType,
      filterDate: clearDate ? null : filterDate ?? this.filterDate,
    );
  }
}

class LogsNotifier extends StateNotifier<LogsState> {
  final LogRepository _repo;
  DocumentSnapshot? _lastDocument;

  LogsNotifier(this._repo)
      : super(const LogsState(items: [], isLoading: false, hasMore: true)) {
    fetchInitial();
  }

  /// Reset cursor dan ambil halaman pertama dengan filter aktif
  Future<void> fetchInitial() async {
    _lastDocument = null;
    state = state.copyWith(
      isLoading: true,
      items: [],
      hasMore: true,
      clearError: true,
    );
    try {
      final (items, lastDoc) = await _repo.fetchLogsPage(
        filterEventType: state.filterEventType,
        filterDate: state.filterDate,
      );
      _lastDocument = lastDoc;
      state = state.copyWith(
        items: items,
        isLoading: false,
        hasMore: items.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Ambil halaman berikutnya (dipanggil saat scroll ke bawah)
  Future<void> fetchNextPage() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true);
    try {
      final (newItems, lastDoc) = await _repo.fetchLogsPage(
        startAfter: _lastDocument,
        filterEventType: state.filterEventType,
        filterDate: state.filterDate,
      );
      _lastDocument = lastDoc;
      state = state.copyWith(
        items: [...state.items, ...newItems],
        isLoading: false,
        hasMore: newItems.length >= 20,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Terapkan filter baru, reset halaman dari awal
  void applyFilter({String? eventType, DateTime? date}) {
    state = state.copyWith(
      filterEventType: eventType,
      filterDate: date,
      clearFilter: eventType == null,
      clearDate: date == null,
    );
    fetchInitial();
  }

  void clearFilter() {
    state = state.copyWith(clearFilter: true, clearDate: true);
    fetchInitial();
  }
}

final logsProvider = StateNotifierProvider<LogsNotifier, LogsState>((ref) {
  return LogsNotifier(ref.watch(logRepositoryProvider));
});

/// Logs hari ini saja — untuk HomeScreen
final todayLogsProvider = FutureProvider<List<LogEventModel>>((ref) {
  return ref.watch(logRepositoryProvider).fetchTodayLogs();
});
