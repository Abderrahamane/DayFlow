# 🔄 providers/ Folder Documentation

## Overview

The `providers/` folder contains **state management** code using the **Provider pattern**. Providers are the "managers" of your app's data and state.

**Think of providers as orchestra conductors**: They coordinate everything, keep track of what's happening, and make sure everyone (all the UI components) stays in sync.

---

## What is State Management?

**State** = The current data and status of your app at any moment.

Examples of state:
- List of tasks currently displayed
- Whether the user is logged in
- Current language setting
- Is data loading?
- Are there any errors?

**State Management** = Keeping track of this data and updating the UI when it changes.

### Why Do We Need Providers?

Without state management:
```dart
// ❌ BAD: Data scattered everywhere
class TodoPage {
  List<Task> tasks = [];  // Each page has its own copy
}

class SettingsPage {
  List<Task> tasks = [];  // Duplicate data!
}
```

With providers:
```dart
// ✅ GOOD: Single source of truth
class TasksProvider {
  List<Task> _tasks = [];  // ONE central list
  
  // All pages use this same provider
}
```

---

## Files in providers/

```
providers/
├── tasks_provider.dart      # Manages tasks (to-dos)
├── habits_provider.dart     # Manages habits
├── auth_provider.dart       # Manages authentication state
├── analytics_provider.dart  # Manages analytics tracking
└── language_provider.dart   # Manages app language
```

---

## 📋 tasks_provider.dart

**Purpose**: Manages all task-related state and operations.

### What It Manages

- List of all tasks
- Current filter (all, completed, pending, overdue, today)
- Current sort (by date, priority, alphabetical)
- Loading state
- Errors

### Key Properties

```dart
class TasksProvider extends ChangeNotifier {
  // Private data (only accessible within this class)
  List<Task> _tasks = [];
  TaskFilter _currentFilter = TaskFilter.all;
  TaskSort _currentSort = TaskSort.dateCreated;
  bool _isLoading = false;
  String? _error;
  
  // Public getters (read-only access)
  List<Task> get tasks => _getFilteredAndSortedTasks();
  List<Task> get allTasks => _tasks;
  TaskFilter get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Statistics
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((t) => t.isCompleted).length;
  int get pendingTasks => _tasks.where((t) => !t.isCompleted).length;
  int get overdueTasks => _tasks.where((t) => t.isOverdue).length;
}
```

### Key Methods

#### Load Tasks from Firestore
```dart
Future<void> loadTasks() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  
  _isLoading = true;
  notifyListeners();  // Update UI to show loading
  
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .get();
    
    _tasks = snapshot.docs.map((doc) {
      return Task.fromFirestore(doc.data(), doc.id);
    }).toList();
    
    _isLoading = false;
    notifyListeners();  // Update UI with new data
  } catch (e) {
    _error = 'Error loading tasks: $e';
    _isLoading = false;
    notifyListeners();  // Update UI to show error
  }
}
```

**What happens**:
1. Sets loading = true, UI shows loading spinner
2. Fetches tasks from Firebase
3. Converts Firebase data to Task objects
4. Sets loading = false, UI shows tasks
5. If error occurs, UI shows error message

#### Add New Task
```dart
Future<void> addTask(Task task) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  
  try {
    // Save to Firestore
    final docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .add(task.toFirestore());
    
    // Add to local list
    final taskWithId = task.copyWith(id: docRef.id);
    _tasks.add(taskWithId);
    
    // Update UI
    notifyListeners();
    
    // Track analytics
    MixpanelService.instance.trackTaskCreated(
      taskId: docRef.id,
      taskTitle: task.title,
      priority: task.priority.name,
    );
  } catch (e) {
    _error = 'Error adding task: $e';
    notifyListeners();
  }
}
```

#### Update Task
```dart
Future<void> updateTask(String taskId, Task updatedTask) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  
  try {
    // Update in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(taskId)
        .update(updatedTask.toFirestore());
    
    // Update in local list
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  } catch (e) {
    _error = 'Error updating task: $e';
    notifyListeners();
  }
}
```

#### Delete Task
```dart
Future<void> deleteTask(String taskId) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  
  try {
    // Delete from Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(taskId)
        .delete();
    
    // Remove from local list
    _tasks.removeWhere((t) => t.id == taskId);
    
    // Update UI
    notifyListeners();
  } catch (e) {
    _error = 'Error deleting task: $e';
    notifyListeners();
  }
}
```

#### Toggle Task Completion
```dart
Future<void> toggleTaskCompletion(String taskId) async {
  final task = _tasks.firstWhere((t) => t.id == taskId);
  final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
  
  await updateTask(taskId, updatedTask);
  
  // Track analytics
  if (updatedTask.isCompleted) {
    MixpanelService.instance.trackTaskCompleted(
      taskId: taskId,
      taskTitle: task.title,
    );
  }
}
```

