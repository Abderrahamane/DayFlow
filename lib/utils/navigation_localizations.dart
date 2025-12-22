import 'package:flutter/material.dart';

class NavigationLocalizations {
  final Locale locale;

  NavigationLocalizations(this.locale);

  static NavigationLocalizations of(BuildContext context) {
    return Localizations.of<NavigationLocalizations>(context, NavigationLocalizations)!;
  }

  static const LocalizationsDelegate<NavigationLocalizations> delegate =
      _NavigationLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'DayFlow',
      'your_smart_daily_planner': 'Your smart daily planner',
      'tasks': 'Tasks',
      'manage_todos': 'Manage your to-dos',
      'notes': 'Notes',
      'quick_ideas': 'Capture quick ideas',
      'calendar': 'Calendar',
      'plan_schedule': 'Plan your schedule',
      'habits': 'Habits',
      'track_habits': 'Track daily habits',
      'statistics': 'Statistics',
      'view_progress': 'View your progress',
      'settings': 'Settings',
      'customize_experience': 'Customize your experience',
      'theme': 'Theme',
      'logout': 'Logout',
      'login': 'Login',
      'signup': 'Sign Up',
      'are_you_sure_logout': 'Are you sure you want to logout?',
      'cancel': 'Cancel',
      'logout_success': 'Logged out successfully',
      'open_menu': 'Open menu',
      'search': 'Search',
      'notifications': 'Notifications',
      'coming_soon': 'Coming soon',
    },
    'fr': {
      'app_name': 'DayFlow',
      'your_smart_daily_planner': 'Votre planificateur quotidien intelligent',
      'tasks': 'Tâches',
      'manage_todos': 'Gérez vos tâches',
      'notes': 'Notes',
      'quick_ideas': 'Capturez des idées rapides',
      'calendar': 'Calendrier',
      'plan_schedule': 'Planifiez votre emploi du temps',
      'habits': 'Habitudes',
      'track_habits': 'Suivez vos habitudes quotidiennes',
      'statistics': 'Statistiques',
      'view_progress': 'Voir vos progrès',
      'settings': 'Paramètres',
      'customize_experience': 'Personnalisez votre expérience',
      'theme': 'Thème',
      'logout': 'Déconnexion',
      'login': 'Connexion',
      'signup': 'S\'inscrire',
      'are_you_sure_logout': 'Êtes-vous sûr de vouloir vous déconnecter ?',
      'cancel': 'Annuler',
      'logout_success': 'Déconnecté avec succès',
      'open_menu': 'Ouvrir le menu',
      'search': 'Rechercher',
      'notifications': 'Notifications',
      'coming_soon': 'Bientôt disponible',
    },
    'ar': {
      'app_name': 'DayFlow',
      'your_smart_daily_planner': 'مخططك اليومي الذكي',
      'tasks': 'المهام',
      'manage_todos': 'إدارة مهامك',
      'notes': 'ملاحظات',
      'quick_ideas': 'التقاط أفكار سريعة',
      'calendar': 'التقويم',
      'plan_schedule': 'خطط لجدولك الزمني',
      'habits': 'العادات',
      'track_habits': 'تتبع العادات اليومية',
      'statistics': 'الإحصائيات',
      'view_progress': 'عرض تقدمك',
      'settings': 'الإعدادات',
      'customize_experience': 'تخصيص تجربتك',
      'theme': 'المظهر',
      'logout': 'تسجيل الخروج',
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'are_you_sure_logout': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
      'cancel': 'إلغاء',
      'logout_success': 'تم تسجيل الخروج بنجاح',
      'open_menu': 'فتح القائمة',
      'search': 'بحث',
      'notifications': 'إشعارات',
      'coming_soon': 'قريباً',
    },
  };

  String get appName => _localizedValues[locale.languageCode]!['app_name']!;
  String get yourSmartDailyPlanner => _localizedValues[locale.languageCode]!['your_smart_daily_planner']!;
  String get tasks => _localizedValues[locale.languageCode]!['tasks']!;
  String get manageTodos => _localizedValues[locale.languageCode]!['manage_todos']!;
  String get notes => _localizedValues[locale.languageCode]!['notes']!;
  String get quickIdeas => _localizedValues[locale.languageCode]!['quick_ideas']!;
  String get calendar => _localizedValues[locale.languageCode]!['calendar']!;
  String get planSchedule => _localizedValues[locale.languageCode]!['plan_schedule']!;
  String get habits => _localizedValues[locale.languageCode]!['habits']!;
  String get trackHabits => _localizedValues[locale.languageCode]!['track_habits']!;
  String get statistics => _localizedValues[locale.languageCode]!['statistics']!;
  String get viewProgress => _localizedValues[locale.languageCode]!['view_progress']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get customizeExperience => _localizedValues[locale.languageCode]!['customize_experience']!;
  String get theme => _localizedValues[locale.languageCode]!['theme']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get signup => _localizedValues[locale.languageCode]!['signup']!;
  String get areYouSureLogout => _localizedValues[locale.languageCode]!['are_you_sure_logout']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get logoutSuccess => _localizedValues[locale.languageCode]!['logout_success']!;
  String get openMenu => _localizedValues[locale.languageCode]!['open_menu']!;
  String get search => _localizedValues[locale.languageCode]!['search']!;
  String get notifications => _localizedValues[locale.languageCode]!['notifications']!;
  String get comingSoon => _localizedValues[locale.languageCode]!['coming_soon']!;
}

class _NavigationLocalizationsDelegate
    extends LocalizationsDelegate<NavigationLocalizations> {
  const _NavigationLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<NavigationLocalizations> load(Locale locale) async {
    return NavigationLocalizations(locale);
  }

  @override
  bool shouldReload(_NavigationLocalizationsDelegate old) => false;
}

