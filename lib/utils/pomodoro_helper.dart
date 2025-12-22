import 'package:flutter/material.dart';
import '../models/pomodoro_model.dart';
import 'app_localizations.dart';

class PomodoroHelper {
  static String getSessionTypeLabel(BuildContext context, PomodoroSessionType type) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case PomodoroSessionType.work:
        return l10n.sessionTypeWork;
      case PomodoroSessionType.shortBreak:
        return l10n.sessionTypeShortBreak;
      case PomodoroSessionType.longBreak:
        return l10n.sessionTypeLongBreak;
    }
  }
}

