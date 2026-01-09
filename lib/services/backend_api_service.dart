import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import '../models/task_model.dart';
import '../models/habit_model.dart';
import '../models/note_model.dart';
import '../models/notification_model.dart';

class BackendApiException implements Exception {
  final int statusCode;
  final String message;

  BackendApiException(this.statusCode, this.message);

  @override
  String toString() => 'BackendApiException($statusCode): $message';
}

/// Check if running on Android emulator
Future<bool> _isAndroidEmulator() async {
  if (!Platform.isAndroid) return false;
  try {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    // Emulator indicators
    return !androidInfo.isPhysicalDevice ||
        androidInfo.model.toLowerCase().contains('sdk') ||
        androidInfo.hardware.toLowerCase().contains('goldfish') ||
        androidInfo.hardware.toLowerCase().contains('ranchu');
  } catch (e) {
    return false;
  }
}

const String? _productionBackendUrl =
    'https://ay-low-ackend-mohamedalaminsaad7753-nw351cb9.leapcell.dev/api';

Future<String?> _getDefaultBackendUrl() async {
  const envUrl = String.fromEnvironment('BACKEND_URL');
  if (envUrl.isNotEmpty) {
    print('[BackendApiService] 📍 Using env BACKEND_URL: $envUrl');
    return envUrl;
  }
  if (_productionBackendUrl != null && _productionBackendUrl!.isNotEmpty) {
    print(
        '[BackendApiService] 📍 Using production URL: $_productionBackendUrl');
    return _productionBackendUrl;
  }

  return 'http://localhost:3000/api';
}

class BackendApiService {
  BackendApiService._internal(this._client, this.baseUrl);

  static BackendApiService? _instance;
  static bool _initializing = false;

  static Future<BackendApiService?> create({
    http.Client? client,
    String? baseUrl,
  }) async {
    if (_instance != null) return _instance;
    if (_initializing) return null;

    _initializing = true;
    try {
      final url = baseUrl ?? await _getDefaultBackendUrl();
      if (url == null) {
        print(
            '[BackendApiService] ⚠️ Backend URL not available - running in offline mode');
        _initializing = false;
        return null;
      }
      _instance = BackendApiService._internal(client ?? http.Client(), url);
      print('[BackendApiService] ✅ Initialized with URL: $url');
      return _instance;
    } finally {
      _initializing = false;
    }
  }

  static BackendApiService? get instance => _instance;

  static bool get isAvailable => _instance != null;

  final http.Client _client;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String baseUrl;

