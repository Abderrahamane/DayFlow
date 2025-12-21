import 'package:dayflow/data/local/app_database.dart';
import 'package:dayflow/models/notification_model.dart';
import 'package:dayflow/services/firestore_service.dart';

class NotificationRepository {
  final AppDatabase _localDb;
  final FirestoreService _firestoreService;

  NotificationRepository(this._localDb, this._firestoreService);

  bool get _isRemote => _firestoreService.currentUserId != null;

  Future<void> _ensureDb() async => _localDb.init();

  Future<List<AppNotification>> fetchNotifications({int limit = 10, AppNotification? startAfter}) async {
    final now = DateTime.now();

    if (_isRemote) {
      final collection = _firestoreService.notifications;
      if (collection == null) return [];

      var query = collection
          .where('timestamp', isLessThanOrEqualTo: now.toIso8601String())
          .orderBy('timestamp', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfter([startAfter.timestamp.toIso8601String()]);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        return AppNotification.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } else {
      await _ensureDb();

      String sql = 'SELECT * FROM notifications WHERE timestamp <= ?';
      List<Object> args = [now.millisecondsSinceEpoch];

      if (startAfter != null) {
        sql += ' AND timestamp < ?';
        args.add(startAfter.timestamp.millisecondsSinceEpoch);
      }

      sql += ' ORDER BY timestamp DESC LIMIT ?';
      args.add(limit);

      final result = _localDb.rawDb.select(sql, args);
      return result.map((row) => AppNotification.fromDatabase(row)).toList();
    }
  }

  Future<void> saveNotification(AppNotification notification) async {
    if (_isRemote) {
      final collection = _firestoreService.notifications;
      if (collection == null) return;
      await collection.doc(notification.id).set(notification.toFirestore());
    } else {
      await _ensureDb();
      final data = notification.toDatabase();
      _localDb.rawDb.execute(
        '''INSERT OR REPLACE INTO notifications 
          (id, title, body, timestamp, isRead, payload) 
          VALUES (?, ?, ?, ?, ?, ?)''',
        [
          data['id'],
          data['title'],
          data['body'],
          data['timestamp'],
          data['isRead'],
          data['payload'],
        ],
      );
    }
  }

  Future<void> markAsRead(String id) async {
    if (_isRemote) {
      final collection = _firestoreService.notifications;
      if (collection == null) return;
      await collection.doc(id).update({'isRead': true});
    } else {
      await _ensureDb();
      _localDb.rawDb.execute('UPDATE notifications SET isRead = 1 WHERE id = ?', [id]);
    }
  }
}
