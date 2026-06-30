import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_radius.dart';
import '../../../core/utils/date_utils.dart';
import '../../notes/models/note_model.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final VoidCallback onTap;
  final Future<void> Function(Note note, String action)? onActionSelected;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    this.onActionSelected,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 240),
          scale: _isHovering ? 1.01 : 1.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppRadius.lg,
              gradient: AppGradients.card,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(
                    ((_isHovering ? 0.12 : 0.06) * 255).round(),
                  ),
                  blurRadius: _isHovering ? 24 : 18,
                  offset: const Offset(0, 14),
                ),
              ],
              border: Border.all(color: AppColors.border),
            ),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppRadius.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.note.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (widget.note.isPinned)
                        const Icon(
                          Icons.push_pin,
                          size: 18,
                          color: AppColors.primaryPink,
                        ),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.more_horiz,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        onSelected: (value) async {
                          if (widget.onActionSelected != null) {
                            await widget.onActionSelected!(widget.note, value);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'history',
                            child: Row(
                              children: [
                                Icon(Icons.history_outlined),
                                SizedBox(width: 8),
                                Text('History'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'archive',
                            child: Row(
                              children: [
                                Icon(Icons.archive_outlined),
                                SizedBox(width: 8),
                                Text('Archive'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline),
                                SizedBox(width: 8),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentPink.withAlpha(
                        (0.35 * 255).round(),
                      ),
                      borderRadius: AppRadius.pill,
                    ),
                    child: Text(
                      widget.note.category,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryPink,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.note.preview,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateUtilsHelper.formatShort(widget.note.updatedAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Row(
                        children: [
                          _NoteMetric(label: '${widget.note.readingTime} min'),
                          const SizedBox(width: 12),
                          _NoteMetric(label: '${widget.note.wordCount} words'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NoteMetric extends StatelessWidget {
  final String label;

  const _NoteMetric({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryPink.withAlpha((.08 * 255).round()),
        borderRadius: AppRadius.pill,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.primaryPink,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
