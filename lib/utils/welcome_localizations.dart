import 'package:flutter/material.dart';

class WelcomeLocalizations {
  final Locale locale;

  WelcomeLocalizations(this.locale);

  static WelcomeLocalizations of(BuildContext context) {
    return Localizations.of<WelcomeLocalizations>(context, WelcomeLocalizations)!;
  }

  static const LocalizationsDelegate<WelcomeLocalizations> delegate =
      _WelcomeLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'DayFlow',
      'your_smart_daily_planner': 'Your smart daily planner',
      'organize_tasks': 'Organize Tasks',
      'capture_ideas': 'Capture Ideas',
      'never_miss_reminders': 'Never Miss Reminders',
      'get_started': 'Get Started',
      'already_have_account': 'Already have an account? Login',
    },
    'fr': {
      'app_name': 'DayFlow',
      'your_smart_daily_planner': 'Votre planificateur quotidien intelligent',
      'organize_tasks': 'Organiser les tâches',
      'capture_ideas': 'Capturer des idées',
      'never_miss_reminders': 'Ne manquez jamais les rappels',
      'get_started': 'Commencer',
      'already_have_account': 'Vous avez déjà un compte ? Connexion',
    },
    'ar': {
      'app_name': 'DayFlow',
      'your_smart_daily_planner': 'مخططك اليومي الذكي',
      'organize_tasks': 'تنظيم المهام',
      'capture_ideas': 'التقاط الأفكار',
      'never_miss_reminders': 'لا تفوت التذكيرات أبدًا',
      'get_started': 'البدء',
      'already_have_account': 'لديك حساب بالفعل؟ تسجيل الدخول',
    },
  };

  String get appName => _localizedValues[locale.languageCode]!['app_name']!;
  String get yourSmartDailyPlanner => _localizedValues[locale.languageCode]!['your_smart_daily_planner']!;
  String get organizeTasks => _localizedValues[locale.languageCode]!['organize_tasks']!;
  String get captureIdeas => _localizedValues[locale.languageCode]!['capture_ideas']!;
  String get neverMissReminders => _localizedValues[locale.languageCode]!['never_miss_reminders']!;
  String get getStarted => _localizedValues[locale.languageCode]!['get_started']!;
  String get alreadyHaveAccount => _localizedValues[locale.languageCode]!['already_have_account']!;
}

class _WelcomeLocalizationsDelegate
    extends LocalizationsDelegate<WelcomeLocalizations> {
  const _WelcomeLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<WelcomeLocalizations> load(Locale locale) async {
    return WelcomeLocalizations(locale);
  }

  @override
  bool shouldReload(_WelcomeLocalizationsDelegate old) => false;
}

