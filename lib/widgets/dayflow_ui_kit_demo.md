# Shared UI Kit & Components Implementation Guide

##  Implementation Complete

A complete, reusable UI component library for the DayFlow app with:

- Custom buttons (primary, secondary, outlined, text, icon)
- Input fields (text, password, email, number, multiline, search)
- Card components (basic, info, stat)
- TaskItem with priority, due dates, and actions
- NoteItem with tags, pins, and timestamps
- Modal bottom sheets (basic, form, list, confirmation)
- Date/Time picker wrappers with custom styling
- Consistent theming across all components

---

##  File Structure

```
lib/widgets/
├── ui_kit.dart                    # Central export file
├── custom_button.dart             # Button components
├── custom_input.dart              # Input field components
├── custom_card.dart               # Card components
├── task_item.dart                 # Task display widget
├── note_item.dart                 # Note display widget
├── modal_sheet.dart               # Modal bottom sheet components
└── date_time_picker.dart          # Date/Time picker wrappers
```

---

##  Quick Start

### Import the UI Kit

```dart
import 'package:dayflow/widgets/ui_kit.dart';
```

This single import gives you access to all UI components!

---

## Component Documentation

### 1. Buttons

#### CustomButton
Full-featured button with multiple variants and states.

```dart
// Primary button
CustomButton(
  text: 'Save Task',
  type: ButtonType.primary,
  size: ButtonSize.large,
  icon: Icons.save,
  onPressed: () {
    // Your action
  },
);

// Secondary button
CustomButton(
  text: 'Archive',
  type: ButtonType.secondary,
  onPressed: () {},
);

// Outlined button
CustomButton(
  text: 'Cancel',
  type: ButtonType.outlined,
  onPressed: () {},
);

// Text button
CustomButton(
  text: 'Skip',
  type: ButtonType.text,
  onPressed: () {},
);

// Loading state
CustomButton(
  text: 'Saving...',
  isLoading: true,
  onPressed: () {},
);

// Disabled state
CustomButton(
  text: 'Submit',
  onPressed: null, // null makes it disabled
);
```

**Properties:**
- `text` (required): Button label
- `onPressed`: Callback function
- `type`: ButtonType.primary | secondary | outlined | text
- `size`: ButtonSize.small | medium | large
- `icon`: Optional icon
- `isLoading`: Shows loading spinner
- `width`: Custom width (default: auto)

#### CustomIconButton
Compact icon button with tooltip support.

```dart
CustomIconButton(
  icon: Icons.edit,
  onPressed: () {},
  tooltip: 'Edit',
  color: Colors.blue,
  size: 48,
);
```

---

### 2. Input Fields

#### CustomInput
Versatile input field with multiple types and validation.

```dart
// Text input
CustomInput(
  label: 'Task Title',
  hint: 'Enter task title',
  type: InputType.text,
  prefixIcon: Icons.task,
  controller: _titleController,
  onChanged: (value) {
    print('Changed: $value');
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    }
    return null;
  },
);

// Password input (with show/hide toggle)
CustomInput(
  label: 'Password',
  type: InputType.password,
  prefixIcon: Icons.lock,
);

// Email input
CustomInput(
  label: 'Email',
  type: InputType.email,
  prefixIcon: Icons.email,
);

// Multiline input
CustomInput(
  label: 'Description',
  type: InputType.multiline,
  maxLines: 5,
);

// With character limit
CustomInput(
  label: 'Title',
  maxLength: 50,
);
```

**Input Types:**
- `InputType.text`: Standard text
- `InputType.password`: Auto-hide with toggle
- `InputType.email`: Email keyboard
- `InputType.number`: Numeric keyboard
- `InputType.multiline`: Multi-line text area
- `InputType.search`: Search field

#### SearchInput
Dedicated search field with clear button.

```dart
SearchInput(
  hint: 'Search tasks...',
  controller: _searchController,
  onChanged: (value) {
    // Perform search
  },
  onClear: () {
    // Handle clear
  },
);
```

---

### 3. Cards

#### CustomCard
Basic card container with tap support.

```dart
CustomCard(
  padding: EdgeInsets.all(20),
  margin: EdgeInsets.symmetric(vertical: 8),
  elevation: 2,
  onTap: () {
    // Card tapped
  },
  child: Column(
    children: [
      Text('Card Title'),
      Text('Card content...'),
    ],
  ),
);
```

