import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static const _databaseName = 'notely.db';
  static const _databaseVersion = 2;

  static Future<Database> openDatabaseFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createTables(db);
        }
      },
    );
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT NOT NULL,
        isPinned INTEGER NOT NULL,
        isFavorite INTEGER NOT NULL,
        isArchived INTEGER NOT NULL,
        isDeleted INTEGER NOT NULL,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS note_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        noteId INTEGER NOT NULL,
        action TEXT NOT NULL,
        details TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');
  }
}
