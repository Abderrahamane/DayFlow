import 'package:flutter/material.dart';

class SettingsLocalizations {
  final Locale locale;

  SettingsLocalizations(this.locale);

  static SettingsLocalizations of(BuildContext context) {
    return Localizations.of<SettingsLocalizations>(context, SettingsLocalizations)!;
  }

  static const LocalizationsDelegate<SettingsLocalizations> delegate =
      _SettingsLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'Settings',
      'profile': 'Profile',
      'appearance': 'Appearance',
      'theme': 'Theme',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'theme_changed': 'Theme changed to',
      'language': 'Language',
      'select_language': 'Select Language',
      'language_changed': 'Language changed to',
      'account': 'Account',
      'preferences': 'Preferences',
      'notifications': 'Notifications',
      'notifications_enabled': 'Notifications enabled',
      'notifications_disabled': 'Notifications disabled',
      'receive_task_alerts': 'Receive task alerts',
      'no_notifications': 'No notifications',
      'backup_and_sync': 'Backup & Sync',
      'cloud_backup': 'Cloud backup',
      'about': 'About',
      'about_dayflow': 'About DayFlow',
      'version': 'Version 1.0.0',
      'help_and_support': 'Help & Support',
      'get_help': 'Get help',
      'terms_and_privacy': 'Terms & Privacy',
      'legal_info': 'Legal information',
      'app_description': 'DayFlow is your ultimate daily planner designed to help you stay organized, productive, and focused.',
      'developed_by': 'Developed by',
      'team_members': 'Team Members',
      'close': 'Close',
      'coming_soon': 'Coming Soon',
      'feature_under_development': 'This feature is under development',
      'working_hard_on_feature': 'We are working hard to bring this feature to you.',
      'got_it': 'Got it',
      'sync_status': 'Sync Status',
      'last_synced': 'Last synced just now',
      'change_password': 'Change Password',
      'update_password': 'Update your password',
      'current_password': 'Current Password',
      'new_password': 'New Password',
      'confirm_new_password': 'Confirm New Password',
      'enter_current_password': 'Enter current password',
      'enter_new_password': 'Enter new password',
      'please_enter_current_password': 'Please enter current password',
      'please_enter_new_password': 'Please enter new password',
      'password_must_be_different': 'New password must be different',
      'change': 'Change',
      'edit_profile': 'Edit Profile',
      'save': 'Save',
      'enter_name': 'Enter your name',
      'enter_email': 'Enter your email',
    },
    'fr': {
      'settings': 'Paramètres',
      'profile': 'Profil',
      'appearance': 'Apparence',
      'theme': 'Thème',
      'dark_mode': 'Mode sombre',
      'light_mode': 'Mode clair',
      'theme_changed': 'Thème changé en',
      'language': 'Langue',
      'select_language': 'Choisir la langue',
      'language_changed': 'Langue changée en',
      'account': 'Compte',
      'preferences': 'Préférences',
      'notifications': 'Notifications',
      'notifications_enabled': 'Notifications activées',
      'notifications_disabled': 'Notifications désactivées',
      'receive_task_alerts': 'Recevoir des alertes de tâches',
      'no_notifications': 'Pas de notifications',
      'backup_and_sync': 'Sauvegarde et synchronisation',
      'cloud_backup': 'Sauvegarde cloud',
      'about': 'À propos',
      'about_dayflow': 'À propos de DayFlow',
      'version': 'Version 1.0.0',
      'help_and_support': 'Aide et support',
      'get_help': 'Obtenir de l\'aide',
      'terms_and_privacy': 'Termes et confidentialité',
      'legal_info': 'Informations légales',
      'app_description': 'DayFlow est votre planificateur quotidien ultime conçu pour vous aider à rester organisé, productif et concentré.',
      'developed_by': 'Développé par',
      'team_members': 'Membres de l\'équipe',
      'close': 'Fermer',
      'coming_soon': 'Bientôt disponible',
      'feature_under_development': 'Cette fonctionnalité est en cours de développement',
      'working_hard_on_feature': 'Nous travaillons dur pour vous apporter cette fonctionnalité.',
      'got_it': 'Compris',
      'sync_status': 'État de la synchronisation',
      'last_synced': 'Dernière synchronisation à l\'instant',
      'change_password': 'Changer le mot de passe',
      'update_password': 'Mettre à jour votre mot de passe',
      'current_password': 'Mot de passe actuel',
      'new_password': 'Nouveau mot de passe',
      'confirm_new_password': 'Confirmer le nouveau mot de passe',
      'enter_current_password': 'Entrez le mot de passe actuel',
      'enter_new_password': 'Entrez le nouveau mot de passe',
      'please_enter_current_password': 'Veuillez entrer le mot de passe actuel',
      'please_enter_new_password': 'Veuillez entrer le nouveau mot de passe',
      'password_must_be_different': 'Le nouveau mot de passe doit être différent',
      'change': 'Changer',
      'edit_profile': 'Modifier le profil',
      'save': 'Enregistrer',
      'enter_name': 'Entrez votre nom',
      'enter_email': 'Entrez votre e-mail',
    },
    'ar': {
      'settings': 'الإعدادات',
      'profile': 'الملف الشخصي',
      'appearance': 'المظهر',
      'theme': 'السمة',
      'dark_mode': 'الوضع الداكن',
      'light_mode': 'الوضع الفاتح',
      'theme_changed': 'تم تغيير السمة إلى',
      'language': 'اللغة',
      'select_language': 'اختر اللغة',
      'language_changed': 'تم تغيير اللغة إلى',
      'account': 'الحساب',
      'preferences': 'التفضيلات',
      'notifications': 'الإشعارات',
      'notifications_enabled': 'تم تفعيل الإشعارات',
      'notifications_disabled': 'تم تعطيل الإشعارات',
      'receive_task_alerts': 'تلقي تنبيهات المهام',
      'no_notifications': 'لا توجد إشعارات',
      'backup_and_sync': 'النسخ الاحتياطي والمزامنة',
      'cloud_backup': 'النسخ الاحتياطي السحابي',
      'about': 'حول',
      'about_dayflow': 'حول DayFlow',
      'version': 'الإصدار 1.0.0',
      'help_and_support': 'المساعدة والدعم',
      'get_help': 'الحصول على المساعدة',
      'terms_and_privacy': 'الشروط والخصوصية',
      'legal_info': 'المعلومات القانونية',
      'app_description': 'DayFlow هو مخططك اليومي النهائي المصمم لمساعدتك على البقاء منظمًا ومنتجًا ومركزًا.',
      'developed_by': 'تطوير بواسطة',
      'team_members': 'أعضاء الفريق',
      'close': 'إغلاق',
      'coming_soon': 'قريباً',
      'feature_under_development': 'هذه الميزة قيد التطوير',
      'working_hard_on_feature': 'نحن نعمل بجد لتقديم هذه الميزة لك.',
      'got_it': 'فهمت',
      'sync_status': 'حالة المزامنة',
      'last_synced': 'آخر مزامنة الآن',
      'change_password': 'تغيير كلمة المرور',
      'update_password': 'تحديث كلمة المرور الخاصة بك',
      'current_password': 'كلمة المرور الحالية',
      'new_password': 'كلمة المرور الجديدة',
      'confirm_new_password': 'تأكيد كلمة المرور الجديدة',
      'enter_current_password': 'أدخل كلمة المرور الحالية',
      'enter_new_password': 'أدخل كلمة المرور الجديدة',
      'please_enter_current_password': 'يرجى إدخال كلمة المرور الحالية',
      'please_enter_new_password': 'يرجى إدخال كلمة المرور الجديدة',
      'password_must_be_different': 'يجب أن تكون كلمة المرور الجديدة مختلفة',
      'change': 'تغيير',
      'edit_profile': 'تعديل الملف الشخصي',
      'save': 'حفظ',
      'enter_name': 'أدخل اسمك',
      'enter_email': 'أدخل بريدك الإلكتروني',
    },
  };

  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get appearance => _localizedValues[locale.languageCode]!['appearance']!;
  String get theme => _localizedValues[locale.languageCode]!['theme']!;
  String get darkMode => _localizedValues[locale.languageCode]!['dark_mode']!;
  String get lightMode => _localizedValues[locale.languageCode]!['light_mode']!;
  String get themeChanged => _localizedValues[locale.languageCode]!['theme_changed']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get selectLanguage => _localizedValues[locale.languageCode]!['select_language']!;
  String get languageChanged => _localizedValues[locale.languageCode]!['language_changed']!;
  String get account => _localizedValues[locale.languageCode]!['account']!;
  String get preferences => _localizedValues[locale.languageCode]!['preferences']!;
  String get notifications => _localizedValues[locale.languageCode]!['notifications']!;
  String get notificationsEnabled => _localizedValues[locale.languageCode]!['notifications_enabled']!;
  String get notificationsDisabled => _localizedValues[locale.languageCode]!['notifications_disabled']!;
  String get receiveTaskAlerts => _localizedValues[locale.languageCode]!['receive_task_alerts']!;
  String get noNotifications => _localizedValues[locale.languageCode]!['no_notifications']!;
  String get backupAndSync => _localizedValues[locale.languageCode]!['backup_and_sync']!;
  String get cloudBackup => _localizedValues[locale.languageCode]!['cloud_backup']!;
  String get about => _localizedValues[locale.languageCode]!['about']!;
  String get aboutDayFlow => _localizedValues[locale.languageCode]!['about_dayflow']!;
  String get version => _localizedValues[locale.languageCode]!['version']!;
  String get helpAndSupport => _localizedValues[locale.languageCode]!['help_and_support']!;
  String get getHelp => _localizedValues[locale.languageCode]!['get_help']!;
  String get termsAndPrivacy => _localizedValues[locale.languageCode]!['terms_and_privacy']!;
  String get legalInfo => _localizedValues[locale.languageCode]!['legal_info']!;
  String get appDescription => _localizedValues[locale.languageCode]!['app_description']!;
  String get developedBy => _localizedValues[locale.languageCode]!['developed_by']!;
  String get teamMembers => _localizedValues[locale.languageCode]!['team_members']!;
  String get close => _localizedValues[locale.languageCode]!['close']!;
  String get comingSoon => _localizedValues[locale.languageCode]!['coming_soon']!;
  String get featureUnderDevelopment => _localizedValues[locale.languageCode]!['feature_under_development']!;
  String get workingHardOnFeature => _localizedValues[locale.languageCode]!['working_hard_on_feature']!;
  String get gotIt => _localizedValues[locale.languageCode]!['got_it']!;
  String get syncStatus => _localizedValues[locale.languageCode]!['sync_status']!;
  String get lastSynced => _localizedValues[locale.languageCode]!['last_synced']!;
  String get changePassword => _localizedValues[locale.languageCode]!['change_password']!;
  String get updatePassword => _localizedValues[locale.languageCode]!['update_password']!;
  String get currentPassword => _localizedValues[locale.languageCode]!['current_password']!;
  String get newPassword => _localizedValues[locale.languageCode]!['new_password']!;
  String get confirmNewPassword => _localizedValues[locale.languageCode]!['confirm_new_password']!;
  String get enterCurrentPassword => _localizedValues[locale.languageCode]!['enter_current_password']!;
  String get enterNewPassword => _localizedValues[locale.languageCode]!['enter_new_password']!;
  String get pleaseEnterCurrentPassword => _localizedValues[locale.languageCode]!['please_enter_current_password']!;
  String get pleaseEnterNewPassword => _localizedValues[locale.languageCode]!['please_enter_new_password']!;
  String get passwordMustBeDifferent => _localizedValues[locale.languageCode]!['password_must_be_different']!;
  String get change => _localizedValues[locale.languageCode]!['change']!;
  String get editProfile => _localizedValues[locale.languageCode]!['edit_profile']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get enterName => _localizedValues[locale.languageCode]!['enter_name']!;
  String get enterEmail => _localizedValues[locale.languageCode]!['enter_email']!;
}

class _SettingsLocalizationsDelegate
    extends LocalizationsDelegate<SettingsLocalizations> {
  const _SettingsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<SettingsLocalizations> load(Locale locale) async {
    return SettingsLocalizations(locale);
  }

  @override
  bool shouldReload(_SettingsLocalizationsDelegate old) => false;
}