#### InfoCard
Card with icon, title, and subtitle.

```dart
InfoCard(
  title: 'Productivity Tips',
  subtitle: 'Learn how to be more efficient',
  icon: Icons.lightbulb,
  iconColor: Colors.amber,
  onTap: () {},
);
```

#### StatCard
Display statistics with icon and value.

```dart
StatCard(
  label: 'Completed Tasks',
  value: '24',
  icon: Icons.check_circle,
  color: Colors.green,
);
```

---

### 4. TaskItem

Complete task display with priority, due dates, and actions.

```dart
TaskItem(
  title: 'Complete project documentation',
  description: 'Write comprehensive docs for the new API',
  isCompleted: false,
  priority: TaskPriority.high,
  dueDate: DateTime.now().add(Duration(days: 2)),
  category: 'Work',
  onTap: () {
    // View task details
  },
  onToggleComplete: () {
    // Toggle completion
  },
  onEdit: () {
    // Edit task
  },
  onDelete: () {
    // Delete task
  },
);
```

**Features:**
- Checkbox for completion status
- Priority badges (low, medium, high) with colors
- Due date display with "Today", "Tomorrow", "Overdue"
- Category tags
- Action menu (edit, delete)
- Strike-through for completed tasks
- Visual indicators for overdue tasks

**Priority Levels:**
- `TaskPriority.low` - Green badge
- `TaskPriority.medium` - Orange badge
- `TaskPriority.high` - Red badge

---

### 5. NoteItem

Note display with tags, pins, and timestamps.

```dart
NoteItem(
  title: 'Meeting Notes - Q4 Planning',
  content: 'Discussed project timeline, resource allocation...',
  createdAt: DateTime.now().subtract(Duration(hours: 2)),
  updatedAt: DateTime.now(),
  color: Colors.blue,
  tags: ['work', 'meeting', 'important'],
  isPinned: true,
  onTap: () {
    // View note
  },
  onEdit: () {},
  onDelete: () {},
  onPin: () {
    // Toggle pin
  },
);
```

**Features:**
- Left border with custom color
- Pin indicator
- Content preview (3 lines max)
- Tag display (up to 3 tags)
- Relative timestamps ("2h ago", "Yesterday")
- Action menu (pin, edit, delete)

#### NoteItemCompact
Compact version for grid layouts.

```dart
NoteItemCompact(
  title: 'Quick Idea',
  content: 'Build a feature for task templates...',
  color: Colors.purple.withOpacity(0.2),
  onTap: () {},
);
```

---

### 6. Modal Bottom Sheets

#### Basic Modal
```dart
CustomModalSheet.show(
  context: context,
  title: 'Add New Task',
  child: Column(
    children: [
      CustomInput(label: 'Title', hint: 'Enter title'),
      SizedBox(height: 16),
      CustomButton(
        text: 'Create',
        onPressed: () {
          // Save and close
          Navigator.pop(context);
        },
      ),
    ],
  ),
);
```

#### Form Modal
```dart
final result = await CustomModalSheet.showForm(
  context: context,
  title: 'Edit Task',
  child: Column(
    children: [
      CustomInput(label: 'Title', controller: titleController),
      SizedBox(height: 16),
      CustomInput(label: 'Description', type: InputType.multiline),
    ],
  ),
  confirmText: 'Save Changes',
  cancelText: 'Discard',
  onConfirm: () {
    // Save changes
  },
);

if (result == true) {
  // User confirmed
}
```

#### List Selection Modal
```dart
final selectedPriority = await CustomModalSheet.showListSelection<TaskPriority>(
  context: context,
  title: 'Select Priority',
  items: TaskPriority.values,
  itemBuilder: (priority) => priority.name.toUpperCase(),
  iconBuilder: (priority) => Icons.flag,
  selectedItem: currentPriority,
);

if (selectedPriority != null) {
  // Use selected priority
}
```

#### Confirmation Modal
```dart
final confirmed = await CustomModalSheet.showConfirmation(
  context: context,
  title: 'Delete Task',
  message: 'This action cannot be undone. Are you sure?',
  confirmText: 'Delete',
  cancelText: 'Cancel',
  isDangerous: true,
);

if (confirmed == true) {
  // Delete task
}
```

