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
                              'Your premium notebook',
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                              'Create your first premium note to get started.',
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
