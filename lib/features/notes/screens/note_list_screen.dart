import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../notes/providers/note_provider.dart';
import '../../notes/widgets/note_card.dart';

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();
    final notes = provider.activeNotes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All notes'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: notes.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/empty_notes.png',
                          width: 180,
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'No notes found yet. Create a note and it will appear here.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notes.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 18),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteCard(
                      note: note,
                      onTap: () {
                        Navigator.pushNamed(context, '/editor', arguments: note);
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