#### Quick Action Sheet
```dart
QuickActionSheet.show(
  context: context,
  title: 'Quick Actions',
  actions: [
    QuickAction(
      title: 'Add Task',
      subtitle: 'Create a new task',
      icon: Icons.add_task,
      color: Colors.blue,
      onTap: () {
        // Add task logic
      },
    ),
    QuickAction(
      title: 'Add Note',
      subtitle: 'Jot down a quick note',
      icon: Icons.note_add,
      color: Colors.purple,
      onTap: () {
        // Add note logic
      },
    ),
  ],
);
```

---

### 7. Date/Time Pickers

#### DatePickerField
```dart
DatePickerField(
  label: 'Due Date',
  hint: 'Select due date',
  prefixIcon: Icons.calendar_today,
  initialDate: DateTime.now(),
  firstDate: DateTime.now(),
  lastDate: DateTime.now().add(Duration(days: 365)),
  onChanged: (date) {
    print('Selected date: $date');
  },
);
```

#### TimePickerField
```dart
TimePickerField(
  label: 'Reminder Time',
  hint: 'Select time',
  prefixIcon: Icons.access_time,
  initialTime: TimeOfDay.now(),
  onChanged: (time) {
    print('Selected time: $time');
  },
);
```

#### DateTimePickerField
```dart
DateTimePickerField(
  label: 'Deadline',
  hint: 'Select date and time',
  prefixIcon: Icons.event,
  initialDateTime: DateTime.now(),
  onChanged: (dateTime) {
    print('Selected: $dateTime');
  },
);
```

#### Direct Picker Dialogs
```dart
// Date only
final date = await DateTimePicker.showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
);

// Time only
final time = await DateTimePicker.showTimePicker(
  context: context,
  initialTime: TimeOfDay.now(),
);

// Date and time combined
final dateTime = await DateTimePicker.showDateTimePicker(
  context: context,
  initialDateTime: DateTime.now(),
);
```

---

## Theming

All components automatically use the app's theme provider. They adapt to:
- Light/Dark mode
- Primary/Secondary colors
- Text styles
- Card styles

No additional configuration needed!

---

## Best Practices

### 1. Use Consistent Spacing
```dart
Column(
  children: [
    CustomInput(label: 'Title'),
    SizedBox(height: 16), // Consistent spacing
    CustomInput(label: 'Description'),
    SizedBox(height: 24), // Larger spacing before buttons
    CustomButton(text: 'Save'),
  ],
)
```

### 2. Handle Loading States
```dart
bool _isLoading = false;

CustomButton(
  text: 'Save',
  isLoading: _isLoading,
  onPressed: () async {
    setState(() => _isLoading = true);
    await saveData();
    setState(() => _isLoading = false);
  },
);
```

### 3. Validate Forms
```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      CustomInput(
        label: 'Email',
        type: InputType.email,
        validator: (value) {
          if (value == null || !value.contains('@')) {
            return 'Invalid email';
          }
          return null;
        },
      ),
      CustomButton(
        text: 'Submit',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Process form
          }
        },
      ),
    ],
  ),
)
```

### 4. Use Controllers for Inputs
```dart
final _titleController = TextEditingController();

@override
void dispose() {
  _titleController.dispose();
  super.dispose();
}

CustomInput(
  label: 'Title',
  controller: _titleController,
);

// Access value: _titleController.text
```

---

## Testing the Components

Create a demo page to test all components:

