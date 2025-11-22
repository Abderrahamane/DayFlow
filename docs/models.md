# 📦 models/ Folder Documentation

## Overview

The `models/` folder contains **data models** — blueprints that define the structure of data in the DayFlow app.

**Think of models as forms or templates**: Just like a form has specific fields (name, address, phone), a model defines what information each type of data should have.

---

## What Are Models?

Models are Dart classes that represent real-world objects in your app. They:
- Define what data each object contains
- Provide methods to convert data to/from JSON (for storage)
- Include helper methods for calculations
- Ensure data consistency

**Real-world analogy**: If you have a recipe card, the "recipe template" is the model, and each actual recipe (chocolate cake, apple pie) is an instance of that model.

---

## Files in models/

```
models/
├── task_model.dart     # Defines the structure of a Task/To-Do
├── habit_model.dart    # Defines the structure of a Habit
└── note_model.dart     # Defines the structure of a Note
```

---

## 📝 task_model.dart

**Purpose**: Defines what a task (to-do item) looks like and how it behaves.

### What's Inside a Task?

Every task in DayFlow has these properties:

```dart
class Task {
  final String id;                // Unique identifier (e.g., "task123")
  final String title;             // Task name (e.g., "Buy groceries")
  final String? description;      // Optional details
  final bool isCompleted;         // Is it done? true/false
  final DateTime createdAt;       // When was it created?
  final DateTime? dueDate;        // When is it due? (optional)
  final TaskPriority priority;    // How important? (none/low/medium/high)
  final List<String>? tags;       // Categories (e.g., ["work", "urgent"])
  final List<Subtask>? subtasks;  // Smaller tasks within this task
}
```

### Task Priority Levels

Tasks can have different priority levels:

```dart
enum TaskPriority {
  none,    // No specific priority
  low,     // Can wait
  medium,  // Important but not urgent
  high     // Urgent and important
}
```

**Visual representation**:
- 🔴 High priority → Red color
- 🟡 Medium priority → Yellow color
- 🔵 Low priority → Blue color
- ⚪ No priority → Gray color

### Subtasks

A task can have smaller tasks (subtasks) within it:

```dart
class Subtask {
  final String id;
  final String title;
  final bool isCompleted;
}
```

**Example**:
```
Task: "Prepare presentation"
  ├─ Subtask 1: "Research topic" ✅ (completed)
  ├─ Subtask 2: "Create slides" ✅ (completed)
  └─ Subtask 3: "Practice delivery" ☐ (not completed)
```

### Useful Methods

#### Check if Task is Overdue
```dart
bool get isOverdue {
  if (dueDate == null || isCompleted) return false;
  return dueDate!.isBefore(DateTime.now());
}
```

#### Calculate Progress (for subtasks)
```dart
double get progress {
  if (subtasks == null || subtasks!.isEmpty) {
    return isCompleted ? 1.0 : 0.0;
  }
  
  int completed = subtasks!.where((s) => s.isCompleted).length;
  return completed / subtasks!.length;
}
```

**Example**: If you have 4 subtasks and 3 are completed, progress = 3/4 = 0.75 (75%)

#### Copy with Changes
```dart
Task copyWith({
  String? title,
  bool? isCompleted,
  // ... other fields
}) {
  return Task(
    id: this.id,
    title: title ?? this.title,  // Use new title, or keep current
    isCompleted: isCompleted ?? this.isCompleted,
    // ... other fields
  );
}
```

