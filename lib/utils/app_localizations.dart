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
  String get welcome => translate('welcome');
  String get getStarted => translate('get_started');
  String get signIn => translate('sign_in');
  String get alreadyHaveAccount => translate('already_have_account');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get close => translate('close');
  String get change => translate('change');
  String get gotIt => translate('got_it');
  String get loading => translate('loading');

  // Authentication
  String get login => translate('login');
  String get signup => translate('signup');
  String get logout => translate('logout');
  String get email => translate('email');
  String get password => translate('password');
  String get fullName => translate('full_name');
  String get confirmPassword => translate('confirm_password');
  String get forgotPassword => translate('forgot_password');
  String get resetPassword => translate('reset_password');
  String get sendResetLink => translate('send_reset_link');
  String get backToLogin => translate('back_to_login');
  String get createAccount => translate('create_account');
  String get welcomeBack => translate('welcome_back');
  String get signInToContinue => translate('sign_in_to_continue');
  String get signUpToGetStarted => translate('sign_up_to_get_started');
  String get dontHaveAccount => translate('dont_have_account');
  String get continueWithGoogle => translate('continue_with_google');
  String get verifyYourEmail => translate('verify_your_email');
  String get emailVerificationSent => translate('email_verification_sent');
  String get resendVerificationEmail => translate('resend_verification_email');
  String get useDifferentAccount => translate('use_different_account');
  String get checkingVerificationStatus =>
      translate('checking_verification_status');

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

  // Welcome Page
  String get yourSmartDailyPlanner => translate('your_smart_daily_planner');
  String get organizeTasks => translate('organize_tasks');
  String get captureIdeas => translate('capture_ideas');
  String get neverMissReminders => translate('never_miss_reminders');

  // Onboarding
  String get skip => translate('skip');
  String get next => translate('next');
  String get organizeYourTasks => translate('organize_your_tasks');
  String get organizeTasksDesc => translate('organize_tasks_desc');
  String get captureYourIdeas => translate('capture_your_ideas');
  String get captureIdeasDesc => translate('capture_ideas_desc');
  String get setSmartReminders => translate('set_smart_reminders');
  String get setRemindersDesc => translate('set_reminders_desc');
  String get trackYourHabits => translate('track_your_habits');
  String get trackHabitsDesc => translate('track_habits_desc');

  // Auth Pages
  String get rememberPassword => translate('remember_password');
  String get checkYourEmail => translate('check_your_email');
  String get forgotPasswordDesc => translate('forgot_password_desc');
  String get resetEmailSent => translate('reset_email_sent');
  String get resendEmail => translate('resend_email');
  String get didntReceiveEmail => translate('didnt_receive_email');
  String get checkSpamFolder => translate('check_spam_folder');
  String get emailVerifiedSuccess => translate('email_verified_success');
  String get verificationEmailTo => translate('verification_email_to');
  String get checkInboxAndClick => translate('check_inbox_and_click');
  String get resendIn => translate('resend_in');
  String get iAgreeToThe => translate('i_agree_to_the');
  String get termsConditions => translate('terms_conditions');
  String get and => translate('and');
  String get privacyPolicy => translate('privacy_policy');
  String get pleaseAcceptTerms => translate('please_accept_terms');
  String get or => translate('or');
  String get makeEmailCorrect => translate('make_email_correct');
  String get waitAndResend => translate('wait_and_resend');

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
  String get retry => translate('retry');
  String get clearAll => translate('clear_all');
  String get filterNotes => translate('filter_notes');

  String get authenticateToViewNote => translate('authenticate_to_view_note');
  String get enterPin => translate('enter_pin');
  String get enter4DigitPin => translate('enter_4_digit_pin');
  String get unlock => translate('unlock');

  String get pinToTop => translate('pin_to_top');
  String get unpin => translate('unpin');
  String get changeColor => translate('change_color');
  String get lockNote => translate('lock_note');
  String get removeLock => translate('remove_lock');

  String get chooseColor => translate('choose_color');

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
  String get biometricsNotAvailableUsingPin => translate('biometrics_not_available_using_pin');

  String get setBackupPin => translate('set_backup_pin');
  String get setPinBackupForBiometrics => translate('set_pin_backup_for_biometrics');
  String get pin => translate('pin');
  String get confirmPin => translate('confirm_pin');
  String get pinsDoNotMatch => translate('pins_do_not_match');
  String get pinMustBe4Digits => translate('pin_must_be_4_digits');

  String get deleteNote => translate('delete_note');
  String get deleteNoteConfirmMsg => translate('delete_note_confirm_msg');

  String get noNotesYet => translate('no_notes_yet');
  String get noNotesMatchingFilters => translate('no_notes_matching_filters');
  String get createFirstNote => translate('create_first_note');

  // Notes sections & empty-state helper strings
  String get pinned => translate('pinned');
  String get others => translate('others');
  String get tryAdjustingYourFilters => translate('try_adjusting_your_filters');
  String get startCreatingNotes => translate('start_creating_notes');

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
  String get addTagHint => translate('add_tag_hint');
}

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
  'app_name': 'DayFlow',
  'welcome': 'Welcome',
  'get_started': 'Get Started',
  'sign_in': 'Sign In',
  'already_have_account': 'Already have an account?',
  'cancel': 'Cancel',
  'save': 'Save',
  'close': 'Close',
  'change': 'Change',
  'got_it': 'Got it',
  'loading': 'Loading...',

  'login': 'Login',
  'signup': 'Sign Up',
  'logout': 'Logout',
  'email': 'Email',
  'password': 'Password',
  'full_name': 'Full Name',
  'confirm_password': 'Confirm Password',
  'forgot_password': 'Forgot Password?',
  'reset_password': 'Reset Password',
  'send_reset_link': 'Send Reset Link',
  'back_to_login': 'Back to Login',
  'create_account': 'Create Account',
  'welcome_back': 'Welcome Back!',
  'sign_in_to_continue': 'Sign in to continue to DayFlow',
  'sign_up_to_get_started': 'Sign up to get started with DayFlow',
  'dont_have_account': "Don't have an account?",
  'continue_with_google': 'Continue with Google',
  'verify_your_email': 'Verify Your Email',
  'email_verification_sent': "We've sent a verification email to",
  'resend_verification_email': 'Resend Verification Email',
  'use_different_account': 'Use Different Account',
  'checking_verification_status': 'Checking verification status...',

  // Dialogs
  'coming_soon': 'Coming Soon',
  'feature_under_development': 'This feature is under development',
  'working_hard_on_feature':
      "We're working hard to bring you this feature soon!",
  'logout_confirmation': 'Logout',
  'are_you_sure_logout': 'Are you sure you want to logout?',
  'logout_success': 'Logged out successfully',
  'language_changed': 'Language changed to',
  'theme_changed': 'Theme changed to',
  'profile_updated': 'Profile updated successfully',
  'password_changed': 'Password changed successfully',

  // Validation
  'please_enter_email': 'Please enter your email',
  'please_enter_valid_email': 'Please enter a valid email',
  'please_enter_password': 'Please enter your password',
  'password_too_short': 'Password must be at least 6 characters',
  'please_enter_name': 'Please enter your name',
  'name_too_short': 'Name must be at least 3 characters',
  'please_confirm_password': 'Please confirm your password',
  'passwords_do_not_match': 'Passwords do not match',
  'password_must_be_different': 'New password must be different',
  'please_enter_current_password': 'Please enter current password',
  'please_enter_new_password': 'Please enter new password',

  // Input Placeholders
  'enter_email': 'Enter your email',
  'enter_password': 'Enter your password',
  'enter_name': 'Enter your full name',
  're_enter_password': 'Re-enter your password',
  'enter_current_password': 'Enter current password',
  'enter_new_password': 'Enter new password',

  // About
  'app_description': 'DayFlow is your smart daily planner, designed to help you organize tasks, capture ideas, and never miss a reminder.',
  'developed_by': 'Developed by: Your Name',
  'team_members': 'Team Members: Member1, Member2, Member3',

  // Welcome Page
  'your_smart_daily_planner': 'Your Smart Daily Planner',
  'organize_tasks': 'Organize Tasks',
  'capture_ideas': 'Capture Ideas',
  'never_miss_reminders': 'Never Miss Reminders',

  // Onboarding
  'skip': 'Skip',
  'next': 'Next',
  'organize_your_tasks': 'Organize Your Tasks',
  'organize_tasks_desc': 'Easily organize and prioritize your tasks in one place.',
  'capture_your_ideas': 'Capture Your Ideas',
  'capture_ideas_desc': 'Quickly jot down your ideas and inspirations.',
  'set_smart_reminders': 'Set Smart Reminders',
  'set_reminders_desc': 'Get reminded of your tasks and events at the right time.',
  'track_your_habits': 'Track Your Habits',
  'track_habits_desc': 'Monitor your habits and stay consistent.',

  // Auth Pages
  'remember_password': 'Remember Password?',
  'check_your_email': 'Check Your Email',
  'forgot_password_desc': 'Enter your email address and we\'ll send you a link to reset your password.',
  'reset_email_sent': 'Reset Email Sent',
  'resend_email': 'Resend Email',
  'didnt_receive_email': 'Didn\'t receive the email?',
  'check_spam_folder': 'Check your spam or junk folder.',
  'email_verified_success': 'Email verified successfully!',
  'verification_email_to': 'Verification email sent to',
  'check_inbox_and_click': 'Check your inbox and click the verification link.',
  'resend_in': 'Resend in {minutes} minutes',
  'i_agree_to_the': 'I agree to the',
  'terms_conditions': 'Terms and Conditions',
  'and': 'and',
  'privacy_policy': 'Privacy Policy',
  'please_accept_terms': 'Please accept the terms and conditions to continue.',
  'or': 'or',
  'make_email_correct': 'Please make sure your email is correct.',
  'wait_and_resend': 'Wait for a few minutes before resending the verification email.',

  // Navigation & Drawer
  'tasks': 'Tasks',
  'notes': 'Notes',
  'reminders': 'Reminders',
  'habits': 'Habits',
  'manage_todos': 'Manage Todos',
  'quick_ideas': 'Quick Ideas',
  'never_miss_tasks': 'Never Miss Tasks',
  'track_daily_habits': 'Track Daily Habits',
  'statistics': 'Statistics',
  'view_progress': 'View Progress',
  'customize_experience': 'Customize Experience',
  'habits_page_coming_soon': 'Habits page is coming soon!',
  'statistics_coming_soon': 'Statistics feature is coming soon!',
  'open_menu': 'Open Menu',
  'search': 'Search',

  // Help & Support
  'how_can_we_help': 'How can we help you?',
  'find_answers': 'Find Answers',
  'contact_us': 'Contact Us',
  'email_support': 'Email Support',
  'live_chat': 'Live Chat',
  'chat_with_team': 'Chat with our team',
  'report_problem': 'Report a Problem',
  'let_us_know': 'Let us know how we can help you.',
  'faq': 'FAQ',
  'resources': 'Resources',
  'user_guide': 'User Guide',
  'learn_how_to_use': 'Learn how to use DayFlow',
  'video_tutorials': 'Video Tutorials',
  'watch_guides': 'Watch Guides',
  'tips_tricks': 'Tips & Tricks',
  'get_most_out': 'Get the most out of DayFlow',
  'problem_type': 'Problem Type',
  'description': 'Description',
  'describe_issue': 'Please describe your issue or question.',
  'submit': 'Submit',
  'problem_report_submitted': 'Your problem report has been submitted.',
  'faq_create_task': 'How to create a task?',
  'faq_create_task_answer': 'To create a task, go to the Tasks tab and click on "Add Task".',
  'faq_dark_mode': 'How to enable dark mode?',
  'faq_dark_mode_answer': 'To enable dark mode, go to Settings > Appearance > Theme and select "Dark Mode".',
  'faq_sync_data': 'How to sync data across devices?',
  'faq_sync_data_answer': 'To sync data, make sure you are logged in with the same account on all devices and enable "Sync with Cloud" in Settings.',
  'faq_set_reminders': 'How to set reminders?',
  'faq_set_reminders_answer': 'To set reminders, go to the task details and select "Add Reminder".',
  'faq_backup_data': 'How to backup data?',
  'faq_backup_data_answer': 'To backup data, go to Settings > Backup & Sync and select "Backup Now".',
  'faq_export_data': 'How to export data?',
  'faq_export_data_answer': 'To export data, go to Settings > Backup & Sync and select "Export Data".',

  // Pomodoro
  'pomodoro_timer': 'Pomodoro Timer',
  'session_history': 'Session History',
  'timer_finished': 'Timer Finished',
  'what_would_you_like_to_do': 'What would you like to do now?',
  'extend_5m': 'Extend 5 minutes',
  'stop': 'Stop',
  'focus_time': 'Focus Time',
  'streak': 'Streak',
  'start_focus': 'Start Focus',
  'link_to_task': 'Link to Task',
  'working_on': 'Working on',
  'no_sessions_today': 'No sessions recorded for today.',
  'start_focus_session_msg': 'Start a focus session to improve your productivity.',
  'todays_sessions': 'Today\'s Sessions',
  'focus_session': 'Focus Session',
  'select_task': 'Select Task',
  'no_pending_tasks': 'No pending tasks found.',
  'due_prefix': 'Due: ',
  'sessions_suffix': ' sessions',
  'sessions_label': 'Sessions',
  'no_sessions_yet': 'No sessions recorded yet.',
  'timer_settings': 'Timer Settings',
  'work_duration': 'Work Duration',
  'short_break': 'Short Break',
  'long_break': 'Long Break',
  'sessions_before_long_break': 'Sessions before long break',
  'auto_start_breaks': 'Auto Start Breaks',
  'auto_start_breaks_desc': 'Automatically start breaks after a session ends.',
  'auto_start_work': 'Auto Start Work',
  'auto_start_work_desc': 'Automatically start the next work session.',
  'sound': 'Sound',
  'sound_desc': 'Select the sound for the timer.',
  'session_type_work': 'Work',
  'session_type_short_break': 'Short Break',
  'session_type_long_break': 'Long Break',
  'min_suffix': 'min',
  'minutes': 'minutes',

  // Templates
  'task_templates': 'Task Templates',
  'search_templates': 'Search Templates',
  'create_template': 'Create Template',
  'edit_template': 'Edit Template',
  'template_name': 'Template Name',
  'template_name_hint': 'Enter a name for the template',
  'default_priority': 'Default Priority',
  'estimated_duration': 'Estimated Duration',
  'category': 'Category',
  'category_hint': 'Select a category for the task',
  'save_template': 'Save Template',
  'create_task_from_template': 'Create Task from Template',
  'view': 'View',
  'no_templates_found': 'No templates found.',
  'no_templates_yet': 'No templates created yet.',
  'create_first_template': 'Create your first template',
  'delete_template': 'Delete Template',
  'delete_template_confirmation': 'Are you sure you want to delete this template?',
  'template_deleted': 'Template deleted successfully.',
  'template_saved': 'Template saved successfully.',
  'use_template': 'Use Template',
  'popular_templates': 'Popular Templates',
  'recent_templates': 'Recent Templates',
  'all_templates': 'All Templates',
  'icon': 'Icon',
  'task_settings': 'Task Settings',
  'subtasks': 'Subtasks',
  'add': 'Add',

  // Backup
  'backup_status': 'Backup Status',
  'last_backup': 'Last Backup',
  'no_backups_yet': 'No backups found.',
  'quick_actions': 'Quick Actions',
  'backup_now': 'Backup Now',
  'restore_backup': 'Restore Backup',
  'sync_with_cloud': 'Sync with Cloud',
  'backup_settings': 'Backup Settings',
  'auto_backup': 'Auto Backup',
  'auto_backup_daily': 'Auto Backup Daily',
  'cloud_sync': 'Cloud Sync',
  'sync_across_devices': 'Sync Across Devices',
  'encrypt_data': 'Encrypt Data',
  'secure_backups': 'Secure Backups',
  'clear_cache': 'Clear Cache',
  'free_up_storage': 'Free Up Storage',
  'delete_all_data': 'Delete All Data',
  'permanently_remove': 'Permanently Remove',
  'processing': 'Processing...',
  'backup_completed': 'Backup completed successfully.',
  'backup_restored': 'Backup restored successfully.',
  'synced_cloud': 'Data synced with cloud.',
  'restore_confirm': 'Are you sure you want to restore this backup?',
  'delete_data_confirm': 'Are you sure you want to delete all data?',
  'clear_cache_confirm': 'Are you sure you want to clear the cache?',
  'cache_cleared': 'Cache cleared.',
  'all_data_deleted': 'All data deleted.',
  'delete_all': 'Delete All',
  'clear': 'Clear',
  'restore': 'Restore',

  // Terms & Privacy
  'terms_of_service': 'Terms of Service',
  'privacy_policy_title': 'Privacy Policy',
  'last_updated': 'Last Updated',
  'by_using_dayflow': 'By using DayFlow, you agree to our Terms of Service and Privacy Policy.',

  // Reminders Page Localization
  'remindersRetry': 'Retry',
  'remindersNoRemindersTitle': 'No Reminders Yet',
  'remindersNoRemindersSubtitle': 'You have not set any reminders yet.',
  'remindersToday': 'Today\'s Reminders',
  'remindersTomorrow': 'Tomorrow\'s Reminders',
  'remindersUpcoming': 'Upcoming Reminders',
  'remindersSomethingWrong': 'Something went wrong. Please try again.',

  // Reminders model page Localization
  'weekdayMonday': 'Monday',
  'weekdayTuesday': 'Tuesday',
  'weekdayWednesday': 'Wednesday',
  'weekdayThursday': 'Thursday',
  'weekdayFriday': 'Friday',
  'weekdaySaturday': 'Saturday',
  'weekdaySunday': 'Sunday',

  // Reminder add dialog Localization
  'reminderCreateTitle': 'Create Reminder',
  'reminderTitle': 'Reminder Title',
  'reminderEnterTitle': 'Enter a title for your reminder',
  'reminderDescriptionOptional': 'Description (optional)',
  'reminderEnterDescription': 'Enter a description for your reminder',
  'reminderSelectTime': 'Select Time',
  'reminderAdd': 'Add Reminder',
  'reminderErrorTitleRequired': 'Title is required',
  'reminderErrorTimeRequired': 'Time is required',
  'reminderAdded': 'Reminder added successfully.',

  // reminders item Localization
  'reminderEditTitle': 'Edit Reminder',
  'update': 'Update',
  'editReminder': 'Edit Reminder',
  'deleteReminder': 'Delete Reminder',
  'enableReminder': 'Enable Reminder',
  'disableReminder': 'Disable Reminder',
  'reminderDeleteConfirmation': 'Are you sure you want to delete this reminder?',
  'reminderUpdated': 'Reminder updated successfully.',
  'reminderDeleted': 'Reminder deleted successfully.',
  'delete': 'Delete',
  'reminderInfoTaskLocked': 'This reminder is linked to a locked task.',
  'task': 'Task',

  // Tasks Page
  'todays_list': 'Today\'s Tasks',
  'failed_to_load_tasks': 'Failed to load tasks. Please try again.',
  'create_new_task': 'Create New Task',
  'edit_task': 'Edit Task',
  'task_title': 'Task Title',
  'required': 'Required',
  'tags_hint': 'Enter tags separated by commas',
  'set_due_date': 'Set Due Date',
  'add_recurrence': 'Add Recurrence',
  'add_task': 'Add Task',
  'update_task': 'Update Task',
  'task_added': 'Task added successfully.',
  'task_updated': 'Task updated successfully.',
  'no_tasks_yet': 'No tasks found. Create your first task!',
  'create_first_task': 'Create your first task',

  // Task Filter Bar
  'sorted_by': 'Sorted by',
  'filter_and_sort': 'Filter & Sort',
  'all_tasks': 'All Tasks',
  'pending_tasks': 'Pending Tasks',
  'completed_tasks': 'Completed Tasks',
  'todays_tasks': 'Today\'s Tasks',
  'overdue_tasks': 'Overdue Tasks',
  'filter_by': 'Filter by',
  'sort_by': 'Sort by',
  'apply': 'Apply',

  // Priorities
  'priority_none': 'No Priority',
  'priority_low': 'Low Priority',
  'priority_medium': 'Medium Priority',
  'priority_high': 'High Priority',

  // Sort Options
  'sort_date_created': 'Sort by Date Created',
  'sort_due_date': 'Sort by Due Date',
  'sort_priority': 'Sort by Priority',
  'sort_alphabetical': 'Sort Alphabetically',

  // Recurrence
  'repeat': 'Repeat',
  'recurrence_none': 'Does not repeat',
  'recurrence_daily': 'Daily',
  'recurrence_weekly': 'Weekly',
  'recurrence_monthly': 'Monthly',
  'recurrence_custom': 'Custom',

  // Recurrence Picker
  'recurrence_repeat': 'Repeat',
  'recurrence_every': 'Every',
  'recurrence_day': 'day',
  'recurrence_days': 'days',
  'recurrence_week': 'week',
  'recurrence_weeks': 'weeks',
  'recurrence_month': 'month',
  'recurrence_months': 'months',
  'recurrence_on_these_days': 'On these days',
  'recurrence_on_day': 'On day',
  'recurrence_of_the_month': 'of the month',
  'recurrence_ends': 'Ends',
  'recurrence_on_specific_date': 'On specific date',
  'recurrence_on_date': 'On date',
  'recurrence_after': 'After',
  'recurrence_occurrences': 'occurrences',
  'recurrence_never': 'Never',
  'recurrence_until': 'Until',
  'recurrence_times': 'times',

  // Task Card
  'no_due_date': 'No due date',
  'overdue_prefix': 'Overdue: ',
  'due_today_prefix': 'Due today: ',

  // Dialogs
  'coming_soon': 'Coming Soon',

  // Quote
  'quote_text': 'The only way to do great work is to love what you do. - Steve Jobs',
  'quote_author': 'Steve Jobs',

  // Recurrence Descriptions
  'recurrence_does_not_repeat': 'This task does not repeat.',
  'recurrence_repeats_daily': 'This task repeats daily.',
  'recurrence_repeats_every_days': 'This task repeats every {days} days.',
  'recurrence_repeats_weekly_on': 'This task repeats weekly on {day}.',
  'recurrence_repeats_weekly': 'This task repeats weekly.',
  'recurrence_repeats_every_weeks': 'This task repeats every {weeks} weeks.',
  'recurrence_repeats_monthly': 'This task repeats monthly.',
  'recurrence_repeats_every_months': 'This task repeats every {months} months.',
  'recurrence_custom_every_days': 'This task has a custom recurrence every {days} days.',

  // Task Detail
  'delete_task_question': 'Are you sure you want to delete this task?',
  'delete_task_confirmation': 'Delete Task',
  'save_as_template': 'Save as Template',
  'create_template_from_task_desc': 'Create a template from this task',
  'template_created_success': 'Template created successfully.',
  'task_not_found': 'Task not found.',
  'task_not_found_msg': 'The task you are looking for does not exist.',
  'days_overdue': '{days} days overdue',
  'due_today': 'Due today',
  'days_left': '{days} days left',
  'completed_count': 'Completed: {count}',

  // Notes
  'notes': 'Notes',
  'search_notes_hint': 'Search notes...',
  'create_new': 'Create New',
  'text_note': 'Text Note',
  'simple_text_note': 'Simple Text Note',
  'checklist': 'Checklist',
  'task_list_with_checkboxes': 'Task List with Checkboxes',
  'rich_text_note': 'Rich Text Note',
  'with_formatting_options': 'With formatting options',
  'failed_to_load_notes': 'Failed to load notes. Please try again.',
  'retry': 'Retry',
  'clear_all': 'Clear All',

  'authenticate_to_view_note': 'Authenticate to view note',
  'enter_pin': 'Enter PIN',
  'enter_4_digit_pin': 'Enter 4-digit PIN',
  'unlock': 'Unlock',

  'pin_to_top': 'Pin to Top',
  'unpin': 'Unpin',
  'change_color': 'Change Color',
  'lock_note': 'Lock Note',
  'remove_lock': 'Remove Lock',

  'choose_color': 'Choose Color',

  'secure_your_note': 'Secure your note',
  'choose_how_to_protect_note': 'Choose how to protect your note',
  'biometrics': 'Biometrics',
  'use_fingerprint_or_face': 'Use fingerprint or face recognition',
  'note_locked_with_biometrics': 'This note is locked with biometrics.',
  'biometrics_not_available': 'Biometrics not available.',
  'pin_code': 'PIN Code',
  'set_4_digit_security_code': 'Set a 4-digit security code',
  'both': 'Both',
  'use_biometrics_with_pin_backup': 'Use biometrics with PIN backup',
  'biometrics_not_available_using_pin': 'Biometrics not available, using PIN instead.',

  'set_backup_pin': 'Set Backup PIN',
  'set_pin_backup_for_biometrics': 'Set PIN backup for biometrics',
  'pin': 'PIN',
  'confirm_pin': 'Confirm PIN',
  'pins_do_not_match': 'PINs do not match',
  'pin_must_be_4_digits': 'PIN must be 4 digits',

  'delete_note': 'Delete Note',
  'delete_note_confirm_msg': 'Are you sure you want to delete this note?',

  'no_notes_yet': 'No notes found. Create your first note!',
  'no_notes_matching_filters': 'No notes matching the current filters.',
  'create_first_note': 'Create your first note',

  'filter_notes': 'Filter Notes',

  // Note editor
  'untitled': 'Untitled',
  'note_created': 'Note created',
  'note_updated': 'Note updated',
  'discard_changes': 'Discard changes?',
  'unsaved_changes_discard': 'You have unsaved changes. Discard them?',
  'discard': 'Discard',
  'title_hint': 'Title',
  'start_writing_hint': 'Start writing your note...',
  'reset_to_default': 'Reset to default',
  'none': 'None',
  'add_tag_hint': 'Add a tag',
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
};

