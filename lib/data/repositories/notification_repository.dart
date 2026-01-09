import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dayflow/data/local/app_database.dart';
import 'package:dayflow/models/notification_model.dart';
import 'package:dayflow/services/firestore_service.dart';
import 'package:dayflow/services/backend_api_service.dart';

class NotificationRepository {
  final AppDatabase _localDb;
  final FirestoreService _firestoreService;
  final BackendApiService? _api;

  NotificationRepository(this._localDb, this._firestoreService,
      {BackendApiService? api})
      : _api = api;

  /// Check if backend API sync is available
  bool get _useBackend =>
      _api != null && _firestoreService.currentUserId != null;

  /// Check if Firestore sync is available (just needs logged in user)
  bool get _useFirestore => _firestoreService.currentUserId != null;

  Future<void> _ensureDb() async => _localDb.init();

  Future<void> _upsertNotificationFirestore(
      AppNotification notification) async {
    final col = _firestoreService.notifications;
    if (col == null) return;
    await col.doc(notification.id).set({
      'id': notification.id,
      'title': notification.title,
      'body': notification.body,
      'timestamp': Timestamp.fromDate(notification.timestamp),
      'isRead': notification.isRead,
      'payload': notification.payload,
    });
  }

  Future<void> _deleteNotificationFirestore(String id) async {
    final col = _firestoreService.notifications;
    if (col == null) return;
    await col.doc(id).delete();
  }

  Future<void> _markReadFirestore(String id) async {
    final col = _firestoreService.notifications;
    if (col == null) return;
    await col.doc(id).update({'isRead': true});
  }

  Future<void> _cacheNotificationsLocal(
      List<AppNotification> notifications) async {
    await _ensureDb();
    _localDb.rawDb.execute('DELETE FROM notifications');
    for (final n in notifications) {
      await _saveNotificationLocal(n);
    }
  }

