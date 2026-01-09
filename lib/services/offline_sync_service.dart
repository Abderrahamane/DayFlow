import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class PendingOperation {
  final String id;
  final String type; // 'task', 'habit', 'note'
  final String action; // 'upsert', 'delete', 'toggle'
  final String entityId;
  final Map<String, dynamic>? data;
  final DateTime createdAt;

  PendingOperation({
    required this.id,
    required this.type,
    required this.action,
    required this.entityId,
    this.data,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'action': action,
        'entityId': entityId,
        'data': data,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PendingOperation.fromJson(Map<String, dynamic> json) {
    return PendingOperation(
      id: json['id'],
      type: json['type'],
      action: json['action'],
      entityId: json['entityId'],
      data: json['data'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class OfflineSyncService {
  static final OfflineSyncService _instance = OfflineSyncService._internal();
  factory OfflineSyncService() => _instance;
  OfflineSyncService._internal();

  static const String _pendingOpsKey = 'pending_operations';

  final List<PendingOperation> _pendingOperations = [];
  StreamSubscription? _connectivitySubscription;
  bool _isOnline = true;
  bool _isSyncing = false;

  Future<bool> Function(PendingOperation op)? onSyncOperation;

  Future<void> initialize() async {
    await _loadPendingOperations();

    final connectivityResult = await Connectivity().checkConnectivity();
    _isOnline = !connectivityResult.contains(ConnectivityResult.none);

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      final wasOffline = !_isOnline;
      _isOnline = !result.contains(ConnectivityResult.none);

      print('🌐 Connectivity changed: ${_isOnline ? "Online" : "Offline"}');

      if (wasOffline && _isOnline) {
        syncPendingOperations();
      }
    });

    print('✅ OfflineSyncService initialized');
    print('   Pending operations: ${_pendingOperations.length}');
    print('   Online status: $_isOnline');
  }

  bool get isOnline => _isOnline;

  int get pendingCount => _pendingOperations.length;

  Future<void> addPendingOperation(PendingOperation op) async {
    _pendingOperations.removeWhere((existing) =>
        existing.type == op.type && existing.entityId == op.entityId);

    _pendingOperations.add(op);
    await _savePendingOperations();

    print('📝 Added pending operation: ${op.type}/${op.action}/${op.entityId}');
    print('   Total pending: ${_pendingOperations.length}');
  }

  /// Remove an operation from the queue (after successful sync)
  Future<void> removePendingOperation(String id) async {
    _pendingOperations.removeWhere((op) => op.id == id);
    await _savePendingOperations();
  }

  Future<void> syncPendingOperations() async {
    if (_isSyncing || _pendingOperations.isEmpty || !_isOnline) {
      return;
    }

    _isSyncing = true;
    print(
        '🔄 Starting sync of ${_pendingOperations.length} pending operations...');

    final toSync = List<PendingOperation>.from(_pendingOperations);

    for (final op in toSync) {
      try {
        if (onSyncOperation != null) {
          final success = await onSyncOperation!(op);
          if (success) {
            await removePendingOperation(op.id);
            print('✅ Synced: ${op.type}/${op.action}/${op.entityId}');
          } else {
            print('❌ Sync failed: ${op.type}/${op.action}/${op.entityId}');
          }
        }
      } catch (e) {
        print('❌ Sync error for ${op.id}: $e');
      }
    }

    _isSyncing = false;
    print('✅ Sync complete. Remaining: ${_pendingOperations.length}');
  }

  Future<void> clearPendingOperations() async {
    _pendingOperations.clear();
    await _savePendingOperations();
  }

  Future<void> _loadPendingOperations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_pendingOpsKey);
      if (json != null) {
        final list = jsonDecode(json) as List;
        _pendingOperations.clear();
        _pendingOperations.addAll(list
            .map((e) => PendingOperation.fromJson(e as Map<String, dynamic>)));
      }
    } catch (e) {
      print('❌ Error loading pending operations: $e');
    }
  }

  Future<void> _savePendingOperations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json =
          jsonEncode(_pendingOperations.map((e) => e.toJson()).toList());
      await prefs.setString(_pendingOpsKey, json);
    } catch (e) {
      print('❌ Error saving pending operations: $e');
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}
