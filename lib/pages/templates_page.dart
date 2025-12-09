import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../blocs/template/template_bloc.dart';
import '../blocs/task/task_bloc.dart';
import '../models/task_template_model.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

class TemplatesPage extends StatefulWidget {
  const TemplatesPage({super.key});

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TemplateBloc>().add(LoadTemplates());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showTemplateEditor({TaskTemplate? template}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<TemplateBloc>(),
        child: _TemplateEditorSheet(template: template),
      ),
    );
  }

  void _createTaskFromTemplate(TaskTemplate template) {
    // Increment usage count
    context.read<TemplateBloc>().add(UseTemplate(template.id));

    // Create task from template
    final task = template.toTask(taskId: const Uuid().v4());
    context.read<TaskBloc>().add(AddOrUpdateTask(task));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task.title}" created from template'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Navigate to tasks page
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Templates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showTemplateEditor(),
            tooltip: 'Create Template',
          ),
        ],
      ),
      body: BlocBuilder<TemplateBloc, TemplateState>(
        builder: (context, state) {
          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) =>
                      context.read<TemplateBloc>().add(SearchTemplates(value)),
                  decoration: InputDecoration(
                    hintText: 'Search templates...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              context.read<TemplateBloc>().add(ClearFilter());
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                ),
              ),

              // Category filter chips
              if (state.categories.isNotEmpty)
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: state.selectedCategory == null,
                        onSelected: (_) =>
                            context.read<TemplateBloc>().add(ClearFilter()),
                      ),
                      const SizedBox(width: 8),
                      ...state.categories.map((category) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(category),
                              selected: state.selectedCategory == category,
                              onSelected: (_) => context
                                  .read<TemplateBloc>()
                                  .add(FilterByCategory(category)),
                            ),
                          )),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              // Templates list
              Expanded(
                child: _buildContent(state, theme),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTemplateEditor(),
        icon: const Icon(Icons.add),
        label: const Text('New Template'),
      ),
    );
  }

  Widget _buildContent(TemplateState state, ThemeData theme) {
    if (state.status == TemplateStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == TemplateStatus.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('Failed to load templates', style: theme.textTheme.titleLarge),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () =>
                  context.read<TemplateBloc>().add(LoadTemplates()),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.filteredTemplates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books,
                size: 64, color: theme.colorScheme.primary.withAlpha(128)),
            const SizedBox(height: 16),
            Text(
              state.searchQuery.isNotEmpty
                  ? 'No templates found'
                  : 'No templates yet',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.searchQuery.isNotEmpty
                  ? 'Try a different search term'
                  : 'Create templates for quick task creation',
              style: theme.textTheme.bodyMedium,
            ),
            if (state.searchQuery.isEmpty) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => _showTemplateEditor(),
                icon: const Icon(Icons.add),
                label: const Text('Create Template'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: state.filteredTemplates.length,
      itemBuilder: (context, index) {
        final template = state.filteredTemplates[index];
        return _TemplateCard(
          template: template,
          onTap: () => _showTemplateOptions(template),
          onQuickCreate: () => _createTaskFromTemplate(template),
        );
      },
    );
  }

  void _showTemplateOptions(TaskTemplate template) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (template.icon != null)
                  Text(template.icon!, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (template.description != null)
                        Text(
                          template.description!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _OptionButton(
              icon: Icons.add_task,
              label: 'Create Task',
              subtitle: 'Quick create task from this template',
              color: AppTheme.successColor,
              onTap: () {
                Navigator.pop(ctx);
                _createTaskFromTemplate(template);
              },
            ),
            _OptionButton(
              icon: Icons.edit,
              label: 'Edit Template',
              subtitle: 'Modify template settings',
              color: Theme.of(context).colorScheme.primary,
              onTap: () {
                Navigator.pop(ctx);
                _showTemplateEditor(template: template);
              },
            ),
            _OptionButton(
              icon: Icons.delete_outline,
              label: 'Delete Template',
              subtitle: 'Remove this template',
              color: AppTheme.errorColor,
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(template);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(TaskTemplate template) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Template'),
        content: Text('Are you sure you want to delete "${template.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<TemplateBloc>().add(DeleteTemplate(template.id));
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final TaskTemplate template;
  final VoidCallback onTap;
  final VoidCallback onQuickCreate;

  const _TemplateCard({
    required this.template,
    required this.onTap,
    required this.onQuickCreate,
  });

  Color _getPriorityColor() {
    switch (template.priority) {
      case TaskPriority.high:
        return AppTheme.errorColor;
      case TaskPriority.medium:
        return const Color(0xFFF59E0B);
      case TaskPriority.low:
        return AppTheme.successColor;
      case TaskPriority.none:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _getPriorityColor().withAlpha(77),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (template.icon != null)
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(26),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(template.icon!,
                            style: const TextStyle(fontSize: 20)),
                      ),
                    )
                  else
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(26),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.library_books,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (template.category != null)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary.withAlpha(26),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              template.category!,
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onQuickCreate,
                    icon: const Icon(Icons.add_task),
                    color: AppTheme.successColor,
                    tooltip: 'Quick Create',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Task preview
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(color: _getPriorityColor(), width: 3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.task_alt,
                            size: 16, color: theme.colorScheme.outline),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            template.taskTitle,
                            style: theme.textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (template.subtasks != null &&
                        template.subtasks!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${template.subtasks!.length} subtasks',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withAlpha(128),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Footer
              Row(
                children: [
                  Icon(Icons.repeat, size: 14, color: theme.colorScheme.outline),
                  const SizedBox(width: 4),
                  Text(
                    'Used ${template.usageCount} times',
                    style: theme.textTheme.bodySmall,
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getPriorityColor().withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      template.priority.displayName,
                      style: TextStyle(
                        fontSize: 10,
                        color: _getPriorityColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (template.tags != null && template.tags!.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.label_outline,
                        size: 14, color: theme.colorScheme.outline),
                    const SizedBox(width: 4),
                    Text('${template.tags!.length}',
                        style: theme.textTheme.bodySmall),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _OptionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(label),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.outline),
    );
  }
}

class _TemplateEditorSheet extends StatefulWidget {
  final TaskTemplate? template;

  const _TemplateEditorSheet({this.template});

  @override
  State<_TemplateEditorSheet> createState() => _TemplateEditorSheetState();
}

class _TemplateEditorSheetState extends State<_TemplateEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _taskTitleController;
  late TextEditingController _taskDescController;
  late TextEditingController _tagsController;
  TaskPriority _priority = TaskPriority.medium;
  String? _category;
  String? _icon;
  List<String> _subtasks = [];

  static const List<String> _icons = [
    '📋', '📝', '💼', '📁', '📅', '🎯', '💡', '🚀',
    '✅', '⭐', '🔔', '📌', '🏷️', '📊', '🛒', '🏃',
  ];

  @override
  void initState() {
    super.initState();
    final t = widget.template;
    _nameController = TextEditingController(text: t?.name ?? '');
    _descController = TextEditingController(text: t?.description ?? '');
    _taskTitleController = TextEditingController(text: t?.taskTitle ?? '');
    _taskDescController = TextEditingController(text: t?.taskDescription ?? '');
    _tagsController = TextEditingController(text: t?.tags?.join(', ') ?? '');
    _priority = t?.priority ?? TaskPriority.medium;
    _category = t?.category;
    _icon = t?.icon;
    _subtasks = t?.subtasks?.map((s) => s.title).toList() ?? [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _taskTitleController.dispose();
    _taskDescController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final tags = _tagsController.text.isNotEmpty
        ? _tagsController.text.split(',').map((t) => t.trim()).toList()
        : null;

    final template = TaskTemplate(
      id: widget.template?.id ?? '',
      name: _nameController.text,
      description: _descController.text.isNotEmpty ? _descController.text : null,
      taskTitle: _taskTitleController.text,
      taskDescription:
          _taskDescController.text.isNotEmpty ? _taskDescController.text : null,
      priority: _priority,
      tags: tags,
      subtasks: _subtasks.isNotEmpty
          ? _subtasks.map((t) => SubtaskTemplate(title: t)).toList()
          : null,
      category: _category,
      icon: _icon,
      createdAt: widget.template?.createdAt ?? DateTime.now(),
      usageCount: widget.template?.usageCount ?? 0,
    );

    if (widget.template != null) {
      context.read<TemplateBloc>().add(UpdateTemplate(template));
    } else {
      context.read<TemplateBloc>().add(AddTemplate(template));
    }

    Navigator.pop(context);
  }

  void _addSubtask() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Subtask'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Subtask title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() => _subtasks.add(controller.text));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.template != null;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  isEditing ? 'Edit Template' : 'New Template',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon selector
                    Text('Icon',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _icons.map((emoji) {
                        final isSelected = _icon == emoji;
                        return GestureDetector(
                          onTap: () => setState(() => _icon = emoji),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primary.withAlpha(26)
                                  : theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: isSelected
                                  ? Border.all(color: theme.colorScheme.primary)
                                  : null,
                            ),
                            child: Center(
                              child:
                                  Text(emoji, style: const TextStyle(fontSize: 20)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Template name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Template Name *',
                        hintText: 'e.g., Weekly Report',
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Template description',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),

                    // Category
                    Text('Category',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: TemplateCategory.values.map((cat) {
                        final isSelected = _category == cat.name;
                        return FilterChip(
                          label: Text('${cat.icon} ${cat.displayName}'),
                          selected: isSelected,
                          onSelected: (_) => setState(() {
                            _category = isSelected ? null : cat.name;
                          }),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    const Divider(),
                    const SizedBox(height: 20),

                    // Task settings
                    Text('Task Settings',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _taskTitleController,
                      decoration: const InputDecoration(
                        labelText: 'Task Title *',
                        hintText: 'Title for created tasks',
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _taskDescController,
                      decoration: const InputDecoration(
                        labelText: 'Task Description',
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),

                    // Priority
                    Text('Priority',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SegmentedButton<TaskPriority>(
                      segments: TaskPriority.values.map((p) {
                        return ButtonSegment(
                          value: p,
                          label: Text(p.displayName),
                        );
                      }).toList(),
                      selected: {_priority},
                      onSelectionChanged: (s) =>
                          setState(() => _priority = s.first),
                    ),
                    const SizedBox(height: 16),

                    // Tags
                    TextFormField(
                      controller: _tagsController,
                      decoration: const InputDecoration(
                        labelText: 'Tags',
                        hintText: 'Comma-separated tags',
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Subtasks
                    Row(
                      children: [
                        Text('Subtasks',
                            style: theme.textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: _addSubtask,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add'),
                        ),
                      ],
                    ),
                    if (_subtasks.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ...List.generate(_subtasks.length, (i) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_box_outline_blank, size: 18),
                              const SizedBox(width: 8),
                              Expanded(child: Text(_subtasks[i])),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () =>
                                    setState(() => _subtasks.removeAt(i)),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

