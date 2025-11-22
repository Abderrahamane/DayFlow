# 🧩 widgets/ Folder Documentation

## Overview

The `widgets/` folder contains **reusable UI components** that are used across multiple pages in the DayFlow app.

**Think of widgets as LEGO blocks**: Instead of building everything from scratch on each page, you create reusable pieces that can be combined in different ways.

---

## Why Reusable Widgets?

### Benefits:
✅ **DRY Principle** (Don't Repeat Yourself) - Write once, use everywhere
✅ **Consistency** - Same look and behavior across the app
✅ **Maintainability** - Fix a bug once, it's fixed everywhere
✅ **Readability** - Cleaner, more organized code
✅ **Testability** - Test components independently

### Example:
**❌ Without reusable widgets:**
```dart
// In todo_page.dart
Container(
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(/*...*/),
  child: Row(/*...*/),  // 50 lines of task card code
)

// In task_detail_page.dart
Container(
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(/*...*/),  // Duplicate code!
  child: Row(/*...*/),  // Another 50 lines!
)
```

**✅ With reusable widgets:**
```dart
// In both pages:
TaskCard(task: task, onTap: () {/*...*/})  // Clean and simple!
```

---

## Files in widgets/

```
widgets/
├── task_card.dart          # Display a single task
├── task_item.dart          # Simpler task display
├── task_filter_bar.dart    # Task filtering UI
├── habit_card.dart         # Display a single habit
├── note_item.dart          # Display a single note
├── custom_button.dart      # Styled buttons
├── custom_input.dart       # Styled text fields
├── custom_card.dart        # Styled card container
├── app_drawer.dart         # Side navigation menu
├── bottom_nav_bar.dart     # Bottom navigation
├── date_time_picker.dart   # Date/time selection
├── modal_sheet.dart        # Bottom sheet modal
├── quote_card.dart         # Motivational quotes
└── ui_kit.dart            # UI component library
```

---

## 📋 task_card.dart

**Purpose**: Display a task in a list with all key information and actions.

### What It Shows

- Task title
- Description (if exists)
- Due date
- Priority indicator (color-coded)
- Completion checkbox
- Progress bar (if has subtasks)
- Tags

### Usage

```dart
TaskCard(
  task: task,
  onTap: () {
    Navigator.pushNamed(context, '/task/detail', arguments: task.id);
  },
  onToggleComplete: () {
    tasksProvider.toggleTaskCompletion(task.id);
  },
  onDelete: () {
    tasksProvider.deleteTask(task.id);
  },
)
```

### Visual Structure

```
┌─────────────────────────────────────────┐
│ ○ Task Title             [Priority] 🔴  │
│   Description text                      │
│   📅 Due: Jan 15, 2024                  │
│   ■■■■■□□□ 5/8 subtasks                 │
│   🏷️ work  🏷️ urgent                    │
└─────────────────────────────────────────┘
```

### Key Features

- **Checkbox**: Circle that fills when complete
- **Priority Color**: Border/accent color based on priority
  - 🔴 High = Red
  - 🟡 Medium = Yellow
  - 🔵 Low = Blue
- **Swipe Actions**: Swipe left to delete
- **Tap**: Opens task detail page

### Code Structure

```dart
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;
  final VoidCallback? onDelete;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getPriorityColor(task.priority),
            width: 2,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Checkbox
                  GestureDetector(
                    onTap: onToggleComplete,
                    child: Icon(
                      task.isCompleted 
                          ? Icons.check_circle 
                          : Icons.circle_outlined,
                    ),
                  ),
                  SizedBox(width: 12),
                  
                  // Title
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted 
                            ? TextDecoration.lineThrough 
                            : null,
                      ),
                    ),
                  ),
                  
                  // Priority badge
                  _PriorityBadge(priority: task.priority),
                ],
              ),
              
              // Description
              if (task.description != null)
                Text(task.description!, maxLines: 2),
              
              // Due date
              if (task.dueDate != null)
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16),
                    Text('Due: ${formatDate(task.dueDate!)}'),
                  ],
                ),
              
              // Progress (subtasks)
              if (task.subtasks != null && task.subtasks!.isNotEmpty)
                LinearProgressIndicator(value: task.progress),
              
              // Tags
              if (task.tags != null)
                Wrap(
                  children: task.tags!.map((tag) => 
                    Chip(label: Text(tag))
                  ).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🎯 habit_card.dart

**Purpose**: Display a habit with completion tracking and streak info.

### What It Shows

- Habit icon (emoji)
- Habit name
- Frequency (daily, weekly)
- Current streak 🔥
- Completion checkbox for today
- Progress indicator

### Usage

```dart
HabitCard(
  habit: habit,
  onTap: () {
    Navigator.pushNamed(context, '/habit/detail', arguments: habit.id);
  },
  onToggleComplete: () {
    habitsProvider.completeHabitToday(habit.id);
  },
)
```

### Visual Structure

```
┌─────────────────────────────────────────┐
│ 💪 Exercise                         ☑️  │
│ Daily • 5 times per week                │
│ 🔥 7 day streak                         │
│ ▓▓▓▓▓▓▓░ 7/7 this week                  │
└─────────────────────────────────────────┘
```

### Key Features

- **Icon**: Large emoji or icon
- **Streak Fire**: 🔥 appears when streak > 0
- **Weekly Progress**: Bar showing completions this week
- **Color Coding**: Each habit has custom color
- **Check Today**: Toggle to mark today as complete

---

## 📝 note_item.dart

**Purpose**: Display a note in a list.

### What It Shows

- Note title
- Content preview (first few lines)
- Created/updated date
- Color background
- Pin indicator
- Tags

### Usage

```dart
NoteItem(
  note: note,
  onTap: () {
    Navigator.pushNamed(context, '/note/edit', arguments: note);
  },
  onPin: () {
    notesProvider.togglePin(note.id);
  },
  onDelete: () {
    notesProvider.deleteNote(note.id);
  },
)
```

### Visual Structure

```
┌─────────────────────────────────────────┐
│ 📌 Meeting Notes              [Edit] 🗑️ │
│ Discussion about Q1 goals...            │
│ 🏷️ work  🏷️ important                   │
│ Updated: 2 hours ago                    │
└─────────────────────────────────────────┘
```

---

## 🎨 custom_button.dart

**Purpose**: Styled button component with consistent design.

### Button Variants

1. **Primary Button** (filled, main actions)
2. **Secondary Button** (outlined, secondary actions)
3. **Text Button** (no background, tertiary actions)
4. **Icon Button** (icon only)

### Usage

```dart
CustomButton.primary(
  text: 'Save',
  onPressed: () {/*...*/},
  icon: Icons.save,
  isLoading: isSubmitting,
)

CustomButton.secondary(
  text: 'Cancel',
  onPressed: () {/*...*/},
)

CustomButton.text(
  text: 'Skip',
  onPressed: () {/*...*/},
)
```

### Features

- Loading state (shows spinner)
- Disabled state
- Icon support
- Full width option
- Custom colors

---

## 📝 custom_input.dart

**Purpose**: Styled text input field with validation.

### Input Types

1. **Text Input** (single line)
2. **Multiline Input** (textarea)
3. **Password Input** (hidden text)
4. **Email Input** (with validation)
5. **Number Input** (numeric keyboard)

### Usage

```dart
CustomInput(
  label: 'Task Title',
  hint: 'Enter task name',
  controller: titleController,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    return null;
  },
  required: true,
)

