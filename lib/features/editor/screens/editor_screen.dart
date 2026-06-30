import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../core/utils/validators.dart';
import '../../../features/notes/models/note_model.dart';
import '../../../features/notes/providers/note_provider.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../shared/widgets/glass_card.dart';

class EditorScreen extends StatefulWidget {
  final Note? note;

  const EditorScreen({super.key, this.note});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final _formKey = GlobalKey<FormState>();
  bool _previewMode = false;
  String _category = 'Work';
  bool _isPinned = false;
  bool _isFavorite = false;
  bool _isArchived = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    _contentController.addListener(() {
      setState(() {});
    });
    _category = widget.note?.category ?? 'Work';
    _isPinned = widget.note?.isPinned ?? false;
    _isFavorite = widget.note?.isFavorite ?? false;
    _isArchived = widget.note?.isArchived ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    final note = Note(
      id: widget.note?.id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      category: _category,
      isPinned: _isPinned,
      isFavorite: _isFavorite,
      isArchived: _isArchived,
      isDeleted: widget.note?.isDeleted ?? false,
      createdAt: widget.note?.createdAt,
      updatedAt: DateTime.now(),
    );

    await context.read<NoteProvider>().saveNote(note);
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  void _togglePreview() {
    setState(() {
      _previewMode = !_previewMode;
    });
  }

  void _togglePin() {
    setState(() {
      _isPinned = !_isPinned;
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _toggleArchive() {
    setState(() {
      _isArchived = !_isArchived;
    });
  }

  int _getWordCount() {
    if (_contentController.text.isEmpty) return 0;
    return _contentController.text
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
  }

  int _getCharacterCount() {
    return _contentController.text.length;
  }

  int _getReadingTime() {
    final wordCount = _getWordCount();
    return (wordCount / 180).ceil().clamp(1, 999);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.xl,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.06),
                          blurRadius: 18,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, size: 18),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Capture your next idea',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Markdown support, live preview, stats, and smooth interaction.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlassCard(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          validator: Validators.validateTitle,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            hintText: 'Start with a memorable headline',
                          ),
                        ),
                        const SizedBox(height: 18),
                        DropdownButtonFormField<String>(
                          initialValue: _category,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Work',
                              child: Text('Work'),
                            ),
                            DropdownMenuItem(
                              value: 'Design',
                              child: Text('Design'),
                            ),
                            DropdownMenuItem(
                              value: 'Ideas',
                              child: Text('Ideas'),
                            ),
                            DropdownMenuItem(
                              value: 'Journal',
                              child: Text('Journal'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _category = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _togglePreview,
                                icon: Icon(
                                  _previewMode ? Icons.edit : Icons.visibility,
                                ),
                                label: Text(_previewMode ? 'Edit' : 'Preview'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryOrange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.pill,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton.outlined(
                              onPressed: _togglePin,
                              icon: Icon(
                                _isPinned
                                    ? Icons.push_pin
                                    : Icons.push_pin_outlined,
                              ),
                              tooltip: _isPinned ? 'Unpin note' : 'Pin note',
                            ),
                            IconButton.outlined(
                              onPressed: _toggleFavorite,
                              icon: Icon(
                                _isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                              ),
                              tooltip: _isFavorite
                                  ? 'Remove from favorites'
                                  : 'Add to favorites',
                            ),
                            IconButton.outlined(
                              onPressed: _toggleArchive,
                              icon: Icon(
                                _isArchived
                                    ? Icons.unarchive
                                    : Icons.archive_outlined,
                              ),
                              tooltip: _isArchived
                                  ? 'Unarchive note'
                                  : 'Archive note',
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Container(
                          height: 340,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: AppRadius.lg,
                          ),
                          child: _previewMode
                              ? MarkdownBody(
                                  data: _contentController.text.isEmpty
                                      ? 'Nothing to preview yet. Start typing to see your note come alive.'
                                      : _contentController.text,
                                )
                              : TextFormField(
                                  controller: _contentController,
                                  maxLines: null,
                                  minLines: 10,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        'Write your note here. Use markdown formatting and checklists.',
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _EditorBadge(label: 'Words', value: '${_getWordCount()}'),
                      _EditorBadge(
                        label: 'Characters',
                        value: '${_getCharacterCount()}',
                      ),
                      _EditorBadge(
                        label: 'Read',
                        value: '${_getReadingTime()} min',
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  GradientButton(
                    title: widget.note == null ? 'Save note' : 'Update note',
                    onPressed: _saveNote,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      if (widget.note != null) {
                        context.read<NoteProvider>().deleteNote(widget.note!);
                      }
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.pill,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Discard'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditorBadge extends StatelessWidget {
  final String label;
  final String value;

  const _EditorBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.pill,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
