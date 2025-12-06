// lib/utils/app_localizations.dart

import 'package:flutter/material.dart';

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
    return _localizedValues[locale.languageCode]?[key] ?? key;
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

  'settings': 'Settings',
  'profile': 'Profile',
  'edit_profile': 'Edit Profile',
  'appearance': 'Appearance',
  'theme': 'Theme',
  'light_mode': 'Light Mode',
  'dark_mode': 'Dark Mode',
  'language': 'Language',
  'select_language': 'Select Language',
  'account': 'Account',
  'sync_status': 'Sync Status',
  'last_synced': 'Last synced just now',
  'change_password': 'Change Password',
  'update_password': 'Update your password',
  'current_password': 'Current Password',
  'new_password': 'New Password',
  'confirm_new_password': 'Confirm New Password',
  'preferences': 'Preferences',
  'notifications': 'Notifications',
  'notifications_enabled': 'Notifications enabled',
  'notifications_disabled': 'Notifications turned off',
  'receive_task_alerts': 'Receive task and reminder alerts',
  'no_notifications': 'No notifications',
  'privacy': 'Privacy',
  'privacy_settings': 'Control your privacy settings',
  'backup_and_sync': 'Backup & Sync',
  'cloud_backup': 'Cloud backup settings',
  'about': 'About',
  'about_dayflow': 'About DayFlow',
  'version': 'Version 1.0.0',
  'help_and_support': 'Help & Support',
  'get_help': 'Get help with DayFlow',
  'terms_and_privacy': 'Terms & Privacy Policy',
  'legal_info': 'Legal information',
  'sign_in_to_continue_desc':
      'Access your tasks, notes, and reminders\nacross all your devices',

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

  'enter_email': 'Enter your email',
  'enter_password': 'Enter your password',
  'enter_name': 'Enter your full name',
  're_enter_password': 'Re-enter your password',
  'enter_current_password': 'Enter current password',
  'enter_new_password': 'Enter new password',

  'app_description':
      'A smart daily planner to help you manage your tasks, notes, and reminders efficiently.',
  'developed_by': 'Developed by Team DayFlow',
  'team_members': 'Abderrahmane Houri\nMohamed Al Amin Saàd\nLina Selma Ouadah',

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
  'backup_status': 'Backup Status',
  'last_backup': 'Last backup',
  'no_backups_yet': 'No backups yet',
  'quick_actions': 'Quick Actions',
  'backup_now': 'Backup Now',
  'restore_backup': 'Restore Backup',
  'sync_with_cloud': 'Sync with Cloud',
  'backup_settings': 'Backup Settings',
  'auto_backup': 'Auto Backup',
  'auto_backup_daily': 'Automatically backup data daily',
  'cloud_sync': 'Cloud Sync',
  'sync_across_devices': 'Sync data across devices',
  'encrypt_data': 'Encrypt Data',
  'secure_backups': 'Secure your backups',
  'clear_cache': 'Clear Cache',
  'free_up_storage': 'Free up storage space',
  'delete_all_data': 'Delete All Data',
  'permanently_remove': 'Permanently remove all data',
  'processing': 'Processing...',
  'backup_completed': '✓ Backup completed successfully',
  'backup_restored': '✓ Backup restored successfully',
  'synced_cloud': '✓ Synced with cloud successfully',
  'restore_confirm':
      'This will restore your data from the last backup. Current data will be replaced. Continue?',
  'delete_data_confirm':
      '⚠️ This will permanently delete all your data including tasks, notes, and settings. This action cannot be undone!',
  'clear_cache_confirm':
      'This will clear temporary files and free up storage space. Continue?',
  'cache_cleared': '✓ Cache cleared successfully',
  'all_data_deleted': 'All data deleted',
  'delete_all': 'Delete All',
  'clear': 'Clear',
  'restore': 'Restore',
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
  "reminderInfoTaskLocked": "This reminder is from a task and cannot be edited here",
  "task": "task",
};

