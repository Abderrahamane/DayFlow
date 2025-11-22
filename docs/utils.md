# 🔧 utils/ Folder Documentation

## Overview

The `utils/` folder contains **helper functions**, **utilities**, and **constants** that are used throughout the DayFlow app. These are the "tools" that make development easier and more consistent.

**Think of utils as a toolbox**: Instead of creating the same helper function in multiple places, you create it once here and use it everywhere.

---

## What Are Utils?

Utilities are:
- Helper functions that don't fit elsewhere
- Constants used across the app
- Configuration files
- Pure functions (no side effects)
- Reusable code snippets

---

## Files in utils/

```
utils/
├── routes.dart              # App navigation routes
├── constants.dart           # App-wide constants (empty in current project)
├── date_utils.dart          # Date formatting helpers
├── app_localizations.dart   # Multi-language support
└── language.dart            # Language definitions
```

---

## 🗺️ routes.dart

**Purpose**: Centralized navigation management. Defines all app routes and navigation helpers.

### Why Routes?

Instead of hardcoding route names everywhere:
```dart
// ❌ Bad: Hardcoded, error-prone
Navigator.pushNamed(context, '/todo-page');  // Typo!
Navigator.pushNamed(context, '/todo_page');  // Inconsistent!
```

Use centralized routes:
```dart
// ✅ Good: Type-safe, consistent
Navigator.pushNamed(context, Routes.todo);
```

### Route Definitions

```dart
class Routes {
  // Route names as constants
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String todo = '/todo';
  static const String notes = '/notes';
  static const String reminders = '/reminders';
  static const String habits = '/habits';
  static const String settings = '/settings';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String emailVerification = '/email-verification';
  static const String privacyBackup = '/privacy-backup';
  static const String helpSupport = '/help-support';
  static const String termsPrivacy = '/terms-privacy';
}
```

### Route Map

Maps route names to page widgets:

```dart
static Map<String, WidgetBuilder> routes = {
  welcome: (context) => const WelcomePage(),
  home: (context) => const MainNavigationShell(),
  todo: (context) => const TodoPage(),
  habits: (context) => const HabitsPage(),
  settings: (context) => const SettingsPage(),
  login: (context) => const LoginPage(),
  signup: (context) => const SignupPage(),
  // ... more routes
};
```

### Helper Navigation Methods

Convenience methods for common navigation patterns:

```dart
// Navigate to home (replace current page)
static void navigateToHome(BuildContext context) {
  Navigator.pushReplacementNamed(context, home);
}

// Navigate to welcome
static void navigateToWelcome(BuildContext context) {
  Navigator.pushReplacementNamed(context, welcome);
}

// Navigate to login
static void navigateToLogin(BuildContext context) {
  Navigator.pushNamed(context, login);
}

// Navigate to signup
static void navigateToSignup(BuildContext context) {
  Navigator.pushNamed(context, signup);
}
```

### Using Routes in main.dart

```dart
MaterialApp(
  initialRoute: Routes.login,
  routes: Routes.routes,
  // ...
);
```

### Using Routes in Widgets

```dart
// Simple navigation
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, Routes.todo);
  },
  child: Text('Go to Tasks'),
)

// Or use helper methods
ElevatedButton(
  onPressed: () {
    Routes.navigateToHome(context);
  },
  child: Text('Go Home'),
)

// Navigate with replacement (can't go back)
ElevatedButton(
  onPressed: () {
    Navigator.pushReplacementNamed(context, Routes.welcome);
  },
  child: Text('Sign Out'),
)

// Navigate with arguments
Navigator.pushNamed(
  context,
  Routes.taskDetail,
  arguments: taskId,
);

// Receive arguments in the target page
class TaskDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskId = ModalRoute.of(context)!.settings.arguments as String;
    // Use taskId
  }
}
```

### Benefits of Centralized Routes

✅ **Type Safety**: Autocomplete prevents typos
✅ **Consistency**: Same route names everywhere
✅ **Easy Refactoring**: Change route in one place
✅ **Clear Structure**: See all pages in one file
✅ **Easy Testing**: Mock navigation in tests

