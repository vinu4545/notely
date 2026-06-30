import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/components/empty_state.dart';
import '../../notes/providers/note_provider.dart';

class TrashScreen extends StatelessWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: provider.trashNotes.isEmpty
              ? SizedBox(
                  height: 500,
                  child: EmptyState(
                    icon: Icons.delete_outline,
                    imageAsset: 'assets/empty_trash.png',
                    title: 'Trash is empty',
                    description:
                        'Notes you delete will appear here. Restore anything with one tap.',
                    buttonLabel: 'Back to workspace',
                    onTap: () => Navigator.pop(context),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.trashNotes.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 18),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final note = provider.trashNotes[index];
                    return ListTile(
                      tileColor: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      title: Text(note.title),
                      subtitle: Text(note.category),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () => provider.restoreNote(note),
                            child: const Text('Restore'),
                          ),
                          TextButton(
                            onPressed: () => provider.deletePermanently(note),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