// French Translations
const Map<String, String> _frTranslations = {
  'app_name': 'DayFlow',
  'welcome': 'Bienvenue',
  'get_started': 'Commencer',
  'sign_in': 'Se connecter',
  'already_have_account': 'Vous avez déjà un compte?',
  'cancel': 'Annuler',
  'save': 'Enregistrer',
  'close': 'Fermer',
  'change': 'Modifier',
  'got_it': "C'est compris",
  'loading': 'Chargement...',

  'login': 'Connexion',
  'signup': "S'inscrire",
  'logout': 'Déconnexion',
  'email': 'Email',
  'password': 'Mot de passe',
  'full_name': 'Nom complet',
  'confirm_password': 'Confirmer le mot de passe',
  'forgot_password': 'Mot de passe oublié?',
  'reset_password': 'Réinitialiser le mot de passe',
  'send_reset_link': 'Envoyer le lien',
  'back_to_login': 'Retour à la connexion',
  'create_account': 'Créer un compte',
  'welcome_back': 'Bon retour!',
  'sign_in_to_continue': 'Connectez-vous pour continuer sur DayFlow',
  'sign_up_to_get_started': 'Inscrivez-vous pour commencer avec DayFlow',
  'dont_have_account': "Vous n'avez pas de compte?",
  'continue_with_google': 'Continuer avec Google',
  'verify_your_email': 'Vérifiez votre email',
  'email_verification_sent': 'Nous avons envoyé un email de vérification à',
  'resend_verification_email': "Renvoyer l'email de vérification",
  'use_different_account': 'Utiliser un autre compte',
  'checking_verification_status': 'Vérification du statut...',

  'settings': 'Paramètres',
  'profile': 'Profil',
  'edit_profile': 'Modifier le profil',
  'appearance': 'Apparence',
  'theme': 'Thème',
  'light_mode': 'Mode clair',
  'dark_mode': 'Mode sombre',
  'language': 'Langue',
  'select_language': 'Sélectionner la langue',
  'account': 'Compte',
  'sync_status': 'État de synchronisation',
  'last_synced': 'Dernière synchronisation',
  'change_password': 'Changer le mot de passe',
  'update_password': 'Mettre à jour votre mot de passe',
  'current_password': 'Mot de passe actuel',
  'new_password': 'Nouveau mot de passe',
  'confirm_new_password': 'Confirmer le nouveau mot de passe',
  'preferences': 'Préférences',
  'notifications': 'Notifications',
  'notifications_enabled': 'Notifications activées',
  'notifications_disabled': 'Notifications désactivées',
  'receive_task_alerts': 'Recevoir des alertes',
  'no_notifications': 'Aucune notification',
  'privacy': 'Confidentialité',
  'privacy_settings': 'Contrôlez vos paramètres de confidentialité',
  'backup_and_sync': 'Sauvegarde et synchronisation',
  'cloud_backup': 'Paramètres de sauvegarde cloud',
  'about': 'À propos',
  'about_dayflow': 'À propos de DayFlow',
  'version': 'Version 1.0.0',
  'help_and_support': 'Aide et support',
  'get_help': "Obtenir de l'aide avec DayFlow",
  'terms_and_privacy': 'Conditions et confidentialité',
  'legal_info': 'Informations légales',
  'sign_in_to_continue_desc':
      'Accédez à vos tâches, notes et rappels\nsur tous vos appareils',

  'coming_soon': 'Bientôt disponible',
  'feature_under_development': 'Cette fonctionnalité est en développement',
  'working_hard_on_feature':
      'Nous travaillons dur pour vous apporter cette fonctionnalité bientôt!',
  'logout_confirmation': 'Déconnexion',
  'are_you_sure_logout': 'Êtes-vous sûr de vouloir vous déconnecter?',
  'logout_success': 'Déconnecté avec succès',
  'language_changed': 'Langue changée en',
  'theme_changed': 'Thème changé en',
  'profile_updated': 'Profil mis à jour avec succès',
  'password_changed': 'Mot de passe changé avec succès',

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

  'enter_email': 'Entrez votre email',
  'enter_password': 'Entrez votre mot de passe',
  'enter_name': 'Entrez votre nom complet',
  're_enter_password': 'Ressaisissez votre mot de passe',
  'enter_current_password': 'Entrez le mot de passe actuel',
  'enter_new_password': 'Entrez le nouveau mot de passe',

  'app_description':
      'Un planificateur quotidien intelligent pour vous aider à gérer efficacement vos tâches, notes et rappels.',
  'developed_by': 'Développé par Team DayFlow',
  'team_members': 'Abderrahmane Houri\nMohamed Al Amin Saàd\nLina Selma Ouadah',

  'your_smart_daily_planner': 'Votre planificateur quotidien intelligent',
  'organize_tasks': 'Organisez vos tâches efficacement',
  'capture_ideas': 'Capturez vos idées instantanément',
  'never_miss_reminders': 'Ne manquez jamais de rappels importants',
  'skip': 'Passer',
  'next': 'Suivant',
  'organize_your_tasks': 'Organisez vos tâches',
  'organize_tasks_desc':
      'Créez, gérez et priorisez vos tâches quotidiennes facilement. Ne manquez plus jamais une échéance.',
  'capture_your_ideas': 'Capturez vos idées',
  'capture_ideas_desc':
      'Notez vos notes, pensées et idées instantanément. Gardez tout organisé en un seul endroit.',
  'set_smart_reminders': 'Définir des rappels intelligents',
  'set_reminders_desc':
      'Recevez des notifications opportunes pour les tâches importantes. Restez au top de votre emploi du temps sans effort.',
  'track_your_habits': 'Suivez vos habitudes',
  'track_habits_desc':
      'Développez de meilleures habitudes avec un suivi quotidien. Surveillez vos progrès et atteignez vos objectifs.',
  'remember_password': 'Vous vous souvenez de votre mot de passe? Connexion',
  'check_your_email': 'Vérifiez votre email',
  'forgot_password_desc':
      "Ne vous inquiétez pas! Entrez votre adresse email et nous vous enverrons un lien pour réinitialiser votre mot de passe.",
  'reset_email_sent':
      "Nous avons envoyé un lien de réinitialisation à votre adresse email. Veuillez vérifier votre boîte de réception et suivre les instructions.",
  'resend_email': "Renvoyer l'email",
  'didnt_receive_email': "Vous n'avez pas reçu l'email?",
  'check_spam_folder':
      "Vérifiez votre dossier spam ou essayez de renvoyer l'email.",
  'email_verified_success':
      'Email vérifié avec succès! Bienvenue sur DayFlow 🎉',
  'verification_email_to': 'Nous avons envoyé un email de vérification à',
  'check_inbox_and_click':
      'Veuillez vérifier votre boîte de réception (et spam) et cliquer sur le lien de vérification pour continuer.',
  'resend_in': 'Renvoyer dans',
  'i_agree_to_the': "J'accepte les ",
  'terms_conditions': 'Conditions générales',
  'and': ' et la ',
  'privacy_policy': 'Politique de confidentialité',
  'please_accept_terms': 'Veuillez accepter les conditions générales',
  'or': 'OU',
  'make_email_correct': "Assurez-vous que l'adresse email est correcte",
  'wait_and_resend': "Attendez quelques minutes et essayez de renvoyer",

  'tasks': 'Tâches',
  'notes': 'Notes',
  'reminders': 'Rappels',
  'habits': 'Habitudes',
  'manage_todos': 'Gérez vos tâches',
  'quick_ideas': 'Idées rapides et pensées',
  'never_miss_tasks': 'Ne manquez jamais de tâches importantes',
  'track_daily_habits': 'Suivez vos habitudes quotidiennes',
  'statistics': 'Statistiques',
  'view_progress': 'Voir vos progrès',
  'customize_experience': 'Personnalisez votre expérience',
  'open_menu': 'Ouvrir le menu',
  'search': 'Rechercher',

  'how_can_we_help': 'Comment pouvons-nous vous aider?',
  'find_answers': 'Trouvez des réponses ou contactez notre équipe',
  'contact_us': 'Nous contacter',
  'email_support': 'Support par email',
  'live_chat': 'Chat en direct',
  'chat_with_team': 'Discutez avec notre équipe',
  'report_problem': 'Signaler un problème',
  'let_us_know': 'Dites-nous ce qui n\'a pas fonctionné',
  'faq': 'Questions fréquemment posées',
  'resources': 'Ressources',
  'user_guide': 'Guide utilisateur',
  'learn_how_to_use': 'Apprenez à utiliser DayFlow',
  'video_tutorials': 'Tutoriels vidéo',
  'watch_guides': 'Regardez des guides étape par étape',
  'tips_tricks': 'Astuces et conseils',
  'get_most_out': 'Tirez le meilleur parti de DayFlow',
  'problem_type': 'Type de problème',
  'description': 'Description',
  'describe_issue': 'Décrivez le problème en détail',
  'submit': 'Soumettre',
  'problem_report_submitted':
      '✓ Rapport de problème soumis. Nous l\'examinerons bientôt!',
  'backup_status': 'État de la sauvegarde',
  'last_backup': 'Dernière sauvegarde',
  'no_backups_yet': 'Pas encore de sauvegardes',
  'quick_actions': 'Actions rapides',
  'backup_now': 'Sauvegarder maintenant',
  'restore_backup': 'Restaurer la sauvegarde',
  'sync_with_cloud': 'Synchroniser avec le cloud',
  'backup_settings': 'Paramètres de sauvegarde',
  'auto_backup': 'Sauvegarde automatique',
  'auto_backup_daily':
      'Sauvegarder automatiquement les données quotidiennement',
  'cloud_sync': 'Synchronisation cloud',
  'sync_across_devices': 'Synchroniser les données sur tous les appareils',
  'encrypt_data': 'Chiffrer les données',
  'secure_backups': 'Sécurisez vos sauvegardes',
  'clear_cache': 'Vider le cache',
  'free_up_storage': 'Libérer de l\'espace',
  'delete_all_data': 'Supprimer toutes les données',
  'permanently_remove': 'Supprimer définitivement toutes les données',
  'processing': 'Traitement...',
  'backup_completed': '✓ Sauvegarde terminée avec succès',
  'backup_restored': '✓ Sauvegarde restaurée avec succès',
  'synced_cloud': '✓ Synchronisé avec le cloud avec succès',
  'restore_confirm':
      'Cela restaurera vos données à partir de la dernière sauvegarde. Les données actuelles seront remplacées. Continuer?',
  'delete_data_confirm':
      '⚠️ Cela supprimera définitivement toutes vos données, y compris les tâches, notes et paramètres. Cette action est irréversible!',
  'clear_cache_confirm':
      'Cela effacera les fichiers temporaires et libérera de l\'espace. Continuer?',
  'cache_cleared': '✓ Cache vidé avec succès',
  'all_data_deleted': 'Toutes les données supprimées',
  'delete_all': 'Tout supprimer',
  'clear': 'Effacer',
  'restore': 'Restaurer',
  'terms_of_service': 'Conditions d\'utilisation',
  'privacy_policy_title': 'Politique de confidentialité',
  'last_updated': 'Dernière mise à jour',
  'by_using_dayflow':
      'En utilisant DayFlow, vous acceptez ces Conditions d\'utilisation et cette Politique de confidentialité.',
  'faq_create_task': 'Comment créer une nouvelle tâche?',
  'faq_create_task_answer':
      'Appuyez sur le bouton + dans la page Tâches, entrez les détails de votre tâche et appuyez sur Enregistrer. Vous pouvez définir des priorités, des dates d\'échéance et des catégories.',
  'faq_dark_mode': 'Comment activer le mode sombre?',
  'faq_dark_mode_answer':
      'Allez dans Paramètres → Apparence, puis basculez l\'interrupteur Thème pour activer le mode sombre.',
  'faq_sync_data': 'Puis-je synchroniser mes données sur plusieurs appareils?',
  'faq_sync_data_answer':
      'Oui! Connectez-vous avec votre compte et activez la Synchronisation Cloud dans Paramètres → Sauvegarde et Synchronisation.',
  'faq_set_reminders': 'Comment définir des rappels?',
  'faq_set_reminders_answer':
      'Ouvrez une tâche ou créez-en une nouvelle, appuyez sur "Définir un rappel", choisissez votre date et heure, et enregistrez.',
  'faq_backup_data': 'Comment sauvegarder mes données?',
  'faq_backup_data_answer':
      'Allez dans Paramètres → Sauvegarde et Synchronisation, puis appuyez sur "Sauvegarder maintenant". Vous pouvez également activer la Sauvegarde automatique.',
  'faq_export_data': 'Puis-je exporter mes données?',
  'faq_export_data_answer':
      'Pour l\'instant, ce n\'est pas possible, peut-être à l\'avenir.',

  // Question Flow
  'qf_biggest_challenge': 'Quel est votre plus grand défi de productivité?',
  'qf_too_many_tasks': '📋 Trop de tâches à gérer',
  'qf_staying_focused': '🎯 Rester concentré',
  'qf_time_management': '⏰ Gestion du temps',
  'qf_remembering_everything': '🧠 Tout se rappeler',

  'qf_when_work_best': 'Quand travaillez-vous le mieux?',
  'qf_early_morning': '🌅 Tôt le matin',
  'qf_afternoon': '☀️ Après-midi',
  'qf_evening': '🌆 Soirée',
  'qf_late_night': '🌙 Tard le soir',

  'qf_main_goal': 'Quel est votre objectif principal avec DayFlow?',
  'qf_get_organized': '✨ M\'organiser',
  'qf_build_habits': '💪 Développer de meilleures habitudes',
  'qf_track_tasks': '✅ Suivre toutes mes tâches',
  'qf_remember_all': '💡 Tout mémoriser',

  'qf_prefer_plan': 'Comment préférez-vous planifier?',
  'qf_day_by_day': '📅 Jour par jour',
  'qf_week_ahead': '📆 Une semaine à l\'avance',
  'qf_monthly_view': '🗓️ Vue mensuelle',
  'qf_go_with_flow': '🌊 Au fil de l\'eau',

  'qf_response_1': 'Compris, noté! 📝',
  'qf_response_2': 'Vous êtes mon genre de planificateur!',
  'qf_response_3': 'Ça m\'en dit beaucoup!',
  'qf_response_4': 'Wow, vous avez de la portée! 🎯',
  'qf_response_5': 'Choix intéressant! ⏰',
  'qf_response_6': 'Je peux travailler avec ça!',
  'qf_response_7': 'Super, la flexibilité est la clé! 🌟',
  'qf_response_8': 'Vous êtes polyvalent! J\'adore!',
  'qf_response_9': 'Vous allez adorer DayFlow pour ça! 🚀',
  'qf_response_10': 'Parfait! Nous vous couvrons!',
  'qf_response_11': 'C\'est exactement ce qu\'on fait de mieux! ⭐',
  'qf_response_12': 'Ambitieux! J\'aime ça! 💯',
  'qf_response_13': 'Approche intelligente! 🎯',
  'qf_response_14': 'Je vois votre style de planification!',
  'qf_response_15': 'Mélangez et assortissez, super! 🌈',
  'qf_response_16': 'Vous êtes adaptable! Parfait! ✨',

  'qf_greeting': 'Salut! Faisons connaissance! 👋',
  'qf_next_question': 'Question suivante! 🎯',
  'qf_completion': 'Parfait! Vous êtes prêt! 🎉',
  'qf_finish': 'Terminer',

  "remindersRetry": "Réessayer",
  "remindersNoRemindersTitle": "Aucun rappel",
  "remindersNoRemindersSubtitle": "Ajoutez des rappels ou créez des tâches",
  "remindersToday": "Aujourd'hui",
  "remindersTomorrow": "Demain",
  "remindersUpcoming": "À venir",
  "remindersSomethingWrong": "Une erreur s'est produite",

  "weekdayMonday": "Lundi",
  "weekdayTuesday": "Mardi",
  "weekdayWednesday": "Mercredi",
  "weekdayThursday": "Jeudi",
  "weekdayFriday": "Vendredi",
  "weekdaySaturday": "Samedi",
  "weekdaySunday": "Dimanche",

  "reminderCreateTitle": "Créer un nouveau rappel",
  "reminderTitle": "Titre",
  "reminderEnterTitle": "Entrez le titre du rappel",
  "reminderDescriptionOptional": "Description (Optionnel)",
  "reminderEnterDescription": "Entrez la description",
  "reminderSelectTime": "Sélectionner l'heure",
  "reminderAdd": "Ajouter rappel",
  "reminderErrorTitleRequired": "Veuillez entrer un titre pour le rappel",
  "reminderErrorTimeRequired": "Veuillez sélectionner une heure",
  "reminderAdded": "Rappel ajouté !",

  "reminderEditTitle": "Modifier le rappel",
  "update": "Mettre à jour",
  "editReminder": "Modifier le rappel",
  "deleteReminder": "Supprimer le rappel",
  "enableReminder": "Activer le rappel",
  "disableReminder": "Désactiver le rappel",
  "reminderDeleteConfirmation":
      "Êtes-vous sûr de vouloir supprimer ce rappel ?",
  "reminderUpdated": "Rappel mis à jour !",
  "reminderDeleted": "Rappel supprimé",
  "delete": "supprimé",
  "reminderInfoTaskLocked": "Ce rappel provient d'’'une tâche et ne peut pas être modifié ici",
  "task": "Tâche",

};

