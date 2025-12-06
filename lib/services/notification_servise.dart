import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Initialize notification service
  static Future<void> initNotification() async {
    final instance = NotificationService();
    if (instance._isInitialized) {
      debugPrint('✅ NotificationService already initialized');
      return;
    }

    debugPrint('🔧 Initializing NotificationService...');

    // Initialize timezone
    tz.initializeTimeZones();
    
    // Set local timezone (important!)
    final String timeZoneName = DateTime.now().timeZoneName;
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    debugPrint('✅ Timezone initialized: $timeZoneName');

    const initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    final initialized = await instance.notificationPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        debugPrint('📲 Notification tapped: ${response.payload}');
      },
    );

    debugPrint('✅ Flutter Local Notifications initialized: $initialized');

    // Request permissions for iOS
    final iosPermission = await instance.notificationPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    debugPrint('✅ iOS permissions: $iosPermission');

    // Request permissions for Android 13+
    final androidPermission = await instance.notificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    debugPrint('✅ Android permissions: $androidPermission');

    instance._isInitialized = true;
    debugPrint('✅ NotificationService fully initialized!');
  }

  // Notification details setup
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel_id',
        'Reminder Notifications',
        channelDescription: 'Channel for reminder notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  // Show immediate notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return notificationPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
      payload: payload,
    );
  }

  // Schedule notification at specific date and time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_isInitialized) {
      debugPrint('❌ NotificationService not initialized! Call initNotification() first.');
      return;
    }

    // Check if the scheduled time is in the future
    if (scheduledDate.isBefore(DateTime.now())) {
      debugPrint('⚠️ Cannot schedule notification in the past: $scheduledDate');
      return;
    }

    try {
      final tz.TZDateTime scheduledTZDate =
          tz.TZDateTime.from(scheduledDate, tz.local);

      await notificationPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTZDate,
        notificationDetails(),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      debugPrint('✅ Notification scheduled successfully!');
      debugPrint('   ID: $id');
      debugPrint('   Title: $title');
      debugPrint('   Scheduled for: $scheduledTZDate');
      debugPrint('   Current time: ${DateTime.now()}');
    } catch (e) {
      debugPrint('❌ Error scheduling notification: $e');
    }
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await notificationPlugin.cancel(id);
    debugPrint('Notification $id cancelled');
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await notificationPlugin.cancelAll();
    debugPrint('All notifications cancelled');
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await notificationPlugin.pendingNotificationRequests();
  }

  // Check if a notification is scheduled
  Future<bool> isNotificationScheduled(int id) async {
    final pending = await getPendingNotifications();
    return pending.any((notification) => notification.id == id);
  }
}