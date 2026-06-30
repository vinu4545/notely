import 'package:sqflite/sqflite.dart';

import '../../features/notes/models/note_activity.dart';
import '../../features/notes/models/note_model.dart';
import '../constants/app_constants.dart';
import 'database_helper.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  Database? _database;

  Future<Database> get database async {
    _database ??= await DatabaseHelper.openDatabaseFile();
    return _database!;
  }

  Future<List<Note>> fetchNotes() async {
    final db = await database;
    final rows = await db.query(
      AppConstants.noteTable,
      orderBy: 'updatedAt DESC',
    );
    return rows.map(Note.fromMap).toList();
  }

  Future<int> createNote(Note note) async {
    final db = await database;
    return await db.insert(AppConstants.noteTable, note.toMap());
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      AppConstants.noteTable,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNotePermanently(int noteId) async {
    final db = await database;
    return await db.delete(
      AppConstants.noteTable,
      where: 'id = ?',
      whereArgs: [noteId],
    );
  }

  Future<List<NoteActivityEntry>> fetchHistory({int? noteId}) async {
    final db = await database;
    final rows = await db.query(
      AppConstants.noteHistoryTable,
      where: noteId == null ? null : 'noteId = ?',
      whereArgs: noteId == null ? null : [noteId],
      orderBy: 'createdAt DESC',
    );
    return rows.map(NoteActivityEntry.fromMap).toList();
  }

  Future<int> logNoteActivity(NoteActivityEntry entry) async {
    final db = await database;
    return await db.insert(AppConstants.noteHistoryTable, entry.toMap());
  }

  Future<void> ensureSampleNotes() async {
    final notes = await fetchNotes();
    if (notes.isNotEmpty) return;

    final now = DateTime.now();
    final seedNotes = [
      Note(
        title: 'Product sprint planning',
        content:
            'Outline the quarterly goals, define launch milestones, and organize notes for the new dashboard.',
        category: 'Work',
        isPinned: true,
        isFavorite: true,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Note(
        title: 'Design system review',
        content:
            'Review gradients, glass cards, and typography tokens for the next phase of Notely.',
        category: 'Design',
        isPinned: false,
        isFavorite: false,
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now.subtract(const Duration(days: 3)),
      ),
      Note(
        title: 'Ideas for launch email',
        content:
            'Write a short hero sentence, add soft illustrations, and keep the onboarding feeling polished.',
        category: 'Ideas',
        isPinned: false,
        isFavorite: true,
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 6)),
      ),
    ];

    for (final note in seedNotes) {
      await createNote(note);
    }
  }
}
