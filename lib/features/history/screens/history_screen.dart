import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../notes/models/note_model.dart';
import '../../notes/providers/note_provider.dart';

class HistoryScreen extends StatelessWidget {
  final Note? note;

  const HistoryScreen({super.key, this.note});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();
    final entries = note == null
        ? provider.historyEntries
        : provider.historyEntries
              .where((entry) => entry.noteId == note!.id)
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          note == null ? 'Activity history' : '${note!.title} history',
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: entries.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.history_outlined,
                      size: 56,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No activity recorded yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note == null
                          ? 'Archive, restore, or delete notes to build a record.'
                          : 'This note has no recorded actions yet.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Note')),
                      DataColumn(label: Text('Action')),
                      DataColumn(label: Text('Details')),
                      DataColumn(label: Text('Time')),
                    ],
                    rows: entries.map((entry) {
                      return DataRow(
                        cells: [
                          DataCell(
                            SizedBox(
                              width: 180,
                              child: Text(
                                provider.noteTitleFor(entry.noteId),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(Text(entry.action)),
                          DataCell(
                            SizedBox(
                              width: 240,
                              child: Text(
                                entry.details,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${DateUtilsHelper.formatShort(entry.createdAt)} • ${DateUtilsHelper.formatTime(entry.createdAt)}',
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
      ),
    );
  }
}
