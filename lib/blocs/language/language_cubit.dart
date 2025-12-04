import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  static const _keyLanguageCode = 'language_code';

  LanguageCubit() : super(const Locale('ar'));

  bool get isRTL => state.languageCode == 'ar';

  String get languageName {
    switch (state.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'ar':
        return 'العربية';
      default:
        return 'العربية';
    }
  }

  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_keyLanguageCode) ?? 'ar';
    emit(Locale(languageCode));
  }

  Future<void> changeLanguage(String languageCode) async {
    if (state.languageCode == languageCode) return;
    emit(Locale(languageCode));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguageCode, languageCode);
  }
}
