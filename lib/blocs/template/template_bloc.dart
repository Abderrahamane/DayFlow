import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../data/repositories/task_template_repository.dart';
import '../../models/task_template_model.dart';
import '../../models/task_model.dart';

part 'template_event.dart';
part 'template_state.dart';

class TemplateBloc extends Bloc<TemplateEvent, TemplateState> {
  final TaskTemplateRepository _repository;
  final _uuid = const Uuid();

  TemplateBloc(this._repository) : super(const TemplateState()) {
    on<LoadTemplates>(_onLoadTemplates);
    on<AddTemplate>(_onAddTemplate);
    on<UpdateTemplate>(_onUpdateTemplate);
    on<DeleteTemplate>(_onDeleteTemplate);
    on<CreateTemplateFromTask>(_onCreateFromTask);
    on<UseTemplate>(_onUseTemplate);
    on<SearchTemplates>(_onSearchTemplates);
    on<FilterByCategory>(_onFilterByCategory);
    on<ClearFilter>(_onClearFilter);
  }

  Future<void> _onLoadTemplates(
    LoadTemplates event,
    Emitter<TemplateState> emit,
  ) async {
    emit(state.copyWith(status: TemplateStatus.loading));
    try {
      final templates = await _repository.fetchTemplates();
      emit(state.copyWith(
        status: TemplateStatus.ready,
        templates: templates,
        filteredTemplates: templates,
      ));
    } catch (e) {
      emit(state.copyWith(status: TemplateStatus.failure, errorMessage: '$e'));
    }
  }

  Future<void> _onAddTemplate(
    AddTemplate event,
    Emitter<TemplateState> emit,
  ) async {
    final template = event.template.id.isEmpty
        ? event.template.copyWith(id: _uuid.v4(), createdAt: DateTime.now())
        : event.template;

    await _repository.upsertTemplate(template);

    final updatedTemplates = List<TaskTemplate>.from(state.templates)
      ..add(template);

    emit(state.copyWith(
      templates: updatedTemplates,
      filteredTemplates: updatedTemplates,
    ));
  }

  Future<void> _onUpdateTemplate(
    UpdateTemplate event,
    Emitter<TemplateState> emit,
  ) async {
    final updated = event.template.copyWith(updatedAt: DateTime.now());
    await _repository.upsertTemplate(updated);

    final updatedTemplates = state.templates.map((t) {
      return t.id == updated.id ? updated : t;
    }).toList();

    emit(state.copyWith(
      templates: updatedTemplates,
      filteredTemplates: _applyFilter(updatedTemplates, state.selectedCategory),
    ));
  }

  Future<void> _onDeleteTemplate(
    DeleteTemplate event,
    Emitter<TemplateState> emit,
  ) async {
    await _repository.deleteTemplate(event.templateId);

    final updatedTemplates = state.templates
        .where((t) => t.id != event.templateId)
        .toList();

    emit(state.copyWith(
      templates: updatedTemplates,
      filteredTemplates: _applyFilter(updatedTemplates, state.selectedCategory),
    ));
  }

  Future<void> _onCreateFromTask(
    CreateTemplateFromTask event,
    Emitter<TemplateState> emit,
  ) async {
    final template = TaskTemplate.fromTask(
      templateId: _uuid.v4(),
      templateName: event.templateName,
      task: event.task,
      description: event.description,
      category: event.category,
      icon: event.icon,
    );

    await _repository.upsertTemplate(template);

    final updatedTemplates = List<TaskTemplate>.from(state.templates)
      ..add(template);

    emit(state.copyWith(
      templates: updatedTemplates,
      filteredTemplates: _applyFilter(updatedTemplates, state.selectedCategory),
    ));
  }

  Future<void> _onUseTemplate(
    UseTemplate event,
    Emitter<TemplateState> emit,
  ) async {
    await _repository.incrementUsageCount(event.templateId);

    final updatedTemplates = state.templates.map((t) {
      if (t.id == event.templateId) {
        return t.copyWith(usageCount: t.usageCount + 1);
      }
      return t;
    }).toList();

    emit(state.copyWith(
      templates: updatedTemplates,
      filteredTemplates: _applyFilter(updatedTemplates, state.selectedCategory),
    ));
  }

  Future<void> _onSearchTemplates(
    SearchTemplates event,
    Emitter<TemplateState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(
        filteredTemplates: _applyFilter(state.templates, state.selectedCategory),
        searchQuery: '',
      ));
      return;
    }

    final query = event.query.toLowerCase();
    final filtered = state.templates.where((t) {
      return t.name.toLowerCase().contains(query) ||
          t.taskTitle.toLowerCase().contains(query) ||
          (t.description?.toLowerCase().contains(query) ?? false);
    }).toList();

    emit(state.copyWith(filteredTemplates: filtered, searchQuery: event.query));
  }

  void _onFilterByCategory(
    FilterByCategory event,
    Emitter<TemplateState> emit,
  ) {
    emit(state.copyWith(
      selectedCategory: event.category,
      filteredTemplates: _applyFilter(state.templates, event.category),
    ));
  }

  void _onClearFilter(ClearFilter event, Emitter<TemplateState> emit) {
    emit(state.copyWith(
      selectedCategory: null,
      filteredTemplates: state.templates,
      searchQuery: '',
    ));
  }

  List<TaskTemplate> _applyFilter(List<TaskTemplate> templates, String? category) {
    if (category == null) return templates;
    return templates.where((t) => t.category == category).toList();
  }
}

