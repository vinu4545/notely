import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/database/database_service.dart';
import '../models/note_activity.dart';
import '../models/note_model.dart';

class NoteProvider extends ChangeNotifier {
  NoteProvider() {
    _service = DatabaseService.instance;
  }

  late final DatabaseService _service;
  List<Note> _notes = [];
  List<NoteActivityEntry> _historyEntries = [];
  List<String> _categories = [];
  bool isLoading = true;
  String activeCategory = 'All';

  static const List<String> defaultCategories = ['Work', 'Travelling', 'Study'];

  List<Note> get notes => [..._notes];

  List<Note> get activeNotes =>
      _notes.where((note) => !note.isDeleted && !note.isArchived).toList();

  List<Note> get pinnedNotes =>
      activeNotes.where((note) => note.isPinned).toList();

  List<Note> get favoriteNotes =>
      activeNotes.where((note) => note.isFavorite).toList();

  List<Note> get archivedNotes =>
      _notes.where((note) => note.isArchived && !note.isDeleted).toList();

  List<Note> get trashNotes => _notes.where((note) => note.isDeleted).toList();

  List<NoteActivityEntry> get historyEntries => [..._historyEntries];

  List<String> get categories {
    final items = <String>['All', ..._categories];
    for (final category in activeNotes.map((note) => note.category)) {
      if (!items.contains(category)) {
        items.add(category);
      }
    }
    return items;
  }

  List<String> get availableCategories => [..._categories];

  List<String> get customCategories => _categories
      .where((category) => !defaultCategories.contains(category))
      .toList();

  Future<void> initialize() async {
    await _loadSavedCategories();
    await _service.ensureSampleNotes();
    await loadNotes();
    await loadHistory();
  }

  Future<void> loadNotes() async {
    isLoading = true;
    notifyListeners();
    _notes = await _service.fetchNotes();
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    _historyEntries = await _service.fetchHistory();
    notifyListeners();
  }

  Future<void> _loadSavedCategories() async {
    final preferences = await SharedPreferences.getInstance();
    _categories =
        preferences.getStringList(AppConstants.categoryPreferenceKey) ??
        defaultCategories;
    if (_categories.isEmpty) {
      _categories = defaultCategories;
    }
  }

