// // lib/providers/language_provider.dart
//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class LanguageProvider extends ChangeNotifier {
//   static const String _keyLanguageCode = 'language_code';
//
//   Locale _locale = const Locale('ar'); // Default to English
//
//   Locale get locale => _locale;
//
//   // Get language name for display
//   String get languageName {
//     switch (_locale.languageCode) {
//       case 'en':
//         return 'English';
//       case 'fr':
//         return 'Français';
//       case 'ar':
//         return 'العربية';
//       default:
//         return 'العربية';
//     }
//   }
//
//   // Load saved language from SharedPreferences
//   Future<void> loadSavedLanguage() async {
//     final prefs = await SharedPreferences.getInstance();
//     final languageCode = prefs.getString(_keyLanguageCode) ?? 'ar';
//     _locale = Locale(languageCode);
//     notifyListeners();
//   }
//
//   // Change language and save preference
//   Future<void> changeLanguage(String languageCode) async {
//     if (_locale.languageCode == languageCode) return;
//
//     _locale = Locale(languageCode);
//
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_keyLanguageCode, languageCode);
//
//     notifyListeners();
//   }
//
//   // Check if current language is RTL (Right-to-Left)
//   bool get isRTL => _locale.languageCode == 'ar';
// }