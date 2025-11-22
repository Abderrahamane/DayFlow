# 🛠️ services/ Folder Documentation

## Overview

The `services/` folder contains all the code that **communicates with external systems** and handles **specialized operations**. Services act as bridges between your app and the outside world.

**Think of services as specialized workers**: Just like you might hire a plumber for plumbing or an electrician for electrical work, services handle specific technical tasks that require external expertise.

---

## What Are Services?

Services are classes that:
- Handle communication with external APIs (Firebase, Mixpanel, etc.)
- Manage data persistence (saving/loading data)
- Perform complex operations that don't belong in UI code
- Provide a clean interface for the rest of the app

**Key principle**: Services separate "how to do something" from "what to do with it". Providers manage state (what), services handle operations (how).

---

## Files in services/

```
services/
├── firebase_auth_service.dart  # Firebase authentication operations
├── auth_service.dart           # General authentication utilities
├── task_service.dart           # Task CRUD operations
├── habit_service.dart          # Habit CRUD operations
├── mixpanel_service.dart       # Analytics event tracking
└── local_storage.dart          # Local data persistence
```

---

## 🔥 firebase_auth_service.dart

**Purpose**: Handles all Firebase authentication operations (login, signup, logout, etc.)

### What It Does

This service manages user authentication using Firebase:
- Email/password authentication
- Google Sign-In
- Password reset
- Email verification
- User session management

### Key Methods

#### Sign In with Email/Password
```dart
Future<UserCredential?> signInWithEmail(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      throw 'No user found with this email';
    } else if (e.code == 'wrong-password') {
      throw 'Wrong password';
    }
    throw 'Login failed: ${e.message}';
  }
}
```

**What happens**:
1. Sends email/password to Firebase
2. Firebase checks if credentials are valid
3. Returns user info if successful
4. Throws error if failed

#### Sign Up (Create New Account)
```dart
Future<UserCredential?> signUpWithEmail(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Send verification email
    await credential.user?.sendEmailVerification();
    
    return credential;
  } catch (e) {
    throw 'Sign up failed: $e';
  }
}
```

**Flow**:
1. Create new user account in Firebase
2. Send verification email
3. Return user credentials

#### Sign In with Google
```dart
Future<UserCredential?> signInWithGoogle() async {
  try {
    // Trigger Google Sign-In flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    
    // Obtain auth details
    final GoogleSignInAuthentication? googleAuth = 
        await googleUser?.authentication;
    
    // Create Firebase credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    
    // Sign in to Firebase
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    throw 'Google sign in failed: $e';
  }
}
```

**Flow**:
1. Open Google Sign-In popup
2. User selects Google account
3. Get Google authentication tokens
4. Exchange tokens for Firebase credentials
5. Sign in to Firebase

#### Reset Password
```dart
Future<void> resetPassword(String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  } catch (e) {
    throw 'Password reset failed: $e';
  }
}
```

Sends a password reset email to the user.

#### Sign Out
```dart
Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();  // Also sign out of Google if used
}
```

#### Check Email Verification
```dart
bool isEmailVerified() {
  return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
}
```

#### Send Verification Email
```dart
Future<void> sendEmailVerification() async {
  await FirebaseAuth.instance.currentUser?.sendEmailVerification();
}
```

### Error Handling

The service catches Firebase-specific errors and converts them to user-friendly messages:

```dart
on FirebaseAuthException catch (e) {
  switch (e.code) {
    case 'user-not-found':
      return 'No user found with this email';
    case 'wrong-password':
      return 'Incorrect password';
    case 'email-already-in-use':
      return 'An account already exists with this email';
    case 'weak-password':
      return 'Password is too weak';
    case 'invalid-email':
      return 'Invalid email address';
    default:
      return 'Authentication error: ${e.message}';
  }
}
```

---

## 🔐 auth_service.dart

**Purpose**: Provides additional authentication utilities and helpers.

### What It Does

This service complements FirebaseAuthService with:
- Authentication state helpers
- User data validation
- Token management
- Session utilities

### Common Methods

#### Validate Email Format
```dart
bool isValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}
```

#### Validate Password Strength
```dart
bool isStrongPassword(String password) {
  // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
  return password.length >= 8 &&
         RegExp(r'[A-Z]').hasMatch(password) &&
         RegExp(r'[a-z]').hasMatch(password) &&
         RegExp(r'[0-9]').hasMatch(password);
}
```

#### Get Current User ID
```dart
String? getCurrentUserId() {
  return FirebaseAuth.instance.currentUser?.uid;
}
```

---

## ✅ task_service.dart

**Purpose**: Handles all task-related operations and business logic.

### What It Does

