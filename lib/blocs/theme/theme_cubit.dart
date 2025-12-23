import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  bool get isDarkMode {
    if (state == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return state == ThemeMode.dark;
  }

  void setThemeMode(ThemeMode mode) => emit(mode);

  void toggleTheme() => emit(isDarkMode ? ThemeMode.light : ThemeMode.dark);
}
