// lib/utils/app_localizations.dart

import 'package:flutter/material.dart';
import 'translations/settings_translations.dart';
import 'translations/backup_translations.dart';

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
  String get comingSoon => translate('coming_soon');
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
  String get pomodoroTimer => translate('pomodoroTimer');
  String get sessionHistory => translate('sessionHistory');
  String get timerFinished => translate('timerFinished');
  String get whatWouldYouLikeToDo => translate('whatWouldYouLikeToDo');
  String get extend5m => translate('extend5m');
  String get stop => translate('stop');
  String get focusTime => translate('focusTime');
  String get streak => translate('streak');
  String get startFocus => translate('startFocus');
  String get linkToTask => translate('linkToTask');
  String get workingOn => translate('workingOn');
  String get noSessionsToday => translate('noSessionsToday');
  String get startFocusSessionMsg => translate('startFocusSessionMsg');
  String get todaysSessions => translate('todaysSessions');
  String get focusSession => translate('focusSession');
  String get selectTask => translate('selectTask');
  String get noPendingTasks => translate('noPendingTasks');
  String get duePrefix => translate('duePrefix');
  String get sessionsSuffix => translate('sessionsSuffix');
  String get noSessionsYet => translate('noSessionsYet');
  String get timerSettings => translate('timerSettings');
  String get workDuration => translate('workDuration');
  String get shortBreak => translate('shortBreak');
  String get longBreak => translate('longBreak');
  String get sessionsBeforeLongBreak => translate('sessionsBeforeLongBreak');
  String get autoStartBreaks => translate('autoStartBreaks');
  String get autoStartBreaksDesc => translate('autoStartBreaksDesc');
  String get autoStartWork => translate('autoStartWork');
  String get autoStartWorkDesc => translate('autoStartWorkDesc');
  String get sound => translate('sound');
  String get soundDesc => translate('soundDesc');

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

}

