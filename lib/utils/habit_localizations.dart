import 'package:flutter/material.dart';

class HabitLocalizations {
  final Locale locale;

  HabitLocalizations(this.locale);

  static HabitLocalizations of(BuildContext context) {
    return Localizations.of<HabitLocalizations>(context, HabitLocalizations)!;
  }

  static const LocalizationsDelegate<HabitLocalizations> delegate =
      _HabitLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'todays_progress': "Today's Progress",
      'stats': 'Stats',
      'completed': 'Completed',
      'streaks': 'Streaks',
      'rate': 'Rate',
      'habit_added': 'Habit added',
      'habit_updated': 'Habit updated',
      'create_habit': 'Create Habit',
      'edit_habit': 'Edit Habit',
      'habit_name': 'Habit name',
      'required': 'Required',
      'description': 'Description',
      'emoji_icon': 'Emoji / Icon',
      'linked_task_tags': 'Linked task tags',
      'frequency': 'Frequency',
      'weekly_goal': 'Weekly goal',
      'color': 'Color',
      'add_habit': 'Add Habit',
      'update_habit': 'Update Habit',
      'no_habits_yet': 'No habits yet',
      'create_first_habit': 'Create your first habit to start\nbuilding better routines',
      'add_habit_button': 'Add habit',
      'export_statistics': 'Export Statistics',
      'export_as_text': 'Export as Text',
      'plain_text_summary': 'Plain text summary',
      'share_stats': 'Share Stats',
      'share_with_others': 'Share with others',
      'habit_statistics_report': '=== Habit Statistics Report ===',
      'generated': 'Generated: ',
      'overview': 'Overview',
      'total_habits': '- Total Habits: ',
      'overall_completion_rate': '- Overall Completion Rate: ',
      'total_completions': '- Total Completions: ',
      'active_streak_days': '- Active Streak Days: ',
      'individual_habits': 'Individual Habits:',
      'current_streak': '  - Current Streak: {days} days',
      'longest_streak': '  - Longest Streak: {days} days',
      'seven_day_rate': '  - 7-Day Rate: {rate}%',
      'thirty_day_rate': '  - 30-Day Rate: {rate}%',
      'stats_copied': 'Statistics copied to clipboard!',
      'share_functionality': 'Share functionality - integrate with share_plus package',
      'habit_statistics': 'Habit Statistics',
      'export': 'Export',
      'completion_rate': 'Completion Rate',
      'heatmap': 'Heatmap',
      'failed_to_load_stats': 'Failed to load statistics',
      'retry': 'Retry',
      'create_habits_to_see_stats': 'Create habits to see statistics',
      'active_streaks': 'Active Streaks',
      'total_done': 'Total Done',
      'habits': 'Habits',
      'best_performer': 'Best Performer',
      'time_range_7_days': '7 Days',
      'time_range_30_days': '30 Days',
      'time_range_90_days': '90 Days',
      'less': 'Less',
      'more': 'More',
      'mon': 'Mon',
      'tue': 'Tue',
      'wed': 'Wed',
      'thu': 'Thu',
      'fri': 'Fri',
      'sat': 'Sat',
      'sun': 'Sun',
      'month_j': 'J',
      'month_f': 'F',
      'month_m': 'M',
      'month_a': 'A',
      'month_ma': 'M',
      'month_ju': 'J',
      'month_jl': 'J',
      'month_au': 'A',
      'month_s': 'S',
      'month_o': 'O',
      'month_n': 'N',
      'month_d': 'D',
    },
    'fr': {
      'todays_progress': "Progrès d'aujourd'hui",
      'stats': 'Stats',
      'completed': 'Terminé',
      'streaks': 'Séries',
      'rate': 'Taux',
      'habit_added': 'Habitude ajoutée',
      'habit_updated': 'Habitude mise à jour',
      'create_habit': 'Créer une habitude',
      'edit_habit': 'Modifier l\'habitude',
      'habit_name': 'Nom de l\'habitude',
      'required': 'Requis',
      'description': 'Description',
      'emoji_icon': 'Emoji / Icône',
      'linked_task_tags': 'Tags de tâches liés',
      'frequency': 'Fréquence',
      'weekly_goal': 'Objectif hebdomadaire',
      'color': 'Couleur',
      'add_habit': 'Ajouter l\'habitude',
      'update_habit': 'Mettre à jour l\'habitude',
      'no_habits_yet': 'Pas encore d\'habitudes',
      'create_first_habit': 'Créez votre première habitude pour commencer\nà construire de meilleures routines',
      'add_habit_button': 'Ajouter une habitude',
      'export_statistics': 'Exporter les statistiques',
      'export_as_text': 'Exporter en texte',
      'plain_text_summary': 'Résumé en texte brut',
      'share_stats': 'Partager les stats',
      'share_with_others': 'Partager avec d\'autres',
      'habit_statistics_report': '=== Rapport de statistiques d\'habitudes ===',
      'generated': 'Généré: ',
      'overview': 'Aperçu',
      'total_habits': '- Total des habitudes: ',
      'overall_completion_rate': '- Taux de complétion global: ',
      'total_completions': '- Total des complétions: ',
      'active_streak_days': '- Jours de série active: ',
      'individual_habits': 'Habitudes individuelles:',
      'current_streak': '  - Série actuelle: {days} jours',
      'longest_streak': '  - Plus longue série: {days} jours',
      'seven_day_rate': '  - Taux sur 7 jours: {rate}%',
      'thirty_day_rate': '  - Taux sur 30 jours: {rate}%',
      'stats_copied': 'Statistiques copiées dans le presse-papiers!',
      'share_functionality': 'Fonctionnalité de partage - intégrer avec le paquet share_plus',
      'habit_statistics': 'Statistiques d\'habitudes',
      'export': 'Exporter',
      'completion_rate': 'Taux de complétion',
      'heatmap': 'Carte thermique',
      'failed_to_load_stats': 'Échec du chargement des statistiques',
      'retry': 'Réessayer',
      'create_habits_to_see_stats': 'Créez des habitudes pour voir les statistiques',
      'active_streaks': 'Séries actives',
      'total_done': 'Total fait',
      'habits': 'Habitudes',
      'best_performer': 'Meilleure performance',
      'time_range_7_days': '7 Jours',
      'time_range_30_days': '30 Jours',
      'time_range_90_days': '90 Jours',
      'less': 'Moins',
      'more': 'Plus',
      'mon': 'Lun',
      'tue': 'Mar',
      'wed': 'Mer',
      'thu': 'Jeu',
      'fri': 'Ven',
      'sat': 'Sam',
      'sun': 'Dim',
      'month_j': 'J',
      'month_f': 'F',
      'month_m': 'M',
      'month_a': 'A',
      'month_ma': 'M',
      'month_ju': 'J',
      'month_jl': 'J',
      'month_au': 'A',
      'month_s': 'S',
      'month_o': 'O',
      'month_n': 'N',
      'month_d': 'D',
    },
    'ar': {
      'todays_progress': "تقدم اليوم",
      'stats': 'إحصائيات',
      'completed': 'مكتمل',
      'streaks': 'سلاسل',
      'rate': 'معدل',
      'habit_added': 'تمت إضافة العادة',
      'habit_updated': 'تم تحديث العادة',
      'create_habit': 'إنشاء عادة',
      'edit_habit': 'تعديل العادة',
      'habit_name': 'اسم العادة',
      'required': 'مطلوب',
      'description': 'الوصف',
      'emoji_icon': 'رمز تعبيري / أيقونة',
      'linked_task_tags': 'وسوم المهام المرتبطة',
      'frequency': 'التكرار',
      'weekly_goal': 'الهدف الأسبوعي',
      'color': 'اللون',
      'add_habit': 'إضافة عادة',
      'update_habit': 'تحديث العادة',
      'no_habits_yet': 'لا توجد عادات بعد',
      'create_first_habit': 'أنشئ عادتك الأولى لتبدأ\nببناء روتين أفضل',
      'add_habit_button': 'إضافة عادة',
      'export_statistics': 'تصدير الإحصائيات',
      'export_as_text': 'تصدير كنص',
      'plain_text_summary': 'ملخص نصي عادي',
      'share_stats': 'مشاركة الإحصائيات',
      'share_with_others': 'مشاركة مع الآخرين',
      'habit_statistics_report': '=== تقرير إحصائيات العادات ===',
      'generated': 'تم الإنشاء: ',
      'overview': 'نظرة عامة',
      'total_habits': '- إجمالي العادات: ',
      'overall_completion_rate': '- معدل الإكمال العام: ',
      'total_completions': '- إجمالي الإكمالات: ',
      'active_streak_days': '- أيام السلسلة النشطة: ',
      'individual_habits': 'العادات الفردية:',
      'current_streak': '  - السلسلة الحالية: {days} أيام',
      'longest_streak': '  - أطول سلسلة: {days} أيام',
      'seven_day_rate': '  - معدل 7 أيام: {rate}%',
      'thirty_day_rate': '  - معدل 30 يوم: {rate}%',
      'stats_copied': 'تم نسخ الإحصائيات إلى الحافظة!',
      'share_functionality': 'وظيفة المشاركة - دمج مع حزمة share_plus',
      'habit_statistics': 'إحصائيات العادات',
      'export': 'تصدير',
      'completion_rate': 'معدل الإكمال',
      'heatmap': 'خريطة حرارية',
      'failed_to_load_stats': 'فشل تحميل الإحصائيات',
      'retry': 'إعادة المحاولة',
      'create_habits_to_see_stats': 'أنشئ عادات لرؤية الإحصائيات',
      'active_streaks': 'السلاسل النشطة',
      'total_done': 'الإجمالي المنجز',
      'habits': 'العادات',
      'best_performer': 'الأفضل أداءً',
      'time_range_7_days': '7 أيام',
      'time_range_30_days': '30 يوم',
      'time_range_90_days': '90 يوم',
      'less': 'أقل',
      'more': 'أكثر',
      'mon': 'إثن',
      'tue': 'ثلا',
      'wed': 'أرب',
      'thu': 'خمي',
      'fri': 'جمع',
      'sat': 'سبت',
      'sun': 'أحد',
      'month_j': 'ي',
      'month_f': 'ف',
      'month_m': 'م',
      'month_a': 'أ',
      'month_ma': 'م',
      'month_ju': 'ي',
      'month_jl': 'ي',
      'month_au': 'أ',
      'month_s': 'س',
      'month_o': 'أ',
      'month_n': 'ن',
      'month_d': 'د',
    },
  };

  String get todaysProgress => _localizedValues[locale.languageCode]!['todays_progress']!;
  String get stats => _localizedValues[locale.languageCode]!['stats']!;
  String get completed => _localizedValues[locale.languageCode]!['completed']!;
  String get streaks => _localizedValues[locale.languageCode]!['streaks']!;
  String get rate => _localizedValues[locale.languageCode]!['rate']!;
  String get habitAdded => _localizedValues[locale.languageCode]!['habit_added']!;
  String get habitUpdated => _localizedValues[locale.languageCode]!['habit_updated']!;
  String get createHabit => _localizedValues[locale.languageCode]!['create_habit']!;
  String get editHabit => _localizedValues[locale.languageCode]!['edit_habit']!;
  String get habitName => _localizedValues[locale.languageCode]!['habit_name']!;
  String get required => _localizedValues[locale.languageCode]!['required']!;
  String get description => _localizedValues[locale.languageCode]!['description']!;
  String get emojiIcon => _localizedValues[locale.languageCode]!['emoji_icon']!;
  String get linkedTaskTags => _localizedValues[locale.languageCode]!['linked_task_tags']!;
  String get frequency => _localizedValues[locale.languageCode]!['frequency']!;
  String get weeklyGoal => _localizedValues[locale.languageCode]!['weekly_goal']!;
  String get color => _localizedValues[locale.languageCode]!['color']!;
  String get addHabit => _localizedValues[locale.languageCode]!['add_habit']!;
  String get updateHabit => _localizedValues[locale.languageCode]!['update_habit']!;
  String get noHabitsYet => _localizedValues[locale.languageCode]!['no_habits_yet']!;
  String get createFirstHabit => _localizedValues[locale.languageCode]!['create_first_habit']!;
  String get addHabitButton => _localizedValues[locale.languageCode]!['add_habit_button']!;
  String get exportStatistics => _localizedValues[locale.languageCode]!['export_statistics']!;
  String get exportAsText => _localizedValues[locale.languageCode]!['export_as_text']!;
  String get plainTextSummary => _localizedValues[locale.languageCode]!['plain_text_summary']!;
  String get shareStats => _localizedValues[locale.languageCode]!['share_stats']!;
  String get shareWithOthers => _localizedValues[locale.languageCode]!['share_with_others']!;
  String get habitStatisticsReport => _localizedValues[locale.languageCode]!['habit_statistics_report']!;
  String get generated => _localizedValues[locale.languageCode]!['generated']!;
  String get overview => _localizedValues[locale.languageCode]!['overview']!;
  String get totalHabits => _localizedValues[locale.languageCode]!['total_habits']!;
  String get overallCompletionRate => _localizedValues[locale.languageCode]!['overall_completion_rate']!;
  String get totalCompletions => _localizedValues[locale.languageCode]!['total_completions']!;
  String get activeStreakDays => _localizedValues[locale.languageCode]!['active_streak_days']!;
  String get individualHabits => _localizedValues[locale.languageCode]!['individual_habits']!;
  String get statsCopied => _localizedValues[locale.languageCode]!['stats_copied']!;
  String get shareFunctionality => _localizedValues[locale.languageCode]!['share_functionality']!;
  String get habitStatistics => _localizedValues[locale.languageCode]!['habit_statistics']!;
  String get export => _localizedValues[locale.languageCode]!['export']!;
  String get completionRate => _localizedValues[locale.languageCode]!['completion_rate']!;
  String get heatmap => _localizedValues[locale.languageCode]!['heatmap']!;
  String get failedToLoadStats => _localizedValues[locale.languageCode]!['failed_to_load_stats']!;
  String get retry => _localizedValues[locale.languageCode]!['retry']!;
  String get createHabitsToSeeStats => _localizedValues[locale.languageCode]!['create_habits_to_see_stats']!;
  String get activeStreaks => _localizedValues[locale.languageCode]!['active_streaks']!;
  String get totalDone => _localizedValues[locale.languageCode]!['total_done']!;
  String get habits => _localizedValues[locale.languageCode]!['habits']!;
  String get bestPerformer => _localizedValues[locale.languageCode]!['best_performer']!;
  String get timeRange7Days => _localizedValues[locale.languageCode]!['time_range_7_days']!;
  String get timeRange30Days => _localizedValues[locale.languageCode]!['time_range_30_days']!;
  String get timeRange90Days => _localizedValues[locale.languageCode]!['time_range_90_days']!;
  String get less => _localizedValues[locale.languageCode]!['less']!;
  String get more => _localizedValues[locale.languageCode]!['more']!;

  List<String> get daysOfWeek => [
    _localizedValues[locale.languageCode]!['mon']!,
    _localizedValues[locale.languageCode]!['tue']!,
    _localizedValues[locale.languageCode]!['wed']!,
    _localizedValues[locale.languageCode]!['thu']!,
    _localizedValues[locale.languageCode]!['fri']!,
    _localizedValues[locale.languageCode]!['sat']!,
    _localizedValues[locale.languageCode]!['sun']!,
  ];

  List<String> get months => [
    _localizedValues[locale.languageCode]!['month_j']!,
    _localizedValues[locale.languageCode]!['month_f']!,
    _localizedValues[locale.languageCode]!['month_m']!,
    _localizedValues[locale.languageCode]!['month_a']!,
    _localizedValues[locale.languageCode]!['month_ma']!,
    _localizedValues[locale.languageCode]!['month_ju']!,
    _localizedValues[locale.languageCode]!['month_jl']!,
    _localizedValues[locale.languageCode]!['month_au']!,
    _localizedValues[locale.languageCode]!['month_s']!,
    _localizedValues[locale.languageCode]!['month_o']!,
    _localizedValues[locale.languageCode]!['month_n']!,
    _localizedValues[locale.languageCode]!['month_d']!,
  ];

  String currentStreak(int days) {
    return _localizedValues[locale.languageCode]!['current_streak']!
        .replaceAll('{days}', days.toString());
  }

  String longestStreak(int days) {
    return _localizedValues[locale.languageCode]!['longest_streak']!
        .replaceAll('{days}', days.toString());
  }

  String sevenDayRate(double rate) {
    return _localizedValues[locale.languageCode]!['seven_day_rate']!
        .replaceAll('{rate}', rate.toStringAsFixed(1));
  }

  String thirtyDayRate(double rate) {
    return _localizedValues[locale.languageCode]!['thirty_day_rate']!
        .replaceAll('{rate}', rate.toStringAsFixed(1));
  }
}

class _HabitLocalizationsDelegate
    extends LocalizationsDelegate<HabitLocalizations> {
  const _HabitLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<HabitLocalizations> load(Locale locale) async {
    return HabitLocalizations(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<HabitLocalizations> old) {
    return false;
  }
}