---

## 📅 date_utils.dart

**Purpose**: Helper functions for date formatting and manipulation.

### Current Functions

#### Format Header Date
```dart
String formattedHeaderDate() {
  final now = DateTime.now();
  const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 
                    'Friday', 'Saturday', 'Sunday'];
  const months = ['January', 'February', 'March', 'April', 'May', 'June',
                  'July', 'August', 'September', 'October', 'November', 'December'];
  
  final wd = weekdays[now.weekday - 1];
  final m = months[now.month - 1];
  
  return '$wd, ${now.day} $m';
}
```

**Output**: "Monday, 15 January"

### Common Date Utilities (can be added)

```dart
// Format date as "Jan 15, 2024"
String formatShortDate(DateTime date) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

// Format time as "3:45 PM"
String formatTime(DateTime time) {
  final hour = time.hour > 12 ? time.hour - 12 : time.hour;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $period';
}

// Check if two dates are the same day
bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
         date1.month == date2.month &&
         date1.day == date2.day;
}

// Get relative date string
String getRelativeDateString(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);
  
  if (difference.inDays == 0) {
    return 'Today';
  } else if (difference.inDays == 1) {
    return 'Yesterday';
  } else if (difference.inDays == -1) {
    return 'Tomorrow';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} days ago';
  } else {
    return formatShortDate(date);
  }
}

// Check if date is overdue
bool isOverdue(DateTime date) {
  return date.isBefore(DateTime.now());
}

// Get start of day
DateTime startOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

// Get end of day
DateTime endOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day, 23, 59, 59);
}

// Get start of week
DateTime startOfWeek(DateTime date) {
  return date.subtract(Duration(days: date.weekday - 1));
}

// Days until date
int daysUntil(DateTime date) {
  final today = DateTime.now();
  final difference = date.difference(today);
  return difference.inDays;
}
```

### Usage Examples

```dart
// In a widget
Text(formattedHeaderDate())  // "Monday, 15 January"

// Task due date
final dueDate = task.dueDate;
Text('Due: ${formatShortDate(dueDate)}')  // "Due: Jan 15, 2024"

// Relative time
Text(getRelativeDateString(task.createdAt))  // "2 days ago"

// Check overdue
if (isOverdue(task.dueDate)) {
  // Show overdue indicator
}
```

---

## 🌍 app_localizations.dart

**Purpose**: Multi-language support (internationalization/i18n).

### What It Does

Translates app text to different languages:
- 🇬🇧 English
- 🇫🇷 French
- 🇸🇦 Arabic (with RTL support)

### How It Works

#### 1. Translation Keys
```dart
class AppLocalizations {
  final Locale locale;
  
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': _enTranslations,
    'fr': _frTranslations,
    'ar': _arTranslations,
  };
  
  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}
```

#### 2. Getter Methods
```dart
// Common
String get appName => translate('app_name');
String get welcome => translate('welcome');
String get save => translate('save');
String get cancel => translate('cancel');

// Authentication
String get login => translate('login');
String get signup => translate('signup');
String get email => translate('email');
String get password => translate('password');

// Tasks
String get tasks => translate('tasks');
String get addTask => translate('add_task');
String get editTask => translate('edit_task');
String get deleteTask => translate('delete_task');

// Habits
String get habits => translate('habits');
String get addHabit => translate('add_habit');
String get completeHabit => translate('complete_habit');

// Settings
String get settings => translate('settings');
String get theme => translate('theme');
String get language => translate('language');
String get darkMode => translate('dark_mode');
```