// English Translations
const Map<String, String> _enTranslations = {
  ...SettingsTranslations.en,
  ...BackupTranslations.en,
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


  'your_smart_daily_planner': 'Your Smart Daily Planner',
  'organize_tasks': 'Organize your tasks efficiently',
  'capture_ideas': 'Capture ideas instantly',
  'never_miss_reminders': 'Never miss important reminders',
  'skip': 'Skip',
  'next': 'Next',
  'organize_your_tasks': 'Organize Your Tasks',
  'organize_tasks_desc':
      'Create, manage, and prioritize your daily tasks with ease. Never miss a deadline again.',
  'capture_your_ideas': 'Capture Your Ideas',
  'capture_ideas_desc':
      'Jot down notes, thoughts, and ideas instantly. Keep everything organized in one place.',
  'set_smart_reminders': 'Set Smart Reminders',
  'set_reminders_desc':
      'Get timely notifications for important tasks. Stay on top of your schedule effortlessly.',
  'track_your_habits': 'Track Your Habits',
  'track_habits_desc':
      'Build better habits with daily tracking. Monitor your progress and achieve your goals.',
  'remember_password': 'Remember your password? Login',
  'check_your_email': 'Check Your Email',
  'forgot_password_desc':
      "Don't worry! Enter your email address and we'll send you a link to reset your password.",
  'reset_email_sent':
      "We've sent a password reset link to your email address. Please check your inbox and follow the instructions.",
  'resend_email': 'Resend Email',
  'didnt_receive_email': "Didn't receive the email?",
  'check_spam_folder': 'Check your spam folder or try resending the email.',
  'email_verified_success':
      'Email verified successfully! Welcome to DayFlow 🎉',
  'verification_email_to': "We've sent a verification email to",
  'check_inbox_and_click':
      'Please check your inbox (and spam folder) and click the verification link to continue.',
  'resend_in': 'Resend in',
  'i_agree_to_the': 'I agree to the ',
  'terms_conditions': 'Terms & Conditions',
  'and': ' and ',
  'privacy_policy': 'Privacy Policy',
  'please_accept_terms': 'Please accept the terms and conditions',
  'or': 'OR',
  'make_email_correct': 'Make sure the email address is correct',
  'wait_and_resend': 'Wait a few minutes and try resending',

  'tasks': 'Tasks',
  'notes': 'Notes',
  'reminders': 'Reminders',
  'habits': 'Habits',
  'manage_todos': 'Manage your to-dos',
  'quick_ideas': 'Quick ideas and thoughts',
  'never_miss_tasks': 'Never miss important tasks',
  'track_daily_habits': 'Track your daily habits',
  'statistics': 'Statistics',
  'view_progress': 'View your progress',
  'customize_experience': 'Customize your experience',
  'open_menu': 'Open menu',
  'search': 'Search',

  'how_can_we_help': 'How can we help you?',
  'find_answers': 'Find answers or reach out to our support team',
  'contact_us': 'Contact Us',
  'email_support': 'Email Support',
  'live_chat': 'Live Chat',
  'chat_with_team': 'Chat with our team',
  'report_problem': 'Report a Problem',
  'let_us_know': 'Let us know what went wrong',
  'faq': 'Frequently Asked Questions',
  'resources': 'Resources',
  'user_guide': 'User Guide',
  'learn_how_to_use': 'Learn how to use DayFlow',
  'video_tutorials': 'Video Tutorials',
  'watch_guides': 'Watch step-by-step guides',
  'tips_tricks': 'Tips & Tricks',
  'get_most_out': 'Get the most out of DayFlow',
  'problem_type': 'Problem Type',
  'description': 'Description',
  'describe_issue': 'Describe the issue in detail',
  'submit': 'Submit',
  'problem_report_submitted':
      "✓ Problem report submitted. We'll review it soon!",
  'terms_of_service': 'Terms of Service',
  'privacy_policy_title': 'Privacy Policy',
  'last_updated': 'Last updated',
  'by_using_dayflow':
      'By using DayFlow, you agree to these Terms of Service and Privacy Policy.',
  'faq_create_task': 'How do I create a new task?',
  'faq_create_task_answer':
      'Tap the + button on the Tasks page, enter your task details, and tap Save. You can set priorities, due dates, and categories.',
  'faq_dark_mode': 'How do I enable dark mode?',
  'faq_dark_mode_answer':
      'Go to Settings → Appearance, then toggle the Theme switch to enable dark mode.',
  'faq_sync_data': 'Can I sync my data across devices?',
  'faq_sync_data_answer':
      'Yes! Sign in with your account and enable Cloud Sync in Settings → Backup & Sync.',
  'faq_set_reminders': 'How do I set reminders?',
  'faq_set_reminders_answer':
      'Open a task or create a new one, tap on "Set Reminder", choose your date and time, and save.',
  'faq_backup_data': 'How do I backup my data?',
  'faq_backup_data_answer':
      'Go to Settings → Backup & Sync, then tap "Backup Now". You can also enable Auto Backup.',
  'faq_export_data': 'Can I export my data?',
  'faq_export_data_answer':
      'For now this is not possible, maybe in the future yes.',

  // Question Flow
  'qf_biggest_challenge': "What's your biggest productivity challenge?",
  'qf_too_many_tasks': '📋 Too many tasks to manage',
  'qf_staying_focused': '🎯 Staying focused',
  'qf_time_management': '⏰ Time management',
  'qf_remembering_everything': '🧠 Remembering everything',

  'qf_when_work_best': 'When do you work best?',
  'qf_early_morning': '🌅 Early morning',
  'qf_afternoon': '☀️ Afternoon',
  'qf_evening': '🌆 Evening',
  'qf_late_night': '🌙 Late night',

  'qf_main_goal': "What's your main goal with DayFlow?",
  'qf_get_organized': '✨ Get organized',
  'qf_build_habits': '💪 Build better habits',
  'qf_track_tasks': '✅ Track all my tasks',
  'qf_remember_all': '💡 Remember everything',

  'qf_prefer_plan': 'How do you prefer to plan?',
  'qf_day_by_day': '📅 Day by day',
  'qf_week_ahead': '📆 Week ahead',
  'qf_monthly_view': '🗓️ Monthly view',
  'qf_go_with_flow': '🌊 Go with the flow',

  'qf_response_1': 'Got it, noted! 📝',
  'qf_response_2': "You're my kind of planner!",
  'qf_response_3': 'That tells me a lot!',
  'qf_response_4': "Wow, you've got range! 🎯",
  'qf_response_5': 'Interesting choice! ⏰',
  'qf_response_6': 'I can work with that!',
  'qf_response_7': 'Nice, flexibility is key! 🌟',
  'qf_response_8': "You're versatile! Love it!",
  'qf_response_9': "You're going to love DayFlow for that! 🚀",
  'qf_response_10': "Perfect! We've got you covered!",
  'qf_response_11': "That's exactly what we do best! ⭐",
  'qf_response_12': 'Ambitious! I like it! 💯',
  'qf_response_13': 'Smart approach! 🎯',
  'qf_response_14': 'I see your planning style!',
  'qf_response_15': 'Mix and match, nice! 🌈',
  'qf_response_16': "You're adaptable! Perfect! ✨",

  'qf_greeting': "Hi there! Let's get to know you! 👋",
  'qf_next_question': 'Next question! 🎯',
  'qf_completion': "Perfect! You're all set! 🎉",
  'qf_finish': 'Finish',

  "remindersRetry": "Retry",
  "remindersNoRemindersTitle": "No Reminders",
  "remindersNoRemindersSubtitle": "Add reminders or create tasks",
  "remindersToday": "Today",
  "remindersTomorrow": "Tomorrow",
  "remindersUpcoming": "Upcoming",
  "remindersSomethingWrong": "Something went wrong",

  "weekdayMonday": "Monday",
  "weekdayTuesday": "Tuesday",
  "weekdayWednesday": "Wednesday",
  "weekdayThursday": "Thursday",
  "weekdayFriday": "Friday",
  "weekdaySaturday": "Saturday",
  "weekdaySunday": "Sunday",

  "reminderCreateTitle": "Create New Reminder",
  "reminderTitle": "Title",
  "reminderEnterTitle": "Enter reminder title",
  "reminderDescriptionOptional": "Description (Optional)",
  "reminderEnterDescription": "Enter description",
  "reminderSelectTime": "Select Time",
  "reminderAdd": "Add Reminder",
  "reminderErrorTitleRequired": "Please enter a reminder title",
  "reminderErrorTimeRequired": "Please select a time",
  "reminderAdded": "Reminder added!",

  "reminderEditTitle": "Edit Reminder",
  "update": "Update",
  "editReminder": "Edit Reminder",
  "deleteReminder": "Delete Reminder",
  "enableReminder": "Enable Reminder",
  "disableReminder": "Disable Reminder",
  "reminderDeleteConfirmation":
      "Are you sure you want to delete this reminder?",
  "reminderUpdated": "Reminder updated!",
  "reminderDeleted": "Reminder deleted",
  "delete": "delete",
  "reminderInfoTaskLocked": "This reminder is from a task and cannot be modified.",
  "task": "Task",
};

