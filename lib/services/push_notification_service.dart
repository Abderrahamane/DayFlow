import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../data/repositories/notification_repository.dart';
import '../models/notification_model.dart';
import 'backend_api_service.dart';
import 'notification_servise.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📬 Background FCM message received: ${message.messageId}');
  print(
      '   Notification: ${message.notification?.title} - ${message.notification?.body}');
  print('   Data: ${message.data}');

  String? title;
  String? body;

  if (message.notification != null) {
    title = message.notification!.title;
    body = message.notification!.body;
  } else if (message.data.isNotEmpty) {
    title = message.data['title'];
    body = message.data['body'] ?? message.data['message'];
  }

  // Skip if no content
  if (title == null && body == null) {
    print('⚠️ FCM message has no title or body, skipping notification');
    return;
  }

  try {
    final FlutterLocalNotificationsPlugin localNotifications =
        FlutterLocalNotificationsPlugin();
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await localNotifications.initialize(initSettings);

    await localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title ?? 'DayFlow',
      body ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'push_notifications',
          'Push Notifications',
          channelDescription: 'Server-sent notifications',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          enableVibration: true,
          visibility: NotificationVisibility.public,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.message,
          autoCancel: true,
        ),
      ),
    );
    print('✅ Background FCM notification shown: $title');
  } catch (e) {
    print('❌ Failed to show background FCM notification: $e');
  }
}

class PushNotificationService {
  static final PushNotificationService _instance =
      PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin get _localNotifications =>
      NotificationService().notificationPlugin;

  final _uuid = const Uuid();
  BackendApiService? _api;
  NotificationRepository? _notificationRepository;
  bool _initialized = false;
  String? _fcmToken;

  Future<void> initialize({
    BackendApiService? api,
    NotificationRepository? notificationRepository,
  }) async {
    if (_initialized) return;

    _api = api;
    _notificationRepository = notificationRepository;

    print('🔔 Initializing PushNotificationService...');

    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('🔔 FCM Permission status: ${settings.authorizationStatus}');

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await _getAndSaveToken();

      _messaging.onTokenRefresh.listen(_onTokenRefresh);

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      await _setupLocalNotifications();
    }

    _initialized = true;
    print('✅ PushNotificationService initialized!');
  }

  String? get fcmToken => _fcmToken;

  Future<void> _getAndSaveToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      print('🔔 FCM Token: $_fcmToken');

      if (_fcmToken != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fcm_token', _fcmToken!);

        await _sendTokenToBackend(_fcmToken!);
      }
    } catch (e) {
      print('❌ Error getting FCM token: $e');
    }
  }

  Future<void> _onTokenRefresh(String token) async {
    print('🔔 FCM Token refreshed: $token');
    _fcmToken = token;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);

    await _sendTokenToBackend(token);
  }

  Future<void> _sendTokenToBackend(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('⚠️ User not authenticated - token will be sent after login');
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('settings')
          .doc('fcm')
          .set({
        'token': token,
        'updatedAt': FieldValue.serverTimestamp(),
        'platform': 'android', // or detect platform
      }, SetOptions(merge: true));
      print('✅ FCM token saved to Firestore');
    } catch (e) {
      print('⚠️ Failed to save FCM token to Firestore: $e');
    }

    if (_api == null) {
      print('⚠️ No API service - token not sent to backend');
      return;
    }

    try {
      await _api!.saveFcmToken(token);
      print('✅ FCM token sent to backend');
    } catch (e) {
      print('⚠️ Failed to send FCM token to backend: $e');
    }
  }

  Future<void> sendPendingToken() async {
    if (_fcmToken != null && _api != null) {
      await _sendTokenToBackend(_fcmToken!);
    }
  }

  Future<void> _setupLocalNotifications() async {
    const androidChannel = AndroidNotificationChannel(
      'push_notifications',
      'Push Notifications',
      description: 'Server-sent notifications like greetings and updates',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('📬 Foreground FCM message received!');
    print('   MessageId: ${message.messageId}');
    print('   Title: ${message.notification?.title}');
    print('   Body: ${message.notification?.body}');
    print('   Data: ${message.data}');

    final notification = message.notification;
    String title = 'DayFlow';
    String body = '';

    if (!NotificationService().isInitialized) {
      print('⚠️ NotificationService not initialized, initializing...');
      await NotificationService.initNotification();
    }

    if (notification != null) {
      title = notification.title ?? 'DayFlow';
      body = notification.body ?? '';

      try {
        final notificationId = message.hashCode;
        print('📬 Showing FCM notification with ID: $notificationId');

        await _localNotifications.show(
          notificationId,
          title,
          body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'push_notifications',
              'Push Notifications',
              channelDescription: 'Server-sent notifications',
              importance: Importance.max,
              priority: Priority.max,
              playSound: true,
              enableVibration: true,
              visibility: NotificationVisibility.public,
              fullScreenIntent: true,
              category: AndroidNotificationCategory.message,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: jsonEncode(message.data),
        );
        print('✅ FCM notification shown successfully');
      } catch (e) {
        print('❌ Error showing FCM notification: $e');
      }
    } else if (message.data.isNotEmpty) {
      print('📬 Data-only FCM message, showing from data payload');
      title = message.data['title'] ?? 'DayFlow';
      body = message.data['body'] ?? message.data['message'] ?? '';

      try {
        await _localNotifications.show(
          message.hashCode,
          title,
          body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'push_notifications',
              'Push Notifications',
              channelDescription: 'Server-sent notifications',
              importance: Importance.max,
              priority: Priority.max,
              playSound: true,
              enableVibration: true,
              visibility: NotificationVisibility.public,
              fullScreenIntent: true,
              category: AndroidNotificationCategory.message,
            ),
          ),
        );
        print('✅ Data-only FCM notification shown');
      } catch (e) {
        print('❌ Error showing data-only notification: $e');
      }
    } else {
      print('⚠️ FCM message has no notification or data payload');
      return;
    }

    _saveToInAppNotifications(title, body);
  }

  Future<void> _saveToInAppNotifications(String title, String body) async {
    if (_notificationRepository == null) {
      print('⚠️ NotificationRepository not set, in-app notification not saved');
      return;
    }

    try {
      await _notificationRepository!.saveNotification(AppNotification(
        id: _uuid.v4(),
        title: title,
        body: body,
        timestamp: DateTime.now(),
      ));
      print('✅ FCM notification saved to in-app history');
    } catch (e) {
      print('❌ Error saving FCM to in-app history: $e');
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    print('📬 Message opened app: ${message.data}');

    // Handle navigation based on message type
    final type = message.data['type'];
    switch (type) {
      case 'task_reminder':
        break;
      case 'engagement':
        break;
      case 'holiday_greeting':
        break;
      default:
        break;
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    print('🔔 Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    print('🔔 Unsubscribed from topic: $topic');
  }

  void setNotificationRepository(NotificationRepository repository) {
    _notificationRepository = repository;
    print('✅ PushNotificationService: NotificationRepository set');
  }

  Future<void> updateLastActive() async {
    if (_api == null) return;

    try {
      await _api!.updateLastActive();
    } catch (e) {
      print('❌ Failed to update last active: $e');
    }
  }
}
