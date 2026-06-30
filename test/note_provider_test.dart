import 'package:flutter_test/flutter_test.dart';
import 'package:notely/features/notes/models/note_model.dart';
import 'package:notely/features/notes/providers/note_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class _FakePathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.';

  @override
  Future<String?> getApplicationSupportPath() async => '.';

  @override
  Future<String?> getTemporaryPath() async => '.';

  @override
  Future<String?> getLibraryPath() async => '.';

  @override
  Future<String?> getDownloadsPath() async => '.';

  @override
  Future<String?> getApplicationCachePath() async => '.';

  @override
  Future<String?> getExternalStoragePath() async => '.';

  @override
  Future<List<String>?> getExternalCachePaths() async => ['.'];

  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async => ['.'];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    PathProviderPlatform.instance = _FakePathProviderPlatform();
  });

  test('archiving a note adds a history entry', () async {
    final provider = NoteProvider();
    await provider.initialize();

    final note = Note(
      title: 'History test note',
      content: 'This note should be archived and logged.',
      category: 'Ideas',
    );

    await provider.saveNote(note);

    final savedNote = provider.notes.firstWhere(
      (entry) => entry.title == 'History test note',
    );

    await provider.archiveNote(savedNote);

    expect(
      provider.archivedNotes.any((entry) => entry.id == savedNote.id),
      isTrue,
    );
    expect(
      provider.historyEntries.any(
        (entry) => entry.noteId == savedNote.id && entry.action == 'Archived',
      ),
      isTrue,
    );
  });
}
