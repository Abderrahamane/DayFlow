import 'package:flutter/material.dart';

class QuestionFlowLocalizations {
  final Locale locale;

  QuestionFlowLocalizations(this.locale);

  static QuestionFlowLocalizations of(BuildContext context) {
    return Localizations.of<QuestionFlowLocalizations>(context, QuestionFlowLocalizations)!;
  }

  static const LocalizationsDelegate<QuestionFlowLocalizations> delegate =
      _QuestionFlowLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'qf_biggest_challenge': 'What is your biggest challenge?',
      'qf_too_many_tasks': 'Too many tasks',
      'qf_staying_focused': 'Staying focused',
      'qf_time_management': 'Time management',
      'qf_remembering_everything': 'Remembering everything',
      'qf_response_1': 'I understand, managing many tasks can be overwhelming.',
      'qf_response_2': 'Focus is key! We can help with that.',
      'qf_response_3': 'Time management is a skill we can build together.',
      'qf_response_4': 'Don\'t worry, we\'ll help you keep track of everything.',
      'qf_when_work_best': 'When do you work best?',
      'qf_early_morning': 'Early morning',
      'qf_afternoon': 'Afternoon',
      'qf_evening': 'Evening',
      'qf_late_night': 'Late night',
      'qf_response_5': 'Early bird! Great time for deep work.',
      'qf_response_6': 'Afternoon energy! Perfect for getting things done.',
      'qf_response_7': 'Evening focus. A calm time to work.',
      'qf_response_8': 'Night owl! Quiet hours are productive.',
      'qf_main_goal': 'What is your main goal?',
      'qf_get_organized': 'Get organized',
      'qf_build_habits': 'Build habits',
      'qf_track_tasks': 'Track tasks',
      'qf_remember_all': 'Remember everything',
      'qf_response_9': 'Organization brings clarity.',
      'qf_response_10': 'Habits are the building blocks of success.',
      'qf_response_11': 'Tracking tasks helps you stay on top.',
      'qf_response_12': 'A second brain for your thoughts.',
      'qf_prefer_plan': 'How do you prefer to plan?',
      'qf_day_by_day': 'Day by day',
      'qf_week_ahead': 'Week ahead',
      'qf_monthly_view': 'Monthly view',
      'qf_go_with_flow': 'Go with the flow',
      'qf_response_13': 'Taking it one day at a time.',
      'qf_response_14': 'Looking ahead prepares you for success.',
      'qf_response_15': 'Big picture planning!',
      'qf_response_16': 'Flexible and adaptable.',
      'qf_greeting': 'Hi! I\'m Flow, your personal assistant. Let\'s get to know you better!',
      'qf_finish': 'Finish',
      'qf_next_question': 'Great! Next question...',
      'qf_completion': 'All done! Setting up your experience...',
      'qf_next': 'Next',
      'qf_you_are_all_set': 'You are all set!',
      'qf_lets_get_productive': 'Let\'s get productive! 🚀',
    },
    'fr': {
      'qf_biggest_challenge': 'Quel est votre plus grand défi ?',
      'qf_too_many_tasks': 'Trop de tâches',
      'qf_staying_focused': 'Rester concentré',
      'qf_time_management': 'Gestion du temps',
      'qf_remembering_everything': 'Se souvenir de tout',
      'qf_response_1': 'Je comprends, gérer beaucoup de tâches peut être accablant.',
      'qf_response_2': 'La concentration est la clé ! Nous pouvons vous aider.',
      'qf_response_3': 'La gestion du temps est une compétence que nous pouvons développer ensemble.',
      'qf_response_4': 'Ne vous inquiétez pas, nous vous aiderons à tout suivre.',
      'qf_when_work_best': 'Quand travaillez-vous le mieux ?',
      'qf_early_morning': 'Tôt le matin',
      'qf_afternoon': 'Après-midi',
      'qf_evening': 'Soirée',
      'qf_late_night': 'Tard le soir',
      'qf_response_5': 'Lève-tôt ! Excellent moment pour un travail approfondi.',
      'qf_response_6': 'Énergie de l\'après-midi ! Parfait pour faire avancer les choses.',
      'qf_response_7': 'Concentration du soir. Un moment calme pour travailler.',
      'qf_response_8': 'Oiseau de nuit ! Les heures calmes sont productives.',
      'qf_main_goal': 'Quel est votre objectif principal ?',
      'qf_get_organized': 'S\'organiser',
      'qf_build_habits': 'Construire des habitudes',
      'qf_track_tasks': 'Suivre les tâches',
      'qf_remember_all': 'Se souvenir de tout',
      'qf_response_9': 'L\'organisation apporte de la clarté.',
      'qf_response_10': 'Les habitudes sont les fondations du succès.',
      'qf_response_11': 'Le suivi des tâches vous aide à rester au top.',
      'qf_response_12': 'Un second cerveau pour vos pensées.',
      'qf_prefer_plan': 'Comment préférez-vous planifier ?',
      'qf_day_by_day': 'Au jour le jour',
      'qf_week_ahead': 'Semaine à venir',
      'qf_monthly_view': 'Vue mensuelle',
      'qf_go_with_flow': 'Suivre le courant',
      'qf_response_13': 'Prendre un jour à la fois.',
      'qf_response_14': 'Regarder devant vous prépare au succès.',
      'qf_response_15': 'Planification globale !',
      'qf_response_16': 'Flexible et adaptable.',
      'qf_greeting': 'مرحباً! أنا فلو، مساعدك الشخصي. دعنا نتعرف عليك بشكل أفضل!',
      'qf_finish': 'إنهاء',
      'qf_next_question': 'رائع! السؤال التالي...',
      'qf_completion': 'تم كل شيء! جاري إعداد تجربتك...',
      'qf_next': 'التالي',
      'qf_you_are_all_set': 'أنت جاهز تماماً!',
      'qf_lets_get_productive': 'دعنا نكون منتجين! 🚀',
    },
    'ar': {
      'qf_biggest_challenge': 'ما هو أكبر تحدٍ تواجهه؟',
      'qf_too_many_tasks': 'الكثير من المهام',
      'qf_staying_focused': 'البقاء مركزاً',
      'qf_time_management': 'إدارة الوقت',
      'qf_remembering_everything': 'تذكر كل شيء',
      'qf_response_1': 'أفهم ذلك، إدارة العديد من المهام قد تكون مرهقة.',
      'qf_response_2': 'التركيز هو المفتاح! يمكننا المساعدة في ذلك.',
      'qf_response_3': 'إدارة الوقت مهارة يمكننا بناؤها معاً.',
      'qf_response_4': 'لا تقلق، سنساعدك في تتبع كل شيء.',
      'qf_when_work_best': 'متى تعمل بشكل أفضل؟',
      'qf_early_morning': 'في الصباح الباكر',
      'qf_afternoon': 'بعد الظهر',
      'qf_evening': 'في المساء',
      'qf_late_night': 'في وقت متأخر من الليل',
      'qf_response_5': 'طائر مبكر! وقت رائع للعمل العميق.',
      'qf_response_6': 'طاقة بعد الظهر! مثالية لإنجاز الأمور.',
      'qf_response_7': 'تركيز المساء. وقت هادئ للعمل.',
      'qf_response_8': 'بومة الليل! الساعات الهادئة منتجة.',
      'qf_main_goal': 'ما هو هدفك الرئيسي؟',
      'qf_get_organized': 'التنظيم',
      'qf_build_habits': 'بناء العادات',
      'qf_track_tasks': 'تتبع المهام',
      'qf_remember_all': 'تذكر كل شيء',
      'qf_response_9': 'التنظيم يجلب الوضوح.',
      'qf_response_10': 'العادات هي لبنات النجاح.',
      'qf_response_11': 'تتبع المهام يساعدك على البقاء في القمة.',
      'qf_response_12': 'دماغ ثانٍ لأفكارك.',
      'qf_prefer_plan': 'كيف تفضل التخطيط؟',
      'qf_day_by_day': 'يوماً بيوم',
      'qf_week_ahead': 'الأسبوع القادم',
      'qf_monthly_view': 'عرض شهري',
      'qf_go_with_flow': 'مسايرة التيار',
      'qf_response_13': 'أخذ الأمور يوماً بيوم.',
      'qf_response_14': 'التطلع إلى الأمام يجهزك للنجاح.',
      'qf_response_15': 'تخطيط الصورة الكبيرة!',
      'qf_response_16': 'مرن وقابل للتكيف.',
    },
  };

  String get qfBiggestChallenge => _localizedValues[locale.languageCode]!['qf_biggest_challenge']!;
  String get qfTooManyTasks => _localizedValues[locale.languageCode]!['qf_too_many_tasks']!;
  String get qfStayingFocused => _localizedValues[locale.languageCode]!['qf_staying_focused']!;
  String get qfTimeManagement => _localizedValues[locale.languageCode]!['qf_time_management']!;
  String get qfRememberingEverything => _localizedValues[locale.languageCode]!['qf_remembering_everything']!;
  String get qfResponse1 => _localizedValues[locale.languageCode]!['qf_response_1']!;
  String get qfResponse2 => _localizedValues[locale.languageCode]!['qf_response_2']!;
  String get qfResponse3 => _localizedValues[locale.languageCode]!['qf_response_3']!;
  String get qfResponse4 => _localizedValues[locale.languageCode]!['qf_response_4']!;
  String get qfWhenWorkBest => _localizedValues[locale.languageCode]!['qf_when_work_best']!;
  String get qfEarlyMorning => _localizedValues[locale.languageCode]!['qf_early_morning']!;
  String get qfAfternoon => _localizedValues[locale.languageCode]!['qf_afternoon']!;
  String get qfEvening => _localizedValues[locale.languageCode]!['qf_evening']!;
  String get qfLateNight => _localizedValues[locale.languageCode]!['qf_late_night']!;
  String get qfResponse5 => _localizedValues[locale.languageCode]!['qf_response_5']!;
  String get qfResponse6 => _localizedValues[locale.languageCode]!['qf_response_6']!;
  String get qfResponse7 => _localizedValues[locale.languageCode]!['qf_response_7']!;
  String get qfResponse8 => _localizedValues[locale.languageCode]!['qf_response_8']!;
  String get qfMainGoal => _localizedValues[locale.languageCode]!['qf_main_goal']!;
  String get qfGetOrganized => _localizedValues[locale.languageCode]!['qf_get_organized']!;
  String get qfBuildHabits => _localizedValues[locale.languageCode]!['qf_build_habits']!;
  String get qfTrackTasks => _localizedValues[locale.languageCode]!['qf_track_tasks']!;
  String get qfRememberAll => _localizedValues[locale.languageCode]!['qf_remember_all']!;
  String get qfResponse9 => _localizedValues[locale.languageCode]!['qf_response_9']!;
  String get qfResponse10 => _localizedValues[locale.languageCode]!['qf_response_10']!;
  String get qfResponse11 => _localizedValues[locale.languageCode]!['qf_response_11']!;
  String get qfResponse12 => _localizedValues[locale.languageCode]!['qf_response_12']!;
  String get qfPreferPlan => _localizedValues[locale.languageCode]!['qf_prefer_plan']!;
  String get qfDayByDay => _localizedValues[locale.languageCode]!['qf_day_by_day']!;
  String get qfWeekAhead => _localizedValues[locale.languageCode]!['qf_week_ahead']!;
  String get qfMonthlyView => _localizedValues[locale.languageCode]!['qf_monthly_view']!;
  String get qfGoWithFlow => _localizedValues[locale.languageCode]!['qf_go_with_flow']!;
  String get qfResponse13 => _localizedValues[locale.languageCode]!['qf_response_13']!;
  String get qfResponse14 => _localizedValues[locale.languageCode]!['qf_response_14']!;
  String get qfResponse15 => _localizedValues[locale.languageCode]!['qf_response_15']!;
  String get qfResponse16 => _localizedValues[locale.languageCode]!['qf_response_16']!;
  String get qfGreeting => _localizedValues[locale.languageCode]!['qf_greeting']!;
  String get qfFinish => _localizedValues[locale.languageCode]!['qf_finish']!;
  String get qfNextQuestion => _localizedValues[locale.languageCode]!['qf_next_question']!;
  String get qfCompletion => _localizedValues[locale.languageCode]!['qf_completion']!;
  String get qfNext => _localizedValues[locale.languageCode]!['qf_next']!;
  String get qfYouAreAllSet => _localizedValues[locale.languageCode]!['qf_you_are_all_set']!;
  String get qfLetsGetProductive => _localizedValues[locale.languageCode]!['qf_lets_get_productive']!;
}

class _QuestionFlowLocalizationsDelegate
    extends LocalizationsDelegate<QuestionFlowLocalizations> {
  const _QuestionFlowLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<QuestionFlowLocalizations> load(Locale locale) async {
    return QuestionFlowLocalizations(locale);
  }

  @override
  bool shouldReload(_QuestionFlowLocalizationsDelegate old) => false;
}
