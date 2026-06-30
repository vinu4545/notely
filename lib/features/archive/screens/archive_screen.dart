import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/components/empty_state.dart';
import '../../notes/providers/note_provider.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: provider.archivedNotes.isEmpty
              ? SizedBox(
                  height: 500,
                  child: EmptyState(
                    icon: Icons.archive_outlined,
                    imageAsset: 'assets/empty_archive.png',
                    title: 'Archive is empty',
                    description:
                        'Long press a note from your workspace to save it for later.',
                    buttonLabel: 'Browse notes',
                    onTap: () => Navigator.pop(context),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.archivedNotes.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 18),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final note = provider.archivedNotes[index];
                    return ListTile(
                      tileColor: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      title: Text(note.title),
                      subtitle: Text(note.category),
                      trailing: TextButton(
                        onPressed: () {
                          provider.restoreNote(note);
                        },
                        child: const Text('Restore'),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
