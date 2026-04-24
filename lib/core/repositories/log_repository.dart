import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sipelanin/core/models/log_event_model.dart';

class LogRepository {
  final FirebaseFirestore _firestore;
  static const int _pageSize = 20;

  const LogRepository(this._firestore);

  /// Ambil satu halaman logs dengan filter opsional dan cursor pagination
  Future<(List<LogEventModel>, DocumentSnapshot?)> fetchLogsPage({
    DocumentSnapshot? startAfter,
    String? filterEventType,
    DateTime? filterDate,
  }) async {
    Query query = _firestore
        .collection('logs')
        .orderBy('timestamp', descending: true)
        .limit(_pageSize);

    if (filterEventType != null &&
        filterEventType != 'Semua' &&
        filterEventType.isNotEmpty) {
      query = query.where('event_type', isEqualTo: filterEventType);
    }

    if (filterDate != null) {
      final start = Timestamp.fromDate(
        DateTime(filterDate.year, filterDate.month, filterDate.day),
      );
      final end = Timestamp.fromDate(
        DateTime(filterDate.year, filterDate.month, filterDate.day, 23, 59, 59),
      );
      query = query
          .where('timestamp', isGreaterThanOrEqualTo: start)
          .where('timestamp', isLessThanOrEqualTo: end);
    }

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();
    final items = snapshot.docs.map(LogEventModel.fromFirestore).toList();
    final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
    return (items, lastDoc);
  }

  /// Ambil logs hari ini saja (untuk HomeScreen, limit 10)
  Future<List<LogEventModel>> fetchTodayLogs() async {
    final now = DateTime.now();
    final start = Timestamp.fromDate(
      DateTime(now.year, now.month, now.day),
    );
    final snapshot = await _firestore
        .collection('logs')
        .where('timestamp', isGreaterThanOrEqualTo: start)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();
    return snapshot.docs.map(LogEventModel.fromFirestore).toList();
  }
}