#### Set Filter
```dart
void setFilter(TaskFilter filter) {
  _currentFilter = filter;
  notifyListeners();  // UI automatically updates with filtered tasks
}
```

#### Set Sort
```dart
void setSort(TaskSort sort) {
  _currentSort = sort;
  notifyListeners();  // UI automatically updates with sorted tasks
}
```

### How Filtering Works

```dart
List<Task> _getFilteredAndSortedTasks() {
  List<Task> filtered = [];
  
  // Apply filter
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
        return isSameDay(t.dueDate!, today);
      }).toList();
      break;
  }
  
  // Apply sort
  return _sortTasks(filtered);
}
```

### Using TasksProvider in UI

```dart
// In your widget
class TodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TasksProvider>(
      builder: (context, tasksProvider, child) {
        // UI automatically rebuilds when tasks change!
        
        if (tasksProvider.isLoading) {
          return CircularProgressIndicator();
        }
        
        if (tasksProvider.error != null) {
          return Text('Error: ${tasksProvider.error}');
        }
        
        final tasks = tasksProvider.tasks;
        
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return TaskCard(task: tasks[index]);
          },
        );
      },
    );
  }
}
```

**Magic of Consumer**: When `notifyListeners()` is called in the provider, the Consumer widget automatically rebuilds with the new data!

---

## 🎯 habits_provider.dart

**Purpose**: Manages all habit-related state and operations.

### What It Manages

- List of all habits
- Habit completion tracking
- Loading state
- Errors

### Key Properties

```dart
class HabitsProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  bool _isLoading = false;
  String? _error;
  
  // Getters
  List<Habit> get habits => List.unmodifiable(_habits);
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Statistics
  int get totalHabits => _habits.length;
  int get completedToday => _habits.where((h) => h.isCompletedToday).length;
  int get activeStreaks => _habits.where((h) => h.currentStreak > 0).length;
}
```

### Key Methods

#### Load Habits
```dart
Future<void> loadHabits() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  
  _isLoading = true;
  notifyListeners();
  
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('habits')
        .get();
    
    _habits = snapshot.docs.map((doc) {
      return Habit.fromFirestore(doc.data(), doc.id);
    }).toList();
    
    _isLoading = false;
    notifyListeners();
  } catch (e) {
    _error = 'Error loading habits: $e';
    _isLoading = false;
    notifyListeners();
  }
}
```

#### Add Habit
```dart
Future<void> addHabit(Habit habit) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  
  try {
    final docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('habits')
        .add(habit.toFirestore());
    
    final habitWithId = habit.copyWith(id: docRef.id);
    _habits.add(habitWithId);
    
    notifyListeners();
    
    // Track analytics
    MixpanelService.instance.trackHabitCreated(
      habitId: docRef.id,
      habitName: habit.name,
      frequency: habit.frequency.name,
    );
  } catch (e) {
    _error = 'Error adding habit: $e';
    notifyListeners();
  }
}
```

#### Complete Habit Today
```dart
Future<void> completeHabitToday(String habitId) async {
  final habit = _habits.firstWhere((h) => h.id == habitId);
  final today = Habit.getDateKey(DateTime.now());
  
  // Update completion history
  final updatedHistory = Map<String, bool>.from(habit.completionHistory);
  updatedHistory[today] = true;
  
  final updatedHabit = habit.copyWith(completionHistory: updatedHistory);
  
  await updateHabit(habitId, updatedHabit);
  
  // Track analytics
  MixpanelService.instance.trackHabitCompleted(
    habitId: habitId,
    habitName: habit.name,
    currentStreak: updatedHabit.currentStreak,
  );
}
```

#### Check Task Tags for Auto-Completion
```dart
Future<void> checkTaskTags(List<String> taskTags) async {
  bool anyUpdated = false;
  
  for (final habit in _habits) {
    if (habit.isCompletedToday) continue;
    
    // Check if any task tags match habit's linked tags
    final hasMatch = habit.linkedTaskTags.any(
      (tag) => taskTags.contains(tag)
    );
    
    if (hasMatch) {
      await completeHabitToday(habit.id);
      anyUpdated = true;
    }
  }
  
  if (anyUpdated) {
    notifyListeners();
  }
}
```

**This is powerful!** When you complete a task with tag "workout", any habit linked to "workout" automatically marks as complete! 🎉

---

## 🔐 auth_provider.dart

**Purpose**: Manages authentication state and user session.

### What It Manages

- Current user
- Login/logout state
- Email verification status
- Loading state
- Errors

### Key Properties

```dart
class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isEmailVerified => _user?.emailVerified ?? false;
}
```

### Key Methods

