// lib/utils/app_localizations.dart

import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  String get checkingVerificationStatus => translate('checking_verification_status');

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
  String get pleaseEnterCurrentPassword => translate('please_enter_current_password');
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
  'sign_in_to_continue_desc': 'Access your tasks, notes, and reminders\nacross all your devices',

  'coming_soon': 'Coming Soon',
  'feature_under_development': 'This feature is under development',
  'working_hard_on_feature': "We're working hard to bring you this feature soon!",
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

  'app_description': 'A smart daily planner to help you manage your tasks, notes, and reminders efficiently.',
  'developed_by': 'Developed by Team DayFlow',
  'team_members': 'Abderrahmane Houri\nMohamed Al Amin Saàd\nLina Selma Ouadah',

  'your_smart_daily_planner': 'Your Smart Daily Planner',
  'organize_tasks': 'Organize your tasks efficiently',
  'capture_ideas': 'Capture ideas instantly',
  'never_miss_reminders': 'Never miss important reminders',
  'skip': 'Skip',
  'next': 'Next',
  'organize_your_tasks': 'Organize Your Tasks',
  'organize_tasks_desc': 'Create, manage, and prioritize your daily tasks with ease. Never miss a deadline again.',
  'capture_your_ideas': 'Capture Your Ideas',
  'capture_ideas_desc': 'Jot down notes, thoughts, and ideas instantly. Keep everything organized in one place.',
  'set_smart_reminders': 'Set Smart Reminders',
  'set_reminders_desc': 'Get timely notifications for important tasks. Stay on top of your schedule effortlessly.',
  'track_your_habits': 'Track Your Habits',
  'track_habits_desc': 'Build better habits with daily tracking. Monitor your progress and achieve your goals.',
  'remember_password': 'Remember your password? Login',
  'check_your_email': 'Check Your Email',
  'forgot_password_desc': "Don't worry! Enter your email address and we'll send you a link to reset your password.",
  'reset_email_sent': "We've sent a password reset link to your email address. Please check your inbox and follow the instructions.",
  'resend_email': 'Resend Email',
  'didnt_receive_email': "Didn't receive the email?",
  'check_spam_folder': 'Check your spam folder or try resending the email.',
  'email_verified_success': 'Email verified successfully! Welcome to DayFlow 🎉',
  'verification_email_to': "We've sent a verification email to",
  'check_inbox_and_click': 'Please check your inbox (and spam folder) and click the verification link to continue.',
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
  'sign_in_to_continue_desc': 'Accédez à vos tâches, notes et rappels\nsur tous vos appareils',

  'coming_soon': 'Bientôt disponible',
  'feature_under_development': 'Cette fonctionnalité est en développement',
  'working_hard_on_feature': 'Nous travaillons dur pour vous apporter cette fonctionnalité bientôt!',
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

  'app_description': 'Un planificateur quotidien intelligent pour vous aider à gérer efficacement vos tâches, notes et rappels.',
  'developed_by': 'Développé par Team DayFlow',
  'team_members': 'Abderrahmane Houri\nMohamed Al Amin Saàd\nLina Selma Ouadah',

  'your_smart_daily_planner': 'Votre planificateur quotidien intelligent',
  'organize_tasks': 'Organisez vos tâches efficacement',
  'capture_ideas': 'Capturez vos idées instantanément',
  'never_miss_reminders': 'Ne manquez jamais de rappels importants',
  'skip': 'Passer',
  'next': 'Suivant',
  'organize_your_tasks': 'Organisez vos tâches',
  'organize_tasks_desc': 'Créez, gérez et priorisez vos tâches quotidiennes facilement. Ne manquez plus jamais une échéance.',
  'capture_your_ideas': 'Capturez vos idées',
  'capture_ideas_desc': 'Notez vos notes, pensées et idées instantanément. Gardez tout organisé en un seul endroit.',
  'set_smart_reminders': 'Définir des rappels intelligents',
  'set_reminders_desc': 'Recevez des notifications opportunes pour les tâches importantes. Restez au top de votre emploi du temps sans effort.',
  'track_your_habits': 'Suivez vos habitudes',
  'track_habits_desc': 'Développez de meilleures habitudes avec un suivi quotidien. Surveillez vos progrès et atteignez vos objectifs.',
  'remember_password': 'Vous vous souvenez de votre mot de passe? Connexion',
  'check_your_email': 'Vérifiez votre email',
  'forgot_password_desc': "Ne vous inquiétez pas! Entrez votre adresse email et nous vous enverrons un lien pour réinitialiser votre mot de passe.",
  'reset_email_sent': "Nous avons envoyé un lien de réinitialisation à votre adresse email. Veuillez vérifier votre boîte de réception et suivre les instructions.",
  'resend_email': "Renvoyer l'email",
  'didnt_receive_email': "Vous n'avez pas reçu l'email?",
  'check_spam_folder': "Vérifiez votre dossier spam ou essayez de renvoyer l'email.",
  'email_verified_success': 'Email vérifié avec succès! Bienvenue sur DayFlow 🎉',
  'verification_email_to': 'Nous avons envoyé un email de vérification à',
  'check_inbox_and_click': 'Veuillez vérifier votre boîte de réception (et spam) et cliquer sur le lien de vérification pour continuer.',
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
  'sign_in_to_continue_desc': 'الوصول إلى مهامك وملاحظاتك وتذكيراتك\nعلى جميع أجهزتك',

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

  'app_description': 'مخطط يومي ذكي لمساعدتك في إدارة مهامك وملاحظاتك وتذكيراتك بكفاءة.',
  'developed_by': 'تطوير فريق ديفلو',
  'team_members': 'عبد الرحمن حوري\nمحمد الأمين سعد\nلينا سلمى وداح',

  'your_smart_daily_planner': 'مخططك اليومي الذكي',
  'organize_tasks': 'نظم مهامك بكفاءة',
  'capture_ideas': 'سجل أفكارك فوراً',
  'never_miss_reminders': 'لا تفوت التذكيرات المهمة أبداً',
  'skip': 'تخطي',
  'next': 'التالي',
  'organize_your_tasks': 'نظم مهامك',
  'organize_tasks_desc': 'أنشئ وأدر ورتب مهامك اليومية بسهولة. لا تفوت موعداً نهائياً مرة أخرى.',
  'capture_your_ideas': 'سجل أفكارك',
  'capture_ideas_desc': 'دون ملاحظاتك وأفكارك وخواطرك فوراً. احتفظ بكل شيء منظماً في مكان واحد.',
  'set_smart_reminders': 'اضبط تذكيرات ذكية',
  'set_reminders_desc': 'احصل على إشعارات في الوقت المناسب للمهام المهمة. ابق في صدارة جدولك بسهولة.',
  'track_your_habits': 'تتبع عاداتك',
  'track_habits_desc': 'ابنِ عادات أفضل مع التتبع اليومي. راقب تقدمك وحقق أهدافك.',
  'remember_password': 'هل تتذكر كلمة المرور؟ تسجيل الدخول',
  'check_your_email': 'تحقق من بريدك الإلكتروني',
  'forgot_password_desc': 'لا تقلق! أدخل عنوان بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.',
  'reset_email_sent': 'لقد أرسلنا رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني. يرجى التحقق من صندوق الوارد واتباع التعليمات.',
  'resend_email': 'إعادة إرسال البريد',
  'didnt_receive_email': 'لم تستلم البريد الإلكتروني؟',
  'check_spam_folder': 'تحقق من مجلد الرسائل غير المرغوب فيها أو حاول إعادة الإرسال.',
  'email_verified_success': 'تم التحقق من البريد الإلكتروني بنجاح! مرحباً بك في ديفلو 🎉',
  'verification_email_to': 'لقد أرسلنا بريداً إلكترونياً للتحقق إلى',
  'check_inbox_and_click': 'يرجى التحقق من صندوق الوارد (ومجلد الرسائل غير المرغوب فيها) والنقر على رابط التحقق للمتابعة.',
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
};

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}