CustomInput.password(
  label: 'Password',
  controller: passwordController,
  showToggle: true,  // Show/hide password
)

CustomInput.multiline(
  label: 'Description',
  controller: descController,
  maxLines: 5,
)
```

### Features

- Label and hint text
- Validation with error messages
- Required indicator (*)
- Character counter
- Prefix/suffix icons
- Clear button

---

## 📄 custom_card.dart

**Purpose**: Styled card container for grouping content.

### Usage

```dart
CustomCard(
  title: 'Statistics',
  child: Column(
    children: [
      Text('Total Tasks: 42'),
      Text('Completed: 28'),
    ],
  ),
)
```

### Features

- Optional title
- Optional subtitle
- Padding and margins
- Elevation/shadow
- Rounded corners
- Tap action

---

## 🗂️ app_drawer.dart

**Purpose**: Side navigation menu (hamburger menu).

### What It Shows

- User profile header
  - Avatar
  - Name
  - Email
- Navigation items:
  - 🏠 Home
  - ✅ Tasks
  - 🎯 Habits
  - 📝 Notes
  - ⏰ Reminders
  - ⚙️ Settings
  - ❓ Help
  - 🚪 Sign Out

### Usage

```dart
Scaffold(
  drawer: AppDrawer(),
  body: /*...*/,
)
```

### Code Structure

```dart
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    
    return Drawer(
      child: ListView(
        children: [
          // Header with user info
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'User'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              child: Text(user?.email?[0] ?? 'U'),
            ),
          ),
          
          // Navigation items
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          
          ListTile(
            leading: Icon(Icons.task_alt),
            title: Text('Tasks'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/tasks');
            },
          ),
          
          // ... more items
          
          Divider(),
          
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: () async {
              await Provider.of<AuthProvider>(context, listen: false).signOut();
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

## 📱 bottom_nav_bar.dart

**Purpose**: Bottom navigation bar for main app sections.

### What It Shows

- 4-5 navigation items with icons
- Current page indicator
- Badge for notifications

### Usage

```dart
Scaffold(
  body: pages[currentIndex],
  bottomNavigationBar: BottomNavBar(
    currentIndex: currentIndex,
    onTap: (index) {
      setState(() => currentIndex = index);
    },
  ),
)
```

### Navigation Items

1. 🏠 Home
2. ✅ Tasks
3. 🎯 Habits
4. 📝 Notes
5. ⚙️ Settings

---

## 📅 date_time_picker.dart

**Purpose**: Custom date and time picker widget.

### Usage

```dart
DateTimePicker(
  label: 'Due Date',
  initialDate: DateTime.now(),
  onDateSelected: (date) {
    setState(() => selectedDate = date);
  },
  onTimeSelected: (time) {
    setState(() => selectedTime = time);
  },
)
```

### Features

- Date picker dialog
- Time picker dialog
- Combined date+time
- Min/max date constraints
- Clear button

---

## 📱 modal_sheet.dart

**Purpose**: Bottom sheet modal for actions/forms.

### Usage

```dart
showModalBottomSheet(
  context: context,
  builder: (context) => ModalSheet(
    title: 'Add Task',
    child: TaskForm(),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          // Save and close
        },
        child: Text('Save'),
      ),
    ],
  ),
);
```

### Common Uses

- Quick add forms
- Filter/sort menus
- Action lists
- Confirmations

---

## 💬 quote_card.dart

**Purpose**: Display motivational quotes.

### Usage

```dart
QuoteCard(
  quote: "The secret of getting ahead is getting started.",
  author: "Mark Twain",
)
```

### Features

- Random quotes
- Beautiful styling
- Share button
- Refresh for new quote

---

## 🎨 ui_kit.dart

**Purpose**: Collection of common UI patterns and components.

### Contains

- Empty state widgets
- Error widgets
- Loading indicators
- Success/error messages
- Confirmation dialogs
- Info banners
- Stats cards
- Progress indicators

### Usage

```dart
// Empty state
UIKit.emptyState(
  icon: Icons.task_alt,
  title: 'No tasks yet',
  message: 'Add your first task to get started',
  action: UIKit.button(
    text: 'Add Task',
    onPressed: () {/*...*/},
  ),
)

// Loading
UIKit.loading(message: 'Loading tasks...')

// Error
UIKit.error(
  message: 'Failed to load tasks',
  onRetry: () {/*...*/},
)
```

---

## Widget Composition

Widgets are often composed together:

```dart
// Example: Task Detail Page Layout
Scaffold(
  appBar: AppBar(/*...*/),
  drawer: AppDrawer(),  // Reusable drawer
  body: SingleChildScrollView(
    child: Column(
      children: [
        TaskCard(task: task),  // Reusable task display
        CustomCard(  // Reusable card
          title: 'Subtasks',
          child: SubtaskList(/*...*/),
        ),
        CustomButton.primary(  // Reusable button
          text: 'Mark Complete',
          onPressed: () {/*...*/},
        ),
      ],
    ),
  ),
  bottomNavigationBar: BottomNavBar(/*...*/),  // Reusable nav
)
```

---

## Widget Best Practices

### ✅ DO:

1. **Keep widgets focused**
   ```dart
   // Good: Single responsibility
   class TaskTitle extends StatelessWidget {
     final String title;
     final bool isCompleted;
     // Just renders title with styling
   }
   ```

2. **Use const constructors**
   ```dart
   const CustomButton(text: 'Click me');  // Better performance
   ```

3. **Extract complex logic**
   ```dart
   // Extract to method
   Color _getPriorityColor() {
     switch (priority) {
       case TaskPriority.high: return Colors.red;
       // ...
     }
   }
   ```

4. **Make widgets configurable**
   ```dart
   CustomButton({
     required this.text,
     this.icon,  // Optional
     this.color,  // Optional
     this.onPressed,  // Optional (can be disabled)
   });
   ```

### ❌ DON'T:

1. **Don't put business logic in widgets**
   ```dart
   // Bad: Business logic in widget
   onPressed: () {
     // Calculate complex things
     // Update database
     // Call APIs
   }
   
   // Good: Delegate to provider
   onPressed: () => provider.handleAction();
   ```

2. **Don't make widgets too large**
   ```dart
   // Bad: 500 line widget
   class GiantWidget extends StatelessWidget {
     // Too much code
   }
   
   // Good: Break into smaller pieces
   class ParentWidget extends StatelessWidget {
     Widget build(context) => Column(
       children: [
         HeaderWidget(),
         ContentWidget(),
         FooterWidget(),
       ],
     );
   }
   ```

---

## Creating Your Own Widget

### Basic Template

```dart
import 'package:flutter/material.dart';

class MyCustomWidget extends StatelessWidget {
  // 1. Define properties
  final String title;
  final VoidCallback? onTap;
  final IconData? icon;
  
  // 2. Constructor
  const MyCustomWidget({
    Key? key,
    required this.title,
    this.onTap,
    this.icon,
  }) : super(key: key);
  
  // 3. Build method
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (icon != null) Icon(icon),
            if (icon != null) SizedBox(width: 12),
            Text(title),
          ],
        ),
      ),
    );
  }
}
```

### Stateful Widget Template

```dart
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);
  
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // State variables
  bool _isExpanded = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _isExpanded ? 200 : 100,
        child: /*...*/,
      ),
    );
  }
}
```

---

## For Beginners: Understanding Widgets

**Q: When should I create a new widget?**
A: Create a new widget when:
- You need to use the same UI in multiple places
- A section of your code is getting too long
- You want to make your code more organized

**Q: StatelessWidget vs StatefulWidget?**
A:
- **StatelessWidget**: Doesn't change (static)
- **StatefulWidget**: Can change over time (dynamic)

**Q: How do I pass data to widgets?**
A: Through constructor parameters:
```dart
MyWidget(
  title: 'Hello',
  count: 42,
  onTap: () {/*...*/},
)
```

**Q: How do I get data from widgets?**
A: Through callbacks:
```dart
// Parent passes callback
MyWidget(
  onDataChanged: (newData) {
    // Parent receives data here
  },
)

// Child calls callback
widget.onDataChanged('new value');
```

---

## Quick Reference

| Widget | Purpose | Key Props |
|--------|---------|-----------|
| **TaskCard** | Display task | task, onTap, onToggleComplete |
| **HabitCard** | Display habit | habit, onTap, onToggleComplete |
| **NoteItem** | Display note | note, onTap, onPin, onDelete |
| **CustomButton** | Styled button | text, onPressed, icon, isLoading |
| **CustomInput** | Text field | label, controller, validator |
| **AppDrawer** | Side menu | - (uses providers) |
| **BottomNavBar** | Bottom nav | currentIndex, onTap |
| **DateTimePicker** | Date/time | onDateSelected, onTimeSelected |

---

## Next Steps

Now that you understand widgets, check out:
- 📱 [pages/ - App Screens](./pages.md) - See how widgets are used
- 🏗️ [Architecture](./architecture.md) - Understand component structure

---

**Widgets are your building blocks! 🧱**
