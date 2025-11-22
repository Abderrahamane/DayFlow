# 📱 pages/ Folder Documentation

## Overview

The `pages/` folder contains all the **screens** (also called pages or views) that users see and interact with in the DayFlow app.

**Think of pages as rooms in a house**: Each page is a different room, and users navigate between them to access different features.

---

## What Are Pages?

Pages are full-screen widgets that represent complete screens in your app. Each page typically:
- Has its own route/URL
- Displays specific content (tasks, habits, settings, etc.)
- Handles user interactions
- Uses providers to get/update data
- Can navigate to other pages

---

## Files in pages/

```
pages/
├── welcome_page.dart             # App landing/home page
├── todo_page.dart                # Task list screen
├── task_detail_page.dart         # View/edit single task
├── task_edit_page.dart           # Edit task form
├── habits_page.dart              # Habit tracking list
├── habit_detail_page.dart        # View/edit single habit
├── notes_page.dart               # Notes list
├── note_page_write.dart          # Create/edit note
├── reminders_page.dart           # Reminders list
├── settings_page.dart            # App settings
├── privacy_backup_page.dart      # Privacy & backup settings
├── help_support_page.dart        # Help & support
├── terms_privacy_page.dart       # Terms & privacy policy
├── auth/                         # Authentication pages
│   ├── login_page.dart
│   ├── signup_page.dart
│   ├── forgot_password_page.dart
│   └── email_verification_page.dart
└── onboarding/                   # First-time user experience
    ├── onboarding_page.dart
    ├── question_flow_page.dart
    └── question_flow_widgets/
```

---

## 🏠 welcome_page.dart

**Purpose**: The main landing page after login. Shows quick overview and navigation.

### What It Shows

- Welcome message with user's name
- Quick stats (total tasks, habits, etc.)
- Quick action buttons
- Navigation to other pages

### Key Features

```dart
class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final tasks = Provider.of<TasksProvider>(context).tasks;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user?.displayName ?? "User"}'),
      ),
      body: Column(
        children: [
          // Quick stats cards
          StatsCard(
            title: 'Tasks Today',
            value: tasks.where((t) => t.dueDate == today).length,
          ),
          
          // Quick actions
          QuickActionButton(
            icon: Icons.add_task,
            label: 'Add Task',
            onTap: () => Navigator.pushNamed(context, '/task/add'),
          ),
        ],
      ),
    );
  }
}
```

### Navigation From Here

- ➡️ Tasks page
- ➡️ Habits page
- ➡️ Notes page
- ➡️ Settings page

---

## ✅ todo_page.dart

**Purpose**: Main task management screen. Shows list of tasks with filtering and sorting.

### What It Shows

- List of all tasks
- Filter buttons (all, completed, pending, overdue, today)
- Sort dropdown
- Add task button
- Task statistics

### Key Features

```dart
class TodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TasksProvider>(
      builder: (context, tasksProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Tasks'),
            actions: [
              // Filter menu
              PopupMenuButton<TaskFilter>(
                onSelected: (filter) {
                  tasksProvider.setFilter(filter);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: TaskFilter.all,
                    child: Text('All'),
                  ),
                  PopupMenuItem(
                    value: TaskFilter.pending,
                    child: Text('Pending'),
                  ),
                  // ... more filters
                ],
              ),
            ],
          ),
          body: ListView.builder(
            itemCount: tasksProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = tasksProvider.tasks[index];
              return TaskCard(
                task: task,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/task/detail',
                    arguments: task.id,
                  );
                },
                onToggleComplete: () {
                  tasksProvider.toggleTaskCompletion(task.id);
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/task/add');
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
```

### User Interactions

- ✅ Tap task → View task details
- ✅ Tap checkbox → Mark complete/incomplete
- ✅ Swipe task → Delete
- ✅ FAB → Add new task
- ✅ Filter menu → Change filter
- ✅ Sort menu → Change sort order

---

## 📋 task_detail_page.dart

**Purpose**: Shows detailed information about a single task.

### What It Shows

- Task title and description
- Due date and time
- Priority level
- Tags
- Subtasks list with progress bar
- Edit and delete buttons

### Key Features

```dart
class TaskDetailPage extends StatelessWidget {
  final String taskId;
  
  @override
  Widget build(BuildContext context) {
    final task = Provider.of<TasksProvider>(context)
        .allTasks
        .firstWhere((t) => t.id == taskId);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/task/edit',
                arguments: taskId,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, taskId),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Task info
            ListTile(
              title: Text(task.title),
              subtitle: Text(task.description ?? ''),
            ),
            
            // Due date
            if (task.dueDate != null)
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Due: ${formatDate(task.dueDate!)}'),
              ),
            
            // Priority
            ListTile(
              leading: Icon(Icons.flag),
              title: Text('Priority: ${task.priority.name}'),
            ),
            
            // Tags
            if (task.tags != null && task.tags!.isNotEmpty)
              Wrap(
                children: task.tags!.map((tag) => Chip(label: Text(tag))).toList(),
              ),
            
            // Subtasks
            if (task.subtasks != null)
              SubtasksList(subtasks: task.subtasks!),
          ],
        ),
      ),
    );
  }
}
```