```dart
import 'package:flutter/material.dart';
import 'package:dayflow/widgets/ui_kit.dart';

class UIKitDemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('UI Kit Demo')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('Buttons', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 16),
          CustomButton(text: 'Primary Button', onPressed: () {}),
          SizedBox(height: 8),
          CustomButton(text: 'Secondary', type: ButtonType.secondary, onPressed: () {}),
          SizedBox(height: 8),
          CustomButton(text: 'Outlined', type: ButtonType.outlined, onPressed: () {}),
          
          SizedBox(height: 32),
          Text('Inputs', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 16),
          CustomInput(label: 'Text Input', hint: 'Enter text'),
          SizedBox(height: 16),
          CustomInput(label: 'Password', type: InputType.password),
          SizedBox(height: 16),
          SearchInput(hint: 'Search...'),
          
          SizedBox(height: 32),
          Text('Cards', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 16),
          InfoCard(
            title: 'Sample Card',
            subtitle: 'Card subtitle',
            icon: Icons.info,
            onTap: () {},
          ),
          
          SizedBox(height: 32),
          Text('Task Item', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 16),
          TaskItem(
            title: 'Sample Task',
            description: 'This is a task description',
            priority: TaskPriority.high,
            dueDate: DateTime.now().add(Duration(days: 1)),
            onToggleComplete: () {},
          ),
          
          SizedBox(height: 32),
          Text('Note Item', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 16),
          NoteItem(
            title: 'Sample Note',
            content: 'This is note content that can be quite long...',
            tags: ['demo', 'test'],
            createdAt: DateTime.now(),
            onTap: () {},
          ),
          
          SizedBox(height: 32),
          Text('Date/Time Pickers', style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 16),
          DatePickerField(
            label: 'Date',
            hint: 'Select date',
            onChanged: (date) => print(date),
          ),
          SizedBox(height: 16),
          TimePickerField(
            label: 'Time',
            hint: 'Select time',
            onChanged: (time) => print(time),
          ),
          
          SizedBox(height: 32),
          CustomButton(
            text: 'Show Modal Sheet',
            onPressed: () {
              CustomModalSheet.show(
                context: context,
                title: 'Demo Modal',
                child: Column(
                  children: [
                    Text('This is a modal sheet'),
                    SizedBox(height: 16),
                    CustomButton(
                      text: 'Close',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

---

## Component Summary

| Component | File | Purpose |
|-----------|------|---------|
| **CustomButton** | custom_button.dart | Primary, secondary, outlined, text buttons |
| **CustomIconButton** | custom_button.dart | Compact icon buttons |
| **CustomInput** | custom_input.dart | Text, password, email, number inputs |
| **SearchInput** | custom_input.dart | Dedicated search field |
| **CustomCard** | custom_card.dart | Basic card container |
| **InfoCard** | custom_card.dart | Icon + title + subtitle card |
| **StatCard** | custom_card.dart | Statistics display card |
| **TaskItem** | task_item.dart | Task display with priority & dates |
| **NoteItem** | note_item.dart | Note display with tags & pins |
| **NoteItemCompact** | note_item.dart | Compact note for grids |
| **CustomModalSheet** | modal_sheet.dart | Modal bottom sheet utilities |
| **QuickActionSheet** | modal_sheet.dart | Quick action menu |
| **DatePickerField** | date_time_picker.dart | Date selection field |
| **TimePickerField** | date_time_picker.dart | Time selection field |
| **DateTimePickerField** | date_time_picker.dart | Combined date/time field |
| **DateTimePicker** | date_time_picker.dart | Direct picker dialogs |

---

## Next Steps for Team

### Mohamed (Todo & Reminders Pages)

**Use these components:**
```dart
// Todo Page
TaskItem(
  title: task.title,
  description: task.description,
  isCompleted: task.isCompleted,
  priority: task.priority,
  dueDate: task.dueDate,
  onToggleComplete: () => toggleTask(task.id),
  onEdit: () => editTask(task.id),
  onDelete: () => deleteTask(task.id),
);

// Add task modal
CustomModalSheet.showForm(
  context: context,
  title: 'Add Task',
  child: Column(
    children: [
      CustomInput(label: 'Title', controller: titleController),
      SizedBox(height: 16),
      CustomInput(label: 'Description', type: InputType.multiline),
      SizedBox(height: 16),
      DateTimePickerField(label: 'Due Date', onChanged: (date) {}),
    ],
  ),
  onConfirm: () => saveTask(),
);

// Reminders Page - Similar pattern
```

### Lina (Notes & Habits Pages)

**Use these components:**
```dart
// Notes Page
NoteItem(
  title: note.title,
  content: note.content,
  tags: note.tags,
  color: note.color,
  isPinned: note.isPinned,
  createdAt: note.createdAt,
  onTap: () => viewNote(note.id),
  onEdit: () => editNote(note.id),
  onDelete: () => deleteNote(note.id),
  onPin: () => togglePin(note.id),
);

// Add note modal
CustomModalSheet.showForm(
  context: context,
  title: 'New Note',
  child: Column(
    children: [
      CustomInput(label: 'Title', controller: titleController),
      SizedBox(height: 16),
      CustomInput(
        label: 'Content',
        type: InputType.multiline,
        controller: contentController,
      ),
    ],
  ),
  onConfirm: () => saveNote(),
);

