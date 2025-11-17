# DayFlow Team Instructions

This document contains detailed instructions for implementing the course features. Read your assigned section carefully and follow the steps.

## 📋 Table of Contents

1. [General Workflow](#general-workflow)
2. [Issue 3: Mixpanel Analytics - Lina & Mohammed](#issue-3-mixpanel-analytics---lina--mohammed)
3. [Issue 4: Node.js Backend - Mohammed](#issue-4-nodejs-backend---mohammed)
4. [Issue 5: State Management - Lina](#issue-5-state-management---lina)

---

## General Workflow

Before starting any task, follow these steps:

### 1. Pull the Latest Changes

```bash
git checkout copilot/implement-course-features
git pull origin copilot/implement-course-features
```

### 2. Create Your Feature Branch

```bash
# For Lina:
git checkout -b feature/lina-[task-name]

# For Mohammed:
git checkout -b feature/mohammed-[task-name]
```

### 3. Work on Your Task

Follow the specific instructions in your section below.

### 4. Test Your Changes

Make sure everything works before committing.

### 5. Commit and Push

```bash
git add .
git commit -m "Brief description of what you did"
git push origin feature/[your-branch-name]
```

### 6. Create a Pull Request

1. Go to GitHub repository
2. Click "Pull Requests" → "New Pull Request"
3. Select your branch
4. Add description of your changes
5. Request review from team lead (Abderrahmane)

### 7. Review Other PRs

Check your teammates' PRs and provide feedback.

---

## Issue 3: Mixpanel Analytics - Lina & Mohammed

**Goal**: Add analytics tracking to the DayFlow app using Mixpanel.

### What's Already Done ✅

The following files have been created for you:
- `lib/services/mixpanel_service.dart` - Service for Mixpanel integration
- `lib/providers/analytics_provider.dart` - Provider for analytics state management
- The dependency `mixpanel_flutter` has been added to `pubspec.yaml`
- Basic initialization code has been added to `main.dart`
- Settings page already tracks when it's opened

### Your Tasks 📝

#### Step 1: Get a Mixpanel Project Token (Mohammed)

1. Go to [https://mixpanel.com](https://mixpanel.com)
2. Sign up for a free account
3. Create a new project called "DayFlow"
4. Go to Project Settings → Project Token
5. Copy your project token

#### Step 2: Add Your Token to the App (Mohammed)

1. Open `lib/main.dart`
2. Find this line (around line 34):
```dart
await analyticsProvider.initialize('YOUR_MIXPANEL_TOKEN_HERE');
```
3. Replace `'YOUR_MIXPANEL_TOKEN_HERE'` with your actual token:
```dart
await analyticsProvider.initialize('abc123yourtokenhere');
```

#### Step 3: Install Dependencies (Both)

```bash
cd /path/to/DayFlow
flutter pub get
```

#### Step 4: Add Analytics to Login (Lina)

**File to edit**: `lib/pages/auth/login_page.dart` (or wherever login happens)

Find where the user successfully logs in. After successful login, add:

```dart
// Track login event
final analytics = Provider.of<AnalyticsProvider>(context, listen: false);
analytics.trackLogin(
  userId: user.uid,
  email: user.email ?? '',
  loginProvider: 'email', // or 'google' for Google sign-in
);
```

For Google sign-in, use `loginProvider: 'google'` instead.

**Full example**:
```dart
Future<void> _handleLogin() async {
  // ... your login code ...
  
  if (loginSuccessful && user != null) {
    // Add analytics tracking here
    final analytics = Provider.of<AnalyticsProvider>(context, listen: false);
    analytics.trackLogin(
      userId: user.uid,
      email: user.email ?? '',
      loginProvider: 'email',
    );
    
    // Navigate to home
    Navigator.pushReplacementNamed(context, Routes.home);
  }
}
```

#### Step 5: Add Analytics to Task Completion (Mohammed)

**File to edit**: `lib/pages/todo_page.dart` (or wherever tasks are marked as complete)

Find where a task is marked as completed. After the task is completed, add:

```dart
// Track task completion
final analytics = Provider.of<AnalyticsProvider>(context, listen: false);
analytics.trackTaskCompleted(
  taskId: task.id,
  taskTitle: task.title,
  priority: task.priority.toString().split('.').last, // 'high', 'medium', 'low'
);
```

**Full example**:
```dart
void _toggleTaskCompletion(Task task) {
  // Update task status
  setState(() {
    task.isCompleted = !task.isCompleted;
  });
  
  // If task is now completed, track it
  if (task.isCompleted) {
    final analytics = Provider.of<AnalyticsProvider>(context, listen: false);
    analytics.trackTaskCompleted(
      taskId: task.id,
      taskTitle: task.title,
      priority: task.priority.toString().split('.').last,
    );
  }
}
```

#### Step 6: Add Analytics to Habit Creation (Lina)

**File to edit**: `lib/pages/habits_page.dart` or `lib/pages/habit_detail_page.dart` (wherever new habits are created)

Find where a new habit is created. After the habit is successfully created, add:

```dart
// Track habit creation
final analytics = Provider.of<AnalyticsProvider>(context, listen: false);
analytics.trackHabitCreated(
  habitId: newHabit.id,
  habitName: newHabit.name,
  frequency: newHabit.frequency, // 'daily', 'weekly', etc.
);
```

**Full example**:
```dart
Future<void> _createHabit() async {
  // ... create habit logic ...
  
  if (habitCreated) {
    // Track in analytics
    final analytics = Provider.of<AnalyticsProvider>(context, listen: false);
    analytics.trackHabitCreated(
      habitId: newHabit.id,
      habitName: newHabit.name,
      frequency: 'daily',
    );
    
    // Close dialog or navigate
    Navigator.pop(context);
  }
}
```

#### Step 7: Test Analytics (Both)

1. Run the app: `flutter run`
2. Perform these actions:
   - Log in to the app
   - Complete a task
   - Create a habit
   - Open settings page
3. Go to Mixpanel dashboard
4. Click "Events" to see your tracked events:
   - User Logged In
   - User Completed Task
   - User Created Habit
   - Page Viewed (Settings)

#### Step 8: Take Screenshots (Both)

Take screenshots of:
1. Mixpanel dashboard showing events
2. The app running with analytics working

### Deliverables ✅

- [ ] Mixpanel token added to main.dart
- [ ] Login event tracked
- [ ] Task completion event tracked
- [ ] Habit creation event tracked
- [ ] Settings page view tracked (already done)
- [ ] All events visible in Mixpanel dashboard
- [ ] Screenshots included in PR

---

## Issue 4: Node.js Backend - Mohammed

**Goal**: Set up a minimal Node.js + MongoDB backend.

### What's Already Done ✅

The backend structure has been created for you:
```
backend/
├── config/
│   └── database.js          # MongoDB connection
├── controllers/
│   └── statusController.js  # Status endpoint logic
├── models/                  # (empty, for future models)
├── routes/
│   └── status.js           # Status route
├── .env.example            # Environment variable template
├── .gitignore              # Git ignore file
├── package.json            # Dependencies
├── README.md               # Setup instructions
└── server.js               # Main server file
```

### Your Tasks 📝

#### Step 1: Navigate to Backend Folder

```bash
cd backend
```

#### Step 2: Install Dependencies

```bash
npm install
```

This installs:
- Express (web framework)
- Mongoose (MongoDB)
- Dotenv (environment variables)
- CORS (cross-origin requests)
- Body-parser (request parsing)
- Nodemon (auto-restart during development)

#### Step 3: Set Up MongoDB

Choose ONE option:

**Option A: MongoDB Atlas (Cloud - Recommended)**

1. Go to [https://www.mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
2. Sign up (free account)
3. Create a free cluster
4. Click "Connect" → "Connect your application"
5. Copy the connection string
6. It looks like: `mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/dayflow`

**Option B: Local MongoDB**

1. Download MongoDB: [https://www.mongodb.com/try/download/community](https://www.mongodb.com/try/download/community)
2. Install and start MongoDB service
3. Use: `mongodb://localhost:27017/dayflow`

#### Step 4: Create .env File

```bash
cp .env.example .env
```

Edit `.env` and add your MongoDB URI:

```env
PORT=5000
NODE_ENV=development
MONGODB_URI=mongodb+srv://your-connection-string-here
```

#### Step 5: Start the Server

For development (auto-restarts):
```bash
npm run dev
```

For production:
```bash
npm start
```

You should see:
```
✅ MongoDB connected successfully
📦 Database: dayflow
✅ Server running on port 5000
🌐 Environment: development
```

#### Step 6: Test the API

Open a new terminal and test:

```bash
curl http://localhost:5000/api/status
```

Or open in browser: `http://localhost:5000/api/status`

Expected response:
```json
{
  "ok": true,
  "message": "DayFlow backend is running",
  "timestamp": "2024-01-20T10:30:00.000Z",
  "database": {
    "status": "connected",
    "name": "dayflow"
  },
  "environment": "development"
}
```

#### Step 7: Take Screenshots

Take screenshots of:
1. Terminal showing server running
2. Browser/Postman showing API response
3. MongoDB Atlas dashboard (if using Atlas)

### Troubleshooting 🔧

**Port already in use?**
Change `PORT=5000` to `PORT=3000` in `.env`

**MongoDB connection error?**
- Check MongoDB service is running (local)
- Verify connection string (Atlas)
- Check IP whitelist in Atlas (add `0.0.0.0/0` for development)

**Dependencies not installing?**
```bash
npm cache clean --force
npm install
```

### Deliverables ✅

- [ ] Dependencies installed (node_modules folder exists)
- [ ] MongoDB connection working
- [ ] Server starts successfully
- [ ] GET /api/status returns correct response
- [ ] .env file created (NOT committed to git)
- [ ] Screenshots of working backend

---

## Issue 5: State Management - Lina

**Goal**: Implement clean state management using Providers for tasks, habits, and authentication.

### What's Already Done ✅

Three new providers have been created for you:
- `lib/providers/tasks_provider.dart` - Manages tasks with Firestore
- `lib/providers/habits_provider.dart` - Manages habits with Firestore
- `lib/providers/auth_provider.dart` - Manages authentication
- All providers are registered in `main.dart`

### Your Tasks 📝

#### Step 1: Understand the Providers

Read these files to understand what's available:
- `lib/providers/tasks_provider.dart`
- `lib/providers/habits_provider.dart`
- `lib/providers/auth_provider.dart`

Key methods to know:

**TasksProvider**:
- `loadTasks()` - Load all tasks
- `addTask(task)` - Create new task
- `updateTask(task)` - Update existing task
- `toggleTaskCompletion(taskId)` - Mark task complete/incomplete
- `deleteTask(taskId)` - Delete a task
- `setFilter(filter)` - Filter tasks (all, completed, pending, etc.)
- `setSort(sort)` - Sort tasks

**HabitsProvider**:
- `loadHabits()` - Load all habits
- `addHabit(habit)` - Create new habit
- `updateHabit(habit)` - Update existing habit
- `toggleHabitCompletion(habitId)` - Mark habit done for today
- `deleteHabit(habitId)` - Delete a habit

**AuthProvider**:
- `signInWithEmail(email, password)` - Email login
- `signInWithGoogle()` - Google login
- `registerWithEmail(email, password)` - Sign up
- `signOut()` - Logout
- `resetPassword(email)` - Password reset

#### Step 2: Update To-Do Page to Use TasksProvider

**File to edit**: `lib/pages/todo_page.dart`

**Current code** (probably looks like this):
```dart
class _TodoPageState extends State<TodoPage> {
  final TaskService _taskService = TaskService();
  List<Task> tasks = [];
  
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }
  
  void _loadTasks() {
    setState(() {
      tasks = _taskService.tasks;
    });
  }
}
```

**New code** (using Provider):
```dart
class _TodoPageState extends State<TodoPage> {
  @override
  void initState() {
    super.initState();
    // Load tasks when page opens
    Future.microtask(() {
      final tasksProvider = Provider.of<TasksProvider>(context, listen: false);
      tasksProvider.loadTasks();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<TasksProvider>(
      builder: (context, tasksProvider, child) {
        if (tasksProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        
        final tasks = tasksProvider.tasks;
        
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskTile(
              task: task,
              onToggle: () {
                tasksProvider.toggleTaskCompletion(task.id);
              },
              onDelete: () {
                tasksProvider.deleteTask(task.id);
              },
            );
          },
        );
      },
    );
  }
}
```

**Key changes**:
1. Remove `TaskService` - use `TasksProvider` instead
2. Use `Consumer<TasksProvider>` to listen to changes
3. Call provider methods like `toggleTaskCompletion()` instead of local state

#### Step 3: Update Habits Page to Use HabitsProvider

**File to edit**: `lib/pages/habits_page.dart`

**Similar pattern**:
```dart
class _HabitsPageState extends State<HabitsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final habitsProvider = Provider.of<HabitsProvider>(context, listen: false);
      habitsProvider.loadHabits();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<HabitsProvider>(
      builder: (context, habitsProvider, child) {
        if (habitsProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        
        final habits = habitsProvider.habits;
        
        return ListView.builder(
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            return HabitTile(
              habit: habit,
              onToggle: () {
                habitsProvider.toggleHabitCompletion(habit.id);
              },
            );
          },
        );
      },
    );
  }
}
```

#### Step 4: Update Login Page to Use AuthProvider

**File to edit**: `lib/pages/auth/login_page.dart`

**Find the login button's onPressed**:
```dart
// OLD way
ElevatedButton(
  onPressed: () async {
    final user = await FirebaseAuthService().signInWithEmail(email, password);
    if (user != null) {
      Navigator.pushNamed(context, Routes.home);
    }
  },
  child: Text('Login'),
)
```

**NEW way**:
```dart
ElevatedButton(
  onPressed: () async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signInWithEmail(email, password);
    
    if (success) {
      Navigator.pushReplacementNamed(context, Routes.home);
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error ?? 'Login failed')),
      );
    }
  },
  child: authProvider.isLoading
      ? CircularProgressIndicator(color: Colors.white)
      : Text('Login'),
)
```

**For showing loading state**:
```dart
@override
Widget build(BuildContext context) {
  return Consumer<AuthProvider>(
    builder: (context, authProvider, child) {
      return Scaffold(
        body: Column(
          children: [
            // ... email and password fields ...
            
            ElevatedButton(
              onPressed: authProvider.isLoading ? null : () async {
                // login logic
              },
              child: authProvider.isLoading
                  ? CircularProgressIndicator()
                  : Text('Login'),
            ),
          ],
        ),
      );
    },
  );
}
```

#### Step 5: Update Logout to Use AuthProvider

**File to edit**: `lib/pages/settings_page.dart`

Find the logout button and update it:

```dart
// OLD
ElevatedButton(
  onPressed: () async {
    await FirebaseAuthService().signOut();
    Navigator.pushReplacementNamed(context, Routes.welcome);
  },
  child: Text('Logout'),
)

// NEW
ElevatedButton(
  onPressed: () async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();
    Navigator.pushReplacementNamed(context, Routes.welcome);
  },
  child: Text('Logout'),
)
```

#### Step 6: Add Task Creation with Provider

When creating a new task:

```dart
Future<void> _createTask() async {
  final task = Task(
    id: '', // Will be set by Firestore
    title: _titleController.text,
    description: _descriptionController.text,
    isCompleted: false,
    createdAt: DateTime.now(),
    priority: selectedPriority,
  );
  
  final tasksProvider = Provider.of<TasksProvider>(context, listen: false);
  await tasksProvider.addTask(task);
  
  Navigator.pop(context); // Close dialog/page
}
```

#### Step 7: Add Habit Creation with Provider

When creating a new habit:

```dart
Future<void> _createHabit() async {
  final habit = Habit(
    id: '', // Will be set by Firestore
    name: _nameController.text,
    description: _descriptionController.text,
    icon: selectedIcon,
    color: selectedColor,
    frequency: 'daily',
    goalCount: 7,
    createdAt: DateTime.now(),
  );
  
  final habitsProvider = Provider.of<HabitsProvider>(context, listen: false);
  await habitsProvider.addHabit(habit);
  
  // Also track in analytics
  final analytics = Provider.of<AnalyticsProvider>(context, listen: false);
  analytics.trackHabitCreated(
    habitId: habit.id,
    habitName: habit.name,
    frequency: 'daily',
  );
  
  Navigator.pop(context);
}
```

#### Step 8: Test Everything

1. Run the app: `flutter run`
2. Test these flows:
   - Login → Should use AuthProvider
   - View tasks → Should use TasksProvider
   - Create task → Should save to Firestore via provider
   - Complete task → Should update via provider
   - View habits → Should use HabitsProvider
   - Create habit → Should save via provider
   - Logout → Should use AuthProvider

### Common Patterns 📚

**1. Get provider without listening (one-time action)**:
```dart
final provider = Provider.of<TasksProvider>(context, listen: false);
await provider.addTask(task);
```

**2. Listen to provider changes (rebuild when data changes)**:
```dart
return Consumer<TasksProvider>(
  builder: (context, provider, child) {
    return Text('Tasks: ${provider.tasks.length}');
  },
);
```

**3. Load data on page open**:
```dart
@override
void initState() {
  super.initState();
  Future.microtask(() {
    Provider.of<TasksProvider>(context, listen: false).loadTasks();
  });
}
```

### Deliverables ✅

- [ ] To-do page uses TasksProvider
- [ ] Habits page uses HabitsProvider
- [ ] Login uses AuthProvider
- [ ] Logout uses AuthProvider
- [ ] Task creation uses provider
- [ ] Habit creation uses provider
- [ ] No direct Firestore calls in UI code
- [ ] All CRUD operations go through providers

---

## 🎯 Summary of Responsibilities

### Lina's Tasks
- [ ] Issue 3: Track login events with Mixpanel
- [ ] Issue 3: Track habit creation with Mixpanel
- [ ] Issue 5: Implement TasksProvider in To-Do page
- [ ] Issue 5: Implement HabitsProvider in Habits page
- [ ] Issue 5: Implement AuthProvider in login/logout

### Mohammed's Tasks
- [ ] Issue 3: Set up Mixpanel account and get token
- [ ] Issue 3: Add token to main.dart
- [ ] Issue 3: Track task completion with Mixpanel
- [ ] Issue 4: Install Node.js dependencies
- [ ] Issue 4: Set up MongoDB (Atlas or local)
- [ ] Issue 4: Start backend server
- [ ] Issue 4: Test API endpoint

---

## 📞 Need Help?

1. Read the error message carefully
2. Check the file comments and documentation
3. Google the error
4. Ask team lead (Abderrahmane)
5. Ask your teammate

## 🎉 Final Notes

- **Take your time** - understand each step before moving forward
- **Test frequently** - don't wait until the end
- **Ask questions** - it's better to ask than to guess
- **Help each other** - you're a team!
- **Document issues** - if something doesn't work, write it down

Good luck! You've got this! 🚀
