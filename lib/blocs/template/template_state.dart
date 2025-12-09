part of 'template_bloc.dart';

enum TemplateStatus { initial, loading, ready, failure }

class TemplateState extends Equatable {
  final List<TaskTemplate> templates;
  final List<TaskTemplate> filteredTemplates;
  final TemplateStatus status;
  final String? errorMessage;
  final String? selectedCategory;
  final String searchQuery;

  const TemplateState({
    this.templates = const [],
    this.filteredTemplates = const [],
    this.status = TemplateStatus.initial,
    this.errorMessage,
    this.selectedCategory,
    this.searchQuery = '',
  });

  int get totalCount => templates.length;

  List<TaskTemplate> get mostUsed =>
      List<TaskTemplate>.from(templates)
        ..sort((a, b) => b.usageCount.compareTo(a.usageCount));

  List<TaskTemplate> get recentlyCreated =>
      List<TaskTemplate>.from(templates)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  Map<String, List<TaskTemplate>> get groupedByCategory {
    final grouped = <String, List<TaskTemplate>>{};
    for (final template in templates) {
      final category = template.category ?? 'Other';
      grouped.putIfAbsent(category, () => []);
      grouped[category]!.add(template);
    }
    return grouped;
  }

  List<String> get categories =>
      templates.map((t) => t.category ?? 'Other').toSet().toList()..sort();

  TemplateState copyWith({
    List<TaskTemplate>? templates,
    List<TaskTemplate>? filteredTemplates,
    TemplateStatus? status,
    String? errorMessage,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return TemplateState(
      templates: templates ?? this.templates,
      filteredTemplates: filteredTemplates ?? this.filteredTemplates,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCategory: selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        templates,
        filteredTemplates,
        status,
        errorMessage,
        selectedCategory,
        searchQuery,
      ];
}