  Future<List<AppNotification>> _fetchNotificationsLocal(
      {int limit = 10, AppNotification? startAfter}) async {
    await _ensureDb();
    final now = DateTime.now();

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

  Future<void> _saveNotificationLocal(AppNotification notification) async {
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
    print('✅ Notification saved to local DB: ${notification.id}');
  }

  Future<void> _markLocalRead(String id) async {
    await _ensureDb();
    _localDb.rawDb
        .execute('UPDATE notifications SET isRead = 1 WHERE id = ?', [id]);
  }

  /// LOCAL-FIRST: Return local data immediately, sync in background
  Future<List<AppNotification>> fetchNotifications(
      {int limit = 10, AppNotification? startAfter}) async {
    print('🔔 NotificationRepository.fetchNotifications() - LOCAL FIRST');

    // Always fetch from local first for instant UI
    final localNotifications =
        await _fetchNotificationsLocal(limit: limit, startAfter: startAfter);
    print('🔔 Got ${localNotifications.length} notifications from local DB');

    // Sync from backend in background
    if (_useBackend) {
      _syncNotificationsFromBackend(limit: limit, startAfter: startAfter);
    }

    return localNotifications;
  }

  Future<void> _syncNotificationsFromBackend(
      {int limit = 10, AppNotification? startAfter}) async {
    try {
      final cursor = startAfter?.timestamp.toIso8601String();
      final notifications =
          await _api!.fetchNotifications(limit: limit, cursor: cursor);
      await _cacheNotificationsLocal(notifications);
      print('✅ Background: synced ${notifications.length} notifications');
    } catch (e) {
      print('⚠️ Background notification sync failed: $e');
    }
  }

  /// LOCAL-FIRST: Save locally immediately, sync to Firestore and backend in background
  Future<void> saveNotification(AppNotification notification) async {
    print('🔔 NotificationRepository.saveNotification() - LOCAL FIRST');

    await _saveNotificationLocal(notification);

    if (_useFirestore) {
      _syncNotificationToFirestore(notification);
    }

    if (_useBackend) {
      _syncNotificationToBackend(notification);
    }
  }

  Future<void> _syncNotificationToFirestore(
      AppNotification notification) async {
    try {
      await _upsertNotificationFirestore(notification);
      print('✅ Notification synced to Firestore: ${notification.id}');
    } catch (e) {
      print('⚠️ Firestore notification sync failed: $e');
    }
  }

  Future<void> _syncNotificationToBackend(AppNotification notification) async {
    try {
      await _api!.createNotification(notification);
      print('✅ Background: notification synced to backend');
    } catch (e) {
      print('⚠️ Background notification sync failed: $e');
    }
  }

  /// LOCAL-FIRST: Mark read locally immediately, sync in background
  Future<void> markAsRead(String id) async {
    print('🔔 NotificationRepository.markAsRead() - LOCAL FIRST');

    await _markLocalRead(id);

    if (_useFirestore) {
      _markReadInFirestore(id);
    }

    if (_useBackend) {
      _markReadBackend(id);
    }
  }

  Future<void> _markReadInFirestore(String id) async {
    try {
      await _markReadFirestore(id);
      print('✅ Notification marked read in Firestore');
    } catch (e) {
      print('⚠️ Firestore mark read failed: $e');
    }
  }

  Future<void> _markReadBackend(String id) async {
    try {
      await _api!.markNotificationRead(id);
      print('✅ Background: mark read synced');
    } catch (e) {
      print('⚠️ Background mark read failed: $e');
    }
  }

  /// LOCAL-FIRST: Mark all read locally immediately, sync in background
  Future<int> markAllAsRead() async {
    print('🔔 NotificationRepository.markAllAsRead() - LOCAL FIRST');

    await _ensureDb();
    final result = _localDb.rawDb
        .select('SELECT COUNT(*) as count FROM notifications WHERE isRead = 0');
    final count = result.first['count'] as int;
    _localDb.rawDb.execute('UPDATE notifications SET isRead = 1');

    if (_useFirestore) {
      _markAllReadInFirestore();
    }

    if (_useBackend) {
      _markAllReadBackend();
    }

    return count;
  }

  Future<void> _markAllReadInFirestore() async {
    try {
      final col = _firestoreService.notifications;
      if (col == null) return;
      final unread = await col.where('isRead', isEqualTo: false).get();
      for (final doc in unread.docs) {
        await doc.reference.update({'isRead': true});
      }
      print('✅ All notifications marked read in Firestore');
    } catch (e) {
      print('⚠️ Firestore mark all read failed: $e');
    }
  }

  Future<void> _markAllReadBackend() async {
    try {
      await _api!.markAllNotificationsRead();
      print('✅ Background: mark all read synced');
    } catch (e) {
      print('⚠️ Background mark all read failed: $e');
    }
  }

  /// LOCAL-FIRST: Delete locally immediately, sync in background
  Future<void> deleteNotification(String id) async {
    print('🔔 NotificationRepository.deleteNotification() - LOCAL FIRST');

    await _ensureDb();
    _localDb.rawDb.execute('DELETE FROM notifications WHERE id = ?', [id]);
    print('✅ Notification deleted from local DB');

    if (_useFirestore) {
      _deleteNotificationFromFirestore(id);
    }

    if (_useBackend) {
      _deleteNotificationFromBackend(id);
    }
  }

  Future<void> _deleteNotificationFromFirestore(String id) async {
    try {
      await _deleteNotificationFirestore(id);
      print('✅ Notification deleted from Firestore: $id');
    } catch (e) {
      print('⚠️ Firestore delete failed: $e');
    }
  }

  Future<void> _deleteNotificationFromBackend(String id) async {
    try {
      await _api!.deleteNotification(id);
      print('✅ Background: notification deleted from backend');
    } catch (e) {
      // 404 is expected if notification was created locally only
      if (e.toString().contains('404')) {
        print('ℹ️ Notification not on backend (local-only): $id');
      } else {
        print('⚠️ Background delete failed: $e');
      }
    }
  }

  /// LOCAL-FIRST: Get count from local immediately
  Future<int> getUnreadCount() async {
    await _ensureDb();
    final result = _localDb.rawDb
        .select('SELECT COUNT(*) as count FROM notifications WHERE isRead = 0');
    return result.first['count'] as int;
  }

  Future<void> syncLocalDataToFirestore() async {
    if (!_useFirestore) {
      print('⚠️ Cannot sync: user not logged in');
      return;
    }

    print('🔄 NotificationRepository: Syncing local data to Firestore...');

    try {
      final localNotifications = await _fetchNotificationsLocal(limit: 100);
      if (localNotifications.isEmpty) {
        print('🔔 No local notifications to sync');
        return;
      }

      final col = _firestoreService.notifications;
      if (col == null) return;

      final existingDocs = await col.get();
      final existingIds = existingDocs.docs.map((doc) => doc.id).toSet();

      int syncedCount = 0;
      for (final notification in localNotifications) {
        if (!existingIds.contains(notification.id)) {
          await _upsertNotificationFirestore(notification);
          syncedCount++;
        }
      }

      print(
          '✅ Synced $syncedCount new notifications to Firestore (${localNotifications.length - syncedCount} already existed)');
    } catch (e) {
      print('⚠️ Error syncing local notifications to Firestore: $e');
    }
  }
}