**Why is this useful?** In Dart, models are usually immutable (can't be changed). To "update" a task, you create a new one with some fields changed.

**Example usage**:
```dart
// Mark task as completed
Task updatedTask = oldTask.copyWith(isCompleted: true);
```

### Saving Tasks (JSON Serialization)

To save tasks to Firebase or local storage, we convert them to JSON:

```dart
Map<String, dynamic> toJson() {
  return {
    'id': id,
    'title': title,
    'description': description,
    'isCompleted': isCompleted,
    'createdAt': createdAt.toIso8601String(),
    'dueDate': dueDate?.toIso8601String(),
    'priority': priority.name,
    'tags': tags,
    'subtasks': subtasks?.map((s) => s.toJson()).toList(),
  };
}
```

And to load from JSON:
```dart
factory Task.fromJson(Map<String, dynamic> json) {
  return Task(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    isCompleted: json['isCompleted'] ?? false,
    createdAt: DateTime.parse(json['createdAt']),
    dueDate: json['dueDate'] != null 
        ? DateTime.parse(json['dueDate']) 
        : null,
    priority: TaskPriority.values.byName(json['priority'] ?? 'medium'),
    tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    subtasks: json['subtasks'] != null
        ? (json['subtasks'] as List).map((s) => Subtask.fromJson(s)).toList()
        : null,
  );
}
```

### Task Filtering

DayFlow supports different ways to filter tasks:

```dart
enum TaskFilter {
  all,        // Show all tasks
  completed,  // Only show completed tasks
  pending,    // Only show incomplete tasks
  overdue,    // Only show overdue tasks
  today       // Only show tasks due today
}
```

### Task Sorting

Tasks can be sorted in different ways:

```dart
enum TaskSort {
  dateCreated,    // Newest first
  dueDate,        // Closest deadline first
  priority,       // Highest priority first
  alphabetical    // A to Z
}
```

---

## 🎯 habit_model.dart

**Purpose**: Defines the structure of habits that users want to build.

### What's Inside a Habit?

```dart
class Habit {
  final String id;                          // Unique identifier
  final String name;                        // Habit name (e.g., "Exercise")
  final String? description;                // Optional details
  final String icon;                        // Emoji or icon (e.g., "💪")
  final HabitFrequency frequency;           // daily/weekly/custom
  final int goalCount;                      // Target (e.g., 5 times per week)
  final List<String> linkedTaskTags;        // Auto-complete from tasks
  final Map<String, bool> completionHistory; // Track each day's completion
  final DateTime createdAt;                 // When habit was created
  final Color color;                        // Visual color for the habit
}
```

### Habit Frequency

How often should the habit be done?

```dart
enum HabitFrequency {
  daily,    // Every day
  weekly,   // Multiple times per week
  custom    // User-defined schedule
}
```

### Completion History

Habits track completion for each day:

```dart
Map<String, bool> completionHistory = {
  '2024-01-15': true,   // ✅ Completed on Jan 15
  '2024-01-16': false,  // ❌ Missed on Jan 16
  '2024-01-17': true,   // ✅ Completed on Jan 17
};
```

### Powerful Habit Methods

#### Check if Completed Today
```dart
bool get isCompletedToday {
  final today = getDateKey(DateTime.now());
  return completionHistory[today] ?? false;
}
```

#### Calculate Current Streak
```dart
int get currentStreak {
  int streak = 0;
  DateTime date = DateTime.now();
  
  while (true) {
    final dateKey = getDateKey(date);
    if (completionHistory[dateKey] == true) {
      streak++;
      date = date.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }
  
  return streak;
}
```

**Example**: If you completed the habit for the last 5 days in a row, `currentStreak` returns 5. 🔥

#### Calculate Longest Streak
```dart
int get longestStreak {
  // Finds the longest consecutive completion streak ever
  // Example: If your best run was 14 days, this returns 14
}
```

#### Get Completion Rate
```dart
double getCompletionRate(int days) {
  int completed = 0;
  final now = DateTime.now();
  
  for (int i = 0; i < days; i++) {
    final date = now.subtract(Duration(days: i));
    final dateKey = getDateKey(date);
    if (completionHistory[dateKey] == true) {
      completed++;
    }
  }
  
  return days > 0 ? (completed / days) * 100 : 0;
}
```

**Example**: `habit.getCompletionRate(7)` returns the percentage of days you completed the habit in the last week.

#### This Week's Progress
```dart
int get thisWeekCompletions {
  // Counts how many days this week you completed the habit
  // Example: If you completed it Mon, Wed, Fri → returns 3
}
```

#### Total Completions
```dart
int get totalCompletions {
  return completionHistory.values.where((completed) => completed).length;
}
```

### Linked Task Tags

Habits can be linked to task tags for automatic completion:

**Example**:
- Habit: "Exercise" with linkedTaskTags: `["workout", "gym"]`
- When you complete a task tagged "workout" or "gym", the habit can auto-mark as completed

This creates a powerful connection between tasks and habits! 🔗

### Date Helper
```dart
static String getDateKey(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}
```

Converts a date to a string key like "2024-01-15" for easy storage.

---

## 📒 note_model.dart

**Purpose**: Defines the structure of quick notes users can take.

### What's Inside a Note?

```dart
class Note {
  String title;                    // Note title
  String content;                  // Note content/body
  final DateTime? createdAt;       // When created
  DateTime? updatedAt;             // Last edited time
  final Color? color;              // Visual color for the note
  final List<String>? tags;        // Categories for organization
  bool isPinned;                   // Pin to top of list?
  
  // Callback functions for actions
  VoidCallback? onTap;             // When note is tapped
  final VoidCallback? onEdit;      // When edit button pressed
  VoidCallback? onDelete;          // When delete button pressed
  final VoidCallback? onPin;       // When pin button pressed
}
```

### Note Features

#### Pinning
Important notes can be pinned to the top:
```dart
note.isPinned = true;  // This note stays at the top
```

#### Color Coding
Notes can have different colors for visual organization:
```dart
Note blueNote = Note(
  title: "Meeting notes",
  content: "...",
  color: Colors.blue,
);
```

#### Tags for Organization
Categorize notes with tags:
```dart
Note workNote = Note(
  title: "Project ideas",
  content: "...",
  tags: ["work", "brainstorming", "Q1-2024"],
);
```

You can filter notes by tags later!

#### Timestamps
Track when notes are created and modified:
```dart
createdAt: DateTime.now(),        // Note creation time
updatedAt: DateTime.now(),        // Last edit time
```

---

## How Models Work Together

Here's how the three models interact in the app:

```
User creates a TASK: "Go to gym" with tag "workout"
    ↓
HABIT: "Exercise" is linked to tag "workout"
    ↓
When task is completed → Habit automatically gets credit!
    ↓
User takes a NOTE: "Workout routine" with tag "fitness"
    ↓
All three are connected through tags and provide a complete productivity system
```

---

## Model Design Principles

### 1. Immutability
Most fields are `final`, meaning they can't be changed after creation. To "update", you create a new instance with `copyWith()`.

**Why?**
- Prevents accidental changes
- Makes state management predictable
- Easier to debug

### 2. Null Safety
Dart's null safety is used throughout:
- Required fields: `String title` (must have a value)
- Optional fields: `String? description` (can be null)

### 3. JSON Serialization
Every model can convert to/from JSON for storage:
- `toJson()` → Save to database
- `fromJson()` → Load from database
- `toFirestore()` → Save to Firebase
- `fromFirestore()` → Load from Firebase

### 4. Helper Methods
Models include useful computed properties:
- `task.isOverdue` - Check if task is past due
- `habit.currentStreak` - Get current streak count
- `task.progress` - Calculate completion percentage

---

## Common Patterns

### Creating a New Task
```dart
Task newTask = Task(
  id: uuid.v4(),  // Generate unique ID
  title: 'Buy groceries',
  description: 'Milk, eggs, bread',
  isCompleted: false,
  createdAt: DateTime.now(),
  dueDate: DateTime.now().add(Duration(days: 1)),
  priority: TaskPriority.medium,
  tags: ['shopping', 'home'],
);
```

### Updating a Task
```dart
Task updatedTask = existingTask.copyWith(
  isCompleted: true,
  // Other fields stay the same
);
```

### Creating a New Habit
```dart
Habit exerciseHabit = Habit(
  id: uuid.v4(),
  name: 'Daily Exercise',
  description: '30 minutes of physical activity',
  icon: '💪',
  frequency: HabitFrequency.daily,
  goalCount: 7,  // 7 times per week
  linkedTaskTags: ['workout', 'gym', 'exercise'],
  createdAt: DateTime.now(),
  color: Colors.green,
);
```

### Completing a Habit for Today
```dart
String today = Habit.getDateKey(DateTime.now());
Map<String, bool> updatedHistory = Map.from(habit.completionHistory);
updatedHistory[today] = true;

Habit completedHabit = habit.copyWith(
  completionHistory: updatedHistory,
);
```

---

## For Beginners: Understanding Models

**Q: Why do we need models?**
A: Models provide structure and consistency. Without them, data could be messy and inconsistent across the app.

**Q: What's the difference between a model and a provider?**
A: 
- **Model** = What the data looks like (blueprint)
- **Provider** = Manages multiple instances of that data (manager)

**Q: Why are models immutable?**
A: It makes the app more predictable and prevents bugs. Instead of changing data, we create new versions.

**Q: What's JSON serialization?**
A: Converting data to/from a text format that can be saved to a database or file.

---

## Quick Reference

| Model | Purpose | Key Properties | Key Methods |
|-------|---------|----------------|-------------|
| **Task** | To-do items | title, dueDate, priority, subtasks | isOverdue, progress, copyWith |
| **Habit** | Habit tracking | name, frequency, completionHistory | currentStreak, longestStreak, getCompletionRate |
| **Note** | Quick notes | title, content, tags, isPinned | (actions through callbacks) |

---

## Next Steps

Now that you understand models, check out:
- 🔄 [providers/ - State Management](./providers.md) - See how models are used
- 🛠️ [services/ - External Services](./services.md) - See how models are saved/loaded
- 📱 [pages/ - App Screens](./pages.md) - See how models are displayed

---

**Models are the foundation of your app's data! 🏗️**
