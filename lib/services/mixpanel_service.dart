// lib/services/mixpanel_service.dart

import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:flutter/foundation.dart';

/// MixpanelService - Handles all analytics tracking for DayFlow app
/// 
/// This service initializes Mixpanel and provides methods to track user events
/// and set user properties.
/// 
/// Usage:
/// 1. Initialize in main.dart: await MixpanelService.init('YOUR_TOKEN');
/// 2. Track events: MixpanelService.instance.trackEvent('event_name', {...});
/// 3. Set user properties: MixpanelService.instance.identifyUser('userId', {...});
class MixpanelService {
  static Mixpanel? _mixpanel;
  static MixpanelService? _instance;

  MixpanelService._();

  /// Get singleton instance
  static MixpanelService get instance {
    _instance ??= MixpanelService._();
    return _instance!;
  }

  /// Initialize Mixpanel with your project token
  /// 
  /// Call this in main.dart before running the app:
  /// ```dart
  /// await MixpanelService.init('YOUR_MIXPANEL_TOKEN');
  /// ```
  /// 
  /// Get your token from: https://mixpanel.com/project/[PROJECT_ID]/settings
  static Future<void> init(String token) async {
    try {
      _mixpanel = await Mixpanel.init(
        token,
        trackAutomaticEvents: true, // Automatically track app opens, sessions
      );
      debugPrint('✅ Mixpanel initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing Mixpanel: $e');
    }
  }

  /// Track a custom event with optional properties
  /// 
  /// Example:
  /// ```dart
  /// MixpanelService.instance.trackEvent('Task Completed', {
  ///   'task_id': 'task123',
  ///   'task_priority': 'high',
  ///   'completion_time': DateTime.now().toIso8601String(),
  /// });
  /// ```
  void trackEvent(String eventName, [Map<String, dynamic>? properties]) {
    if (_mixpanel == null) {
      debugPrint('⚠️ Mixpanel not initialized. Call MixpanelService.init() first');
      return;
    }

    try {
      _mixpanel!.track(eventName, properties: properties);
      debugPrint('📊 Tracked event: $eventName ${properties != null ? 'with properties' : ''}');
    } catch (e) {
      debugPrint('❌ Error tracking event: $e');
    }
  }

  /// Identify user and set user profile properties
  /// 
  /// Call this after user logs in:
  /// ```dart
  /// MixpanelService.instance.identifyUser('user123', {
  ///   'email': 'user@example.com',
  ///   'name': 'John Doe',
  ///   'login_provider': 'google',
  /// });
  /// ```
  void identifyUser(String userId, Map<String, dynamic>? properties) {
    if (_mixpanel == null) {
      debugPrint('⚠️ Mixpanel not initialized');
      return;
    }

    try {
      _mixpanel!.identify(userId);
      
      if (properties != null) {
        // Set user profile properties
        _mixpanel!.getPeople().set('\$email', properties['email']);
        _mixpanel!.getPeople().set('\$name', properties['name']);
        
        // Set custom properties
        properties.forEach((key, value) {
          if (key != 'email' && key != 'name') {
            _mixpanel!.getPeople().set(key, value);
          }
        });
      }
      
      debugPrint('👤 User identified: $userId');
    } catch (e) {
      debugPrint('❌ Error identifying user: $e');
    }
  }

  /// Clear user identity (call on logout)
  void reset() {
    if (_mixpanel == null) return;
    
    try {
      _mixpanel!.reset();
      debugPrint('🔄 Mixpanel user reset');
    } catch (e) {
      debugPrint('❌ Error resetting Mixpanel: $e');
    }
  }

  /// Track user login event
  /// 
  /// This is a convenience method for tracking login events
  void trackLogin({
    required String userId,
    required String email,
    required String loginProvider,
  }) {
    trackEvent('User Logged In', {
      'user_id': userId,
      'email': email,
      'login_provider': loginProvider,
      'timestamp': DateTime.now().toIso8601String(),
    });

    identifyUser(userId, {
      'email': email,
      'name': email.split('@')[0], // Use email prefix as name
      'login_provider': loginProvider,
    });
  }

  /// Track task completion event
  void trackTaskCompleted({
    required String taskId,
    required String taskTitle,
    String? priority,
  }) {
    trackEvent('User Completed Task', {
      'task_id': taskId,
      'task_title': taskTitle,
      'task_priority': priority ?? 'none',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Track habit creation event
  void trackHabitCreated({
    required String habitId,
    required String habitName,
    String? frequency,
  }) {
    trackEvent('User Created Habit', {
      'habit_id': habitId,
      'habit_name': habitName,
      'frequency': frequency ?? 'daily',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Track page view event
  void trackPageView(String pageName) {
    trackEvent('Page Viewed', {
      'page_name': pageName,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
