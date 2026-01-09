import 'package:flutter/foundation.dart';

class SyncStatusService extends ChangeNotifier {
  static final SyncStatusService _instance = SyncStatusService._internal();
  factory SyncStatusService() => _instance;
  SyncStatusService._internal();

  final Set<String> _activeSyncs = {};
  String? _lastSyncMessage;
  DateTime? _lastSyncTime;

  bool get isSyncing => _activeSyncs.isNotEmpty;

  List<String> get activeSyncs => _activeSyncs.toList();

  String? get lastSyncMessage => _lastSyncMessage;

  DateTime? get lastSyncTime => _lastSyncTime;

  void startSync(String operation) {
    if (_activeSyncs.add(operation)) {
      _lastSyncMessage = 'Syncing $operation...';
      debugPrint('🔄 Sync started: $operation');
      notifyListeners();
    }
  }

  void endSync(String operation, {bool success = true}) {
    if (_activeSyncs.remove(operation)) {
      _lastSyncTime = DateTime.now();
      _lastSyncMessage = success
          ? '$operation synced successfully'
          : 'Failed to sync $operation';
      debugPrint('✅ Sync ended: $operation (success: $success)');
      notifyListeners();
    }
  }

  void clearAll() {
    _activeSyncs.clear();
    notifyListeners();
  }

  String get statusMessage {
    if (_activeSyncs.isEmpty) {
      return 'All data synced';
    }
    if (_activeSyncs.length == 1) {
      return 'Syncing ${_activeSyncs.first}...';
    }
    return 'Syncing ${_activeSyncs.length} items...';
  }
}