Manages task operations including:
- Creating tasks
- Updating tasks
- Deleting tasks
- Filtering and sorting
- Mock data for testing

### Key Features

#### Task Operations
```dart
class TaskService extends ChangeNotifier {
  final List<Task> _tasks = [];
  TaskFilter _currentFilter = TaskFilter.all;
  TaskSort _currentSort = TaskSort.dateCreated;
  
  // Getters
  List<Task> get tasks => _getFilteredAndSortedTasks();
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((t) => t.isCompleted).length;
  int get pendingTasks => _tasks.where((t) => !t.isCompleted).length;
  int get overdueTasks => _tasks.where((t) => t.isOverdue).length;
}
```

#### Add Task
```dart
void addTask(Task task) {
  _tasks.add(task);
  notifyListeners();  // Update UI
}
```

#### Update Task
```dart
void updateTask(String id, Task updatedTask) {
  final index = _tasks.indexWhere((t) => t.id == id);
  if (index != -1) {
    _tasks[index] = updatedTask;
    notifyListeners();
  }
}
```

#### Delete Task
```dart
void deleteTask(String id) {
  _tasks.removeWhere((t) => t.id == id);
  notifyListeners();
}
```

#### Toggle Task Completion
```dart
void toggleTaskCompletion(String id) {
  final task = _tasks.firstWhere((t) => t.id == id);
  final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
  updateTask(id, updatedTask);
  
  // Sync with habit if task has tags
  if (task.tags != null && task.tags!.isNotEmpty) {
    _syncWithHabits(task.tags!);
  }
}
```

#### Filter Tasks
```dart
void setFilter(TaskFilter filter) {
  _currentFilter = filter;
  notifyListeners();
}

List<Task> _getFilteredAndSortedTasks() {
  List<Task> filtered = [];
  
  switch (_currentFilter) {
    case TaskFilter.all:
      filtered = List.from(_tasks);
      break;
    case TaskFilter.completed:
      filtered = _tasks.where((t) => t.isCompleted).toList();
      break;
    case TaskFilter.pending:
      filtered = _tasks.where((t) => !t.isCompleted).toList();
      break;
    case TaskFilter.overdue:
      filtered = _tasks.where((t) => t.isOverdue).toList();
      break;
    case TaskFilter.today:
      final today = DateTime.now();
      filtered = _tasks.where((t) {
        if (t.dueDate == null) return false;
        return t.dueDate!.year == today.year &&
               t.dueDate!.month == today.month &&
               t.dueDate!.day == today.day;
      }).toList();
      break;
  }
  
  return _sortTasks(filtered);
}
```

#### Sort Tasks
```dart
List<Task> _sortTasks(List<Task> tasks) {
  switch (_currentSort) {
    case TaskSort.dateCreated:
      tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case TaskSort.dueDate:
      tasks.sort((a, b) {
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });
      break;
    case TaskSort.priority:
      tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
      break;
    case TaskSort.alphabetical:
      tasks.sort((a, b) => a.title.compareTo(b.title));
      break;
  }
  
  return tasks;
}
```

#### Link with Habit Service
```dart
void linkHabitService(HabitService habitService) {
  _habitService = habitService;
}

void _syncWithHabits(List<String> tags) {
  if (_habitService != null) {
    _habitService!.checkTaskCompletion(tags);
  }
}
```

This creates a powerful connection: when you complete a task with certain tags, related habits automatically get credit! 🎯

---

## 🎯 habit_service.dart

**Purpose**: Manages habit tracking operations and habit-task synchronization.

### What It Does

- Create and manage habits
- Track daily completions
- Calculate streaks and statistics
- Auto-complete habits based on task tags
- Provide habit analytics

### Key Methods

#### Add Habit
```dart
void addHabit(Habit habit) {
  _habits.add(habit);
  notifyListeners();
}
```

#### Mark Habit as Complete Today
```dart
void completeHabit(String habitId) {
  final habit = _habits.firstWhere((h) => h.id == habitId);
  final today = Habit.getDateKey(DateTime.now());
  
  final updatedHistory = Map<String, bool>.from(habit.completionHistory);
  updatedHistory[today] = true;
  
  final updatedHabit = habit.copyWith(completionHistory: updatedHistory);
  updateHabit(habitId, updatedHabit);
}
```

#### Check Task Completion for Auto-Habit
```dart
void checkTaskCompletion(List<String> taskTags) {
  for (final habit in _habits) {
    // Check if any task tags match habit's linked tags
    final hasMatchingTag = habit.linkedTaskTags.any(
      (tag) => taskTags.contains(tag)
    );
    
    if (hasMatchingTag && !habit.isCompletedToday) {
      completeHabit(habit.id);
    }
  }
}
```