### Navigation From Here

- ➡️ Edit task page
- ⬅️ Back to tasks list

---

## ✏️ task_edit_page.dart

**Purpose**: Form for creating or editing a task.

### What It Shows

- Text fields for title and description
- Date/time picker for due date
- Priority selector
- Tag input
- Subtask manager
- Save button

### Key Features

```dart
class TaskEditPage extends StatefulWidget {
  final String? taskId;  // null for new task
  
  @override
  _TaskEditPageState createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.medium;
  List<String> _tags = [];
  List<Subtask> _subtasks = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskId == null ? 'New Task' : 'Edit Task'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            // Title field
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            
            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            
            // Due date picker
            ListTile(
              title: Text('Due Date'),
              subtitle: Text(_dueDate != null 
                  ? formatDate(_dueDate!) 
                  : 'Not set'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  setState(() => _dueDate = date);
                }
              },
            ),
            
            // Priority selector
            DropdownButtonFormField<TaskPriority>(
              value: _priority,
              decoration: InputDecoration(labelText: 'Priority'),
              items: TaskPriority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _priority = value);
                }
              },
            ),
            
            // Save button
            ElevatedButton(
              onPressed: _saveTask,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final task = Task(
        id: widget.taskId ?? uuid.v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        createdAt: DateTime.now(),
        dueDate: _dueDate,
        priority: _priority,
        tags: _tags,
        subtasks: _subtasks,
      );
      
      final provider = Provider.of<TasksProvider>(context, listen: false);
      
      if (widget.taskId == null) {
        await provider.addTask(task);
      } else {
        await provider.updateTask(widget.taskId!, task);
      }
      
      Navigator.pop(context);
    }
  }
}
```

---

## 🎯 habits_page.dart

**Purpose**: Shows list of habits with tracking interface.

### What It Shows

- List of all habits
- Completion checkboxes for today
- Current streak indicators
- Progress visualization
- Add habit button

### Key Features

```dart
class HabitsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HabitsProvider>(
      builder: (context, habitsProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Habits'),
            subtitle: Text('${habitsProvider.completedToday}/${habitsProvider.totalHabits} completed today'),
          ),
          body: ListView.builder(
            itemCount: habitsProvider.habits.length,
            itemBuilder: (context, index) {
              final habit = habitsProvider.habits[index];
              return HabitCard(
                habit: habit,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/habit/detail',
                    arguments: habit.id,
                  );
                },
                onToggleComplete: () {
                  habitsProvider.completeHabitToday(habit.id);
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/habit/add');
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
```

---

## 📊 habit_detail_page.dart

**Purpose**: Shows detailed statistics and information about a habit.

### What It Shows

- Habit name and description
- Current streak
- Longest streak
- Completion rate (7 days, 30 days)
- Calendar view of completions
- Linked task tags
- Edit and delete buttons

### Visual Elements

- 🔥 Streak counter
- 📈 Progress chart
- 📅 Calendar heatmap
- 🏆 Achievement badges

---

## 📝 notes_page.dart

**Purpose**: Shows list of notes with search and filtering.

### What It Shows

- List of notes (pinned first)
- Search bar
- Tag filters
- Note previews
- Add note button

### Key Features

- 📌 Pinned notes appear at top
- 🎨 Color-coded notes
- 🔍 Search by title or content
- 🏷️ Filter by tags

---

## ✍️ note_page_write.dart

**Purpose**: Create or edit a note.

### What It Shows

- Title field
- Content editor (rich text)
- Color picker
- Tag manager
- Pin toggle
- Save button

---

## ⚙️ settings_page.dart

**Purpose**: App configuration and preferences.

### What It Shows

**Account Section**:
- User profile info
- Email verification status
- Change password
- Sign out button

**Appearance Section**:
- Dark/Light mode toggle
- Language selector (English, French, Arabic)
- Theme customization

**Notifications Section**:
- Enable/disable notifications
- Notification time settings
- Reminder preferences

**Data & Privacy Section**:
- Backup & sync settings
- Export data
- Delete account

**About Section**:
- App version
- Terms & Privacy
- Help & Support
- Rate app

### Key Features

