// lib/repositories/reminder_repository.dart

import 'package:dayflow/data/local/app_database.dart';
import 'package:dayflow/models/reminder_model.dart';
import 'package:sqlite3/sqlite3.dart';

class ReminderRepository {
  final AppDatabase _database;

  ReminderRepository(this._database);

  // Get all reminders from reminders table
  Future<List<ReminderModel>> getRemindersFromTable() async {
    try {
      final db = _database.rawDb;
      final result = db.select('''
        SELECT * FROM reminders 
        WHERE isActive = 1
        ORDER BY date ASC, time ASC
      ''');

      return result.map((row) {
        return ReminderModel(
          id: row['id'] as int,
          title: row['title'] as String,
          time: row['time'] as String,
          description: row['description'] as String?,
          date: DateTime.parse(row['date'] as String),
          isActive: (row['isActive'] as int) == 1,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch reminders: $e');
    }
  }

  // Get reminders from tasks table (where hasRemainder = 1)
  Future<List<ReminderModel>> getRemindersFromTasks() async {
    try {
      final db = _database.rawDb;
      
      // Check if tasks table has required columns
      final result = db.select('''
        SELECT * FROM tasks 
        WHERE dueDate IS NOT NULL
        ORDER BY dueDate ASC
      ''');

      return result.map((row) {
        final dueDate = row['dueDate'] as int?;
        final dateTime = dueDate != null 
            ? DateTime.fromMillisecondsSinceEpoch(dueDate)
            : DateTime.now();
            
        return ReminderModel(
          id: null, // Tasks don't have reminder IDs
          title: row['title'] as String,
          time: _formatTimeFromTimestamp(dueDate),
          description: row['description'] as String?,
          date: dateTime,
          isActive: true,
        );
      }).toList();
    } catch (e) {
      // If tasks table doesn't have the right structure, return empty list
      return [];
    }
  }

  // Get all reminders (combined from both tables)
  Future<List<ReminderModel>> getAllReminders() async {
    final remindersFromTable = await getRemindersFromTable();
    final remindersFromTasks = await getRemindersFromTasks();
    
    // Combine and sort by date
    final allReminders = [...remindersFromTable, ...remindersFromTasks];
    allReminders.sort((a, b) => a.date.compareTo(b.date));
    
    return allReminders;
  }

  // Get reminders for today
  Future<List<ReminderModel>> getTodayReminders() async {
    final allReminders = await getAllReminders();
    final now = DateTime.now();
    
    return allReminders.where((reminder) {
      return reminder.date.year == now.year &&
          reminder.date.month == now.month &&
          reminder.date.day == now.day;
    }).toList();
  }

  // Get reminders for tomorrow
  Future<List<ReminderModel>> getTomorrowReminders() async {
    final allReminders = await getAllReminders();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    
    return allReminders.where((reminder) {
      return reminder.date.year == tomorrow.year &&
          reminder.date.month == tomorrow.month &&
          reminder.date.day == tomorrow.day;
    }).toList();
  }

  // Get upcoming reminders (next 7 days, excluding today and tomorrow)
  Future<List<ReminderModel>> getUpcomingReminders() async {
    final allReminders = await getAllReminders();
    final now = DateTime.now();
    final endDate = now.add(const Duration(days: 7));
    
    return allReminders.where((reminder) {
      final isInRange = reminder.date.isAfter(now) && 
                       reminder.date.isBefore(endDate);
      return isInRange && !reminder.isToday && !reminder.isTomorrow;
    }).toList();
  }

  // Insert a new reminder
  Future<int> insertReminder(ReminderModel reminder) async {
    try {
      final db = _database.rawDb;
      
      db.execute('''
        INSERT INTO reminders (title, time, description, date, isActive, createdAt, source)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      ''', [
        reminder.title,
        reminder.time,
        reminder.description,
        reminder.date.toIso8601String(),
        reminder.isActive ? 1 : 0,
        DateTime.now().millisecondsSinceEpoch,
        'reminder'
      ]);

      // Get the last inserted ID
      final result = db.select('SELECT last_insert_rowid() as id');
      return result.first['id'] as int;
    } catch (e) {
      throw Exception('Failed to insert reminder: $e');
    }
  }

  // Update a reminder
  Future<void> updateReminder(ReminderModel reminder) async {
    if (reminder.id == null) {
      throw Exception('Cannot update reminder without ID');
    }

    try {
      final db = _database.rawDb;
      
      db.execute('''
        UPDATE reminders 
        SET title = ?, time = ?, description = ?, date = ?, isActive = ?
        WHERE id = ?
      ''', [
        reminder.title,
        reminder.time,
        reminder.description,
        reminder.date.toIso8601String(),
        reminder.isActive ? 1 : 0,
        reminder.id,
      ]);
    } catch (e) {
      throw Exception('Failed to update reminder: $e');
    }
  }

  // Delete a reminder
  Future<void> deleteReminder(int id) async {
    try {
      final db = _database.rawDb;
      db.execute('DELETE FROM reminders WHERE id = ?', [id]);
    } catch (e) {
      throw Exception('Failed to delete reminder: $e');
    }
  }

  // Toggle reminder active state
  Future<void> toggleReminderActive(int id, bool isActive) async {
    try {
      final db = _database.rawDb;
      db.execute('''
        UPDATE reminders 
        SET isActive = ?
        WHERE id = ?
      ''', [isActive ? 1 : 0, id]);
    } catch (e) {
      throw Exception('Failed to toggle reminder: $e');
    }
  }

  // Helper method to format time from timestamp
  String _formatTimeFromTimestamp(int? timestamp) {
    if (timestamp == null) return 'No time set';
    
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
}