**Example**:
- Habit "Exercise" has linkedTaskTags: `["workout", "gym"]`
- You complete a task with tag "workout"
- Habit automatically marks as completed for today! 🎉

#### Get Habit Statistics
```dart
Map<String, dynamic> getHabitStats(String habitId) {
  final habit = _habits.firstWhere((h) => h.id == habitId);
  
  return {
    'currentStreak': habit.currentStreak,
    'longestStreak': habit.longestStreak,
    'thisWeekCompletions': habit.thisWeekCompletions,
    'totalCompletions': habit.totalCompletions,
    'completionRate7Days': habit.getCompletionRate(7),
    'completionRate30Days': habit.getCompletionRate(30),
  };
}
```

---

## 📊 mixpanel_service.dart

**Purpose**: Tracks user analytics and behavior using Mixpanel.

### What It Does

Mixpanel helps you understand:
- What features users use most
- Where users have problems
- User engagement patterns
- Conversion funnels

### Initialization

```dart
static Future<void> init(String token) async {
  try {
    _mixpanel = await Mixpanel.init(
      token,
      trackAutomaticEvents: true,  // Auto-track app opens, sessions
    );
    debugPrint('✅ Mixpanel initialized successfully');
  } catch (e) {
    debugPrint('❌ Error initializing Mixpanel: $e');
  }
}
```

**Usage in main.dart**:
```dart
await MixpanelService.init('YOUR_MIXPANEL_TOKEN');
```

### Track Custom Events

```dart
void trackEvent(String eventName, [Map<String, dynamic>? properties]) {
  if (_mixpanel == null) return;
  
  _mixpanel!.track(eventName, properties: properties);
  debugPrint('📊 Event tracked: $eventName');
}
```

**Example usage**:
```dart
// Track task creation
MixpanelService.instance.trackEvent('Task Created', {
  'task_priority': 'high',
  'has_due_date': true,
  'has_subtasks': false,
  'tag_count': 2,
});

// Track habit completion
MixpanelService.instance.trackEvent('Habit Completed', {
  'habit_id': habit.id,
  'current_streak': habit.currentStreak,
  'frequency': habit.frequency.name,
});
```

### User Identification

```dart
void identifyUser(String userId, [Map<String, dynamic>? properties]) {
  if (_mixpanel == null) return;
  
  _mixpanel!.identify(userId);
  
  if (properties != null) {
    setUserProperties(properties);
  }
}
```

**Example**:
```dart
MixpanelService.instance.identifyUser('user123', {
  'email': 'user@example.com',
  'name': 'John Doe',
  'signup_date': DateTime.now().toIso8601String(),
  'plan': 'free',
});
```

### Set User Properties

```dart
void setUserProperties(Map<String, dynamic> properties) {
  if (_mixpanel == null) return;
  
  _mixpanel!.getPeople().set(properties);
}
```

### Common Tracked Events in DayFlow

```dart
// Authentication events
trackLogin(String userId, String method);
trackSignup(String userId);
trackLogout();

// Task events
trackTaskCreated(Task task);
trackTaskCompleted(Task task);
trackTaskDeleted(String taskId);

// Habit events
trackHabitCreated(Habit habit);
trackHabitCompleted(Habit habit);
trackStreakAchieved(Habit habit, int streak);

// Feature usage
trackScreenView(String screenName);
trackFeatureUsed(String featureName);
```

---

## 💾 local_storage.dart

**Purpose**: Saves and loads data locally on the device using SharedPreferences.

### What It Does

- Store user preferences
- Cache data for offline use
- Save app settings
- Store simple key-value pairs

### Key Methods

#### Save String
```dart
Future<void> saveString(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}
```

#### Get String
```dart
Future<String?> getString(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}
```

#### Save Boolean
```dart
Future<void> saveBool(String key, bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}
```

#### Save List
```dart
Future<void> saveStringList(String key, List<String> value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(key, value);
}
```

#### Save Object (as JSON)
```dart
Future<void> saveObject(String key, Map<String, dynamic> object) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = jsonEncode(object);
  await prefs.setString(key, jsonString);
}

Future<Map<String, dynamic>?> getObject(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString(key);
  if (jsonString == null) return null;
  return jsonDecode(jsonString);
}
```

#### Clear All Data
```dart
Future<void> clearAll() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
```

### Common Use Cases

#### Save User Preferences
```dart
// Save theme preference
await LocalStorage.saveBool('darkMode', true);

// Save language
await LocalStorage.saveString('language', 'fr');

// Save last viewed page
await LocalStorage.saveString('lastPage', 'todo');
```

