import 'package:flutter/material.dart' hide SearchBar;
import 'package:provider/provider.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_gradients.dart';
import '../../../app/theme/app_radius.dart';
import '../../../shared/widgets/animated_fab.dart';
import '../../../shared/widgets/category_chip.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/widgets/search_bar.dart';
import '../../../shared/widgets/statistics_card.dart';
import '../../notes/providers/note_provider.dart';
import '../../notes/widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final noteProvider = context.watch<NoteProvider>();
    final isBusy = noteProvider.isLoading;
    final pinnedNotes = noteProvider.pinnedNotes;
    final categories = noteProvider.categories;
    final notes = _searchQuery.isEmpty
        ? noteProvider.filteredNotes()
        : noteProvider.search(_searchQuery);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.background),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              noteProvider.greeting(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Your modern workspace',
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: AppColors.textPrimary,
                            ),
                            onSelected: (value) {
                              switch (value) {
                                case 'archive':
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.archive,
                                  );
                                  break;
                                case 'trash':
                                  Navigator.pushNamed(context, AppRoutes.trash);
                                  break;
                                case 'history':
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.history,
                                  );
                                  break;
                                case 'favorites':
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.notes,
                                    arguments: 'favorites',
                                  );
                                  break;
                                case 'lastVisited':
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.notes,
                                    arguments: 'lastVisited',
                                  );
                                  break;
                                case 'pinned':
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.notes,
                                    arguments: 'pinned',
                                  );
                                  break;
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'archive',
                                child: Row(
                                  children: [
                                    Icon(Icons.archive_outlined),
                                    SizedBox(width: 8),
                                    Text('Archived notes'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'trash',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_outline),
                                    SizedBox(width: 8),
                                    Text('Deleted notes'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'history',
                                child: Row(
                                  children: [
                                    Icon(Icons.history_outlined),
                                    SizedBox(width: 8),
                                    Text('Activity log'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'favorites',
                                child: Row(
                                  children: [
                                    Icon(Icons.favorite_outline),
                                    SizedBox(width: 8),
                                    Text('Favorites'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'lastVisited',
                                child: Row(
                                  children: [
                                    Icon(Icons.access_time_outlined),
                                    SizedBox(width: 8),
                                    Text('Last visited'),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'pinned',
                                child: Row(
                                  children: [
                                    Icon(Icons.push_pin_outlined),
                                    SizedBox(width: 8),
                                    Text('Pinned'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primaryPink,
                                  AppColors.primaryOrange,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: AppRadius.xl,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(255, 77, 141, 0.24),
                                  blurRadius: 18,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'N',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  GlassCard(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          noteProvider.statusText(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SearchBar(
                          controller: _searchController,
                          hintText: 'Search notes, categories, or keywords',
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 122,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      separatorBuilder: (_, index) => const SizedBox(width: 18),
                      itemBuilder: (context, index) {
                        final items = [
                          StatisticsCard(
                            label: 'Pinned',
                            value: '${pinnedNotes.length}',
                            caption: 'Focus items ready to open',
                          ),
                          StatisticsCard(
                            label: 'Favorites',
                            value: '${noteProvider.favoriteNotes.length}',
                            caption: 'Saved inspiration',
                          ),
                          StatisticsCard(
                            label: 'Categories',
                            value: '${categories.length - 1}',
                            caption: 'Organized sections',
                          ),
                        ];
                        return SizedBox(width: 240, child: items[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CategoryChip(
                          label: category,
                          selected: noteProvider.activeCategory == category,
                          onTap: () => noteProvider.selectCategory(category),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (isBusy)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (notes.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
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
                            const Text(
                              'No notes here yet',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Create your first note and keep your ideas flowing.',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: 180,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.editor,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryPink,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.pill,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                child: const Text('Create note'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notes.length,
                      separatorBuilder: (_, index) =>
                          const SizedBox(height: 18),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return NoteCard(
                          note: note,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.editor,
                              arguments: note,
                            );
                          },
                          onActionSelected: (selectedNote, action) async {
                            switch (action) {
                              case 'archive':
                                await noteProvider.archiveNote(selectedNote);
                                break;
                              case 'delete':
                                await noteProvider.deleteNote(selectedNote);
                                break;
                              case 'favorite':
                                await noteProvider.toggleFavorite(selectedNote);
                                break;
                              case 'pin':
                                await noteProvider.togglePin(selectedNote);
                                break;
                              case 'history':
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.history,
                                  arguments: selectedNote,
                                );
                                break;
                            }
                          },
                        );
                      },
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedFAB(
        icon: Icons.add,
        label: 'New note',
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.editor);
        },
      ),
    );
  }
}
