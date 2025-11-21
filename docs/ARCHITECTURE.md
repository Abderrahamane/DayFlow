# 🏗️ DayFlow Architecture Documentation

## Table of Contents
- [Overview](#overview)
- [High-Level Architecture](#high-level-architecture)
- [Project Structure](#project-structure)
- [State Management](#state-management)
- [Navigation Flow](#navigation-flow)
- [Database Integration](#database-integration)
- [Authentication Flow](#authentication-flow)
- [Localization System](#localization-system)
- [Analytics Integration](#analytics-integration)

---

## Overview

DayFlow is a productivity Flutter application that helps users manage their daily tasks, build habits, take notes, and set reminders. The app follows clean architecture principles with clear separation of concerns.

### Tech Stack
- **Frontend**: Flutter (Dart)
- **State Management**: Provider pattern
- **Backend**: Firebase (Authentication, Firestore)
- **Analytics**: Mixpanel
- **Database**: Cloud Firestore (NoSQL cloud database)
- **Authentication**: Firebase Auth with email/password and Google Sign-In
- **Localization**: flutter_localizations with custom AppLocalizations

---

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         DayFlow Application                          │
│                                                                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    Presentation Layer                        │   │
│  │  (Screens, Widgets, UI Components)                          │   │
│  │                                                              │   │
│  │  • Welcome Page        • To-Do Page       • Notes Page      │   │
│  │  • Habits Page         • Reminders Page   • Settings Page   │   │
│  │  • Auth Pages          • Onboarding       • Profile         │   │
│  └────────────────┬────────────────────────────────────────────┘   │
│                   │                                                  │
│  ┌────────────────▼──────────────────────────────────────────┐     │
│  │                    Business Logic Layer                    │     │
│  │  (Providers - State Management)                           │     │
│  │                                                            │     │
│  │  • TasksProvider      • HabitsProvider                    │     │
│  │  • AuthProvider       • AnalyticsProvider                 │     │
│  │  • LanguageProvider   • ThemeProvider                     │     │
│  └────────────────┬──────────────────────────────────────────┘     │
│                   │                                                  │
│  ┌────────────────▼──────────────────────────────────────────┐     │
│  │                     Service Layer                          │     │
│  │  (Services - External Integrations)                       │     │
│  │                                                            │     │
│  │  • FirebaseAuthService    • MixpanelService               │     │
│  │  • TaskService            • HabitService                  │     │
│  │  • LocalStorage                                           │     │
│  └────────────────┬──────────────────────────────────────────┘     │
│                   │                                                  │
│  ┌────────────────▼──────────────────────────────────────────┐     │
│  │                      Data Layer                            │     │
│  │  (Models & Data Sources)                                  │     │
│  │                                                            │     │
│  │  • Task Model         • Habit Model                       │     │
│  │  • Note Model         • User Model                        │     │
│  └────────────────┬──────────────────────────────────────────┘     │
│                   │                                                  │
└───────────────────┼──────────────────────────────────────────────┘
                    │
    ┌───────────────▼────────────────────┐
    │     External Services              │
    ├────────────────────────────────────┤
    │  • Firebase Authentication         │
    │  • Cloud Firestore (Database)      │
    │  • Mixpanel Analytics              │
    │  • Google Sign-In                  │
    └────────────────────────────────────┘
```

---

## Project Structure

The project follows a feature-based organization with clear separation of concerns:

```
lib/
├── main.dart                    # App entry point, provider setup
│
├── models/                      # Data models
│   ├── task_model.dart         # Task entity with priority, subtasks
│   ├── habit_model.dart        # Habit entity with streak tracking
│   └── note_model.dart         # Note entity
│
├── providers/                   # State management (Provider pattern)
│   ├── tasks_provider.dart     # Manages task state + Firestore
│   ├── habits_provider.dart    # Manages habit state + Firestore
│   ├── auth_provider.dart      # Authentication state
│   ├── analytics_provider.dart # Analytics tracking state
│   └── language_provider.dart  # Localization state
│
├── services/                    # Business logic & external APIs
│   ├── firebase_auth_service.dart  # Firebase authentication
│   ├── task_service.dart           # Task operations (legacy)
│   ├── habit_service.dart          # Habit operations (legacy)
│   ├── mixpanel_service.dart       # Analytics tracking
│   └── local_storage.dart          # SharedPreferences wrapper
│
├── pages/                       # Screen widgets
│   ├── welcome_page.dart       # Landing/splash screen
│   ├── todo_page.dart          # Task management screen
│   ├── habits_page.dart        # Habit tracking screen
│   ├── notes_page.dart         # Notes screen
│   ├── reminders_page.dart     # Reminders screen
│   ├── settings_page.dart      # Settings & profile
│   ├── auth/                   # Authentication screens
│   │   ├── login_page.dart
│   │   ├── signup_page.dart
│   │   ├── forgot_password_page.dart
│   │   └── email_verification_page.dart
│   └── onboarding/             # First-time user experience
│       ├── onboarding_page.dart
│       └── question_flow_page.dart
│
├── widgets/                     # Reusable UI components
│   ├── bottom_nav_bar.dart     # Bottom navigation
│   ├── task_card.dart          # Task display widget
│   ├── habit_card.dart         # Habit display widget
│   ├── custom_button.dart      # Styled buttons
│   ├── custom_input.dart       # Styled text fields
│   └── app_drawer.dart         # Navigation drawer
│
├── utils/                       # Utilities & helpers
│   ├── routes.dart             # Named route definitions
│   ├── constants.dart          # App-wide constants
│   ├── date_utils.dart         # Date formatting helpers
│   ├── app_localizations.dart  # Localization implementation
│   └── language.dart           # Language definitions
│
└── theme/                       # Theming
    └── app_theme.dart          # Light & dark theme definitions
```

### Folder Responsibilities

#### 📁 **models/**
Contains data classes that represent the core entities in the application. Each model:
- Defines the structure of data
- Includes serialization/deserialization methods (toJson, fromJson)
- Includes Firestore-specific methods (toFirestore, fromFirestore)
- Contains computed properties (e.g., `isOverdue`, `currentStreak`)

#### 📁 **providers/**
Implements the Provider pattern for state management. Each provider:
- Extends `ChangeNotifier` to notify UI of changes
- Manages a specific domain (tasks, habits, auth)
- Handles loading states and error handling
- Interacts with services and Firestore
- Provides computed values (e.g., statistics, filtered lists)

#### 📁 **services/**
Contains business logic and external API integrations. Services:
- Encapsulate complex operations
- Interface with external systems (Firebase, Mixpanel)
- Can be used by providers or directly in widgets
- Handle error handling and data transformation

#### 📁 **pages/**
Screen-level widgets that represent full pages. Pages:
- Use providers to access state
- Implement UI layout and navigation
- Handle user interactions
- Delegate business logic to providers

#### 📁 **widgets/**
Reusable UI components. Widgets:
- Accept data via constructor parameters
- Emit events via callbacks
- Are stateless when possible
- Follow the single responsibility principle

#### 📁 **utils/**
Helper functions and configurations:
- Routes: Navigation configuration
- Constants: App-wide values
- Localizations: Multi-language support
- Date utilities: Date formatting helpers

---

## State Management

### Provider Pattern Implementation

DayFlow uses the **Provider pattern** for state management (not Cubit/BLoC). This is simpler and more beginner-friendly.

#### Why Provider?
- ✅ Easy to understand for beginners
- ✅ Built-in to Flutter ecosystem
- ✅ Good performance with `ChangeNotifier`
- ✅ Works well with Firestore streams
- ✅ Less boilerplate than BLoC

#### Key Providers

##### 1. TasksProvider
**Purpose**: Manages all task-related state

**Key Features**:
- CRUD operations for tasks
- Filtering (all, completed, pending, overdue, today)
- Sorting (by date, priority, alphabetical)
- Real-time sync with Firestore
- Statistics (total, completed, pending)

**Usage Example**:
```dart
// In a widget
Consumer<TasksProvider>(
  builder: (context, provider, child) {
    return ListView.builder(
      itemCount: provider.tasks.length,
      itemBuilder: (context, index) {
        return TaskCard(task: provider.tasks[index]);
      },
    );
  },
)

// To modify state
final provider = Provider.of<TasksProvider>(context, listen: false);
await provider.addTask(newTask);
```

##### 2. HabitsProvider
**Purpose**: Manages habit tracking

**Key Features**:
- CRUD operations for habits
- Completion tracking with history
- Streak calculations
- Firestore integration
- Analytics tracking on creation

**Usage Example**:
```dart
Consumer<HabitsProvider>(
  builder: (context, provider, child) {
    return GridView.builder(
      itemCount: provider.habits.length,
      itemBuilder: (context, index) {
        return HabitCard(habit: provider.habits[index]);
      },
    );
  },
)
```

##### 3. AuthProvider
**Purpose**: Manages authentication state

**Key Features**:
- Email/password authentication
- Google Sign-In
- User registration
- Password reset
- Email verification
- Automatic analytics tracking

**Usage Example**:
```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
final success = await authProvider.signInWithEmail(email, password);

if (success) {
  Navigator.pushReplacementNamed(context, Routes.home);
}
```

##### 4. AnalyticsProvider
**Purpose**: Manages Mixpanel analytics

**Key Features**:
- Event tracking
- User identification
- Page view tracking
- Custom properties

##### 5. LanguageProvider
**Purpose**: Manages app language

**Key Features**:
- Language selection (English, French, Arabic)
- RTL support for Arabic
- Persists language choice
- Updates app-wide

##### 6. ThemeProvider
**Purpose**: Manages light/dark mode

**Key Features**:
- Theme switching
- Persists user preference

---

## Navigation Flow

### Route Structure

DayFlow uses **named routes** for navigation, defined in `lib/utils/routes.dart`.

```dart
class Routes {
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String todo = '/todo';
  static const String habits = '/habits';
  static const String notes = '/notes';
  static const String reminders = '/reminders';
  static const String settings = '/settings';
  static const String login = '/login';
  static const String signup = '/signup';
  // ... more routes
}
```

### Navigation Hierarchy

```
App Launch (AuthChecker)
    ├─── Not Authenticated ──→ Welcome Page
    │                             ├── Login Page
    │                             └── Signup Page
    │
    └─── Authenticated ──────→ Home (MainNavigationShell)
                                  ├── To-Do Page (Bottom Nav)
                                  ├── Habits Page (Bottom Nav)
                                  ├── Notes Page (Bottom Nav)
                                  ├── Reminders Page (Bottom Nav)
                                  └── Settings Page (Bottom Nav)
                                      ├── Privacy & Backup
                                      ├── Help & Support
                                      └── Terms & Privacy
```

### Authentication Flow

```
1. App starts → AuthChecker widget
2. Checks Firebase auth state
3. If not logged in → Navigate to Welcome
4. If logged in but email not verified → Email Verification Page
5. If logged in and verified → Navigate to Home
```

### Bottom Navigation

The `MainNavigationShell` widget (in `widgets/bottom_nav_bar.dart`) provides persistent bottom navigation between main screens:
- To-Do (tasks)
- Habits
- Notes
- Reminders
- Settings

---

## Database Integration

### ⚠️ Important Note on Database

**Current Implementation**: DayFlow uses **Cloud Firestore** (Firebase's NoSQL cloud database), not a local relational database like SQLite, sqflite, drift, or ObjectBox.

### Firestore Structure

```
users (collection)
  └── {userId} (document)
      ├── tasks (subcollection)
      │   └── {taskId} (document)
      │       ├── title: string
      │       ├── description: string
      │       ├── isCompleted: boolean
      │       ├── createdAt: timestamp
      │       ├── dueDate: timestamp
      │       ├── priority: string
      │       └── tags: array
      │
      └── habits (subcollection)
          └── {habitId} (document)
              ├── name: string
              ├── icon: string
              ├── frequency: string
              ├── goalCount: number
              ├── completionHistory: map
              └── createdAt: timestamp
```

### Data Access Pattern

All Firestore operations go through **Providers**:

1. **Provider** receives request from UI
2. **Provider** performs Firestore operation
3. **Provider** updates local state
4. **Provider** notifies listeners
5. **UI** rebuilds automatically

**Example**:
```dart
// TasksProvider
Future<void> addTask(Task task) async {
  // 1. Save to Firestore
  final docRef = await _firestore
      .collection('users')
      .doc(userId)
      .collection('tasks')
      .add(task.toFirestore());
  
  // 2. Update local state
  _tasks.add(task.copyWith(id: docRef.id));
  
  // 3. Notify UI
  notifyListeners();
}
```

### Why Cloud Database Instead of Local?

**Advantages**:
- ✅ Real-time synchronization across devices
- ✅ Automatic backup
- ✅ No need to implement sync logic
- ✅ Scales automatically
- ✅ Built-in security rules

**Disadvantages**:
- ❌ Requires internet connection
- ❌ Not a relational database
- ❌ More complex queries can be expensive

### Offline Support

Firestore provides automatic offline persistence:
- Data is cached locally
- Works offline automatically
- Syncs when connection restored
- No additional code needed

---

## Authentication Flow

### Firebase Authentication

DayFlow uses **Firebase Authentication** with two methods:
1. Email/Password
2. Google Sign-In

### Authentication Flow Diagram

```
┌─────────────┐
│  App Start  │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│  AuthChecker    │  (Checks Firebase auth state)
└────┬────────┬───┘
     │        │
     │        └──── Not Logged In ─────┐
     │                                  │
     └──── Logged In                    ▼
            │                    ┌──────────────┐
            │                    │ Welcome Page │
            ▼                    └──────┬───────┘
     ┌──────────────┐                  │
     │ Email         │                  ▼
     │ Verified?     │           ┌─────────────┐
     └─┬────────┬───┘            │ Login Page  │
       │        │                └──────┬──────┘
       NO      YES                      │
       │        │                       ▼
       ▼        ▼              ┌────────────────┐
┌──────────┐  ┌──────┐         │ AuthProvider   │
│  Email   │  │ Home │         │ .signInWith    │
│ Verify   │  │ Page │         │    Email()     │
│  Page    │  │      │         └────────┬───────┘
└──────────┘  └──────┘                  │
                                        ▼
                              ┌──────────────────┐
                              │ Firebase Auth    │
                              │ Validates        │
                              └────────┬─────────┘
                                       │
                                       ▼
                              ┌──────────────────┐
                              │ Mixpanel         │
                              │ Track Login      │
                              └────────┬─────────┘
                                       │
                                       ▼
                              ┌──────────────────┐
                              │ Navigate to Home │
                              └──────────────────┘
```

### Email Verification

Firebase requires email verification:
1. User signs up
2. Firebase sends verification email
3. App shows "Verify Email" screen
4. User clicks link in email
5. App detects verification and proceeds

---

## Localization System

### Supported Languages

DayFlow supports **3 languages**:
- 🇬🇧 English (en)
- 🇫🇷 French (fr)
- 🇸🇦 Arabic (ar) - with RTL support

### Implementation

Localization is implemented in `lib/utils/app_localizations.dart`:

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
  
  // Convenience getters
  String get appName => translate('app_name');
  String get welcome => translate('welcome');
  // ... more translations
}
```

### RTL Support

Arabic uses **Right-to-Left** layout:

```dart
// In main.dart
builder: (context, child) {
  return Directionality(
    textDirection: langProvider.isRTL
        ? TextDirection.rtl
        : TextDirection.ltr,
    child: child!,
  );
}
```

### Using Translations

```dart
// In any widget
final l10n = AppLocalizations.of(context);

Text(l10n.welcome);  // Shows "Welcome" or "Bienvenue" or "مرحبا"
```

### Changing Language

```dart
final langProvider = Provider.of<LanguageProvider>(context);
await langProvider.changeLanguage('fr');  // Switch to French
```

---

## Analytics Integration

### Mixpanel Analytics

DayFlow uses **Mixpanel** for user analytics and event tracking.

### What Gets Tracked?

1. **User Login**: When user signs in
2. **Task Completed**: When user marks task as done
3. **Habit Created**: When user creates a new habit
4. **Page Views**: When user navigates to different screens

### Analytics Flow

```
User Action (e.g., Complete Task)
    ↓
Provider Method (e.g., toggleTaskCompletion)
    ↓
Update Firestore
    ↓
MixpanelService.trackTaskCompleted()  ← Automatic
    ↓
Data sent to Mixpanel Dashboard
```

### Event Structure

**Example Event**:
```json
{
  "event": "User Completed Task",
  "properties": {
    "task_id": "abc123",
    "task_title": "Buy groceries",
    "priority": "high",
    "timestamp": "2024-01-20T10:30:00Z"
  }
}
```

### User Properties

When user logs in, profile is set:
```json
{
  "user_id": "firebase_uid",
  "email": "user@example.com",
  "login_provider": "email"
}
```

---

## Key Architectural Decisions

### ✅ What's Implemented Correctly

1. **✅ Good Project Structure**: Clear separation of concerns (models, providers, services, pages, widgets)
2. **✅ Localization**: Three languages with RTL support
3. **✅ Navigation**: Named routes with auth guards
4. **✅ Firebase Integration**: Authentication and Firestore
5. **✅ Analytics**: Mixpanel tracking
6. **✅ Theming**: Light and dark mode support

### ⚠️ Deviations from Original Requirements

1. **State Management**: Uses **Provider** instead of Cubit/BLoC
   - **Reason**: Simpler for beginners, less boilerplate
   - **Impact**: Easier to learn but less structured than BLoC

2. **Database**: Uses **Cloud Firestore** instead of local database (sqflite/drift/objectbox)
   - **Reason**: Real-time sync, no backend needed
   - **Impact**: Requires internet, but automatic sync and backup

### 📊 Comparison: Provider vs BLoC/Cubit

| Aspect | Provider (Current) | BLoC/Cubit |
|--------|-------------------|------------|
| Learning Curve | Easy | Moderate-Hard |
| Boilerplate | Low | High |
| Testing | Good | Excellent |
| Scalability | Good | Excellent |
| Community | Large | Large |
| Best For | Small-Medium Apps | Large Apps |

### 📊 Comparison: Firestore vs Local Database

| Aspect | Firestore (Current) | SQLite/Drift |
|--------|---------------------|--------------|
| Offline Support | Auto (cached) | Yes |
| Sync | Automatic | Manual |
| Setup | Easy | Moderate |
| Cost | Free tier limited | Free |
| Queries | Limited | Full SQL |
| Best For | Multi-device | Single device |

---

## Summary

DayFlow is a well-structured Flutter application that:
- ✅ Uses modern Flutter patterns (Provider for state management)
- ✅ Integrates with Firebase for auth and database
- ✅ Supports multiple languages with RTL
- ✅ Tracks user analytics
- ✅ Has clean separation of concerns
- ⚠️ Uses Provider instead of BLoC (simpler but different from requirements)
- ⚠️ Uses cloud database instead of local database (more features but requires internet)

The architecture is beginner-friendly, maintainable, and production-ready.
