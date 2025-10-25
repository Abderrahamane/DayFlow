// UI Kit - Central export file for all custom components
// Import this file to access all UI components in one place


export 'custom_button.dart';
export 'custom_input.dart';
export 'custom_card.dart';
export 'task_item.dart';
export 'note_item.dart';
export 'modal_sheet.dart';
export 'date_time_picker.dart';
// Usage Examples:
//
// 1. BUTTONS
// ----------
// import 'package:dayflow/widgets/ui_kit.dart';
//
// CustomButton(
//   text: 'Save Task',
//   type: ButtonType.primary,
//   size: ButtonSize.large,
//   icon: Icons.save,
//   onPressed: () {
//     // Save logic
//   },
// );
//
// CustomButton(
//   text: 'Cancel',
//   type: ButtonType.outlined,
//   onPressed: () {
//     // Cancel logic
//   },
// );
//
// CustomIconButton(
//   icon: Icons.edit,
//   onPressed: () {},
//   tooltip: 'Edit',
// );
//
// 2. INPUTS
// ---------
// CustomInput(
//   label: 'Task Title',
//   hint: 'Enter task title',
//   type: InputType.text,
//   prefixIcon: Icons.task,
//   onChanged: (value) {
//     // Handle change
//   },
//   validator: (value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter a title';
//     }
//     return null;
//   },
// );
//
// CustomInput(
//   label: 'Password',
//   type: InputType.password,
//   prefixIcon: Icons.lock,
// );
//
// SearchInput(
//   hint: 'Search tasks...',
//   onChanged: (value) {
//     // Handle search
//   },
// );
//
// 3. CARDS
// --------
// CustomCard(
//   onTap: () {},
//   child: Column(
//     children: [
//       Text('Card Content'),
//     ],
//   ),
// );
//
// InfoCard(
//   title: 'Total Tasks',
//   subtitle: 'Completed this week',
//   icon: Icons.check_circle,
//   iconColor: Colors.green,
//   onTap: () {},
// );
//
// StatCard(
//   label: 'Tasks',
//   value: '12',
//   icon: Icons.task_alt,
//   color: Colors.blue,
// );
//
// 4. TASK ITEM
// ------------
// TaskItem(
//   title: 'Complete project documentation',
//   description: 'Write user guide and API docs',
//   isCompleted: false,
//   priority: TaskPriority.high,
//   dueDate: DateTime.now().add(Duration(days: 2)),
//   category: 'Work',
//   onTap: () {
//     // View task details
//   },
//   onToggleComplete: () {
//     // Toggle completion status
//   },
//   onEdit: () {
//     // Edit task
//   },
//   onDelete: () {
//     // Delete task
//   },
// );
//
// 5. NOTE ITEM
// ------------
// NoteItem(
//   title: 'Meeting Notes',
//   content: 'Discussed project timeline and milestones...',
//   createdAt: DateTime.now().subtract(Duration(hours: 2)),
//   color: Colors.blue,
//   tags: ['work', 'meeting'],
//   isPinned: true,
//   onTap: () {
//     // View note
//   },
//   onEdit: () {
//     // Edit note
//   },
//   onDelete: () {
//     // Delete note
//   },
//   onPin: () {
//     // Toggle pin
//   },
// );
//
// NoteItemCompact(
//   title: 'Quick Idea',
//   content: 'Build a feature for...',
//   color: Colors.purple.withOpacity(0.2),
//   onTap: () {},
// );
//
// 6. MODAL SHEETS
// ---------------
// // Basic modal
// CustomModalSheet.show(
//   context: context,
//   title: 'Add Task',
//   child: Column(
//     children: [
//       CustomInput(label: 'Title', hint: 'Enter title'),
//       SizedBox(height: 16),
//       CustomButton(
//         text: 'Save',
//         onPressed: () {
//           Navigator.pop(context);
//         },
//       ),
//     ],
//   ),
// );
//
// // Form modal with actions
// CustomModalSheet.showForm(
//   context: context,
//   title: 'Edit Task',
//   child: CustomInput(label: 'Title'),
//   confirmText: 'Save',
//   cancelText: 'Cancel',
//   onConfirm: () {
//     // Save logic
//   },
// );
//
// // List selection modal
// final priority = await CustomModalSheet.showListSelection<TaskPriority>(
//   context: context,
//   title: 'Select Priority',
//   items: TaskPriority.values,
//   itemBuilder: (item) => item.name,
//   iconBuilder: (item) => Icons.flag,
//   selectedItem: TaskPriority.medium,
// );
//
// // Confirmation modal
// final confirmed = await CustomModalSheet.showConfirmation(
//   context: context,
//   title: 'Delete Task',
//   message: 'Are you sure you want to delete this task?',
//   confirmText: 'Delete',
//   cancelText: 'Cancel',
//   isDangerous: true,
// );
//
// // Quick action sheet
// QuickActionSheet.show(
//   context: context,
//   title: 'Quick Actions',
//   actions: [
//     QuickAction(
//       title: 'Add Task',
//       subtitle: 'Create a new task',
//       icon: Icons.add_task,
//       onTap: () {},
//     ),
//     QuickAction(
//       title: 'Add Note',
//       subtitle: 'Create a quick note',
//       icon: Icons.note_add,
//       onTap: () {},
//     ),
//   ],
// );
//
// 7. DATE/TIME PICKERS
// --------------------
// // Date picker field
// DatePickerField(
//   label: 'Due Date',
//   hint: 'Select due date',
//   prefixIcon: Icons.calendar_today,
//   onChanged: (date) {
//     print('Selected: $date');
//   },
// );
//
// // Time picker field
// TimePickerField(
//   label: 'Reminder Time',
//   hint: 'Select time',
//   prefixIcon: Icons.access_time,
//   onChanged: (time) {
//     print('Selected: $time');
//   },
// );
//
// // DateTime picker field
// DateTimePickerField(
//   label: 'Deadline',
//   hint: 'Select date and time',
//   prefixIcon: Icons.event,
//   onChanged: (dateTime) {
//     print('Selected: $dateTime');
//   },
// );
//
// // Direct picker dialogs
// final date = await DateTimePicker.showDatePicker(
//   context: context,
//   initialDate: DateTime.now(),
// );
//
// final time = await DateTimePicker.showTimePicker(
//   context: context,
//   initialTime: TimeOfDay.now(),
// );
//
// final dateTime = await DateTimePicker.showDateTimePicker(
//   context: context,
//   initialDateTime: DateTime.now(),
// );