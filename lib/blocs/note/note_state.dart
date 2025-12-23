part of 'note_bloc.dart';

enum NoteStatus { initial, loading, ready, failure }

class NoteState extends Equatable {
  final List<Note> notes;
  final List<Note> filteredNotes;
  final NoteStatus status;
  final String? errorMessage;
  final String searchQuery;
  final NoteCategory? selectedCategory;
  final String? selectedTag;
  final NoteType? selectedType;

  const NoteState({
    this.notes = const [],
    this.filteredNotes = const [],
    this.status = NoteStatus.initial,
    this.errorMessage,
    this.searchQuery = '',
    this.selectedCategory,
    this.selectedTag,
    this.selectedType,
  });

  List<Note> get pinnedNotes => filteredNotes.where((n) => n.isPinned).toList();
  List<Note> get unpinnedNotes => filteredNotes.where((n) => !n.isPinned).toList();

  int get totalCount => notes.length;
  int get pinnedCount => notes.where((n) => n.isPinned).length;
  int get checklistCount => notes.where((n) => n.type == NoteType.checklist).length;
  int get lockedCount => notes.where((n) => n.isLocked).length;

  /// Get all unique tags from notes
  List<String> get allTags {
    final tags = <String>{};
    for (final note in notes) {
      if (note.tags != null) {
        tags.addAll(note.tags!);
      }
    }
    return tags.toList()..sort();
  }

  /// Get notes grouped by category
  Map<NoteCategory, List<Note>> get notesByCategory {
    final grouped = <NoteCategory, List<Note>>{};
    for (final note in notes) {
      if (note.category != null) {
        grouped.putIfAbsent(note.category!, () => []);
        grouped[note.category!]!.add(note);
      }
    }
    return grouped;
  }

  bool get hasActiveFilter =>
      selectedCategory != null || selectedTag != null || selectedType != null;

  NoteState copyWith({
    List<Note>? notes,
    List<Note>? filteredNotes,
    NoteStatus? status,
    String? errorMessage,
    String? searchQuery,
    NoteCategory? selectedCategory,
    String? selectedTag,
    NoteType? selectedType,
    bool clearFilters = false,
  }) {
    return NoteState(
      notes: notes ?? this.notes,
      filteredNotes: filteredNotes ?? this.filteredNotes,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: clearFilters ? null : (selectedCategory ?? this.selectedCategory),
      selectedTag: clearFilters ? null : (selectedTag ?? this.selectedTag),
      selectedType: clearFilters ? null : (selectedType ?? this.selectedType),
    );
  }

  @override
  List<Object?> get props => [
        notes,
        filteredNotes,
        status,
        errorMessage,
        searchQuery,
        selectedCategory,
        selectedTag,
        selectedType,
      ];
}