#### 3. Translation Maps
```dart
// English translations
static const Map<String, String> _enTranslations = {
  'app_name': 'DayFlow',
  'welcome': 'Welcome',
  'save': 'Save',
  'cancel': 'Cancel',
  'login': 'Log In',
  'email': 'Email',
  'password': 'Password',
  'tasks': 'Tasks',
  'habits': 'Habits',
  'settings': 'Settings',
  // ... more translations
};

// French translations
static const Map<String, String> _frTranslations = {
  'app_name': 'DayFlow',
  'welcome': 'Bienvenue',
  'save': 'Enregistrer',
  'cancel': 'Annuler',
  'login': 'Connexion',
  'email': 'Email',
  'password': 'Mot de passe',
  'tasks': 'Tâches',
  'habits': 'Habitudes',
  'settings': 'Paramètres',
  // ... more translations
};

// Arabic translations
static const Map<String, String> _arTranslations = {
  'app_name': 'DayFlow',
  'welcome': 'مرحبا',
  'save': 'حفظ',
  'cancel': 'إلغاء',
  'login': 'تسجيل الدخول',
  'email': 'البريد الإلكتروني',
  'password': 'كلمة المرور',
  'tasks': 'المهام',
  'habits': 'العادات',
  'settings': 'الإعدادات',
  // ... more translations
};
```

### Using Localization in Widgets

```dart
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  
  return Scaffold(
    appBar: AppBar(
      title: Text(l10n.tasks),  // "Tasks" or "Tâches" or "المهام"
    ),
    body: Column(
      children: [
        Text(l10n.welcome),  // "Welcome" or "Bienvenue" or "مرحبا"
        ElevatedButton(
          onPressed: () {/*...*/},
          child: Text(l10n.save),  // "Save" or "Enregistrer" or "حفظ"
        ),
      ],
    ),
  );
}
```

### Setup in main.dart

```dart
MaterialApp(
  // Localization delegates
  localizationsDelegates: [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  
  // Supported languages
  supportedLocales: [
    Locale('en'),  // English
    Locale('fr'),  // French
    Locale('ar'),  // Arabic
  ],
  
  // Current locale from provider
  locale: Provider.of<LanguageProvider>(context).locale,
  
  // ...
);
```

### Changing Language

```dart
// In settings page
final languageProvider = Provider.of<LanguageProvider>(context);

DropdownButton<String>(
  value: languageProvider.locale.languageCode,
  items: [
    DropdownMenuItem(value: 'en', child: Text('English')),
    DropdownMenuItem(value: 'fr', child: Text('Français')),
    DropdownMenuItem(value: 'ar', child: Text('العربية')),
  ],
  onChanged: (code) {
    if (code != null) {
      languageProvider.changeLanguage(code);
      // App automatically rebuilds with new language!
    }
  },
);
```

### RTL Support (Arabic)

```dart
// Check if current language is RTL
bool isRTL = AppLocalizations.of(context).locale.languageCode == 'ar';

// Or use LanguageProvider
bool isRTL = Provider.of<LanguageProvider>(context).isRTL;

// Apply RTL layout
Directionality(
  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
  child: /*...*/,
)
```

---

## 🗣️ language.dart

**Purpose**: Language-related utilities and definitions.

### Language Model

```dart
class Language {
  final String code;
  final String name;
  final String nativeName;
  final bool isRTL;
  
  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
    this.isRTL = false,
  });
}
```

### Supported Languages

```dart
class Languages {
  static const Language english = Language(
    code: 'en',
    name: 'English',
    nativeName: 'English',
    isRTL: false,
  );
  
  static const Language french = Language(
    code: 'fr',
    name: 'French',
    nativeName: 'Français',
    isRTL: false,
  );
  
  static const Language arabic = Language(
    code: 'ar',
    name: 'Arabic',
    nativeName: 'العربية',
    isRTL: true,
  );
  
  static const List<Language> all = [english, french, arabic];
  
  static Language? fromCode(String code) {
    return all.firstWhere(
      (lang) => lang.code == code,
      orElse: () => english,
    );
  }
}
```

---

## 🎯 constants.dart

**Purpose**: App-wide constants (currently empty, but can include).

### Common Constants (can be added)

