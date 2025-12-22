// lib/utils/app_localizations.dart

import 'package:flutter/material.dart';
import 'translations/settings_translations.dart';
import 'translations/backup_translations.dart';
import 'translations/help_support_translations.dart';
import 'translations/terms_privacy_translations.dart';
import 'translations/tasks_translations.dart';
import 'translations/pomodoro_translations.dart';
import 'translations/templates_translations.dart';
import 'translations/task_detail_translations.dart';
import 'translations/notes_translations.dart';
import 'translations/auth_translations.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // All translations
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': _enTranslations,
    'fr': _frTranslations,
    'ar': _arTranslations,
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _enTranslations[key] ??
        key;
  }

  /// Returns a localized string and replaces `{placeholders}` with provided values.
  ///
  /// Example: translateWithArgs('create_task_from_template', args: {'taskTitle': 'Standup'})
  String translateWithArgs(
    String key, {
    Map<String, Object?> args = const {},
  }) {
    var text = translate(key);
    if (args.isEmpty) return text;

    args.forEach((placeholder, value) {
      text = text.replaceAll('{$placeholder}', value?.toString() ?? '');
    });

    return text;
  }

  // Common
  String get appName => translate('app_name');
  String get signIn => translate('sign_in');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get close => translate('close');
  String get change => translate('change');
  String get gotIt => translate('got_it');
  String get loading => translate('loading');

  // Auth Pages - Moved to AuthTranslations and TermsPrivacyTranslations

  // Settings
  String get settings => translate('settings');
  String get profile => translate('profile');
  String get editProfile => translate('edit_profile');
  String get appearance => translate('appearance');
  String get theme => translate('theme');
  String get lightMode => translate('light_mode');
  String get darkMode => translate('dark_mode');
  String get language => translate('language');
  String get selectLanguage => translate('select_language');
  String get account => translate('account');
  String get syncStatus => translate('sync_status');
  String get lastSynced => translate('last_synced');
  String get changePassword => translate('change_password');
  String get updatePassword => translate('update_password');
  String get currentPassword => translate('current_password');
  String get newPassword => translate('new_password');
  String get confirmNewPassword => translate('confirm_new_password');
  String get preferences => translate('preferences');
  String get notifications => translate('notifications');
  String get notificationsEnabled => translate('notifications_enabled');
  String get notificationsDisabled => translate('notifications_disabled');
  String get receiveTaskAlerts => translate('receive_task_alerts');
  String get noNotifications => translate('no_notifications');
  String get privacy => translate('privacy');
  String get privacySettings => translate('privacy_settings');
  String get backupAndSync => translate('backup_and_sync');
  String get cloudBackup => translate('cloud_backup');
  String get about => translate('about');
  String get aboutDayFlow => translate('about_dayflow');
  String get version => translate('version');
  String get helpAndSupport => translate('help_and_support');
  String get getHelp => translate('get_help');
  String get termsAndPrivacy => translate('terms_and_privacy');
  String get legalInfo => translate('legal_info');
  String get signInToContinueDesc => translate('sign_in_to_continue_desc');

  // Dialogs
  String get featureUnderDevelopment => translate('feature_under_development');
  String get workingHardOnFeature => translate('working_hard_on_feature');
  String get logoutConfirmation => translate('logout_confirmation');
  String get areYouSureLogout => translate('are_you_sure_logout');
  String get logoutSuccess => translate('logout_success');
  String get languageChanged => translate('language_changed');
  String get themeChanged => translate('theme_changed');
  String get profileUpdated => translate('profile_updated');
  String get passwordChanged => translate('password_changed');

  // Validation
  String get pleaseEnterEmail => translate('please_enter_email');
  String get pleaseEnterValidEmail => translate('please_enter_valid_email');
  String get pleaseEnterPassword => translate('please_enter_password');
  String get passwordTooShort => translate('password_too_short');
  String get pleaseEnterName => translate('please_enter_name');
  String get nameTooShort => translate('name_too_short');
  String get pleaseConfirmPassword => translate('please_confirm_password');
  String get passwordsDoNotMatch => translate('passwords_do_not_match');
  String get passwordMustBeDifferent => translate('password_must_be_different');
  String get pleaseEnterCurrentPassword =>
      translate('please_enter_current_password');
  String get pleaseEnterNewPassword => translate('please_enter_new_password');

  // Input Placeholders
  String get enterEmail => translate('enter_email');
  String get enterPassword => translate('enter_password');
  String get enterName => translate('enter_name');
  String get reEnterPassword => translate('re_enter_password');
  String get enterCurrentPassword => translate('enter_current_password');
  String get enterNewPassword => translate('enter_new_password');

  // About
  String get appDescription => translate('app_description');
  String get developedBy => translate('developed_by');
  String get teamMembers => translate('team_members');



  // Auth Pages - Moved to AuthTranslations and TermsPrivacyTranslations

  // Navigation & Drawer
  String get tasks => translate('tasks');
  String get notes => translate('notes');
  String get reminders => translate('reminders');
  String get habits => translate('habits');
  String get manageTodos => translate('manage_todos');
  String get quickIdeas => translate('quick_ideas');
  String get neverMissTasks => translate('never_miss_tasks');
  String get trackDailyHabits => translate('track_daily_habits');
  String get statistics => translate('statistics');
  String get viewProgress => translate('view_progress');
  String get customizeExperience => translate('customize_experience');
  String get habitsPageComingSoon => translate('habits_page_coming_soon');
  String get statisticsComingSoon => translate('statistics_coming_soon');
  String get openMenu => translate('open_menu');
  String get search => translate('search');

  // Help & Support
  String get howCanWeHelp => translate('how_can_we_help');
  String get findAnswers => translate('find_answers');
  String get contactUs => translate('contact_us');
  String get emailSupport => translate('email_support');
  String get liveChat => translate('live_chat');
  String get chatWithTeam => translate('chat_with_team');
  String get reportProblem => translate('report_problem');
  String get letUsKnow => translate('let_us_know');
  String get faq => translate('faq');
  String get resources => translate('resources');
  String get userGuide => translate('user_guide');
  String get learnHowToUse => translate('learn_how_to_use');
  String get videoTutorials => translate('video_tutorials');
  String get watchGuides => translate('watch_guides');
  String get tipsTricks => translate('tips_tricks');
  String get getMostOut => translate('get_most_out');
  String get problemType => translate('problem_type');
  String get description => translate('description');
  String get describeIssue => translate('describe_issue');
  String get submit => translate('submit');
  String get problemReportSubmitted => translate('problem_report_submitted');
  String get faqCreateTask => translate('faq_create_task');
  String get faqCreateTaskAnswer => translate('faq_create_task_answer');
  String get faqDarkMode => translate('faq_dark_mode');
  String get faqDarkModeAnswer => translate('faq_dark_mode_answer');
  String get faqSyncData => translate('faq_sync_data');
  String get faqSyncDataAnswer => translate('faq_sync_data_answer');
  String get faqSetReminders => translate('faq_set_reminders');
  String get faqSetRemindersAnswer => translate('faq_set_reminders_answer');
  String get faqBackupData => translate('faq_backup_data');
  String get faqBackupDataAnswer => translate('faq_backup_data_answer');
  String get faqExportData => translate('faq_export_data');
  String get faqExportDataAnswer => translate('faq_export_data_answer');

  // Pomodoro
  String get pomodoroTimer => translate('pomodoro_timer');
  String get sessionHistory => translate('session_history');
  String get timerFinished => translate('timer_finished');
  String get whatWouldYouLikeToDo => translate('what_would_you_like_to_do');
  String get extend5m => translate('extend_5m');
  String get stop => translate('stop');
  String get focusTime => translate('focus_time');
  String get streak => translate('streak');
  String get startFocus => translate('start_focus');
  String get linkToTask => translate('link_to_task');
  String get workingOn => translate('working_on');
  String get noSessionsToday => translate('no_sessions_today');
  String get startFocusSessionMsg => translate('start_focus_session_msg');
  String get todaysSessions => translate('todays_sessions');
  String get focusSession => translate('focus_session');
  String get selectTask => translate('select_task');
  String get noPendingTasks => translate('no_pending_tasks');
  String get duePrefix => translate('due_prefix');
  String get sessionsSuffix => translate('sessions_suffix');
  String get sessionsLabel => translate('sessions_label');
  String get noSessionsYet => translate('no_sessions_yet');
  String get timerSettings => translate('timer_settings');
  String get workDuration => translate('work_duration');
  String get shortBreak => translate('short_break');
  String get longBreak => translate('long_break');
  String get sessionsBeforeLongBreak => translate('sessions_before_long_break');
  String get autoStartBreaks => translate('auto_start_breaks');
  String get autoStartBreaksDesc => translate('auto_start_breaks_desc');
  String get autoStartWork => translate('auto_start_work');
  String get autoStartWorkDesc => translate('auto_start_work_desc');
  String get sound => translate('sound');
  String get soundDesc => translate('sound_desc');
  String get sessionTypeWork => translate('session_type_work');
  String get sessionTypeShortBreak => translate('session_type_short_break');
  String get sessionTypeLongBreak => translate('session_type_long_break');
  String get minSuffix => translate('min_suffix');
  String get minutes => translate('minutes');

  // Templates
  String get taskTemplates => translate('task_templates');
  String get searchTemplates => translate('search_templates');
  String get createTemplate => translate('create_template');
  String get editTemplate => translate('edit_template');
  String get templateName => translate('template_name');
  String get templateNameHint => translate('template_name_hint');
  String get defaultPriority => translate('default_priority');
  String get estimatedDuration => translate('estimated_duration');
  String get category => translate('category');
  String get categoryHint => translate('category_hint');
  String get saveTemplate => translate('save_template');
  String get createTaskFromTemplate => translate('create_task_from_template');
  String get view => translate('view');
  String get noTemplatesFound => translate('no_templates_found');
  String get noTemplatesYet => translate('no_templates_yet');
  String get createFirstTemplate => translate('create_first_template');
  String get deleteTemplate => translate('delete_template');
  String get deleteTemplateConfirmation => translate('delete_template_confirmation');
  String get templateDeleted => translate('template_deleted');
  String get templateSaved => translate('template_saved');
  String get useTemplate => translate('use_template');
  String get popularTemplates => translate('popular_templates');
  String get recentTemplates => translate('recent_templates');
  String get allTemplates => translate('all_templates');
  String get icon => translate('icon');
  String get taskSettings => translate('task_settings');
  String get subtasks => translate('subtasks');
  String get add => translate('add');

  // Backup
  String get backupStatus => translate('backup_status');
  String get lastBackup => translate('last_backup');
  String get noBackupsYet => translate('no_backups_yet');
  String get quickActions => translate('quick_actions');
  String get backupNow => translate('backup_now');
  String get restoreBackup => translate('restore_backup');
  String get syncWithCloud => translate('sync_with_cloud');
  String get backupSettings => translate('backup_settings');
  String get autoBackup => translate('auto_backup');
  String get autoBackupDaily => translate('auto_backup_daily');
  String get cloudSync => translate('cloud_sync');
  String get syncAcrossDevices => translate('sync_across_devices');
  String get encryptData => translate('encrypt_data');
  String get secureBackups => translate('secure_backups');
  String get clearCache => translate('clear_cache');
  String get freeUpStorage => translate('free_up_storage');
  String get deleteAllData => translate('delete_all_data');
  String get permanentlyRemove => translate('permanently_remove');
  String get processing => translate('processing');
  String get backupCompleted => translate('backup_completed');
  String get backupRestored => translate('backup_restored');
  String get syncedCloud => translate('synced_cloud');
  String get restoreConfirm => translate('restore_confirm');
  String get deleteDataConfirm => translate('delete_data_confirm');
  String get clearCacheConfirm => translate('clear_cache_confirm');
  String get cacheCleared => translate('cache_cleared');
  String get allDataDeleted => translate('all_data_deleted');
  String get deleteAll => translate('delete_all');
  String get clear => translate('clear');
  String get restore => translate('restore');

  // Terms & Privacy
  String get termsOfService => translate('terms_of_service');
  String get privacyPolicyTitle => translate('privacy_policy_title');
  String get lastUpdated => translate('last_updated');
  String get byUsingDayflow => translate('by_using_dayflow');

  // Reminders Page Localization
  String get remindersRetry => translate('remindersRetry');
  String get remindersNoRemindersTitle =>
      translate('remindersNoRemindersTitle');
  String get remindersNoRemindersSubtitle =>
      translate('remindersNoRemindersSubtitle');
  String get remindersToday => translate('remindersToday');
  String get remindersTomorrow => translate('remindersTomorrow');
  String get remindersUpcoming => translate('remindersUpcoming');
  String get remindersSomethingWrong => translate('remindersSomethingWrong');

  // Reminders model page Localization
  String get weekdayMonday => translate('weekdayMonday');
  String get weekdayTuesday => translate('weekdayTuesday');
  String get weekdayWednesday => translate('weekdayWednesday');
  String get weekdayThursday => translate('weekdayThursday');
  String get weekdayFriday => translate('weekdayFriday');
  String get weekdaySaturday => translate('weekdaySaturday');
  String get weekdaySunday => translate('weekdaySunday');

  // Reminder add dialog Localization
  String get reminderCreateTitle => translate('reminderCreateTitle');
  String get reminderTitle => translate('reminderTitle');
  String get reminderEnterTitle => translate('reminderEnterTitle');
  String get reminderDescriptionOptional =>
      translate('reminderDescriptionOptional');
  String get reminderEnterDescription => translate('reminderEnterDescription');
  String get reminderSelectTime => translate('reminderSelectTime');
  String get reminderAdd => translate('reminderAdd');
  String get reminderErrorTitleRequired =>
      translate('reminderErrorTitleRequired');
  String get reminderErrorTimeRequired =>
      translate('reminderErrorTimeRequired');
  String get reminderAdded => translate('reminderAdded');

  // reminders item Localization
  String get reminderEditTitle => translate('reminderEditTitle');
  String get update => translate('update');
  String get editReminder => translate('editReminder');
  String get deleteReminder => translate('deleteReminder');
  String get enableReminder => translate('enableReminder');
  String get disableReminder => translate('disableReminder');
  String get reminderDeleteConfirmation =>
      translate('reminderDeleteConfirmation');
  String get reminderUpdated => translate('reminderUpdated');
  String get reminderDeleted => translate('reminderDeleted');
  String get delete => translate('delete');
  String get reminderInfoTaskLocked	 => translate('reminderInfoTaskLocked');
  String get task => translate('task');

  // Tasks Page
  String get todaysList => translate('todays_list');
  String get failedToLoadTasks => translate('failed_to_load_tasks');
  String get createNewTask => translate('create_new_task');
  String get editTask => translate('edit_task');
  String get taskTitle => translate('task_title');
  String get required => translate('required');
  String get tagsHint => translate('tags_hint');
  String get setDueDate => translate('set_due_date');
  String get addRecurrence => translate('add_recurrence');
  String get addTask => translate('add_task');
  String get updateTask => translate('update_task');
  String get taskAdded => translate('task_added');
  String get taskUpdated => translate('task_updated');
  String get noTasksYet => translate('no_tasks_yet');
  String get createFirstTask => translate('create_first_task');

  // Task Filter Bar
  String get sortedBy => translate('sorted_by');
  String get filterAndSort => translate('filter_and_sort');
  String get allTasks => translate('all_tasks');
  String get pendingTasks => translate('pending_tasks');
  String get completedTasks => translate('completed_tasks');
  String get todaysTasks => translate('todays_tasks');
  String get overdueTasks => translate('overdue_tasks');
  String get filterBy => translate('filter_by');
  String get sortBy => translate('sort_by');
  String get apply => translate('apply');

  // Priorities
  String get priorityNone => translate('priority_none');
  String get priorityLow => translate('priority_low');
  String get priorityMedium => translate('priority_medium');
  String get priorityHigh => translate('priority_high');

  // Sort Options
  String get sortDateCreated => translate('sort_date_created');
  String get sortDueDate => translate('sort_due_date');
  String get sortPriority => translate('sort_priority');
  String get sortAlphabetical => translate('sort_alphabetical');

  // Recurrence
  String get repeat => translate('repeat');
  String get recurrenceNone => translate('recurrence_none');
  String get recurrenceDaily => translate('recurrence_daily');
  String get recurrenceWeekly => translate('recurrence_weekly');
  String get recurrenceMonthly => translate('recurrence_monthly');
  String get recurrenceCustom => translate('recurrence_custom');

  // Recurrence Picker
  String get recurrenceRepeat => translate('recurrence_repeat');
  String get recurrenceEvery => translate('recurrence_every');
  String get recurrenceDay => translate('recurrence_day');
  String get recurrenceDays => translate('recurrence_days');
  String get recurrenceWeek => translate('recurrence_week');
  String get recurrenceWeeks => translate('recurrence_weeks');
  String get recurrenceMonth => translate('recurrence_month');
  String get recurrenceMonths => translate('recurrence_months');
  String get recurrenceOnTheseDays => translate('recurrence_on_these_days');
  String get recurrenceOnDay => translate('recurrence_on_day');
  String get recurrenceOfTheMonth => translate('recurrence_of_the_month');
  String get recurrenceEnds => translate('recurrence_ends');
  String get recurrenceOnSpecificDate => translate('recurrence_on_specific_date');
  String get recurrenceOnDate => translate('recurrence_on_date');
  String get recurrenceAfter => translate('recurrence_after');
  String get recurrenceOccurrences => translate('recurrence_occurrences');
  String get recurrenceNever => translate('recurrence_never');
  String get recurrenceUntil => translate('recurrence_until');
  String get recurrenceTimes => translate('recurrence_times');

  // Task Card
  String get noDueDate => translate('no_due_date');
  String get overduePrefix => translate('overdue_prefix');
  String get dueTodayPrefix => translate('due_today_prefix');

  // Dialogs
  String get comingSoon => translate('coming_soon');

  // Quote
  String get quoteText => translate('quote_text');
  String get quoteAuthor => translate('quote_author');

  // Recurrence Descriptions
  String get recurrenceDoesNotRepeat => translate('recurrence_does_not_repeat');
  String get recurrenceRepeatsDaily => translate('recurrence_repeats_daily');
  String get recurrenceRepeatsEveryDays => translate('recurrence_repeats_every_days');
  String get recurrenceRepeatsWeeklyOn => translate('recurrence_repeats_weekly_on');
  String get recurrenceRepeatsWeekly => translate('recurrence_repeats_weekly');
  String get recurrenceRepeatsEveryWeeks => translate('recurrence_repeats_every_weeks');
  String get recurrenceRepeatsMonthly => translate('recurrence_repeats_monthly');
  String get recurrenceRepeatsEveryMonths => translate('recurrence_repeats_every_months');
  String get recurrenceCustomEveryDays => translate('recurrence_custom_every_days');

  // Task Detail
  String get deleteTaskQuestion => translate('delete_task_question');
  String get deleteTaskConfirmation => translate('delete_task_confirmation');
  String get saveAsTemplate => translate('save_as_template');
  String get createTemplateFromTaskDesc => translate('create_template_from_task_desc');
  String get templateCreatedSuccess => translate('template_created_success');
  String get taskNotFound => translate('task_not_found');
  String get taskNotFoundMsg => translate('task_not_found_msg');
  String get daysOverdue => translate('days_overdue');
  String get dueToday => translate('due_today');
  String get daysLeft => translate('days_left');
  String get completedCount => translate('completed_count');

  // Notes
  String get notesTitle => translate('notes');
  String get searchNotesHint => translate('search_notes_hint');
  String get createNew => translate('create_new');
  String get textNote => translate('text_note');
  String get simpleTextNote => translate('simple_text_note');
  String get checklist => translate('checklist');
  String get taskListWithCheckboxes => translate('task_list_with_checkboxes');
  String get richTextNote => translate('rich_text_note');
  String get withFormattingOptions => translate('with_formatting_options');
  String get failedToLoadNotes => translate('failed_to_load_notes');

  // Notes common
  String get retry => translate('retry');
  String get clearAll => translate('clear_all');
  String get more => translate('more');

  // Notes protection / locking
  String get authenticateToViewNote => translate('authenticate_to_view_note');
  String get enterPin => translate('enter_pin');
  String get enter4DigitPin => translate('enter_4_digit_pin');
  String get unlock => translate('unlock');

  // Notes actions/options
  String get pinToTop => translate('pin_to_top');
  String get unpin => translate('unpin');
  String get changeColor => translate('change_color');
  String get lockNote => translate('lock_note');
  String get removeLock => translate('remove_lock');
  String get chooseColor => translate('choose_color');

  // Notes lock options
  String get secureYourNote => translate('secure_your_note');
  String get chooseHowToProtectNote => translate('choose_how_to_protect_note');
  String get biometrics => translate('biometrics');
  String get useFingerprintOrFace => translate('use_fingerprint_or_face');
  String get noteLockedWithBiometrics => translate('note_locked_with_biometrics');
  String get biometricsNotAvailable => translate('biometrics_not_available');
  String get pinCode => translate('pin_code');
  String get set4DigitSecurityCode => translate('set_4_digit_security_code');
  String get both => translate('both');
  String get useBiometricsWithPinBackup => translate('use_biometrics_with_pin_backup');
  String get biometricsNotAvailableUsingPin =>
      translate('biometrics_not_available_using_pin');
  String get setBackupPin => translate('set_backup_pin');
  String get setPinBackupForBiometrics => translate('set_pin_backup_for_biometrics');
  String get confirmPin => translate('confirm_pin');
  String get pinsDoNotMatch => translate('pins_do_not_match');

  // Notes delete dialogs
  String get deleteNote => translate('delete_note');
  String get deleteNoteConfirmMsg => translate('delete_note_confirm_msg');

  // Notes empty state
  String get noNotesYet => translate('no_notes_yet');
  String get noNotesMatchingFilters => translate('no_notes_matching_filters');
  String get tryAdjustingYourFilters => translate('try_adjusting_your_filters');
  String get startCreatingNotes => translate('start_creating_notes');
  String get createFirstNote => translate('create_first_note');

  // Notes sections
  String get pinned => translate('pinned');
  String get others => translate('others');

  // Notes filter sheet labels
  String get filterNotes => translate('filter_notes');
  String get byType => translate('by_type');
  String get byCategory => translate('by_category');
  String get byTag => translate('by_tag');

  // Note editor
  String get untitled => translate('untitled');
  String get noteCreated => translate('note_created');
  String get noteUpdated => translate('note_updated');
  String get discardChanges => translate('discard_changes');
  String get unsavedChangesDiscard => translate('unsaved_changes_discard');
  String get discard => translate('discard');
  String get titleHint => translate('title_hint');
  String get startWritingHint => translate('start_writing_hint');
  String get resetToDefault => translate('reset_to_default');
  String get none => translate('none');
  String get tags => translate('tags');
  String get addTagHint => translate('add_tag_hint');
  String get done => translate('done');
  String get selectBackground => translate('select_background');
  String get selectColorMood => translate('select_color_mood');
  String get selectCategory => translate('select_category');
  String get addCategory => translate('add_category');
  String get addTags => translate('add_tags');
  String get addItem => translate('add_item');
  String get completed => translate('completed');

  // Note editor attachments
  String get images => translate('images');
  String get files => translate('files');

  // Note editor actions
  String get deleteNoteAction => translate('delete_note_action');
  String get duplicateNote => translate('duplicate_note');
  String get share => translate('share');
  String get noteDuplicated => translate('note_duplicated');
  String get copySuffix => translate('copy_suffix');
  String get takePhoto => translate('take_photo');
  String get chooseFromGallery => translate('choose_from_gallery');
}

