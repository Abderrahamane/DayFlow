part of 'template_bloc.dart';

abstract class TemplateEvent extends Equatable {
  const TemplateEvent();

  @override
  List<Object?> get props => [];
}

class LoadTemplates extends TemplateEvent {}

class AddTemplate extends TemplateEvent {
  final TaskTemplate template;

  const AddTemplate(this.template);

  @override
  List<Object?> get props => [template];
}

class UpdateTemplate extends TemplateEvent {
  final TaskTemplate template;

  const UpdateTemplate(this.template);

  @override
  List<Object?> get props => [template];
}

class DeleteTemplate extends TemplateEvent {
  final String templateId;

  const DeleteTemplate(this.templateId);

  @override
  List<Object?> get props => [templateId];
}

class CreateTemplateFromTask extends TemplateEvent {
  final Task task;
  final String templateName;
  final String? description;
  final String? category;
  final String? icon;

  const CreateTemplateFromTask({
    required this.task,
    required this.templateName,
    this.description,
    this.category,
    this.icon,
  });

  @override
  List<Object?> get props => [task, templateName, description, category, icon];
}

class UseTemplate extends TemplateEvent {
  final String templateId;

  const UseTemplate(this.templateId);

  @override
  List<Object?> get props => [templateId];
}

class SearchTemplates extends TemplateEvent {
  final String query;

  const SearchTemplates(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterByCategory extends TemplateEvent {
  final String category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class ClearFilter extends TemplateEvent {}

