part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NoteEvent {}

class AddOrUpdateNote extends NoteEvent {
  final Note note;

  const AddOrUpdateNote(this.note);

  @override
  List<Object?> get props => [note];
}

class DeleteNoteEvent extends NoteEvent {
  final String noteId;

  const DeleteNoteEvent(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

class ToggleNotePinEvent extends NoteEvent {
  final String noteId;

  const ToggleNotePinEvent(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

class SearchNotesEvent extends NoteEvent {
  final String query;

  const SearchNotesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSearchEvent extends NoteEvent {}

class ChangeNoteColorEvent extends NoteEvent {
  final String noteId;
  final Color? color;

  const ChangeNoteColorEvent(this.noteId, this.color);

  @override
  List<Object?> get props => [noteId, color];
}

class LockNoteEvent extends NoteEvent {
  final String noteId;
  final String? pin;
  final bool useBiometric;

  const LockNoteEvent(this.noteId, {this.pin, this.useBiometric = false});

  @override
  List<Object?> get props => [noteId, pin, useBiometric];
}

class UnlockNoteEvent extends NoteEvent {
  final String noteId;

  const UnlockNoteEvent(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

class FilterByCategoryEvent extends NoteEvent {
  final NoteCategory? category;

  const FilterByCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class FilterByTagEvent extends NoteEvent {
  final String? tag;

  const FilterByTagEvent(this.tag);

  @override
  List<Object?> get props => [tag];
}

class FilterByTypeEvent extends NoteEvent {
  final NoteType? type;

  const FilterByTypeEvent(this.type);

  @override
  List<Object?> get props => [type];
}

class ClearFiltersEvent extends NoteEvent {}