// Habits Page - Use StatCard for statistics display
StatCard(
  label: 'Current Streak',
  value: '7 days',
  icon: Icons.local_fire_department,
  color: Colors.orange,
);
```

### Abderrahmane (Settings & Polish)

**Use these components:**
```dart
// Settings Page
InfoCard(
  title: 'Account Settings',
  subtitle: 'Manage your profile',
  icon: Icons.person,
  onTap: () {},
);

InfoCard(
  title: 'Notifications',
  subtitle: 'Configure alerts',
  icon: Icons.notifications,
  onTap: () {},
);

InfoCard(
  title: 'Theme',
  subtitle: 'Light or dark mode',
  icon: Icons.palette,
  onTap: () => showThemeSelector(),
);

// Language selector
CustomModalSheet.showListSelection<String>(
  context: context,
  title: 'Select Language',
  items: ['English', 'Arabic', 'French'],
  itemBuilder: (lang) => lang,
  iconBuilder: (lang) => Icons.language,
);
```

---

## Customization Guide

### Changing Button Colors
Components use theme colors by default. To customize:

```dart
// In app_theme.dart, modify:
static const Color primaryLight = Color(0xFF6366F1); // Your color
static const Color secondaryLight = Color(0xFF8B5CF6); // Your color
```

### Custom Card Colors
```dart
CustomCard(
  color: Colors.blue.shade50,
  child: YourContent(),
);
```

### Custom Input Styling
All inputs follow the theme, but you can override:

```dart
CustomInput(
  label: 'Custom',
  // The component automatically uses theme colors
  // No additional styling needed
);
```

---

## Common Issues & Solutions

### Issue: "Provider not found"
**Solution:** Make sure `ThemeProvider` is wrapped around `MaterialApp` in `main.dart`.

### Issue: Date picker shows wrong theme
**Solution:** The date picker automatically uses your app theme. Ensure `ThemeProvider` is properly set up.

### Issue: Modal doesn't show
**Solution:** Make sure you're calling `CustomModalSheet.show()` with a valid BuildContext.

### Issue: Input validation not working
**Solution:** Wrap inputs in a `Form` widget and use a `GlobalKey<FormState>`:

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      CustomInput(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required field';
          }
          return null;
        },
      ),
    ],
  ),
);

// Validate:
if (_formKey.currentState!.validate()) {
  // Proceed
}
```

---

## Component Feature Matrix

| Component | Validation | Loading State | Disabled State | Theme Support |
|-----------|------------|---------------|----------------|---------------|
| CustomButton | ❌ | ✅ | ✅ | ✅ |
| CustomInput | ✅ | ❌ | ✅ | ✅ |
| CustomCard | ❌ | ❌ | ❌ | ✅ |
| TaskItem | ❌ | ❌ | ❌ | ✅ |
| NoteItem | ❌ | ❌ | ❌ | ✅ |
| ModalSheet | ❌ | ❌ | ✅ | ✅ |
| DatePicker | ❌ | ❌ | ✅ | ✅ |

---

## Learning Resources

### Understand the Code
Each component file includes:
- Clear property documentation
- Logical organization
- Theme integration
- Reusable patterns

### Extend Components
To add new features:

1. Open the component file
2. Add new properties to constructor
3. Use properties in build method
4. Update documentation

Example - Adding badge to TaskItem:
```dart
// In task_item.dart constructor:
final String? badge;

// In build method:
if (badge != null)
  Container(
    padding: EdgeInsets.all(4),
    child: Text(badge!),
  ),
```

---

## Checklist for Team Members

Before using components:
- [ ] Import `'package:dayflow/widgets/ui_kit.dart'`
- [ ] Check component documentation
- [ ] Review usage examples
- [ ] Test with light/dark themes
- [ ] Handle edge cases (null values, long text)
- [ ] Add proper error handling
- [ ] Test on different screen sizes

---

## Support

**Questions about components?**
- Check this documentation first
- Review the code comments
- Test with the demo page
- Ask Abderrahmane (Team Leader)

**Branch:** `feature/abderrahmane/ui-kit`  
**Complexity:** 3/5 
**Status:** Ready for integration  

---

**All components are production-ready and tested!**