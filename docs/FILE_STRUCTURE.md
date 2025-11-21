# 📁 DayFlow File Structure Documentation

This document provides a complete file-by-file explanation of the DayFlow project. Each file's purpose, key components, and relationships are explained in beginner-friendly terms.

## Table of Contents
- [Root Files](#root-files)
- [lib/models/](#libmodels)
- [lib/providers/](#libproviders)
- [lib/services/](#libservices)
- [lib/pages/](#libpages)
- [lib/widgets/](#libwidgets)
- [lib/utils/](#libutils)
- [lib/theme/](#libtheme)

---

## Root Files

### `lib/main.dart`
**Purpose**: The entry point of the Flutter application

**What it does**:
- Initializes Firebase connection
- Sets up all providers (state management)
- Configures localization (multi-language support)
- Initializes analytics (Mixpanel)
- Sets up theme (light/dark mode)
- Defines the authentication checker

**Key Components**:
- `main()`: App startup function
- `DayFlowApp`: Root widget with providers
- `AuthChecker`: Determines if user is logged in
- `SplashScreen`: Loading screen shown during checks

**Key Code**:
```dart
void main() async {
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Load saved language
  final languageProvider = LanguageProvider();
  await languageProvider.loadSavedLanguage();
  
  // Initialize analytics
  final analyticsProvider = AnalyticsProvider();
  await analyticsProvider.initialize('TOKEN');
  
  runApp(DayFlowApp(...));
}
```

**Beginner Notes**:
- This file runs first when the app starts
- It's like the "main entrance" to the app
- All the setup work happens here before users see anything

---

## lib/models/

Models define the structure of data in the app. Think of them as "blueprints" for objects.

### `task_model.dart`
**Purpose**: Defines what a Task looks like

**Properties**:
- `id`: Unique identifier
- `title`: Task name (e.g., "Buy groceries")
- `description`: Optional details
- `isCompleted`: Whether task is done
- `createdAt`: When task was created
- `dueDate`: When task is due (optional)
- `priority`: How important (none, low, medium, high)
- `tags`: Labels for categorization
- `subtasks`: Smaller tasks within the main task

**Key Methods**:
- `toJson()`: Convert task to JSON (for saving)
- `fromJson()`: Create task from JSON (for loading)
- `toFirestore()`: Convert for Firestore database
- `fromFirestore()`: Create from Firestore data
- `copyWith()`: Create modified copy of task

**Computed Properties**:
- `isOverdue`: Is task past due date?
- `isDueToday`: Is task due today?
- `daysRemaining`: How many days until due?
- `completedSubtasks`: How many subtasks are done?

**Enums**:
- `TaskPriority`: none, low, medium, high
- `TaskFilter`: all, completed, pending, overdue, today
- `TaskSort`: dateCreated, dueDate, priority, alphabetical

**Beginner Example**:
```dart
// Create a new task
final task = Task(
  id: '123',
  title: 'Buy milk',
  description: 'Get 2 liters of milk',
  isCompleted: false,
  createdAt: DateTime.now(),
  dueDate: DateTime.now().add(Duration(days: 1)),
  priority: TaskPriority.high,
);

// Check if overdue
if (task.isOverdue) {
  print('Task is overdue!');
}
```

---

### `habit_model.dart`
**Purpose**: Defines what a Habit looks like

**Properties**:
- `id`: Unique identifier
- `name`: Habit name (e.g., "Exercise")
- `description`: Optional details
- `icon`: Emoji or icon name
- `frequency`: How often (daily, weekly, custom)
- `goalCount`: Target completions (e.g., 7 times per week)
- `linkedTaskTags`: Auto-complete from tasks with these tags
- `completionHistory`: Map of dates to completion status
- `createdAt`: When habit was created
- `color`: Display color

**Key Methods**:
- `toJson()`: Convert habit to JSON
- `fromJson()`: Create habit from JSON
- `toFirestore()`: Convert for Firestore
- `fromFirestore()`: Create from Firestore data
- `copyWith()`: Create modified copy

**Computed Properties**:
- `isCompletedToday`: Did user complete today?
- `currentStreak`: Consecutive days completed
- `longestStreak`: Best streak ever
- `thisWeekCompletions`: Completions this week
- `totalCompletions`: All-time completions
- `getCompletionRate(days)`: Success rate over N days

**Beginner Example**:
```dart
// Create a habit
final habit = Habit(
  id: '456',
  name: 'Morning Run',
  icon: '🏃',
  frequency: HabitFrequency.daily,
  goalCount: 7,
  createdAt: DateTime.now(),
  color: Colors.blue,
);

// Check streak
print('Current streak: ${habit.currentStreak} days');
```

---

### `note_model.dart`
**Purpose**: Defines what a Note looks like

**Properties**:
- `id`: Unique identifier
- `title`: Note title
- `content`: Note body text
- `createdAt`: When note was created
- `updatedAt`: Last modification time
- `tags`: Categories/labels
- `isPinned`: Is note pinned to top?

**Key Methods**:
- `toJson()`: Convert note to JSON
- `fromJson()`: Create note from JSON

---

## lib/providers/

Providers manage state and business logic. They notify the UI when data changes.

### `tasks_provider.dart`
**Purpose**: Manages all task-related operations

**What it manages**:
- List of all tasks
- Loading state
- Error messages
- Current filter (all, completed, etc.)
- Current sort order

**Key Methods**:
- `loadTasks()`: Fetch tasks from Firestore
- `addTask(task)`: Create new task
- `updateTask(task)`: Update existing task
- `toggleTaskCompletion(taskId)`: Mark complete/incomplete
- `deleteTask(taskId)`: Remove task
- `setFilter(filter)`: Change task filter
- `setSort(sort)`: Change sort order

**Computed Properties**:
- `tasks`: Filtered and sorted task list
- `totalTasks`: Total number of tasks
- `completedTasks`: Number of completed tasks
- `pendingTasks`: Number of pending tasks
- `overdueTasks`: Number of overdue tasks

**How it works**:
1. UI calls a method (e.g., `addTask`)
2. Provider updates Firestore
3. Provider updates local state
4. Provider calls `notifyListeners()`
5. UI rebuilds automatically

**Beginner Example**:
```dart
// In a widget
final provider = Provider.of<TasksProvider>(context, listen: false);

// Add a task
await provider.addTask(newTask);

// Listen to changes
Consumer<TasksProvider>(
  builder: (context, provider, child) {
    if (provider.isLoading) {
      return CircularProgressIndicator();
    }
    return ListView.builder(
      itemCount: provider.tasks.length,
      itemBuilder: (context, index) {
        return Text(provider.tasks[index].title);
      },
    );
  },
)
```

---

### `habits_provider.dart`
**Purpose**: Manages all habit-related operations

**What it manages**:
- List of all habits
- Loading state
- Error messages

**Key Methods**:
- `loadHabits()`: Fetch habits from Firestore
- `addHabit(habit)`: Create new habit (tracks analytics)
- `updateHabit(habit)`: Update existing habit
- `toggleHabitCompletion(habitId)`: Mark done for today
- `deleteHabit(habitId)`: Remove habit
- `getHabitById(habitId)`: Find specific habit

**Computed Properties**:
- `habits`: List of all habits
- `totalHabits`: Total number of habits
- `completedToday`: Habits completed today
- `activeStreaks`: Habits with active streaks

**Analytics Integration**:
- Automatically tracks habit creation in Mixpanel
- No additional code needed in UI

---

### `auth_provider.dart`
**Purpose**: Manages user authentication

**What it manages**:
- Current user
- Loading state
- Error messages

**Key Methods**:
- `signInWithEmail(email, password)`: Login with email
- `signInWithGoogle()`: Login with Google
- `registerWithEmail(email, password)`: Sign up
- `signOut()`: Logout
- `resetPassword(email)`: Send password reset email
- `reloadUser()`: Refresh user data
- `clearError()`: Clear error message

**Computed Properties**:
- `isAuthenticated`: Is user logged in?
- `isEmailVerified`: Is user's email verified?

**How it works**:
1. UI calls authentication method
2. Provider communicates with Firebase Auth
3. If successful, tracks login in Mixpanel
4. Updates user state
5. Notifies UI

**Beginner Example**:
```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);

// Login
final success = await authProvider.signInWithEmail(
  'user@example.com',
  'password123',
);

if (success) {
  // Navigate to home
  Navigator.pushReplacementNamed(context, Routes.home);
} else {
  // Show error
  showDialog(context, authProvider.error);
}
```

---

### `analytics_provider.dart`
**Purpose**: Manages Mixpanel analytics tracking

**What it manages**:
- Analytics initialization state
- Mixpanel service instance

**Key Methods**:
- `initialize(token)`: Set up Mixpanel with project token
- `trackLogin(...)`: Track user login
- `trackTaskCompleted(...)`: Track task completion
- `trackHabitCreated(...)`: Track habit creation
- `trackPageView(...)`: Track page navigation
- `identifyUser(...)`: Set user properties
- `reset()`: Clear user on logout

**Beginner Notes**:
- This is a wrapper around MixpanelService
- Makes analytics available via Provider pattern
- Tracks events automatically in other providers

---

### `language_provider.dart`
**Purpose**: Manages app language settings

**What it manages**:
- Current locale (language)
- Language preferences

**Key Methods**:
- `changeLanguage(languageCode)`: Switch language
- `loadSavedLanguage()`: Load saved preference

**Supported Languages**:
- English (en)
- French (fr)
- Arabic (ar)

**Computed Properties**:
- `locale`: Current Locale object
- `isRTL`: Is current language right-to-left?

**Beginner Example**:
```dart
final langProvider = Provider.of<LanguageProvider>(context);

// Change to French
await langProvider.changeLanguage('fr');

// Check RTL
if (langProvider.isRTL) {
  // Show RTL layout
}
```

---

## lib/services/

Services handle external integrations and complex operations.

### `firebase_auth_service.dart`
**Purpose**: Handles Firebase Authentication operations

**Key Methods**:
- `signInWithEmail(email, password)`: Email login
- `signInWithGoogle()`: Google OAuth login
- `signUpWithEmail(email, password, name)`: Create account
- `signOut()`: Logout
- `sendPasswordResetEmail(email)`: Password reset
- `sendEmailVerification()`: Send verification email
- `reloadUser()`: Refresh user data

**Error Handling**:
- Catches Firebase exceptions
- Returns user-friendly error messages
- Handles network errors

**Beginner Notes**:
- This is a wrapper around Firebase Auth SDK
- Makes authentication easier to use
- Handles common error cases

---

### `mixpanel_service.dart`
**Purpose**: Handles Mixpanel analytics integration

**Implementation**: Singleton pattern (one instance app-wide)

**Key Methods**:
- `initialize(token)`: Set up Mixpanel
- `trackLogin(...)`: Track login event
- `trackTaskCompleted(...)`: Track task completion
- `trackHabitCreated(...)`: Track habit creation
- `trackPageView(page)`: Track navigation
- `identifyUser(userId, email)`: Set user profile
- `trackEvent(name, properties)`: Track custom event
- `reset()`: Clear user data

**Event Properties**:
- Automatically includes timestamp
- Adds custom properties for each event
- Sets user properties for segmentation

**Beginner Example**:
```dart
// Initialize once in main.dart
await MixpanelService.instance.initialize('YOUR_TOKEN');

// Track events anywhere
MixpanelService.instance.trackTaskCompleted(
  taskId: '123',
  taskTitle: 'Buy milk',
  priority: 'high',
);
```

---

### `task_service.dart`
**Purpose**: Legacy task operations (kept for backward compatibility)

**Status**: Being phased out in favor of TasksProvider

**Note**: New code should use TasksProvider instead

---

### `habit_service.dart`
**Purpose**: Legacy habit operations (kept for backward compatibility)

**Status**: Being phased out in favor of HabitsProvider

**Note**: New code should use HabitsProvider instead

---

### `local_storage.dart`
**Purpose**: Wrapper around SharedPreferences for local storage

**Status**: Currently empty/placeholder

**Potential Use**:
- Storing user preferences
- Caching data
- Offline support

---

## lib/pages/

Pages are full-screen widgets that represent different screens in the app.

### `welcome_page.dart`
**Purpose**: Landing page shown to non-authenticated users

**Features**:
- App logo and name
- "Get Started" button
- Navigates to login/signup

**When Shown**: When user is not logged in

---

### `todo_page.dart`
**Purpose**: Main task management screen

**Features**:
- List of tasks
- Add new task button
- Task filtering (all, completed, pending, etc.)
- Task sorting options
- Mark tasks as complete
- Edit/delete tasks

**State Management**: Uses TasksProvider

**Beginner Example Flow**:
1. User opens app
2. Provider loads tasks from Firestore
3. Tasks display in list
4. User taps checkbox
5. Provider toggles completion
6. Firestore updates
7. UI updates automatically

---

### `habits_page.dart`
**Purpose**: Habit tracking screen

**Features**:
- Grid/list of habits
- Add new habit button
- Mark habit as done for today
- View streaks
- Edit/delete habits
- View habit details

**State Management**: Uses HabitsProvider

---

### `notes_page.dart`
**Purpose**: Note-taking screen

**Features**:
- List of notes
- Add new note button
- Search/filter notes
- Edit/delete notes
- Pin important notes

---

### `reminders_page.dart`
**Purpose**: Reminders and notifications

**Features**:
- List of reminders
- Add reminder button
- Schedule notifications
- Edit/delete reminders

---

### `settings_page.dart`
**Purpose**: App settings and user profile

**Features**:
- Change language
- Toggle dark mode
- User profile info
- Logout button
- Privacy settings
- Help & support links
- About app

**Navigation to Sub-pages**:
- Privacy & Backup
- Help & Support
- Terms & Privacy

---

### `auth/login_page.dart`
**Purpose**: User login screen

**Features**:
- Email input field
- Password input field
- Login button
- "Forgot Password" link
- "Sign Up" link
- Google Sign-In button

**State Management**: Uses AuthProvider

**Flow**:
1. User enters credentials
2. User taps login button
3. AuthProvider validates with Firebase
4. If successful, tracks analytics
5. Navigates to home
6. If failed, shows error

---

### `auth/signup_page.dart`
**Purpose**: New user registration

**Features**:
- Full name input
- Email input
- Password input
- Confirm password input
- Sign up button
- Terms & conditions agreement
- Back to login link

**Validation**:
- Email format check
- Password strength check
- Password match check

---

### `auth/forgot_password_page.dart`
**Purpose**: Password reset flow

**Features**:
- Email input
- Send reset link button
- Back to login button

**Flow**:
1. User enters email
2. Firebase sends reset email
3. User clicks link in email
4. Firebase opens reset form
5. User creates new password

---

### `auth/email_verification_page.dart`
**Purpose**: Email verification waiting screen

**Features**:
- Instructions to check email
- Resend verification button
- Refresh/check verification button
- Sign out button

**Flow**:
1. User signs up
2. Firebase sends verification email
3. App shows this screen
4. User clicks link in email
5. User taps "Check Verification"
6. If verified, proceeds to home

---

### `onboarding/onboarding_page.dart`
**Purpose**: First-time user experience

**Features**:
- Welcome slides
- Feature highlights
- Get started button

**When Shown**: First time user opens app after signup

---

### `onboarding/question_flow_page.dart`
**Purpose**: Interactive onboarding with questions

**Features**:
- Personalization questions
- Multiple choice answers
- Progress indicators
- Mascot/character guidance

---

## lib/widgets/

Reusable UI components used across multiple screens.

### `bottom_nav_bar.dart`
**Purpose**: Bottom navigation bar for main screens

**Features**:
- 5 navigation tabs
- Icons for each tab
- Active tab highlighting
- Navigation between screens

**Tabs**:
1. To-Do (tasks)
2. Habits
3. Notes
4. Reminders
5. Settings

**Implementation**: `MainNavigationShell` widget

---

### `task_card.dart`
**Purpose**: Display a single task in a list

**Features**:
- Task title
- Task description
- Completion checkbox
- Priority indicator
- Due date display
- Tap to view details

**Properties Accepted**:
- `task`: Task object to display
- `onTap`: Callback when tapped
- `onToggle`: Callback when checkbox tapped

---

### `habit_card.dart`
**Purpose**: Display a single habit

**Features**:
- Habit icon
- Habit name
- Current streak
- Completion button
- Color indicator

---

### `custom_button.dart`
**Purpose**: Styled button used throughout app

**Features**:
- Consistent styling
- Loading state
- Disabled state
- Primary/secondary variants

---

### `custom_input.dart`
**Purpose**: Styled text input field

**Features**:
- Consistent styling
- Validation support
- Error message display
- Password visibility toggle

---

### `app_drawer.dart`
**Purpose**: Side navigation drawer

**Features**:
- User profile display
- Navigation menu
- App version info

---

## lib/utils/

Utility functions and configurations.

### `routes.dart`
**Purpose**: Centralized route definitions

**Content**:
- Route name constants
- Route map for Navigator
- Helper navigation methods

**Example**:
```dart
class Routes {
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String login = '/login';
  // ...
  
  static void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, home);
  }
}
```

---

### `constants.dart`
**Purpose**: App-wide constant values

**Potential Content**:
- API endpoints
- Default values
- Configuration settings
- Color codes

---

### `date_utils.dart`
**Purpose**: Date formatting and manipulation helpers

**Example Functions**:
- Format date for display
- Calculate days between dates
- Check if date is today/tomorrow
- Get week start/end dates

---

### `app_localizations.dart`
**Purpose**: Implements multi-language support

**Features**:
- Translation maps for 3 languages
- Convenience getters for strings
- Locale switching support

**Structure**:
```dart
class AppLocalizations {
  // Translation maps
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {...},
    'fr': {...},
    'ar': {...},
  };
  
  // Getters
  String get appName => translate('app_name');
  String get welcome => translate('welcome');
}
```

**Usage**:
```dart
final l10n = AppLocalizations.of(context);
Text(l10n.welcome);  // Shows translated text
```

---

### `language.dart`
**Purpose**: Language model and definitions

**Content**:
- Language class
- Supported languages list
- Language metadata

---

## lib/theme/

Theme definitions for the app.

### `app_theme.dart`
**Purpose**: Defines light and dark themes

**Features**:
- Color schemes
- Text styles
- Component themes
- ThemeProvider for switching

**Theme Components**:
- Primary color
- Secondary color
- Background colors
- Text colors
- Button styles
- Input field styles
- Card styles

**Usage**:
```dart
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.amber,
    ),
    // ... more theme properties
  );
  
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    // ... dark theme properties
  );
}
```

---

## Summary

### File Organization Pattern

```
Data Flow:
UI (pages) 
  ↓ reads from
Providers (state management)
  ↓ uses
Services (external APIs)
  ↓ transforms
Models (data structure)
```

### Key Principles

1. **Separation of Concerns**: Each file has a single responsibility
2. **Reusability**: Widgets and utilities are shared
3. **Maintainability**: Clear structure makes updates easy
4. **Testability**: Components can be tested independently

### For Beginners

- **Start with models**: Understand what data looks like
- **Then providers**: Learn how data is managed
- **Then pages**: See how UI uses data
- **Finally widgets**: Build reusable components

Each file is a building block. Together they create the complete DayFlow application!
