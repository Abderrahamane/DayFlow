import '../../models/task_template_model.dart';
import '../local/app_database.dart';

class TaskTemplateRepository {
  final AppDatabase _db;

  TaskTemplateRepository(this._db);

  Future<void> _ensureDb() async => _db.init();

  Future<List<TaskTemplate>> fetchTemplates() async {
    await _ensureDb();
    final result = _db.rawDb.select(
      'SELECT * FROM task_templates ORDER BY usageCount DESC, createdAt DESC',
    );
    return result.map((row) => TaskTemplate.fromDatabase(row)).toList();
  }

  Future<TaskTemplate?> getTemplateById(String id) async {
    await _ensureDb();
    final result = _db.rawDb.select(
      'SELECT * FROM task_templates WHERE id = ?',
      [id],
    );
    if (result.isEmpty) return null;
    return TaskTemplate.fromDatabase(result.first);
  }

  Future<List<TaskTemplate>> getTemplatesByCategory(String category) async {
    await _ensureDb();
    final result = _db.rawDb.select(
      'SELECT * FROM task_templates WHERE category = ? ORDER BY usageCount DESC',
      [category],
    );
    return result.map((row) => TaskTemplate.fromDatabase(row)).toList();
  }

  Future<void> upsertTemplate(TaskTemplate template) async {
    await _ensureDb();
    final data = template.toDatabase();
    _db.rawDb.execute(
      '''INSERT OR REPLACE INTO task_templates 
        (id, name, description, taskTitle, taskDescription, priority, 
         tagsJson, subtasksJson, category, icon, createdAt, updatedAt, 
         usageCount, isShared) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)''',
      [
        data['id'],
        data['name'],
        data['description'],
        data['taskTitle'],
        data['taskDescription'],
        data['priority'],
        data['tagsJson'],
        data['subtasksJson'],
        data['category'],
        data['icon'],
        data['createdAt'],
        data['updatedAt'],
        data['usageCount'],
        data['isShared'],
      ],
    );
  }

  Future<void> deleteTemplate(String id) async {
    await _ensureDb();
    _db.rawDb.execute('DELETE FROM task_templates WHERE id = ?', [id]);
  }

  Future<void> incrementUsageCount(String id) async {
    await _ensureDb();
    _db.rawDb.execute(
      'UPDATE task_templates SET usageCount = usageCount + 1 WHERE id = ?',
      [id],
    );
  }

  Future<List<TaskTemplate>> searchTemplates(String query) async {
    await _ensureDb();
    final result = _db.rawDb.select(
      '''SELECT * FROM task_templates 
        WHERE name LIKE ? OR taskTitle LIKE ? OR description LIKE ?
        ORDER BY usageCount DESC''',
      ['%$query%', '%$query%', '%$query%'],
    );
    return result.map((row) => TaskTemplate.fromDatabase(row)).toList();
  }
}

