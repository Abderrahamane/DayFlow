import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../data/repositories/note_repository.dart';
import '../../models/note_model.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository _repository;
  final _uuid = const Uuid();

  NoteBloc(this._repository) : super(const NoteState()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddOrUpdateNote>(_onAddOrUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
    on<ToggleNotePinEvent>(_onTogglePin);
    on<SearchNotesEvent>(_onSearchNotes);
    on<ClearSearchEvent>(_onClearSearch);
    on<ChangeNoteColorEvent>(_onChangeColor);
    on<LockNoteEvent>(_onLockNote);
    on<UnlockNoteEvent>(_onUnlockNote);
    on<FilterByCategoryEvent>(_onFilterByCategory);
    on<FilterByTagEvent>(_onFilterByTag);
    on<FilterByTypeEvent>(_onFilterByType);
    on<ClearFiltersEvent>(_onClearFilters);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    emit(state.copyWith(status: NoteStatus.loading));
    try {
      final notes = await _repository.fetchNotes();
      emit(state.copyWith(
        status: NoteStatus.ready,
        notes: notes,
        filteredNotes: notes,
      ));
    } catch (e) {
      emit(state.copyWith(status: NoteStatus.failure, errorMessage: '$e'));
    }
  }

  Future<void> _onAddOrUpdateNote(
    AddOrUpdateNote event,
    Emitter<NoteState> emit,
  ) async {
    final now = DateTime.now();
    final isNew = event.note.id.isEmpty;

    final note = isNew
        ? event.note.copyWith(id: _uuid.v4(), createdAt: now, updatedAt: now)
        : event.note.copyWith(updatedAt: now);

    await _repository.upsertNote(note);

    final updatedNotes = List<Note>.from(state.notes)
      ..removeWhere((n) => n.id == note.id)
      ..add(note);

    _sortNotes(updatedNotes);
    emit(state.copyWith(
      notes: updatedNotes,
      filteredNotes: _applyFilters(updatedNotes),
    ));
  }

  Future<void> _onDeleteNote(
    DeleteNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    await _repository.deleteNote(event.noteId);
    final updatedNotes = state.notes.where((n) => n.id != event.noteId).toList();
    emit(state.copyWith(
      notes: updatedNotes,
      filteredNotes: _applyFilters(updatedNotes),
    ));
  }

  Future<void> _onTogglePin(
    ToggleNotePinEvent event,
    Emitter<NoteState> emit,
  ) async {
    await _repository.togglePin(event.noteId);

    final updatedNotes = state.notes.map((note) {
      if (note.id == event.noteId) {
        return note.copyWith(isPinned: !note.isPinned, updatedAt: DateTime.now());
      }
      return note;
    }).toList();

    _sortNotes(updatedNotes);
    emit(state.copyWith(
      notes: updatedNotes,
      filteredNotes: _applyFilters(updatedNotes),
    ));
  }

  Future<void> _onChangeColor(
    ChangeNoteColorEvent event,
    Emitter<NoteState> emit,
  ) async {
    await _repository.updateNoteColor(event.noteId, event.color?.value);

    final updatedNotes = state.notes.map((note) {
      if (note.id == event.noteId) {
        return note.copyWith(color: event.color, updatedAt: DateTime.now());
      }
      return note;
    }).toList();

    emit(state.copyWith(
      notes: updatedNotes,
      filteredNotes: _applyFilters(updatedNotes),
    ));
  }

  Future<void> _onLockNote(
    LockNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    await _repository.lockNote(event.noteId, event.pin, event.useBiometric);

    final updatedNotes = state.notes.map((note) {
      if (note.id == event.noteId) {
        return note.copyWith(
          isLocked: true,
          lockPin: event.pin,
          useBiometric: event.useBiometric,
          updatedAt: DateTime.now(),
        );
      }
      return note;
    }).toList();

    emit(state.copyWith(
      notes: updatedNotes,
      filteredNotes: _applyFilters(updatedNotes),
    ));
  }

  Future<void> _onUnlockNote(
    UnlockNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    await _repository.unlockNote(event.noteId);

    final updatedNotes = state.notes.map((note) {
      if (note.id == event.noteId) {
        return note.copyWith(
          isLocked: false,
          updatedAt: DateTime.now(),
        );
      }
      return note;
    }).toList();

    emit(state.copyWith(
      notes: updatedNotes,
      filteredNotes: _applyFilters(updatedNotes),
    ));
  }

  Future<void> _onSearchNotes(
    SearchNotesEvent event,
    Emitter<NoteState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(
        filteredNotes: _applyFilters(state.notes),
        searchQuery: '',
      ));
      return;
    }

    final query = event.query.toLowerCase();
    final filtered = state.notes.where((note) {
      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query) ||
          (note.tags?.any((t) => t.toLowerCase().contains(query)) ?? false);
    }).toList();

    emit(state.copyWith(filteredNotes: filtered, searchQuery: event.query));
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<NoteState> emit) {
    emit(state.copyWith(
      filteredNotes: _applyFilters(state.notes),
      searchQuery: '',
    ));
  }

  void _onFilterByCategory(
    FilterByCategoryEvent event,
    Emitter<NoteState> emit,
  ) {
    emit(state.copyWith(
      selectedCategory: event.category,
      filteredNotes: _applyFilters(state.notes, category: event.category),
    ));
  }

  void _onFilterByTag(FilterByTagEvent event, Emitter<NoteState> emit) {
    emit(state.copyWith(
      selectedTag: event.tag,
      filteredNotes: _applyFilters(state.notes, tag: event.tag),
    ));
  }

  void _onFilterByType(FilterByTypeEvent event, Emitter<NoteState> emit) {
    emit(state.copyWith(
      selectedType: event.type,
      filteredNotes: _applyFilters(state.notes, type: event.type),
    ));
  }

  void _onClearFilters(ClearFiltersEvent event, Emitter<NoteState> emit) {
    emit(state.copyWith(
      clearFilters: true,
      filteredNotes: state.notes,
      searchQuery: '',
    ));
  }

  void _sortNotes(List<Note> notes) {
    notes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      final aDate = a.updatedAt ?? a.createdAt;
      final bDate = b.updatedAt ?? b.createdAt;
      return bDate.compareTo(aDate);
    });
  }

  List<Note> _applyFilters(
    List<Note> notes, {
    NoteCategory? category,
    String? tag,
    NoteType? type,
  }) {
    final cat = category ?? state.selectedCategory;
    final t = tag ?? state.selectedTag;
    final noteType = type ?? state.selectedType;

    return notes.where((note) {
      if (cat != null && note.category != cat) return false;
      if (t != null && (note.tags == null || !note.tags!.contains(t))) return false;
      if (noteType != null && note.type != noteType) return false;
      return true;
    }).toList();
  }
}

