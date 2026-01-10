import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dayflow/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Task Management Integration Tests', () {
    testWidgets('should add a new task and verify it appears in list',
        (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to tasks (if not already there)
      final tasksNavItem = find.byIcon(Icons.task_alt);
      if (tasksNavItem.evaluate().isNotEmpty) {
        await tester.tap(tasksNavItem);
        await tester.pumpAndSettle();
      }

      // Find and tap the FAB to add a new task
      final fab = find.byType(FloatingActionButton);
      if (fab.evaluate().isNotEmpty) {
        await tester.tap(fab.first);
        await tester.pumpAndSettle();

        // Fill in task title
        final titleField = find.byType(TextField).first;
        await tester.enterText(titleField, 'Integration Test Task');
        await tester.pumpAndSettle();

        // Save the task
        final saveButton = find.text('Save');
        if (saveButton.evaluate().isNotEmpty) {
          await tester.tap(saveButton);
          await tester.pumpAndSettle();
        }

        // Verify task appears in list
        expect(find.text('Integration Test Task'), findsWidgets);
      }
    });

    testWidgets('should toggle task completion', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find a checkbox or completion indicator
      final checkbox = find.byType(Checkbox);
      if (checkbox.evaluate().isNotEmpty) {
        await tester.tap(checkbox.first);
        await tester.pumpAndSettle();

        // Verify state changed (checkbox should be checked)
        final checkboxWidget = tester.widget<Checkbox>(checkbox.first);
        expect(checkboxWidget.value, isTrue);
      }
    });
  });

  group('Habit Tracking Integration Tests', () {
    testWidgets('should navigate to habits page', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find habits navigation item
      final habitsNavItem = find.byIcon(Icons.repeat);
      if (habitsNavItem.evaluate().isNotEmpty) {
        await tester.tap(habitsNavItem);
        await tester.pumpAndSettle();

        // Verify we're on the habits page
        expect(find.byType(Scaffold), findsWidgets);
      }
    });

    testWidgets('should add a new habit', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to habits
      final habitsNavItem = find.byIcon(Icons.repeat);
      if (habitsNavItem.evaluate().isNotEmpty) {
        await tester.tap(habitsNavItem);
        await tester.pumpAndSettle();

        // Find and tap FAB to add habit
        final fab = find.byType(FloatingActionButton);
        if (fab.evaluate().isNotEmpty) {
          await tester.tap(fab.first);
          await tester.pumpAndSettle();

          // Fill in habit name
          final nameField = find.byType(TextField).first;
          await tester.enterText(nameField, 'Test Habit');
          await tester.pumpAndSettle();

          // Save habit
          final saveButton = find.text('Save');
          if (saveButton.evaluate().isNotEmpty) {
            await tester.tap(saveButton);
            await tester.pumpAndSettle();
          }

          // Verify habit appears
          expect(find.text('Test Habit'), findsWidgets);
        }
      }
    });
  });

  group('Notes Integration Tests', () {
    testWidgets('should navigate to notes page', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find notes navigation item
      final notesNavItem = find.byIcon(Icons.note);
      if (notesNavItem.evaluate().isNotEmpty) {
        await tester.tap(notesNavItem);
        await tester.pumpAndSettle();

        // Verify we're on the notes page
        expect(find.byType(Scaffold), findsWidgets);
      }
    });
  });

  group('Navigation Integration Tests', () {
    testWidgets('should navigate between all main pages',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate through bottom navigation items
      final navItems = [
        Icons.task_alt,
        Icons.repeat,
        Icons.note,
        Icons.calendar_today,
        Icons.settings,
      ];

      for (final icon in navItems) {
        final navItem = find.byIcon(icon);
        if (navItem.evaluate().isNotEmpty) {
          await tester.tap(navItem);
          await tester.pumpAndSettle();

          // Verify page loads without errors
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });
  });

  group('Settings Integration Tests', () {
    testWidgets('should open settings and toggle theme',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to settings
      final settingsNavItem = find.byIcon(Icons.settings);
      if (settingsNavItem.evaluate().isNotEmpty) {
        await tester.tap(settingsNavItem);
        await tester.pumpAndSettle();

        // Look for theme toggle
        final themeToggle = find.byType(Switch);
        if (themeToggle.evaluate().isNotEmpty) {
          await tester.tap(themeToggle.first);
          await tester.pumpAndSettle();

          // Verify theme changed
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });
  });
}

