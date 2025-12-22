import 'package:flutter/material.dart';

class AuthLocalizations {
  final Locale locale;

  AuthLocalizations(this.locale);

  static AuthLocalizations of(BuildContext context) {
    return Localizations.of<AuthLocalizations>(context, AuthLocalizations)!;
  }

  static const LocalizationsDelegate<AuthLocalizations> delegate =
      _AuthLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'login': 'Login',
      'signup': 'Sign Up',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'full_name': 'Full Name',
      'forgot_password': 'Forgot Password?',
      'create_account': 'Create Account',
      'welcome_back': 'Welcome Back',
      'sign_in_to_continue': 'Sign in to continue',
      'sign_up_to_get_started': 'Sign up to get started',
      'already_have_account': 'Already have an account?',
      'dont_have_account': 'Don\'t have an account?',
      'or': 'OR',
      'continue_with_google': 'Continue with Google',
      'i_agree_to_the': 'I agree to the',
      'terms_conditions': 'Terms & Conditions',
      'and': 'and',
      'privacy_policy': 'Privacy Policy',
      'please_accept_terms': 'Please accept terms and conditions',
      'enter_email': 'Enter your email',
      'enter_password': 'Enter your password',
      're_enter_password': 'Re-enter password',
      'please_enter_name': 'Please enter your name',
      'please_enter_email': 'Please enter your email',
      'please_enter_valid_email': 'Please enter a valid email',
      'please_enter_password': 'Please enter your password',
      'please_confirm_password': 'Please confirm password',
      'password_too_short': 'Password must be at least 6 characters',
      'passwords_do_not_match': 'Passwords do not match',
      'name_too_short': 'Name is too short',
      'logout_confirmation': 'Logout Confirmation',
      'are_you_sure_logout': 'Are you sure you want to logout?',
      'cancel': 'Cancel',
      'logout_success': 'Logged out successfully',
      'sign_in': 'Sign In',
      'sign_in_to_continue_desc': 'Sign in to sync your data across devices',
    },
    'fr': {
      'login': 'Connexion',
      'signup': 'S\'inscrire',
      'logout': 'Déconnexion',
      'email': 'E-mail',
      'password': 'Mot de passe',
      'confirm_password': 'Confirmer le mot de passe',
      'full_name': 'Nom complet',
      'forgot_password': 'Mot de passe oublié ?',
      'create_account': 'Créer un compte',
      'welcome_back': 'Bon retour',
      'sign_in_to_continue': 'Connectez-vous pour continuer',
      'sign_up_to_get_started': 'Inscrivez-vous pour commencer',
      'already_have_account': 'Vous avez déjà un compte ?',
      'dont_have_account': 'Vous n\'avez pas de compte ?',
      'or': 'OU',
      'continue_with_google': 'Continuer avec Google',
      'i_agree_to_the': 'J\'accepte les',
      'terms_conditions': 'Termes et conditions',
      'and': 'et',
      'privacy_policy': 'Politique de confidentialité',
      'please_accept_terms': 'Veuillez accepter les termes et conditions',
      'enter_email': 'Entrez votre e-mail',
      'enter_password': 'Entrez votre mot de passe',
      're_enter_password': 'Entrez à nouveau le mot de passe',
      'please_enter_name': 'Veuillez entrer votre nom',
      'please_enter_email': 'Veuillez entrer votre e-mail',
      'please_enter_valid_email': 'Veuillez entrer un e-mail valide',
      'please_enter_password': 'Veuillez entrer votre mot de passe',
      'please_confirm_password': 'Veuillez confirmer le mot de passe',
      'password_too_short': 'Le mot de passe doit contenir au moins 6 caractères',
      'passwords_do_not_match': 'Les mots de passe ne correspondent pas',
      'name_too_short': 'Le nom est trop court',
      'logout_confirmation': 'Confirmation de déconnexion',
      'are_you_sure_logout': 'Êtes-vous sûr de vouloir vous déconnecter ?',
      'cancel': 'Annuler',
      'logout_success': 'Déconnecté avec succès',
      'sign_in': 'Se connecter',
      'sign_in_to_continue_desc': 'Connectez-vous pour synchroniser vos données',
    },
    'ar': {
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'logout': 'تسجيل الخروج',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirm_password': 'تأكيد كلمة المرور',
      'full_name': 'الاسم الكامل',
      'forgot_password': 'نسيت كلمة المرور؟',
      'create_account': 'إنشاء حساب',
      'welcome_back': 'مرحبًا بعودتك',
      'sign_in_to_continue': 'سجل الدخول للمتابعة',
      'sign_up_to_get_started': 'سجل حسابك للبدء',
      'already_have_account': 'لديك حساب بالفعل؟',
      'dont_have_account': 'ليس لديك حساب؟',
      'or': 'أو',
      'continue_with_google': 'المتابعة باستخدام Google',
      'i_agree_to_the': 'أوافق على',
      'terms_conditions': 'الشروط والأحكام',
      'and': 'و',
      'privacy_policy': 'سياسة الخصوصية',
      'please_accept_terms': 'يرجى قبول الشروط والأحكام',
      'enter_email': 'أدخل بريدك الإلكتروني',
      'enter_password': 'أدخل كلمة المرور',
      're_enter_password': 'أعد إدخال كلمة المرور',
      'please_enter_name': 'يرجى إدخال اسمك',
      'please_enter_email': 'يرجى إدخال بريدك الإلكتروني',
      'please_enter_valid_email': 'يرجى إدخال بريد إلكتروني صالح',
      'please_enter_password': 'يرجى إدخال كلمة المرور',
      'please_confirm_password': 'يرجى تأكيد كلمة المرور',
      'password_too_short': 'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
      'passwords_do_not_match': 'كلمات المرور غير متطابقة',
      'name_too_short': 'الاسم قصير جدًا',
      'logout_confirmation': 'تأكيد تسجيل الخروج',
      'are_you_sure_logout': 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
      'cancel': 'إلغاء',
      'logout_success': 'تم تسجيل الخروج بنجاح',
      'sign_in': 'تسجيل الدخول',
      'sign_in_to_continue_desc': 'سجل الدخول لمزامنة بياناتك عبر الأجهزة',
    },
  };

  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get signup => _localizedValues[locale.languageCode]!['signup']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get confirmPassword => _localizedValues[locale.languageCode]!['confirm_password']!;
  String get fullName => _localizedValues[locale.languageCode]!['full_name']!;
  String get forgotPassword => _localizedValues[locale.languageCode]!['forgot_password']!;
  String get createAccount => _localizedValues[locale.languageCode]!['create_account']!;
  String get welcomeBack => _localizedValues[locale.languageCode]!['welcome_back']!;
  String get signInToContinue => _localizedValues[locale.languageCode]!['sign_in_to_continue']!;
  String get signUpToGetStarted => _localizedValues[locale.languageCode]!['sign_up_to_get_started']!;
  String get alreadyHaveAccount => _localizedValues[locale.languageCode]!['already_have_account']!;
  String get dontHaveAccount => _localizedValues[locale.languageCode]!['dont_have_account']!;
  String get or => _localizedValues[locale.languageCode]!['or']!;
  String get continueWithGoogle => _localizedValues[locale.languageCode]!['continue_with_google']!;
  String get iAgreeToThe => _localizedValues[locale.languageCode]!['i_agree_to_the']!;
  String get termsConditions => _localizedValues[locale.languageCode]!['terms_conditions']!;
  String get and => _localizedValues[locale.languageCode]!['and']!;
  String get privacyPolicy => _localizedValues[locale.languageCode]!['privacy_policy']!;
  String get pleaseAcceptTerms => _localizedValues[locale.languageCode]!['please_accept_terms']!;
  String get enterEmail => _localizedValues[locale.languageCode]!['enter_email']!;
  String get enterPassword => _localizedValues[locale.languageCode]!['enter_password']!;
  String get reEnterPassword => _localizedValues[locale.languageCode]!['re_enter_password']!;
  String get pleaseEnterName => _localizedValues[locale.languageCode]!['please_enter_name']!;
  String get pleaseEnterEmail => _localizedValues[locale.languageCode]!['please_enter_email']!;
  String get pleaseEnterValidEmail => _localizedValues[locale.languageCode]!['please_enter_valid_email']!;
  String get pleaseEnterPassword => _localizedValues[locale.languageCode]!['please_enter_password']!;
  String get pleaseConfirmPassword => _localizedValues[locale.languageCode]!['please_confirm_password']!;
  String get passwordTooShort => _localizedValues[locale.languageCode]!['password_too_short']!;
  String get passwordsDoNotMatch => _localizedValues[locale.languageCode]!['passwords_do_not_match']!;
  String get nameTooShort => _localizedValues[locale.languageCode]!['name_too_short']!;
  String get logoutConfirmation => _localizedValues[locale.languageCode]!['logout_confirmation']!;
  String get areYouSureLogout => _localizedValues[locale.languageCode]!['are_you_sure_logout']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get logoutSuccess => _localizedValues[locale.languageCode]!['logout_success']!;
  String get signIn => _localizedValues[locale.languageCode]!['sign_in']!;
  String get signInToContinueDesc => _localizedValues[locale.languageCode]!['sign_in_to_continue_desc']!;
}

class _AuthLocalizationsDelegate
    extends LocalizationsDelegate<AuthLocalizations> {
  const _AuthLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AuthLocalizations> load(Locale locale) async {
    return AuthLocalizations(locale);
  }

  @override
  bool shouldReload(_AuthLocalizationsDelegate old) => false;
}