// French Translations
const Map<String, String> _frTranslations = {
  ...SettingsTranslations.fr,
  ...BackupTranslations.fr,
  // Common
  'app_name': 'DayFlow',
  'welcome': 'Bienvenue',
  'get_started': 'Commencer',
  'sign_in': 'Se connecter',
  'already_have_account': 'Vous avez déjà un compte ?',
  'cancel': 'Annuler',
  'save': 'Enregistrer',
  'close': 'Fermer',
  'change': 'Changer',
  'got_it': 'Compris',
  'loading': 'Chargement...',

  // Authentication
  'login': 'Connexion',
  'signup': "S'inscrire",
  'logout': 'Se déconnecter',
  'email': 'Email',
  'password': 'Mot de passe',
  'full_name': 'Nom complet',
  'confirm_password': 'Confirmer le mot de passe',
  'forgot_password': 'Mot de passe oublié ?',
  'reset_password': 'Réinitialiser le mot de passe',
  'send_reset_link': 'Envoyer le lien de réinitialisation',
  'back_to_login': 'Retour à la connexion',
  'create_account': 'Créer un compte',
  'welcome_back': 'Bon retour !',
  'sign_in_to_continue': 'Connectez-vous pour continuer vers DayFlow',
  'sign_up_to_get_started': 'Inscrivez-vous pour commencer avec DayFlow',
  'dont_have_account': "Vous n'avez pas de compte ?",
  'continue_with_google': 'Continuer avec Google',
  'verify_your_email': 'Vérifiez votre email',
  'email_verification_sent': 'Nous avons envoyé un email de vérification à',
  'resend_verification_email': 'Renvoyer l\'email de vérification',
  'use_different_account': 'Utiliser un autre compte',
  'checking_verification_status': 'Vérification du statut...',

  // Dialogs
  'coming_soon': 'Bientôt disponible',
  'feature_under_development': 'Cette fonctionnalité est en cours de développement',
  'working_hard_on_feature': 'Nous travaillons dur pour vous apporter cette fonctionnalité bientôt !',
  'logout_confirmation': 'Se déconnecter',
  'are_you_sure_logout': 'Êtes-vous sûr de vouloir vous déconnecter ?',
  'logout_success': 'Déconnexion réussie',
  'language_changed': 'Langue changée en',
  'theme_changed': 'Thème changé en',
  'profile_updated': 'Profil mis à jour avec succès',
  'password_changed': 'Mot de passe changé avec succès',

  // Validation
  'please_enter_email': 'Veuillez entrer votre email',
  'please_enter_valid_email': 'Veuillez entrer un email valide',
  'please_enter_password': 'Veuillez entrer votre mot de passe',
  'password_too_short': 'Le mot de passe doit contenir au moins 6 caractères',
  'please_enter_name': 'Veuillez entrer votre nom',
  'name_too_short': 'Le nom doit contenir au moins 3 caractères',
  'please_confirm_password': 'Veuillez confirmer votre mot de passe',
  'passwords_do_not_match': 'Les mots de passe ne correspondent pas',
  'password_must_be_different': 'Le nouveau mot de passe doit être différent',
  'please_enter_current_password': 'Veuillez entrer le mot de passe actuel',
  'please_enter_new_password': 'Veuillez entrer le nouveau mot de passe',

  // Input Placeholders
  'enter_email': 'Entrez votre email',
  'enter_password': 'Entrez votre mot de passe',
  'enter_name': 'Entrez votre nom complet',
  're_enter_password': 'Entrez à nouveau votre mot de passe',
  'enter_current_password': 'Entrez le mot de passe actuel',
  'enter_new_password': 'Entrez le nouveau mot de passe',
};