#### Load User Preferences
```dart
// Load theme
bool isDarkMode = await LocalStorage.getBool('darkMode') ?? false;

// Load language
String language = await LocalStorage.getString('language') ?? 'en';
```

#### Cache Data Offline
```dart
// Save tasks for offline access
await LocalStorage.saveObject('cached_tasks', {
  'tasks': tasks.map((t) => t.toJson()).toList(),
  'lastSync': DateTime.now().toIso8601String(),
});

// Load cached tasks
final cachedData = await LocalStorage.getObject('cached_tasks');
if (cachedData != null) {
  final tasks = (cachedData['tasks'] as List)
      .map((json) => Task.fromJson(json))
      .toList();
}
```

---

## How Services Work Together

Here's a typical flow involving multiple services:

```
1. User logs in
   ↓
   firebase_auth_service.dart → Authenticate with Firebase
   ↓
   mixpanel_service.dart → Track login event
   ↓
   local_storage.dart → Save "isLoggedIn" = true

2. User creates a task
   ↓
   task_service.dart → Add task to list
   ↓
   Firebase Firestore → Save to cloud
   ↓
   local_storage.dart → Cache locally
   ↓
   mixpanel_service.dart → Track "Task Created"

3. User completes a task with tag "workout"
   ↓
   task_service.dart → Mark task complete
   ↓
   habit_service.dart → Check for linked habits
   ↓
   Habit "Exercise" auto-completes! 🎉
   ↓
   mixpanel_service.dart → Track both events
```

---

## Service Design Principles

### 1. **Single Responsibility**
Each service has one clear purpose:
- FirebaseAuthService → Authentication only
- TaskService → Task operations only
- MixpanelService → Analytics only

### 2. **Error Handling**
Services handle errors gracefully:
```dart
try {
  await firebaseOperation();
} catch (e) {
  debugPrint('Error: $e');
  throw UserFriendlyException('Something went wrong. Please try again.');
}
```

### 3. **Singleton Pattern**
Some services use singletons for global access:
```dart
class MixpanelService {
  static MixpanelService? _instance;
  
  static MixpanelService get instance {
    _instance ??= MixpanelService._();
    return _instance!;
  }
}
```

### 4. **Async Operations**
Services use async/await for operations that take time:
```dart
Future<void> saveData() async {
  await Future.delayed(Duration(seconds: 1));  // Simulated delay
  // Save data
}
```

---

## For Beginners: Understanding Services

**Q: What's the difference between a service and a provider?**
A:
- **Service** = How to communicate with external systems (technical details)
- **Provider** = Manages state and notifies UI of changes (state management)

**Q: When should I create a new service?**
A: When you need to:
- Communicate with a new external API
- Perform a complex operation that doesn't fit elsewhere
- Separate technical implementation from business logic

**Q: Why not put everything in providers?**
A: Separation of concerns! Providers focus on state, services focus on operations. This makes code:
- Easier to test
- Easier to maintain
- More reusable

**Q: Do services need to be singletons?**
A: Not always. Use singletons when:
- You need global access (like analytics)
- You want to share state across the app
- Initialization is expensive

---

## Common Patterns

### Service with Loading States
```dart
class DataService {
  bool _isLoading = false;
  String? _error;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  Future<void> fetchData() async {
    _isLoading = true;
    _error = null;
    
    try {
      // Fetch data
      await apiCall();
      _isLoading = false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
    }
  }
}
```

### Service with Retry Logic
```dart
Future<void> fetchWithRetry({int maxAttempts = 3}) async {
  int attempts = 0;
  
  while (attempts < maxAttempts) {
    try {
      await fetchData();
      return;  // Success!
    } catch (e) {
      attempts++;
      if (attempts >= maxAttempts) {
        throw e;  // Failed after max attempts
      }
      await Future.delayed(Duration(seconds: 2));  // Wait before retry
    }
  }
}
```

---

## Quick Reference

| Service | Purpose | Key Methods |
|---------|---------|-------------|
| **firebase_auth_service** | User authentication | signIn, signUp, signOut, resetPassword |
| **auth_service** | Auth utilities | validateEmail, validatePassword |
| **task_service** | Task operations | addTask, updateTask, deleteTask, filterTasks |
| **habit_service** | Habit tracking | addHabit, completeHabit, getStats |
| **mixpanel_service** | Analytics | trackEvent, identifyUser, setUserProperties |
| **local_storage** | Local persistence | saveString, getString, saveObject |

---

## Next Steps

Now that you understand services, check out:
- 🔄 [providers/ - State Management](./providers.md) - See how services are used
- 📱 [pages/ - App Screens](./pages.md) - See services in action
- 🏗️ [Architecture](./architecture.md) - Understand the big picture

---

**Services are the workhorses of your app! 💪**
