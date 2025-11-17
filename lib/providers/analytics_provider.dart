// lib/providers/analytics_provider.dart

import 'package:flutter/foundation.dart';
import '../services/mixpanel_service.dart';

/// AnalyticsProvider - Manages analytics state and provides easy access to tracking
/// 
/// This provider wraps MixpanelService and can be accessed anywhere in the app
/// using Provider.
/// 
/// Usage in Widget:
/// ```dart
/// final analytics = Provider.of<AnalyticsProvider>(context, listen: false);
/// analytics.trackTaskCompleted(taskId: 'task123', taskTitle: 'My Task');
/// ```
class AnalyticsProvider extends ChangeNotifier {
  bool _isInitialized = false;
  
  bool get isInitialized => _isInitialized;

  /// Initialize Mixpanel analytics
  Future<void> initialize(String token) async {
    try {
      await MixpanelService.init(token);
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing analytics: $e');
      _isInitialized = false;
    }
  }

  /// Track a generic event
  void trackEvent(String eventName, [Map<String, dynamic>? properties]) {
    if (!_isInitialized) return;
    MixpanelService.instance.trackEvent(eventName, properties);
  }

  /// Track user login
  void trackLogin({
    required String userId,
    required String email,
    required String loginProvider,
  }) {
    if (!_isInitialized) return;
    MixpanelService.instance.trackLogin(
      userId: userId,
      email: email,
      loginProvider: loginProvider,
    );
  }

  /// Track task completion
  void trackTaskCompleted({
    required String taskId,
    required String taskTitle,
    String? priority,
  }) {
    if (!_isInitialized) return;
    MixpanelService.instance.trackTaskCompleted(
      taskId: taskId,
      taskTitle: taskTitle,
      priority: priority,
    );
  }

  /// Track habit creation
  void trackHabitCreated({
    required String habitId,
    required String habitName,
    String? frequency,
  }) {
    if (!_isInitialized) return;
    MixpanelService.instance.trackHabitCreated(
      habitId: habitId,
      habitName: habitName,
      frequency: frequency,
    );
  }

  /// Track page view
  void trackPageView(String pageName) {
    if (!_isInitialized) return;
    MixpanelService.instance.trackPageView(pageName);
  }

  /// Identify user
  void identifyUser(String userId, Map<String, dynamic>? properties) {
    if (!_isInitialized) return;
    MixpanelService.instance.identifyUser(userId, properties);
  }

  /// Reset user identity (on logout)
  void reset() {
    if (!_isInitialized) return;
    MixpanelService.instance.reset();
  }
}