// Arabic Translations
const Map<String, String> _arTranslations = {
  'app_name': 'ديفلو',
  'welcome': 'مرحباً',
  'get_started': 'ابدأ الآن',
  'sign_in': 'تسجيل الدخول',
  'already_have_account': 'هل لديك حساب بالفعل؟',
  'cancel': 'إلغاء',
  'save': 'حفظ',
  'close': 'إغلاق',
  'change': 'تغيير',
  'got_it': 'فهمت',
  'loading': 'جاري التحميل...',

  'login': 'تسجيل الدخول',
  'signup': 'التسجيل',
  'logout': 'تسجيل الخروج',
  'email': 'البريد الإلكتروني',
  'password': 'كلمة المرور',
  'full_name': 'الاسم الكامل',
  'confirm_password': 'تأكيد كلمة المرور',
  'forgot_password': 'نسيت كلمة المرور؟',
  'reset_password': 'إعادة تعيين كلمة المرور',
  'send_reset_link': 'إرسال رابط الاستعادة',
  'back_to_login': 'العودة لتسجيل الدخول',
  'create_account': 'إنشاء حساب',
  'welcome_back': 'مرحباً بعودتك!',
  'sign_in_to_continue': 'سجل الدخول للمتابعة إلى ديفلو',
  'sign_up_to_get_started': 'سجل للبدء مع ديفلو',
  'dont_have_account': 'ليس لديك حساب؟',
  'continue_with_google': 'المتابعة مع جوجل',
  'verify_your_email': 'تحقق من بريدك الإلكتروني',
  'email_verification_sent': 'لقد أرسلنا بريداً إلكترونياً للتحقق إلى',
  'resend_verification_email': 'إعادة إرسال بريد التحقق',
  'use_different_account': 'استخدام حساب آخر',
  'checking_verification_status': 'جاري التحقق من الحالة...',

  'settings': 'الإعدادات',
  'profile': 'الملف الشخصي',
  'edit_profile': 'تعديل الملف الشخصي',
  'appearance': 'المظهر',
  'theme': 'السمة',
  'light_mode': 'الوضع الفاتح',
  'dark_mode': 'الوضع الداكن',
  'language': 'اللغة',
  'select_language': 'اختر اللغة',
  'account': 'الحساب',
  'sync_status': 'حالة المزامنة',
  'last_synced': 'آخر مزامنة الآن',
  'change_password': 'تغيير كلمة المرور',
  'update_password': 'تحديث كلمة المرور',
  'current_password': 'كلمة المرور الحالية',
  'new_password': 'كلمة المرور الجديدة',
  'confirm_new_password': 'تأكيد كلمة المرور الجديدة',
  'preferences': 'التفضيلات',
  'notifications': 'الإشعارات',
  'notifications_enabled': 'الإشعارات مفعلة',
  'notifications_disabled': 'الإشعارات معطلة',
  'receive_task_alerts': 'استلام تنبيهات المهام',
  'no_notifications': 'لا توجد إشعارات',
  'privacy': 'الخصوصية',
  'privacy_settings': 'التحكم في إعدادات الخصوصية',
  'backup_and_sync': 'النسخ الاحتياطي والمزامنة',
  'cloud_backup': 'إعدادات النسخ الاحتياطي السحابي',
  'about': 'حول',
  'about_dayflow': 'حول ديفلو',
  'version': 'الإصدار 1.0.0',
  'help_and_support': 'المساعدة والدعم',
  'get_help': 'احصل على المساعدة مع ديفلو',
  'terms_and_privacy': 'الشروط والخصوصية',
  'legal_info': 'المعلومات القانونية',
  'sign_in_to_continue_desc':
      'الوصول إلى مهامك وملاحظاتك وتذكيراتك\nعلى جميع أجهزتك',

  'coming_soon': 'قريباً',
  'feature_under_development': 'هذه الميزة قيد التطوير',
  'working_hard_on_feature': 'نحن نعمل بجد لإحضار هذه الميزة قريباً!',
  'logout_confirmation': 'تسجيل الخروج',
  'are_you_sure_logout': 'هل أنت متأكد من تسجيل الخروج؟',
  'logout_success': 'تم تسجيل الخروج بنجاح',
  'language_changed': 'تم تغيير اللغة إلى',
  'theme_changed': 'تم تغيير السمة إلى',
  'profile_updated': 'تم تحديث الملف الشخصي بنجاح',
  'password_changed': 'تم تغيير كلمة المرور بنجاح',

  'please_enter_email': 'الرجاء إدخال بريدك الإلكتروني',
  'please_enter_valid_email': 'الرجاء إدخال بريد إلكتروني صحيح',
  'please_enter_password': 'الرجاء إدخال كلمة المرور',
  'password_too_short': 'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
  'please_enter_name': 'الرجاء إدخال اسمك',
  'name_too_short': 'يجب أن يكون الاسم 3 أحرف على الأقل',
  'please_confirm_password': 'الرجاء تأكيد كلمة المرور',
  'passwords_do_not_match': 'كلمات المرور غير متطابقة',
  'password_must_be_different': 'يجب أن تكون كلمة المرور الجديدة مختلفة',
  'please_enter_current_password': 'الرجاء إدخال كلمة المرور الحالية',
  'please_enter_new_password': 'الرجاء إدخال كلمة المرور الجديدة',

  'enter_email': 'أدخل بريدك الإلكتروني',
  'enter_password': 'أدخل كلمة المرور',
  'enter_name': 'أدخل اسمك الكامل',
  're_enter_password': 'أعد إدخال كلمة المرور',
  'enter_current_password': 'أدخل كلمة المرور الحالية',
  'enter_new_password': 'أدخل كلمة المرور الجديدة',

  'app_description':
      'مخطط يومي ذكي لمساعدتك في إدارة مهامك وملاحظاتك وتذكيراتك بكفاءة.',
  'developed_by': 'تطوير فريق ديفلو',
  'team_members': 'عبد الرحمن حوري\nمحمد الأمين سعد\nلينا سلمى وداح',

  'your_smart_daily_planner': 'مخططك اليومي الذكي',
  'organize_tasks': 'نظم مهامك بكفاءة',
  'capture_ideas': 'سجل أفكارك فوراً',
  'never_miss_reminders': 'لا تفوت التذكيرات المهمة أبداً',
  'skip': 'تخطي',
  'next': 'التالي',
  'organize_your_tasks': 'نظم مهامك',
  'organize_tasks_desc':
      'أنشئ وأدر ورتب مهامك اليومية بسهولة. لا تفوت موعداً نهائياً مرة أخرى.',
  'capture_your_ideas': 'سجل أفكارك',
  'capture_ideas_desc':
      'دون ملاحظاتك وأفكارك وخواطرك فوراً. احتفظ بكل شيء منظماً في مكان واحد.',
  'set_smart_reminders': 'اضبط تذكيرات ذكية',
  'set_reminders_desc':
      'احصل على إشعارات في الوقت المناسب للمهام المهمة. ابق في صدارة جدولك بسهولة.',
  'track_your_habits': 'تتبع عاداتك',
  'track_habits_desc':
      'ابنِ عادات أفضل مع التتبع اليومي. راقب تقدمك وحقق أهدافك.',
  'remember_password': 'هل تتذكر كلمة المرور؟ تسجيل الدخول',
  'check_your_email': 'تحقق من بريدك الإلكتروني',
  'forgot_password_desc':
      'لا تقلق! أدخل عنوان بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.',
  'reset_email_sent':
      'لقد أرسلنا رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني. يرجى التحقق من صندوق الوارد واتباع التعليمات.',
  'resend_email': 'إعادة إرسال البريد',
  'didnt_receive_email': 'لم تستلم البريد الإلكتروني؟',
  'check_spam_folder':
      'تحقق من مجلد الرسائل غير المرغوب فيها أو حاول إعادة الإرسال.',
  'email_verified_success':
      'تم التحقق من البريد الإلكتروني بنجاح! مرحباً بك في ديفلو 🎉',
  'verification_email_to': 'لقد أرسلنا بريداً إلكترونياً للتحقق إلى',
  'check_inbox_and_click':
      'يرجى التحقق من صندوق الوارد (ومجلد الرسائل غير المرغوب فيها) والنقر على رابط التحقق للمتابعة.',
  'resend_in': 'إعادة الإرسال بعد',
  'i_agree_to_the': 'أوافق على ',
  'terms_conditions': 'الشروط والأحكام',
  'and': ' و',
  'privacy_policy': 'سياسة الخصوصية',
  'please_accept_terms': 'يرجى قبول الشروط والأحكام',
  'or': 'أو',
  'make_email_correct': 'تأكد من صحة عنوان البريد الإلكتروني',
  'wait_and_resend': 'انتظر بضع دقائق وحاول إعادة الإرسال',

  'tasks': 'المهام',
  'notes': 'الملاحظات',
  'reminders': 'التذكيرات',
  'habits': 'العادات',
  'manage_todos': 'إدارة مهامك',
  'quick_ideas': 'أفكار سريعة وخواطر',
  'never_miss_tasks': 'لا تفوت المهام المهمة أبداً',
  'track_daily_habits': 'تتبع عاداتك اليومية',
  'statistics': 'الإحصائيات',
  'view_progress': 'عرض تقدمك',
  'customize_experience': 'خصص تجربتك',
  'open_menu': 'فتح القائمة',
  'search': 'بحث',

  'how_can_we_help': 'كيف يمكننا مساعدتك؟',
  'find_answers': 'ابحث عن إجابات أو تواصل مع فريق الدعم',
  'contact_us': 'اتصل بنا',
  'email_support': 'دعم البريد الإلكتروني',
  'live_chat': 'دردشة مباشرة',
  'chat_with_team': 'تحدث مع فريقنا',
  'report_problem': 'الإبلاغ عن مشكلة',
  'let_us_know': 'أخبرنا بما حدث من خطأ',
  'faq': 'الأسئلة الشائعة',
  'resources': 'الموارد',
  'user_guide': 'دليل المستخدم',
  'learn_how_to_use': 'تعلم كيفية استخدام ديفلو',
  'video_tutorials': 'دروس فيديو',
  'watch_guides': 'شاهد أدلة خطوة بخطوة',
  'tips_tricks': 'نصائح وحيل',
  'get_most_out': 'احصل على أقصى استفادة من ديفلو',
  'problem_type': 'نوع المشكلة',
  'description': 'الوصف',
  'describe_issue': 'صف المشكلة بالتفصيل',
  'submit': 'إرسال',
  'problem_report_submitted': '✓ تم إرسال تقرير المشكلة. سنراجعه قريباً!',
  'backup_status': 'حالة النسخ الاحتياطي',
  'last_backup': 'آخر نسخة احتياطية',
  'no_backups_yet': 'لا توجد نسخ احتياطية بعد',
  'quick_actions': 'إجراءات سريعة',
  'backup_now': 'نسخ احتياطي الآن',
  'restore_backup': 'استعادة النسخة الاحتياطية',
  'sync_with_cloud': 'مزامنة مع السحابة',
  'backup_settings': 'إعدادات النسخ الاحتياطي',
  'auto_backup': 'نسخ احتياطي تلقائي',
  'auto_backup_daily': 'نسخ احتياطي تلقائي للبيانات يومياً',
  'cloud_sync': 'مزامنة السحابة',
  'sync_across_devices': 'مزامنة البيانات عبر الأجهزة',
  'encrypt_data': 'تشفير البيانات',
  'secure_backups': 'تأمين النسخ الاحتياطية',
  'clear_cache': 'مسح ذاكرة التخزين المؤقت',
  'free_up_storage': 'تحرير مساحة التخزين',
  'delete_all_data': 'حذف جميع البيانات',
  'permanently_remove': 'إزالة جميع البيانات نهائياً',
  'processing': 'جاري المعالجة...',
  'backup_completed': '✓ اكتمل النسخ الاحتياطي بنجاح',
  'backup_restored': '✓ تمت استعادة النسخة الاحتياطية بنجاح',
  'synced_cloud': '✓ تمت المزامنة مع السحابة بنجاح',
  'restore_confirm':
      'سيؤدي هذا إلى استعادة بياناتك من آخر نسخة احتياطية. سيتم استبدال البيانات الحالية. هل تريد المتابعة؟',
  'delete_data_confirm':
      '⚠️ سيؤدي هذا إلى حذف جميع بياناتك نهائياً بما في ذلك المهام والملاحظات والإعدادات. لا يمكن التراجع عن هذا الإجراء!',
  'clear_cache_confirm':
      'سيؤدي هذا إلى مسح الملفات المؤقتة وتحرير مساحة التخزين. هل تريد المتابعة؟',
  'cache_cleared': '✓ تم مسح ذاكرة التخزين المؤقت بنجاح',
  'all_data_deleted': 'تم حذف جميع البيانات',
  'delete_all': 'حذف الكل',
  'clear': 'مسح',
  'restore': 'استعادة',
  'terms_of_service': 'شروط الخدمة',
  'privacy_policy_title': 'سياسة الخصوصية',
  'last_updated': 'آخر تحديث',
  'by_using_dayflow':
      'باستخدام ديفلو، فإنك توافق على شروط الخدمة وسياسة الخصوصية هذه.',
  'faq_create_task': 'كيف أنشئ مهمة جديدة؟',
  'faq_create_task_answer':
      'اضغط على زر + في صفحة المهام، أدخل تفاصيل مهمتك، واضغط على حفظ. يمكنك تعيين الأولويات وتواريخ الاستحقاق والفئات.',
  'faq_dark_mode': 'كيف أفعّل الوضع الداكن؟',
  'faq_dark_mode_answer':
      'انتقل إلى الإعدادات ← المظهر، ثم قم بتبديل مفتاح السمة لتفعيل الوضع الداكن.',
  'faq_sync_data': 'هل يمكنني مزامنة بياناتي عبر الأجهزة؟',
  'faq_sync_data_answer':
      'نعم! سجل الدخول بحسابك وفعّل مزامنة السحابة في الإعدادات ← النسخ الاحتياطي والمزامنة.',
  'faq_set_reminders': 'كيف أضبط التذكيرات؟',
  'faq_set_reminders_answer':
      'افتح مهمة أو أنشئ واحدة جديدة، اضغط على "تعيين تذكير"، اختر التاريخ والوقت، واحفظ.',
  'faq_backup_data': 'كيف أنسخ بياناتي احتياطياً؟',
  'faq_backup_data_answer':
      'انتقل إلى الإعدادات ← النسخ الاحتياطي والمزامنة، ثم اضغط على "نسخ احتياطي الآن". يمكنك أيضاً تفعيل النسخ الاحتياطي التلقائي.',
  'faq_export_data': 'هل يمكنني تصدير بياناتي؟',
  'faq_export_data_answer':
      'في الوقت الحالي هذا غير ممكن، ربما في المستقبل نعم.',

  // Question Flow
  'qf_biggest_challenge': 'ما هو أكبر تحدي إنتاجية تواجهه?',
  'qf_too_many_tasks': '📋 مهام كثيرة جداً',
  'qf_staying_focused': '🎯 الحفاظ على التركيز',
  'qf_time_management': '⏰ إدارة الوقت',
  'qf_remembering_everything': '🧠 تذكر كل شيء',

  'qf_when_work_best': 'متى تعمل بشكل أفضل?',
  'qf_early_morning': '🌅 الصباح الباكر',
  'qf_afternoon': '☀️ بعد الظهر',
  'qf_evening': '🌆 المساء',
  'qf_late_night': '🌙 في وقت متأخر من الليل',

  'qf_main_goal': 'ما هو هدفك الرئيسي مع ديفلو?',
  'qf_get_organized': '✨ التنظيم',
  'qf_build_habits': '💪 بناء عادات أفضل',
  'qf_track_tasks': '✅ تتبع جميع مهامي',
  'qf_remember_all': '💡 تذكر كل شيء',

  'qf_prefer_plan': 'كيف تفضل التخطيط?',
  'qf_day_by_day': '📅 يوماً بيوم',
  'qf_week_ahead': '📆 أسبوع مقدماً',
  'qf_monthly_view': '🗓️ عرض شهري',
  'qf_go_with_flow': '🌊 المضي مع التدفق',

  'qf_response_1': 'فهمت، مسجل! 📝',
  'qf_response_2': 'أنت من نوع المخططين الذي أحبه!',
  'qf_response_3': 'هذا يخبرني الكثير!',
  'qf_response_4': 'رائع، لديك نطاق واسع! 🎯',
  'qf_response_5': 'اختيار مثير للاهتمام! ⏰',
  'qf_response_6': 'يمكنني العمل مع ذلك!',
  'qf_response_7': 'رائع، المرونة هي المفتاح! 🌟',
  'qf_response_8': 'أنت متعدد الاستخدامات! أحب ذلك!',
  'qf_response_9': 'ستحب ديفلو لهذا! 🚀',
  'qf_response_10': 'مثالي! نحن نغطيك!',
  'qf_response_11': 'هذا بالضبط ما نقوم به بشكل أفضل! ⭐',
  'qf_response_12': 'طموح! أحب ذلك! 💯',
  'qf_response_13': 'نهج ذكي! 🎯',
  'qf_response_14': 'أرى أسلوب التخطيط الخاص بك!',
  'qf_response_15': 'مزج ومطابقة، رائع! 🌈',
  'qf_response_16': 'أنت قابل للتكيف! مثالي! ✨',

  'qf_greeting': 'مرحباً! دعنا نتعرف عليك! 👋',
  'qf_next_question': 'السؤال التالي! 🎯',
  'qf_completion': 'مثالي! أنت جاهز! 🎉',
  'qf_finish': 'إنهاء',

  "remindersRetry": "إعادة المحاولة",
  "remindersNoRemindersTitle": "لا توجد تذكيرات",
  "remindersNoRemindersSubtitle": "أضف تذكيرات أو أنشئ مهام",
  "remindersToday": "اليوم",
  "remindersTomorrow": "غدًا",
  "remindersUpcoming": "القادمة",
  "remindersSomethingWrong": "حدث خطأ ما",

  "weekdayMonday": "الاثنين",
  "weekdayTuesday": "الثلاثاء",
  "weekdayWednesday": "الأربعاء",
  "weekdayThursday": "الخميس",
  "weekdayFriday": "الجمعة",
  "weekdaySaturday": "السبت",
  "weekdaySunday": "الأحد",

  "reminderCreateTitle": "إنشاء تذكير جديد",
  "reminderTitle": "العنوان",
  "reminderEnterTitle": "أدخل عنوان التذكير",
  "reminderDescriptionOptional": "الوصف (اختياري)",
  "reminderEnterDescription": "أدخل الوصف",
  "reminderSelectTime": "اختر الوقت",
  "reminderAdd": "إضافة تذكير",
  "reminderErrorTitleRequired": "يرجى إدخال عنوان التذكير",
  "reminderErrorTimeRequired": "يرجى اختيار الوقت",
  "reminderAdded": "تمت إضافة التذكير!",

  "reminderEditTitle": "تعديل التذكير",
  "update": "تحديث",
  "editReminder": "تعديل التذكير",
  "deleteReminder": "حذف التذكير",
  "enableReminder": "تفعيل التذكير",
  "disableReminder": "إلغاء التذكير",
  "reminderDeleteConfirmation": "هل أنت متأكد أنك تريد حذف هذا التذكير؟",
  "reminderUpdated": "تم تحديث التذكير!",
  "reminderDeleted": "تم حذف التذكير",
  "delete": "حذف",
  "reminderInfoTaskLocked": "هذا التذكير ينتمي لمهمة ولا يمكن تعديله هنا",
  "task": "مهمة",
};

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'fr', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