// Arabic Translations
const Map<String, String> _arTranslations = {
  ...SettingsTranslations.ar,
  ...BackupTranslations.ar,
  // Common
  'app_name': 'DayFlow',
  'welcome': 'مرحباً',
  'get_started': 'ابدأ الآن',
  'sign_in': 'تسجيل الدخول',
  'already_have_account': 'لديك حساب بالفعل؟',
  'cancel': 'إلغاء',
  'save': 'حفظ',
  'close': 'إغلاق',
  'change': 'تغيير',
  'got_it': 'فهمت',
  'loading': 'جاري التحميل...',

  // Authentication
  'login': 'دخول',
  'signup': 'إنشاء حساب',
  'logout': 'تسجيل الخروج',
  'email': 'البريد الإلكتروني',
  'password': 'كلمة المرور',
  'full_name': 'الاسم الكامل',
  'confirm_password': 'تأكيد كلمة المرور',
  'forgot_password': 'نسيت كلمة المرور؟',
  'reset_password': 'إعادة تعيين كلمة المرور',
  'send_reset_link': 'إرسال رابط إعادة التعيين',
  'back_to_login': 'العودة لتسجيل الدخول',
  'create_account': 'إنشاء حساب',
  'welcome_back': 'مرحباً بعودتك!',
  'sign_in_to_continue': 'سجل الدخول للمتابعة إلى DayFlow',
  'sign_up_to_get_started': 'سجل حساباً للبدء مع DayFlow',
  'dont_have_account': 'ليس لديك حساب؟',
  'continue_with_google': 'المتابعة باستخدام Google',
  'verify_your_email': 'تحقق من بريدك الإلكتروني',
  'email_verification_sent': 'لقد أرسلنا رسالة تحقق إلى',
  'resend_verification_email': 'إعادة إرسال رسالة التحقق',
  'use_different_account': 'استخدام حساب آخر',
  'checking_verification_status': 'جاري التحقق من الحالة...',

  // Dialogs
  'coming_soon': 'قريباً',
  'feature_under_development': 'هذه الميزة قيد التطوير',
  'working_hard_on_feature': 'نحن نعمل بجد لتقديم هذه الميزة لك قريباً!',
  'logout_confirmation': 'تسجيل الخروج',
  'are_you_sure_logout': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
  'logout_success': 'تم تسجيل الخروج بنجاح',
  'language_changed': 'تم تغيير اللغة إلى',
  'theme_changed': 'تم تغيير السمة إلى',
  'profile_updated': 'تم تحديث الملف الشخصي بنجاح',
  'password_changed': 'تم تغيير كلمة المرور بنجاح',

  // Validation
  'please_enter_email': 'يرجى إدخال بريدك الإلكتروني',
  'please_enter_valid_email': 'يرجى إدخال بريد إلكتروني صالح',
  'please_enter_password': 'يرجى إدخال كلمة المرور',
  'password_too_short': 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل',
  'please_enter_name': 'يرجى إدخال اسمك',
  'name_too_short': 'يجب أن يتكون الاسم من 3 أحرف على الأقل',
  'please_confirm_password': 'يرجى تأكيد كلمة المرور',
  'passwords_do_not_match': 'كلمات المرور غير متطابقة',
  'password_must_be_different': 'يجب أن تكون كلمة المرور الجديدة مختلفة',
  'please_enter_current_password': 'يرجى إدخال كلمة المرور الحالية',
  'please_enter_new_password': 'يرجى إدخال كلمة المرور الجديدة',

  // Input Placeholders
  'enter_email': 'أدخل بريدك الإلكتروني',
  'enter_password': 'أدخل كلمة المرور',
  'enter_name': 'أدخل اسمك الكامل',
  're_enter_password': 'أعد إدخال كلمة المرور',
  'enter_current_password': 'أدخل كلمة المرور الحالية',
  'enter_new_password': 'أدخل كلمة المرور الجديدة',
};

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