// ------------------------------
// Delegate + translation maps
// ------------------------------

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

// English Translations
final Map<String, String> _enTranslations = {
  ...SettingsTranslations.en,
  ...BackupTranslations.en,
  ...HelpSupportTranslations.en,
  ...TermsPrivacyTranslations.en,
  ...TasksTranslations.en,
  ...PomodoroTranslations.en,
  ...TemplatesTranslations.en,
  ...TaskDetailTranslations.en,
  ...NotesTranslations.en,
  ...AuthTranslations.en,
};

// French Translations
final Map<String, String> _frTranslations = {
  ...SettingsTranslations.fr,
  ...BackupTranslations.fr,
  ...HelpSupportTranslations.fr,
  ...TermsPrivacyTranslations.fr,
  ...TasksTranslations.fr,
  ...PomodoroTranslations.fr,
  ...TemplatesTranslations.fr,
  ...TaskDetailTranslations.fr,
  ...NotesTranslations.fr,
  ...AuthTranslations.fr,
};

// Arabic Translations
final Map<String, String> _arTranslations = {
  ...SettingsTranslations.ar,
  ...BackupTranslations.ar,
  ...HelpSupportTranslations.ar,
  ...TermsPrivacyTranslations.ar,
  ...TasksTranslations.ar,
  ...PomodoroTranslations.ar,
  ...TemplatesTranslations.ar,
  ...TaskDetailTranslations.ar,
  ...NotesTranslations.ar,
  ...AuthTranslations.ar,
};