  Future<void> _saveCategories() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      AppConstants.categoryPreferenceKey,
      _categories,
    );
  }

  Future<void> addCategory(String category) async {
    final normalized = category.trim();
    if (normalized.isEmpty || normalized == 'All') return;
    if (_categories.contains(normalized)) {
      return;
    }
    _categories.add(normalized);
    await _saveCategories();
    notifyListeners();
  }

  Future<void> removeCategory(String category) async {
    if (category.isEmpty || category == 'All') return;
    if (!_categories.contains(category)) return;
    _categories.remove(category);
    await _saveCategories();

    final fallbackCategory = _categories.isNotEmpty
        ? _categories.first
        : defaultCategories.first;

    final affectedNotes = _notes
        .where((note) => note.category == category)
        .toList();
    for (final note in affectedNotes) {
      await _service.updateNote(
        note.copyWith(category: fallbackCategory, updatedAt: DateTime.now()),
      );
    }
    await loadNotes();
    notifyListeners();
  }

  Future<void> saveNote(Note note) async {
    final now = DateTime.now();
    if (note.id == null) {
      final createdId = await _service.createNote(
        note.copyWith(updatedAt: now),
      );
      if (createdId != 0) {
        await _service.logNoteActivity(
          NoteActivityEntry(
            noteId: createdId.toInt(),
            action: 'Created',
            details: 'Added a new note to the workspace',
          ),
        );
      }
    } else {
      await _service.updateNote(note.copyWith(updatedAt: now));
      await _service.logNoteActivity(
        NoteActivityEntry(
          noteId: note.id!,
          action: 'Updated',
          details: 'Updated the note content or metadata',
        ),
      );
    }
    await loadNotes();
    await loadHistory();
  }

  Future<void> deleteNote(Note note) async {
    if (note.id == null) return;
    final updated = note.copyWith(
      isDeleted: true,
      isArchived: false,
      updatedAt: DateTime.now(),
    );
    await _service.updateNote(updated);
    await _service.logNoteActivity(
      NoteActivityEntry(
        noteId: note.id!,
        action: 'Moved to trash',
        details: 'Removed the note from the active workspace',
      ),
    );
    await loadNotes();
    await loadHistory();
  }

  Future<void> archiveNote(Note note) async {
    if (note.id == null) return;
    final updated = note.copyWith(isArchived: true, updatedAt: DateTime.now());
    await _service.updateNote(updated);
    await _service.logNoteActivity(
      NoteActivityEntry(
        noteId: note.id!,
        action: 'Archived',
        details: 'Moved the note into the archive',
      ),
    );
    await loadNotes();
    await loadHistory();
  }

  Future<void> restoreNote(Note note) async {
    if (note.id == null) return;
    final updated = note.copyWith(
      isDeleted: false,
      isArchived: false,
      updatedAt: DateTime.now(),
    );
    await _service.updateNote(updated);
    await _service.logNoteActivity(
      NoteActivityEntry(
        noteId: note.id!,
        action: 'Restored',
        details: 'Brought the note back to the workspace',
      ),
    );
    await loadNotes();
    await loadHistory();
  }

  Future<void> toggleFavorite(Note note) async {
    if (note.id == null) return;
    final updated = note.copyWith(
      isFavorite: !note.isFavorite,
      updatedAt: DateTime.now(),
    );
    await _service.updateNote(updated);
    await _service.logNoteActivity(
      NoteActivityEntry(
        noteId: note.id!,
        action: note.isFavorite
            ? 'Removed from favorites'
            : 'Added to favorites',
        details: note.isFavorite
            ? 'Removed the note from favorites'
            : 'Added the note to favorites',
      ),
    );
    await loadNotes();
  }

  Future<void> togglePin(Note note) async {
    if (note.id == null) return;
    final updated = note.copyWith(
      isPinned: !note.isPinned,
      updatedAt: DateTime.now(),
    );
    await _service.updateNote(updated);
    await _service.logNoteActivity(
      NoteActivityEntry(
        noteId: note.id!,
        action: note.isPinned ? 'Unpinned' : 'Pinned',
        details: note.isPinned
            ? 'Removed the note from pinned'
            : 'Pinned the note for quick access',
      ),
    );
    await loadNotes();
  }

  Future<void> markNoteAsVisited(Note note) async {
    if (note.id == null) return;
    final updated = note.copyWith(updatedAt: DateTime.now());
    await _service.updateNote(updated);
    await _service.logNoteActivity(
      NoteActivityEntry(
        noteId: note.id!,
        action: 'Visited',
        details: 'Viewed the note to continue working on it',
      ),
    );
    await loadNotes();
    await loadHistory();
  }

  Future<void> deletePermanently(Note note) async {
    if (note.id == null) return;
    await _service.deleteNotePermanently(note.id!);
    await _service.logNoteActivity(
      NoteActivityEntry(
        noteId: note.id!,
        action: 'Deleted permanently',
        details: 'Removed the note from storage forever',
      ),
    );
    await loadNotes();
    await loadHistory();
  }

  Note? noteById(int? id) {
    if (id == null) return null;
    for (final note in _notes) {
      if (note.id == id) return note;
    }
    return null;
  }

  String noteTitleFor(int? noteId) {
    final note = noteById(noteId);
    return note?.title ?? 'Untitled note';
  }

  List<Note> get lastVisitedNotes {
    final sortedNotes = activeNotes.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final now = DateTime.now();
    final visitedToday = sortedNotes.where((note) {
      final updated = note.updatedAt;
      return updated.year == now.year &&
          updated.month == now.month &&
          updated.day == now.day;
    }).toList();

    if (visitedToday.isNotEmpty) {
      return visitedToday;
    }

    return sortedNotes.take(10).toList();
  }

  List<Note> notesForSection(String section) {
    switch (section) {
      case 'favorites':
        return favoriteNotes;
      case 'pinned':
        return pinnedNotes;
      case 'lastVisited':
        return lastVisitedNotes;
      default:
        return activeNotes;
    }
  }

  List<Note> search(String query) {
    final normalized = query.toLowerCase();
    return activeNotes.where((note) {
      return note.title.toLowerCase().contains(normalized) ||
          note.content.toLowerCase().contains(normalized) ||
          note.category.toLowerCase().contains(normalized);
    }).toList();
  }

  List<Note> filteredNotes() {
    if (activeCategory == 'All') return activeNotes;
    return activeNotes
        .where((note) => note.category == activeCategory)
        .toList();
  }

  void selectCategory(String category) {
    activeCategory = category;
    notifyListeners();
  }

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String statusText() {
    final count = activeNotes.length;
    return '$count notes waiting for your next idea';
  }
}
