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

    try {
      final String timeZoneName = DateTime.now().timeZoneName;
      try {
        tz.setLocalLocation(tz.getLocation(timeZoneName));
        debugPrint('✅ Timezone initialized: $timeZoneName');
      } catch (e) {
        final offset = DateTime.now().timeZoneOffset;
        final hours = offset.inHours;
        String fallbackTz = 'UTC';
        if (hours == 1)
          fallbackTz = 'Europe/Paris';
        else if (hours == 2)
          fallbackTz = 'Europe/Kiev';
        else if (hours == -5)
          fallbackTz = 'America/New_York';
        else if (hours == -8) fallbackTz = 'America/Los_Angeles';

        tz.setLocalLocation(tz.getLocation(fallbackTz));
        debugPrint(
            '✅ Timezone initialized (fallback): $fallbackTz (offset: $hours)');
      }
    } catch (e) {
      debugPrint('⚠️ Timezone initialization failed, using UTC: $e');
      tz.setLocalLocation(tz.UTC);
    }

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
    final androidPlugin = instance.notificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      // Request notification permission
      final permissionGranted =
          await androidPlugin.requestNotificationsPermission();
      debugPrint(
          '🔔 Android notification permission granted: $permissionGranted');

      // Check if notifications are enabled in system settings
      final areEnabled = await androidPlugin.areNotificationsEnabled();
      debugPrint('🔔 Android notifications enabled in settings: $areEnabled');

      if (areEnabled != true) {
        debugPrint(
            '⚠️ NOTIFICATIONS ARE DISABLED! User needs to enable in Settings > Apps > DayFlow > Notifications');
      }

      // Request exact alarm permission for scheduled notifications
      await androidPlugin.requestExactAlarmsPermission();
      debugPrint('✅ Exact alarms permission requested');
    }

    // Create notification channels for Android
    await _createNotificationChannels(instance);

    instance._isInitialized = true;
    debugPrint('✅ NotificationService fully initialized!');
  }

  static Future<void> _createNotificationChannels(
      NotificationService instance) async {
    final androidPlugin = instance.notificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'reminder_channel_id',
        'Reminder Notifications',
        description: 'Channel for reminder notifications',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
        enableLights: true,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'pomodoro_channel_id',
        'Pomodoro Timer',
        description: 'Notifications for Pomodoro timer sessions',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
        enableLights: true,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'push_notifications',
        'Push Notifications',
        description: 'Server-sent notifications like greetings and updates',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
        enableLights: true,
      ),
    );

    debugPrint('✅ Android notification channels created');
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel_id',
        'Reminder Notifications',
        channelDescription: 'Channel for reminder notifications',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
        visibility: NotificationVisibility.public, // Show on lock screen
        fullScreenIntent: true, // Show even when screen is locked
        category: AndroidNotificationCategory.reminder,
        autoCancel: true,
        ongoing: false,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  NotificationDetails pomodoroNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'pomodoro_channel_id',
        'Pomodoro Timer',
        channelDescription: 'Notifications for Pomodoro timer sessions',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        enableVibration: true,
        fullScreenIntent: true, // Show even when screen is locked
        visibility: NotificationVisibility.public, // Show on lock screen
        category: AndroidNotificationCategory.alarm,
        autoCancel: true,
        ongoing: false,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    debugPrint('📢 Showing notification: $title');
    return notificationPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
      payload: payload,
    );
  }

  Future<void> showPomodoroNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    debugPrint('🍅 showPomodoroNotification called');
    debugPrint('   Title: $title');
    debugPrint('   Initialized: $_isInitialized');

    if (!_isInitialized) {
      debugPrint('⚠️ NotificationService not initialized, initializing now...');
      await NotificationService.initNotification();
    }

    final androidPlugin =
        notificationPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final areEnabled = await androidPlugin.areNotificationsEnabled();
      debugPrint('🔔 Notifications enabled check: $areEnabled');
      if (areEnabled != true) {
        debugPrint('❌ NOTIFICATIONS DISABLED IN SYSTEM SETTINGS!');
        debugPrint(
            '   Go to Settings > Apps > DayFlow > Notifications and enable them');
      }
    }

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    debugPrint('   Notification ID: $id');

    try {
      await notificationPlugin.show(
        id,
        title,
        body,
        pomodoroNotificationDetails(),
        payload: payload,
      );
      debugPrint('✅ notificationPlugin.show() completed');
    } catch (e) {
      debugPrint('❌ notificationPlugin.show() failed: $e');
      rethrow;
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    bool usePomodoroChannel = false,
  }) async {
    if (!_isInitialized) {
      debugPrint(
          '❌ NotificationService not initialized! Call initNotification() first.');
      return;
    }

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
        usePomodoroChannel
            ? pomodoroNotificationDetails()
            : notificationDetails(),
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

  Future<void> cancelNotification(int id) async {
    await notificationPlugin.cancel(id);
    debugPrint('Notification $id cancelled');
  }

  Future<void> cancelAllNotifications() async {
    await notificationPlugin.cancelAll();
    debugPrint('All notifications cancelled');
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await notificationPlugin.pendingNotificationRequests();
  }

  Future<bool> isNotificationScheduled(int id) async {
    final pending = await getPendingNotifications();
    return pending.any((notification) => notification.id == id);
  }

  Future<bool> showTestNotification() async {
    debugPrint('🧪 Testing notification system...');

    if (!_isInitialized) {
      debugPrint('❌ NotificationService not initialized!');
      return false;
    }

    // Check Android permissions
    final androidPlugin =
        notificationPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final areEnabled = await androidPlugin.areNotificationsEnabled();
      debugPrint('🧪 Notifications enabled: $areEnabled');

      if (areEnabled != true) {
        debugPrint('❌ Notifications are DISABLED in system settings!');
        debugPrint('   Go to: Settings > Apps > DayFlow > Notifications');
        return false;
      }

      final channels = await androidPlugin.getNotificationChannels();
      debugPrint('🧪 Active notification channels:');
      for (final channel in channels ?? []) {
        debugPrint('   - ${channel?.id}: importance=${channel?.importance}');
      }
    }

    try {
      final testId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      debugPrint('🧪 Showing test notification with ID: $testId');

      await notificationPlugin.show(
        testId,
        '🧪 Test Notification',
        'If you see this, notifications are working! Time: ${DateTime.now()}',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel_id',
            'Reminder Notifications',
            channelDescription: 'Test notification',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            enableVibration: true,
            visibility: NotificationVisibility.public,
            fullScreenIntent: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );

      debugPrint('✅ Test notification sent successfully!');
      return true;
    } catch (e) {
      debugPrint('❌ Test notification failed: $e');
      return false;
    }
  }

  /// Print diagnostic information about notification system
  Future<void> printDiagnostics() async {
    debugPrint('🔍 NOTIFICATION DIAGNOSTICS');
    debugPrint('Initialized: $_isInitialized');

    final androidPlugin =
        notificationPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final areEnabled = await androidPlugin.areNotificationsEnabled();
      debugPrint('Android notifications enabled: $areEnabled');
    }

    final pending = await getPendingNotifications();
    debugPrint('Pending scheduled notifications: ${pending.length}');
    for (final p in pending) {
      debugPrint('  - ID: ${p.id}, Title: ${p.title}');
    }
  }
}
