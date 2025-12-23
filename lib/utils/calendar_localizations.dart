import 'package:flutter/material.dart';

class CalendarLocalizations {
  final Locale locale;

  CalendarLocalizations(this.locale);

  static CalendarLocalizations of(BuildContext context) {
    return Localizations.of<CalendarLocalizations>(context, CalendarLocalizations)!;
  }

  static const LocalizationsDelegate<CalendarLocalizations> delegate =
      _CalendarLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'calendar_page_title': 'Calendar',
      'month_view': 'Month View',
      'two_weeks': 'Two Weeks',
      'week_view': 'Week View',
      'failed_to_load_calendar': 'Failed to load calendar',
      'summary': 'Summary',
      'no_tasks_for_date': 'No tasks for {date}',
      'tap_plus_to_add_task': 'Tap the + button to add a task',
      'no_habits_for_date': 'No habits for {date}',
      'create_habits_in_tab': 'Create habits in the Habits tab',
      'tasks_by_priority': 'Tasks by Priority',
      'habits_overview': 'Habits Overview',
      'day_streak': '{count} day streak',
    },
    'fr': {
      'calendar_page_title': 'Calendrier',
      'month_view': 'Vue mensuelle',
      'two_weeks': 'Deux semaines',
      'week_view': 'Vue hebdomadaire',
      'failed_to_load_calendar': 'Échec du chargement du calendrier',
      'summary': 'Résumé',
      'no_tasks_for_date': 'Aucune tâche pour {date}',
      'tap_plus_to_add_task': 'Appuyez sur le bouton + pour ajouter une tâche',
      'no_habits_for_date': 'Aucune habitude pour {date}',
      'create_habits_in_tab': 'Créez des habitudes dans l\'onglet Habitudes',
      'tasks_by_priority': 'Tâches par priorité',
      'habits_overview': 'Aperçu des habitudes',
      'day_streak': 'Série de {count} jours',
    },
    'ar': {
      'calendar_page_title': 'التقويم',
      'month_view': 'عرض شهري',
      'two_weeks': 'أسبوعين',
      'week_view': 'عرض أسبوعي',
      'failed_to_load_calendar': 'فشل تحميل التقويم',
      'summary': 'ملخص',
      'no_tasks_for_date': 'لا توجد مهام لـ {date}',
      'tap_plus_to_add_task': 'اضغط على زر + لإضافة مهمة',
      'no_habits_for_date': 'لا توجد عادات لـ {date}',
      'create_habits_in_tab': 'أنشئ عادات في علامة تبويب العادات',
      'tasks_by_priority': 'المهام حسب الأولوية',
      'habits_overview': 'نظرة عامة على العادات',
      'day_streak': '{count} يوم متتالي',
    },
  };

  String get calendarPageTitle => _localizedValues[locale.languageCode]!['calendar_page_title']!;
  String get monthView => _localizedValues[locale.languageCode]!['month_view']!;
  String get twoWeeks => _localizedValues[locale.languageCode]!['two_weeks']!;
  String get weekView => _localizedValues[locale.languageCode]!['week_view']!;
  String get failedToLoadCalendar => _localizedValues[locale.languageCode]!['failed_to_load_calendar']!;
  String get summary => _localizedValues[locale.languageCode]!['summary']!;
  String get tapPlusToAddTask => _localizedValues[locale.languageCode]!['tap_plus_to_add_task']!;
  String get createHabitsInTab => _localizedValues[locale.languageCode]!['create_habits_in_tab']!;
  String get tasksByPriority => _localizedValues[locale.languageCode]!['tasks_by_priority']!;
  String get habitsOverview => _localizedValues[locale.languageCode]!['habits_overview']!;

  String dayStreak(int count) {
    String text = _localizedValues[locale.languageCode]!['day_streak']!;
    return text.replaceAll('{count}', count.toString());
  }

  String noTasksForDate(String date) {
    String text = _localizedValues[locale.languageCode]!['no_tasks_for_date']!;
    return text.replaceAll('{date}', date);
  }

  String noHabitsForDate(String date) {
    String text = _localizedValues[locale.languageCode]!['no_habits_for_date']!;
    return text.replaceAll('{date}', date);
  }
}

class _CalendarLocalizationsDelegate
    extends LocalizationsDelegate<CalendarLocalizations> {
  const _CalendarLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<CalendarLocalizations> load(Locale locale) async {
    return CalendarLocalizations(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<CalendarLocalizations> old) {
    return false;
  }
}
