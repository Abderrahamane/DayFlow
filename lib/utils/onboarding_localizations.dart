import 'package:flutter/material.dart';

class OnboardingLocalizations {
  final Locale locale;

  OnboardingLocalizations(this.locale);

  static OnboardingLocalizations of(BuildContext context) {
    return Localizations.of<OnboardingLocalizations>(context, OnboardingLocalizations)!;
  }

  static const LocalizationsDelegate<OnboardingLocalizations> delegate =
      _OnboardingLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'skip': 'Skip',
      'next': 'Next',
      'get_started': 'Get Started',
      'organize_your_tasks': 'Organize Your Tasks',
      'organize_tasks_desc': 'Keep track of your daily to-dos and boost your productivity with our intuitive task manager.',
      'capture_your_ideas': 'Capture Your Ideas',
      'capture_ideas_desc': 'Quickly jot down thoughts, ideas, and important information so you never forget a thing.',
      'set_smart_reminders': 'Set Smart Reminders',
      'set_reminders_desc': 'Get notified at the right time and place. Never miss an important deadline or event again.',
      'track_your_habits': 'Track Your Habits',
      'track_habits_desc': 'Build positive habits and break bad ones. Monitor your progress and stay motivated.',
    },
    'fr': {
      'skip': 'Passer',
      'next': 'Suivant',
      'get_started': 'Commencer',
      'organize_your_tasks': 'Organisez vos tâches',
      'organize_tasks_desc': 'Suivez vos tâches quotidiennes et augmentez votre productivité grâce à notre gestionnaire de tâches intuitif.',
      'capture_your_ideas': 'Capturez vos idées',
      'capture_ideas_desc': 'Notez rapidement vos pensées, idées et informations importantes pour ne rien oublier.',
      'set_smart_reminders': 'Définissez des rappels intelligents',
      'set_reminders_desc': 'Soyez notifié au bon moment et au bon endroit. Ne manquez plus jamais une échéance ou un événement important.',
      'track_your_habits': 'Suivez vos habitudes',
      'track_habits_desc': 'Construisez des habitudes positives et brisez les mauvaises. Surveillez vos progrès et restez motivé.',
    },
    'ar': {
      'skip': 'تخطي',
      'next': 'التالي',
      'get_started': 'البدء',
      'organize_your_tasks': 'نظم مهامك',
      'organize_tasks_desc': 'تتبع مهامك اليومية وعزز إنتاجيتك مع مدير المهام البديهي لدينا.',
      'capture_your_ideas': 'التقط أفكارك',
      'capture_ideas_desc': 'دون أفكارك ومعلوماتك المهمة بسرعة حتى لا تنسى أي شيء.',
      'set_smart_reminders': 'تعيين تذكيرات ذكية',
      'set_reminders_desc': 'احصل على إشعارات في الوقت والمكان المناسبين. لا تفوت موعدًا نهائيًا أو حدثًا مهمًا مرة أخرى.',
      'track_your_habits': 'تتبع عاداتك',
      'track_habits_desc': 'ابنِ عادات إيجابية وتخلص من العادات السيئة. راقب تقدمك وحافظ على حماسك.',
    },
  };

  String get skip => _localizedValues[locale.languageCode]!['skip']!;
  String get next => _localizedValues[locale.languageCode]!['next']!;
  String get getStarted => _localizedValues[locale.languageCode]!['get_started']!;
  String get organizeYourTasks => _localizedValues[locale.languageCode]!['organize_your_tasks']!;
  String get organizeTasksDesc => _localizedValues[locale.languageCode]!['organize_tasks_desc']!;
  String get captureYourIdeas => _localizedValues[locale.languageCode]!['capture_your_ideas']!;
  String get captureIdeasDesc => _localizedValues[locale.languageCode]!['capture_ideas_desc']!;
  String get setSmartReminders => _localizedValues[locale.languageCode]!['set_smart_reminders']!;
  String get setRemindersDesc => _localizedValues[locale.languageCode]!['set_reminders_desc']!;
  String get trackYourHabits => _localizedValues[locale.languageCode]!['track_your_habits']!;
  String get trackHabitsDesc => _localizedValues[locale.languageCode]!['track_habits_desc']!;
}

class _OnboardingLocalizationsDelegate
    extends LocalizationsDelegate<OnboardingLocalizations> {
  const _OnboardingLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<OnboardingLocalizations> load(Locale locale) async {
    return OnboardingLocalizations(locale);
  }

  @override
  bool shouldReload(_OnboardingLocalizationsDelegate old) => false;
}