  static const Duration _timeout = Duration(seconds: 20);

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      print('[BackendApiService] ❌ Not authenticated - no current user');
      throw BackendApiException(401, 'Not authenticated');
    }
    final token = await user.getIdToken();
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);

    print('[BackendApiService] 🌐 $method $uri');

    http.Response response;
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      switch (method.toUpperCase()) {
        case 'GET':
          response = await _client.get(uri, headers: headers).timeout(_timeout);
          break;
        case 'POST':
          response = await _client
              .post(uri, headers: headers, body: jsonEncode(body ?? {}))
              .timeout(_timeout);
          break;
        case 'PUT':
          response = await _client
              .put(uri, headers: headers, body: jsonEncode(body ?? {}))
              .timeout(_timeout);
          break;
        case 'DELETE':
          response =
              await _client.delete(uri, headers: headers).timeout(_timeout);
          break;
        default:
          throw ArgumentError('Unsupported method $method');
      }
    } on TimeoutException {
      print(
          '[BackendApiService] ⏱️ Request timed out after ${_timeout.inSeconds}s');
      print(
          '[BackendApiService] 💡 Check your network connection or backend server status');
      throw BackendApiException(
          408, 'Connection timed out. Please check your network.');
    } catch (e) {
      print('[BackendApiService] ❌ Network error: $e');
      throw BackendApiException(0, 'Network error: ${e.toString()}');
    }

    print('[BackendApiService] 📥 Status: ${response.statusCode}');

    if (response.statusCode >= 400) {
      print('[BackendApiService] ❌ Error response: ${response.body}');
      throw BackendApiException(response.statusCode, response.body);
    }

    if (response.body.isEmpty) return {};

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;
    return {'data': decoded};
  }

  Future<List<Task>> fetchTasks() async {
    final data = await _request('GET', '/tasks');
    final list = (data['tasks'] as List? ?? []);
    return list
        .map((e) => Task.fromFirestore(
              Map<String, dynamic>.from(e as Map),
              (e as Map)['id'] as String,
            ))
        .toList();
  }

  Future<Task> saveTask(Task task) async {
    final payload = {
      'id': task.id,
      ...task.toFirestore(),
    };

    try {
      final data = await _request('PUT', '/tasks/${task.id}', body: payload);
      return Task.fromFirestore(
          Map<String, dynamic>.from(data)..remove('id'), data['id'] ?? task.id);
    } on BackendApiException catch (e) {
      if (e.statusCode == 404) {
        final data = await _request('POST', '/tasks', body: payload);
        return Task.fromFirestore(Map<String, dynamic>.from(data)..remove('id'),
            data['id'] ?? task.id);
      }
      rethrow;
    }
  }

  Future<void> deleteTask(String id) => _request('DELETE', '/tasks/$id');

  Future<Task> toggleTaskCompletion(String id) async {
    final data = await _request('POST', '/tasks/$id/toggle-complete');
    return Task.fromFirestore(
        Map<String, dynamic>.from(data)..remove('id'), data['id'] ?? id);
  }

  Future<Task> toggleSubtask(String taskId, String subtaskId) async {
    final data =
        await _request('POST', '/tasks/$taskId/subtasks/$subtaskId/toggle');
    return Task.fromFirestore(
        Map<String, dynamic>.from(data)..remove('id'), data['id'] ?? taskId);
  }

  Future<List<Habit>> fetchHabits() async {
    final data = await _request('GET', '/habits');
    final list = (data['habits'] as List? ?? []);
    return list
        .map((e) => Habit.fromFirestore(
              Map<String, dynamic>.from(e as Map),
              (e as Map)['id'] as String,
            ))
        .toList();
  }

  Future<Habit> saveHabit(Habit habit) async {
    final payload = {
      'id': habit.id,
      ...habit.toFirestore(),
    };

    try {
      final data = await _request('PUT', '/habits/${habit.id}', body: payload);
      return Habit.fromFirestore(Map<String, dynamic>.from(data)..remove('id'),
          data['id'] ?? habit.id);
    } on BackendApiException catch (e) {
      if (e.statusCode == 404) {
        final data = await _request('POST', '/habits', body: payload);
        return Habit.fromFirestore(
            Map<String, dynamic>.from(data)..remove('id'),
            data['id'] ?? habit.id);
      }
      rethrow;
    }
  }

  Future<void> deleteHabit(String id) => _request('DELETE', '/habits/$id');

  Future<Habit> toggleHabitCompletion(String id, String dateKey) async {
    final data = await _request('POST', '/habits/$id/toggle-completion',
        body: {'dateKey': dateKey});
    return Habit.fromFirestore(
        Map<String, dynamic>.from(data)..remove('id'), data['id'] ?? id);
  }

  Future<List<Note>> fetchNotes({String? tag, String? category}) async {
    final data = await _request('GET', '/notes', query: {
      if (tag != null) 'tag': tag,
      if (category != null) 'category': category,
    });
    final list = (data['notes'] as List? ?? []);
    return list
        .map((e) => Note.fromFirestore(
              Map<String, dynamic>.from(e as Map),
              (e as Map)['id'] as String,
            ))
        .toList();
  }

  Future<Note> saveNote(Note note) async {
    final payload = {
      'id': note.id,
      ...note.toFirestore(),
    };

    try {
      final data = await _request('PUT', '/notes/${note.id}', body: payload);
      return Note.fromFirestore(
          Map<String, dynamic>.from(data)..remove('id'), data['id'] ?? note.id);
    } on BackendApiException catch (e) {
      if (e.statusCode == 404) {
        final data = await _request('POST', '/notes', body: payload);
        return Note.fromFirestore(Map<String, dynamic>.from(data)..remove('id'),
            data['id'] ?? note.id);
      }
      rethrow;
    }
  }

  Future<void> deleteNote(String id) => _request('DELETE', '/notes/$id');

  Future<Note> toggleNotePin(String id) async {
    final data = await _request('POST', '/notes/$id/toggle-pin');
    return Note.fromFirestore(
        Map<String, dynamic>.from(data)..remove('id'), data['id'] ?? id);
  }

  Future<Note> lockNote(String id,
      {String? lockPin, bool useBiometric = false}) async {
    final data = await _request('POST', '/notes/$id/lock', body: {
      if (lockPin != null) 'lockPin': lockPin,
      'useBiometric': useBiometric,
    });
    return Note.fromFirestore(
        Map<String, dynamic>.from(data)..remove('id'), data['id'] ?? id);
  }

  Future<Note> unlockNote(String id) async {
    final data = await _request('POST', '/notes/$id/unlock');
    return Note.fromFirestore(
        Map<String, dynamic>.from(data)..remove('id'), data['id'] ?? id);
  }

  Future<List<AppNotification>> fetchNotifications(
      {int limit = 20, String? cursor}) async {
    final data = await _request('GET', '/notifications', query: {
      'limit': '$limit',
      if (cursor != null) 'cursor': cursor,
    });
    final list = (data['notifications'] as List? ?? []);
    return list
        .map((e) => AppNotification.fromFirestore(
              Map<String, dynamic>.from(e as Map),
              (e as Map)['id'] as String,
            ))
        .toList();
  }

  Future<AppNotification> createNotification(
      AppNotification notification) async {
    final payload = {
      'id': notification.id,
      ...notification.toFirestore(),
    };
    final data = await _request('POST', '/notifications', body: payload);
    return AppNotification.fromFirestore(
        Map<String, dynamic>.from(data)..remove('id'),
        data['id'] ?? notification.id);
  }

  Future<AppNotification> markNotificationRead(String id) async {
    final data = await _request('POST', '/notifications/$id/read');
    return AppNotification.fromFirestore(
        Map<String, dynamic>.from(data)..remove('id'), data['id'] ?? id);
  }

  Future<int> markAllNotificationsRead() async {
    final data = await _request('POST', '/notifications/read-all');
    return data['updatedCount'] ?? 0;
  }

  Future<void> deleteNotification(String id) =>
      _request('DELETE', '/notifications/$id');

  Future<int> getUnreadNotificationCount() async {
    final data = await _request('GET', '/notifications/unread-count');
    return data['unreadCount'] ?? 0;
  }

  Future<void> saveFcmToken(String token) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw BackendApiException(401, 'Not authenticated');
    }
    await _request('POST', '/fcm/token', body: {
      'uid': user.uid,
      'token': token,
    });
  }

  Future<void> updateLastActive() async {
    await _request('POST', '/fcm/activity');
  }

  Future<Map<String, dynamic>> getNotificationPreferences() async {
    return await _request('GET', '/fcm/preferences');
  }

  Future<void> updateNotificationPreferences({
    bool? holidayGreetings,
    bool? reEngagement,
    bool? appUpdates,
  }) async {
    final body = <String, dynamic>{};
    if (holidayGreetings != null) body['holidayGreetings'] = holidayGreetings;
    if (reEngagement != null) body['reEngagement'] = reEngagement;
    if (appUpdates != null) body['appUpdates'] = appUpdates;
    await _request('PUT', '/fcm/preferences', body: body);
  }
}