```dart
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          // Account section
          ListTile(
            leading: CircleAvatar(
              child: Text(authProvider.user?.email?[0] ?? 'U'),
            ),
            title: Text(authProvider.user?.email ?? ''),
            subtitle: Text('Account'),
          ),
          
          // Language selector
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            subtitle: Text(languageProvider.languageName),
            onTap: () => _showLanguageDialog(context),
          ),
          
          // Theme toggle
          SwitchListTile(
            title: Text('Dark Mode'),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) {
              // Toggle theme
            },
          ),
          
          // Sign out
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: () async {
              await authProvider.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
```

---

## 🔐 auth/ Subfolder

### login_page.dart

**Purpose**: User login screen.

**Features**:
- Email/password fields
- Login button
- Google Sign-In button
- "Forgot password?" link
- "Sign up" link
- Form validation
- Loading state
- Error messages

### signup_page.dart

**Purpose**: New user registration.

**Features**:
- Email/password fields
- Confirm password field
- Sign up button
- Google Sign-In option
- "Already have account?" link
- Email verification flow
- Password strength indicator
- Terms acceptance checkbox

### forgot_password_page.dart

**Purpose**: Password reset.

**Features**:
- Email field
- "Send reset link" button
- Success confirmation
- Back to login link

### email_verification_page.dart

**Purpose**: Email verification prompt.

**Features**:
- Verification message
- "Resend email" button
- "I've verified" button
- Skip option

---

## 🎓 onboarding/ Subfolder

### onboarding_page.dart

**Purpose**: First-time user introduction.

**Features**:
- Multiple slides introducing app features
- Images/illustrations
- Next/Skip buttons
- Progress dots
- "Get Started" button on last slide

### question_flow_page.dart

**Purpose**: Personalization questions for new users.

**Features**:
- Step-by-step questions
- Multiple choice answers
- Progress indicator
- Back/Next navigation
- Saves preferences for customization

---

## Page Navigation Flow

```
App Start
  ↓
Auth Check
  ├─→ Not Logged In → Login Page
  │                    ├─→ Sign Up Page
  │                    └─→ Forgot Password Page
  │
  └─→ Logged In → Welcome Page
                   ├─→ Todo Page → Task Detail → Task Edit
                   ├─→ Habits Page → Habit Detail
                   ├─→ Notes Page → Note Write
                   ├─→ Reminders Page
                   └─→ Settings Page
                       ├─→ Privacy & Backup
                       ├─→ Help & Support
                       └─→ Terms & Privacy
```

---

## Common Page Patterns

### 1. Loading State
```dart
if (provider.isLoading) {
  return Center(child: CircularProgressIndicator());
}
```

### 2. Empty State
```dart
if (tasks.isEmpty) {
  return EmptyState(
    icon: Icons.task_alt,
    message: 'No tasks yet',
    actionText: 'Add your first task',
    onAction: () => Navigator.pushNamed(context, '/task/add'),
  );
}
```

### 3. Error State
```dart
if (provider.error != null) {
  return ErrorWidget(
    message: provider.error!,
    onRetry: () => provider.reload(),
  );
}
```

### 4. Pull to Refresh
```dart
RefreshIndicator(
  onRefresh: () => provider.loadTasks(),
  child: ListView(...),
);
```

---

## Page Lifecycle

1. **Init**: Load data in initState or Consumer
2. **Build**: Render UI based on current state
3. **Interact**: User taps buttons, edits fields
4. **Update**: Provider updates data
5. **Rebuild**: Consumer rebuilds with new data
6. **Dispose**: Clean up controllers, listeners

---

## For Beginners: Page Best Practices

✅ **DO**:
- Keep pages focused on UI
- Use providers for data
- Extract reusable widgets
- Show loading/error states
- Validate user input

❌ **DON'T**:
- Put business logic in pages
- Duplicate code across pages
- Forget to handle errors
- Block the UI with slow operations

---

## Quick Reference

| Page | Purpose | Main Actions |
|------|---------|--------------|
| **welcome_page** | Home screen | View stats, quick navigation |
| **todo_page** | Task list | View, filter, add tasks |
| **task_detail_page** | Task info | View details, edit, delete |
| **task_edit_page** | Task form | Create/edit task |
| **habits_page** | Habit list | Track, view habits |
| **habit_detail_page** | Habit stats | View progress, edit |
| **notes_page** | Note list | View, search notes |
| **note_page_write** | Note editor | Write/edit note |
| **settings_page** | App config | Change settings, sign out |
| **login_page** | Authentication | Log in, sign up |

---

## Next Steps

Now that you understand pages, check out:
- 🧩 [widgets/ - UI Components](./widgets.md) - See reusable components used in pages
- 🔄 [providers/ - State Management](./providers.md) - See how pages get data
- 🏗️ [Architecture](./architecture.md) - Understand navigation flow

---

**Pages are where users spend their time! 📱**