#### Sign In with Email
```dart
Future<bool> signInWithEmail(String email, String password) async {
  _isLoading = true;
  _error = null;
  notifyListeners();
  
  try {
    final userCredential = await FirebaseAuthService().signInWithEmail(
      email, 
      password,
    );
    
    if (userCredential != null) {
      _user = userCredential.user;
      
      // Track login
      MixpanelService.instance.trackLogin(
        userId: _user!.uid,
        email: email,
        loginProvider: 'email',
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  } catch (e) {
    _error = e.toString();
    _isLoading = false;
    notifyListeners();
    return false;
  }
}
```

#### Sign Up
```dart
Future<bool> signUpWithEmail(String email, String password) async {
  _isLoading = true;
  _error = null;
  notifyListeners();
  
  try {
    final userCredential = await FirebaseAuthService().signUpWithEmail(
      email,
      password,
    );
    
    if (userCredential != null) {
      _user = userCredential.user;
      
      // Track signup
      MixpanelService.instance.trackSignup(
        userId: _user!.uid,
        email: email,
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    }
    
    return false;
  } catch (e) {
    _error = e.toString();
    _isLoading = false;
    notifyListeners();
    return false;
  }
}
```

#### Sign In with Google
```dart
Future<bool> signInWithGoogle() async {
  _isLoading = true;
  _error = null;
  notifyListeners();
  
  try {
    final userCredential = await FirebaseAuthService().signInWithGoogle();
    
    if (userCredential != null) {
      _user = userCredential.user;
      
      MixpanelService.instance.trackLogin(
        userId: _user!.uid,
        email: _user!.email ?? '',
        loginProvider: 'google',
      );
      
      _isLoading = false;
      notifyListeners();
      return true;
    }
    
    return false;
  } catch (e) {
    _error = e.toString();
    _isLoading = false;
    notifyListeners();
    return false;
  }
}
```

#### Sign Out
```dart
Future<void> signOut() async {
  try {
    await FirebaseAuthService().signOut();
    _user = null;
    
    MixpanelService.instance.trackLogout();
    
    notifyListeners();
  } catch (e) {
    _error = e.toString();
    notifyListeners();
  }
}
```

#### Listen to Auth State Changes
```dart
AuthProvider() {
  // Automatically update when Firebase auth state changes
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    _user = user;
    notifyListeners();
  });
}
```

**What this does**: When the user logs in/out in Firebase, the provider automatically updates and notifies all listening widgets!

---

## 📊 analytics_provider.dart

**Purpose**: Wrapper around MixpanelService for easy analytics tracking.

### What It Manages

- Analytics initialization status
- Event tracking methods

### Key Methods

#### Initialize Analytics
```dart
Future<void> initialize(String token) async {
  try {
    await MixpanelService.init(token);
    _isInitialized = true;
    notifyListeners();
  } catch (e) {
    _isInitialized = false;
  }
}
```

#### Track Generic Event
```dart
void trackEvent(String eventName, [Map<String, dynamic>? properties]) {
  if (!_isInitialized) return;
  MixpanelService.instance.trackEvent(eventName, properties);
}
```

#### Track Specific Events
```dart
void trackLogin({
  required String userId,
  required String email,
  required String loginProvider,
}) {
  MixpanelService.instance.trackLogin(
    userId: userId,
    email: email,
    loginProvider: loginProvider,
  );
}

void trackTaskCompleted({
  required String taskId,
  required String taskTitle,
  String? priority,
}) {
  MixpanelService.instance.trackTaskCompleted(
    taskId: taskId,
    taskTitle: taskTitle,
    priority: priority,
  );
}

void trackScreenView(String screenName) {
  MixpanelService.instance.trackScreenView(screenName);
}
```

### Usage in Widgets

```dart
// Track screen view
final analytics = Provider.of<AnalyticsProvider>(context, listen: false);
analytics.trackScreenView('TodoPage');

// Track button click
analytics.trackEvent('Button Clicked', {
  'button_name': 'Add Task',
  'screen': 'TodoPage',
});
```

---

## 🌍 language_provider.dart

**Purpose**: Manages app language and localization.

### What It Manages

- Current language/locale
- Language preferences
- RTL (Right-to-Left) support

### Key Properties

```dart
class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');  // Default English
  
  Locale get locale => _locale;
  
  String get languageName {
    switch (_locale.languageCode) {
      case 'en': return 'English';
      case 'fr': return 'Français';
      case 'ar': return 'العربية';
      default: return 'English';
    }
  }
  
  bool get isRTL => _locale.languageCode == 'ar';
}
```

### Key Methods

#### Load Saved Language
```dart
Future<void> loadSavedLanguage() async {
  final prefs = await SharedPreferences.getInstance();
  final languageCode = prefs.getString('language_code') ?? 'en';
  _locale = Locale(languageCode);
  notifyListeners();
}
```