```dart
class AppConstants {
  // App Info
  static const String appName = 'DayFlow';
  static const String appVersion = '1.0.0';
  
  // API Endpoints
  static const String baseUrl = 'https://api.dayflow.app';
  
  // Limits
  static const int maxTaskTitleLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxTagsPerTask = 5;
  
  // Time
  static const Duration snackbarDuration = Duration(seconds: 3);
  static const Duration loadingTimeout = Duration(seconds: 30);
  
  // UI
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double defaultElevation = 2.0;
  
  // Storage Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language_code';
  static const String keyOnboardingComplete = 'onboarding_complete';
  
  // Firebase Collections
  static const String collectionUsers = 'users';
  static const String collectionTasks = 'tasks';
  static const String collectionHabits = 'habits';
  static const String collectionNotes = 'notes';
}

class AppColors {
  // Priority Colors
  static const Color priorityHigh = Color(0xFFEF4444);    // Red
  static const Color priorityMedium = Color(0xFFF59E0B);  // Orange
  static const Color priorityLow = Color(0xFF3B82F6);     // Blue
  static const Color priorityNone = Color(0xFF6B7280);    // Gray
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
}

class AppStrings {
  // Error Messages
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorUnknown = 'An unknown error occurred.';
  static const String errorAuth = 'Authentication failed.';
  
  // Empty States
  static const String emptyTasks = 'No tasks yet. Add your first task!';
  static const String emptyHabits = 'No habits yet. Start building good habits!';
  static const String emptyNotes = 'No notes yet. Capture your thoughts!';
}
```

### Usage

```dart
// In code
Text(AppConstants.appName)
Container(padding: EdgeInsets.all(AppConstants.defaultPadding))
Container(decoration: BoxDecoration(
  color: AppColors.priorityHigh,
  borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
))

// Error handling
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(AppStrings.errorNetwork),
    duration: AppConstants.snackbarDuration,
  ),
);
```

---

## Utility Best Practices

### ✅ DO:

1. **Keep utilities pure** (no side effects)
   ```dart
   // Good: Pure function
   String formatDate(DateTime date) {
     return '${date.year}-${date.month}-${date.day}';
   }
   ```

2. **Make utilities reusable**
   ```dart
   // Good: Flexible parameters
   String formatDate(DateTime date, {String format = 'short'}) {
     // Can handle different formats
   }
   ```

3. **Document utilities**
   ```dart
   /// Formats a date as "Jan 15, 2024"
   /// 
   /// Example:
   /// ```dart
   /// formatShortDate(DateTime.now())  // "Jan 15, 2024"
   /// ```
   String formatShortDate(DateTime date) {/*...*/}
   ```

### ❌ DON'T:

1. **Don't add business logic**
   ```dart
   // Bad: Business logic in utils
   void saveTaskToDatabase(Task task) {
     // This belongs in a service!
   }
   ```

2. **Don't make utilities stateful**
   ```dart
   // Bad: Stateful utility
   class DateUtils {
     DateTime _cachedDate = DateTime.now();  // State!
   }
   ```

---

## Quick Reference

| File | Purpose | Key Items |
|------|---------|-----------|
| **routes.dart** | Navigation | Route names, route map, navigation helpers |
| **date_utils.dart** | Date formatting | formattedHeaderDate, formatShortDate, isOverdue |
| **app_localizations.dart** | Translations | Translate function, getter methods, translation maps |
| **language.dart** | Language definitions | Language model, supported languages |
| **constants.dart** | App constants | App info, limits, colors, strings |

---

## For Beginners: When to Create Utils

Create a utility when:
- ✅ You use the same code in 3+ places
- ✅ The code is a pure function (no side effects)
- ✅ It's a general-purpose helper
- ✅ It doesn't fit in models, services, or providers

Don't create a utility when:
- ❌ It's business logic (use service or provider)
- ❌ It's UI code (use widget)
- ❌ It's only used in one place
- ❌ It needs state management

---

## Next Steps

Now that you understand utils, check out:
- 🎨 [theme/ - App Theming](./theme.md) - Visual styling
- 🏗️ [Architecture](./architecture.md) - See how everything connects

---

**Utils are your productivity boosters! ⚡**
