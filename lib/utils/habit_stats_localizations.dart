import 'package:flutter/material.dart';

class HabitStatsLocalizations {
  final Locale locale;

  HabitStatsLocalizations(this.locale);

  static HabitStatsLocalizations of(BuildContext context) {
    return Localizations.of<HabitStatsLocalizations>(context, HabitStatsLocalizations)!;
  }

  static const LocalizationsDelegate<HabitStatsLocalizations> delegate =
      _HabitStatsLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
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
      'current_streak_param': '  - Current Streak: {days} days',
      'longest_streak_param': '  - Longest Streak: {days} days',
      'seven_day_rate': '  - 7-Day Rate: {rate}%',
      'thirty_day_rate': '  - 30-Day Rate: {rate}%',
      'stats_copied': 'Statistics copied to clipboard!',
      'share_functionality': 'Share functionality - integrate with share_plus package',
      'habit_statistics': 'Habit Statistics',
      'export': 'Export',
      'completion_rate': 'Completion Rate',
      'streaks': 'Streaks',
      'heatmap': 'Heatmap',
      'failed_to_load_stats': 'Failed to load statistics',
      'retry': 'Retry',
      'no_habits_yet': 'No habits yet',
      'create_habits_to_see_stats': 'Create habits to see statistics',
      'active_streaks': 'Active Streaks',
      'total_done': 'Total Done',
      'habits': 'Habits',
      'best_performer': 'Best Performer',
      'all_habits_performance': 'All Habits Performance',
      'time_range_7_days': '7 Days',
      'time_range_30_days': '30 Days',
      'time_range_90_days': '90 Days',
      'by_day_of_week': 'By Day of Week',
      'current_streak': 'Current Streak',
      'longest_streak': 'Longest Streak',
      'streak_history': 'Streak History',
      'no_streak_history_yet': 'No streak history yet',
      'streak_leaderboard': 'Streak Leaderboard',
      'activity_heatmap': 'Activity Heatmap',
      'last_90_days': 'Last 90 days',
      'monthly_activity': 'Monthly Activity',
      'completion': 'completion',
      'day_streak': 'day streak',
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
      'export_statistics': 'Exporter les statistiques',
      'export_as_text': 'Exporter en texte',
      'plain_text_summary': 'Résumé en texte brut',
      'share_stats': 'Partager les stats',
      'share_with_others': 'Partager avec d\'autres',
      'habit_statistics_report': '=== Rapport de statistiques ===',
      'generated': 'Généré le : ',
      'overview': 'Aperçu',
      'total_habits': '- Total des habitudes : ',
      'overall_completion_rate': '- Taux d\'achèvement global : ',
      'total_completions': '- Total des achèvements : ',
      'active_streak_days': '- Jours de série active : ',
      'individual_habits': 'Habitudes individuelles :',
      'current_streak_param': '  - Série actuelle : {days} jours',
      'longest_streak_param': '  - Plus longue série : {days} jours',
      'seven_day_rate': '  - Taux sur 7 jours : {rate}%',
      'thirty_day_rate': '  - Taux sur 30 jours : {rate}%',
      'stats_copied': 'Statistiques copiées dans le presse-papiers !',
      'share_functionality': 'Fonctionnalité de partage - intégrer avec share_plus',
      'habit_statistics': 'Statistiques des habitudes',
      'export': 'Exporter',
      'completion_rate': 'Taux d\'achèvement',
      'streaks': 'Séries',
      'heatmap': 'Carte thermique',
      'failed_to_load_stats': 'Échec du chargement des statistiques',
      'retry': 'Réessayer',
      'no_habits_yet': 'Pas encore d\'habitudes',
      'create_habits_to_see_stats': 'Créez des habitudes pour voir les statistiques',
      'active_streaks': 'Séries actives',
      'total_done': 'Total terminé',
      'habits': 'Habitudes',
      'best_performer': 'Meilleure performance',
      'all_habits_performance': 'Performance de toutes les habitudes',
      'time_range_7_days': '7 Jours',
      'time_range_30_days': '30 Jours',
      'time_range_90_days': '90 Jours',
      'by_day_of_week': 'Par jour de la semaine',
      'current_streak': 'Série actuelle',
      'longest_streak': 'Plus longue série',
      'streak_history': 'Historique des séries',
      'no_streak_history_yet': 'Pas encore d\'historique de série',
      'streak_leaderboard': 'Classement des séries',
      'activity_heatmap': 'Carte thermique d\'activité',
      'last_90_days': '90 derniers jours',
      'monthly_activity': 'Activité mensuelle',
      'completion': 'achèvement',
      'day_streak': 'jours de suite',
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
      'current_streak_param': '  - السلسلة الحالية: {days} أيام',
      'longest_streak_param': '  - أطول سلسلة: {days} أيام',
      'seven_day_rate': '  - معدل 7 أيام: {rate}%',
      'thirty_day_rate': '  - معدل 30 يوم: {rate}%',
      'stats_copied': 'تم نسخ الإحصائيات إلى الحافظة!',
      'share_functionality': 'وظيفة المشاركة - التكامل مع حزمة share_plus',
      'habit_statistics': 'إحصائيات العادات',
      'export': 'تصدير',
      'completion_rate': 'معدل الإكمال',
      'streaks': 'السلاسل',
      'heatmap': 'خريطة حرارية',
      'failed_to_load_stats': 'فشل تحميل الإحصائيات',
      'retry': 'إعادة المحاولة',
      'no_habits_yet': 'لا توجد عادات بعد',
      'create_habits_to_see_stats': 'أنشئ عادات لرؤية الإحصائيات',
      'active_streaks': 'السلاسل النشطة',
      'total_done': 'إجمالي المنجز',
      'habits': 'العادات',
      'best_performer': 'الأفضل أداءً',
      'all_habits_performance': 'أداء جميع العادات',
      'time_range_7_days': '7 أيام',
      'time_range_30_days': '30 يومًا',
      'time_range_90_days': '90 يومًا',
      'by_day_of_week': 'حسب يوم الأسبوع',
      'current_streak': 'السلسلة الحالية',
      'longest_streak': 'أطول سلسلة',
      'streak_history': 'سجل السلاسل',
      'no_streak_history_yet': 'لا يوجد سجل للسلاسل بعد',
      'streak_leaderboard': 'لوحة صدارة السلاسل',
      'activity_heatmap': 'خريطة النشاط الحرارية',
      'last_90_days': 'آخر 90 يومًا',
      'monthly_activity': 'النشاط الشهري',
      'completion': 'إكمال',
      'day_streak': 'أيام متتالية',
      'less': 'أقل',
      'more': 'أكثر',
      'mon': 'إثنين',
      'tue': 'ثلاثاء',
      'wed': 'أربعاء',
      'thu': 'خميس',
      'fri': 'جمعة',
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
  String get streaks => _localizedValues[locale.languageCode]!['streaks']!;
  String get heatmap => _localizedValues[locale.languageCode]!['heatmap']!;
  String get failedToLoadStats => _localizedValues[locale.languageCode]!['failed_to_load_stats']!;
  String get retry => _localizedValues[locale.languageCode]!['retry']!;
  String get noHabitsYet => _localizedValues[locale.languageCode]!['no_habits_yet']!;
  String get createHabitsToSeeStats => _localizedValues[locale.languageCode]!['create_habits_to_see_stats']!;
  String get activeStreaks => _localizedValues[locale.languageCode]!['active_streaks']!;
  String get totalDone => _localizedValues[locale.languageCode]!['total_done']!;
  String get habits => _localizedValues[locale.languageCode]!['habits']!;
  String get bestPerformer => _localizedValues[locale.languageCode]!['best_performer']!;
  String get allHabitsPerformance => _localizedValues[locale.languageCode]!['all_habits_performance']!;
  String get timeRange7Days => _localizedValues[locale.languageCode]!['time_range_7_days']!;
  String get timeRange30Days => _localizedValues[locale.languageCode]!['time_range_30_days']!;
  String get timeRange90Days => _localizedValues[locale.languageCode]!['time_range_90_days']!;
  String get byDayOfWeek => _localizedValues[locale.languageCode]!['by_day_of_week']!;
  String get currentStreak => _localizedValues[locale.languageCode]!['current_streak']!;
  String get longestStreak => _localizedValues[locale.languageCode]!['longest_streak']!;
  String get streakHistory => _localizedValues[locale.languageCode]!['streak_history']!;
  String get noStreakHistoryYet => _localizedValues[locale.languageCode]!['no_streak_history_yet']!;
  String get streakLeaderboard => _localizedValues[locale.languageCode]!['streak_leaderboard']!;
  String get activityHeatmap => _localizedValues[locale.languageCode]!['activity_heatmap']!;
  String get last90Days => _localizedValues[locale.languageCode]!['last_90_days']!;
  String get monthlyActivity => _localizedValues[locale.languageCode]!['monthly_activity']!;
  String get completion => _localizedValues[locale.languageCode]!['completion']!;
  String get dayStreak => _localizedValues[locale.languageCode]!['day_streak']!;
  String get less => _localizedValues[locale.languageCode]!['less']!;
  String get more => _localizedValues[locale.languageCode]!['more']!;

  String currentStreakParam(int days) {
    String text = _localizedValues[locale.languageCode]!['current_streak_param']!;
    return text.replaceAll('{days}', days.toString());
  }

  String longestStreakParam(int days) {
    String text = _localizedValues[locale.languageCode]!['longest_streak_param']!;
    return text.replaceAll('{days}', days.toString());
  }

  String sevenDayRate(double rate) {
    String text = _localizedValues[locale.languageCode]!['seven_day_rate']!;
    return text.replaceAll('{rate}', rate.toStringAsFixed(1));
  }

  String thirtyDayRate(double rate) {
    String text = _localizedValues[locale.languageCode]!['thirty_day_rate']!;
    return text.replaceAll('{rate}', rate.toStringAsFixed(1));
  }

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
}

class _HabitStatsLocalizationsDelegate
    extends LocalizationsDelegate<HabitStatsLocalizations> {
  const _HabitStatsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<HabitStatsLocalizations> load(Locale locale) async {
    return HabitStatsLocalizations(locale);
  }

  @override
  bool shouldReload(_HabitStatsLocalizationsDelegate old) => false;
}