#### Change Language
```dart
Future<void> changeLanguage(String languageCode) async {
  if (_locale.languageCode == languageCode) return;
  
  _locale = Locale(languageCode);
  
  // Save preference
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('language_code', languageCode);
  
  notifyListeners();  // Entire app rebuilds with new language!
}
```

### Using LanguageProvider

```dart
// In your app
return MaterialApp(
  locale: Provider.of<LanguageProvider>(context).locale,
  localizationsDelegates: [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
  supportedLocales: [
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
  ],
  // ...
);

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
    }
  },
);
```

---

## The Provider Pattern Explained

### What is Provider Pattern?

Provider is a **state management solution** that uses InheritedWidget under the hood to efficiently pass data down the widget tree.

### Key Concepts

#### 1. ChangeNotifier
```dart
class MyProvider extends ChangeNotifier {
  int _counter = 0;
  
  int get counter => _counter;
  
  void increment() {
    _counter++;
    notifyListeners();  // Notify all listeners that data changed
  }
}
```

#### 2. Provider Setup (in main.dart)
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => TasksProvider()),
    ChangeNotifierProvider(create: (_) => HabitsProvider()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
    ChangeNotifierProvider(create: (_) => LanguageProvider()),
  ],
  child: MyApp(),
);
```

#### 3. Consumer Widget (read and listen)
```dart
Consumer<TasksProvider>(
  builder: (context, tasksProvider, child) {
    // This rebuilds when tasksProvider calls notifyListeners()
    return Text('Tasks: ${tasksProvider.tasks.length}');
  },
);
```

#### 4. Provider.of (read only, no rebuild)
```dart
// listen: false means don't rebuild when data changes
final tasksProvider = Provider.of<TasksProvider>(context, listen: false);
tasksProvider.addTask(newTask);
```

### Why This Pattern Works

✅ **Single source of truth**: One provider = one source of data
✅ **Reactive**: UI automatically updates when data changes
✅ **Efficient**: Only rebuilds widgets that need updating
✅ **Testable**: Easy to test providers independently
✅ **Scalable**: Easy to add new providers

---

## Common Patterns

### Loading States
```dart
if (provider.isLoading) {
  return CircularProgressIndicator();
}

if (provider.error != null) {
  return Text('Error: ${provider.error}');
}

return ListView(...);
```

### Optimistic Updates
```dart
void deleteTask(String taskId) {
  // Remove from UI immediately
  _tasks.removeWhere((t) => t.id == taskId);
  notifyListeners();
  
  // Then delete from database
  _firestore.collection('tasks').doc(taskId).delete().catchError((e) {
    // If failed, add back and show error
    loadTasks();
  });
}
```

### Combining Multiple Providers
```dart
Consumer2<TasksProvider, HabitsProvider>(
  builder: (context, tasksProvider, habitsProvider, child) {
    return Column(
      children: [
        Text('Tasks: ${tasksProvider.tasks.length}'),
        Text('Habits: ${habitsProvider.habits.length}'),
      ],
    );
  },
);
```

---

## For Beginners: Understanding Providers

**Q: When should data go in a provider vs. local widget state?**
A:
- **Provider**: Data needed by multiple screens (tasks, user info, settings)
- **Local state**: Data only needed in one widget (text field value, dropdown selection)

**Q: How does notifyListeners() work?**
A: It tells all Consumer widgets using this provider to rebuild with the new data.

**Q: What's the difference between Provider.of and Consumer?**
A:
- **Consumer**: Listens for changes and rebuilds
- **Provider.of(listen: false)**: Read once, don't rebuild

**Q: Can I use multiple providers in one widget?**
A: Yes! Use Consumer2, Consumer3, etc., or nest multiple Consumers.

**Q: Should I create a provider for everything?**
A: No! Only for data that:
  - Is shared across screens
  - Needs to persist
  - Needs to be updated from multiple places

---

## Quick Reference

| Provider | Manages | Key Methods |
|----------|---------|-------------|
| **TasksProvider** | Tasks/To-dos | loadTasks, addTask, updateTask, deleteTask, toggleCompletion |
| **HabitsProvider** | Habits | loadHabits, addHabit, completeHabitToday, checkTaskTags |
| **AuthProvider** | User auth | signIn, signUp, signOut, resetPassword |
| **AnalyticsProvider** | Event tracking | trackEvent, trackLogin, trackScreenView |
| **LanguageProvider** | App language | changeLanguage, loadSavedLanguage |

---

## Next Steps

Now that you understand providers, check out:
- 🛠️ [services/ - External Services](./services.md) - See what providers use
- 📱 [pages/ - App Screens](./pages.md) - See providers in action
- 🏗️ [Architecture](./architecture.md) - Understand the full picture

---

**Providers are the backbone of your app's state! 🦴**
