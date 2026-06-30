import 'package:flutter/material.dart' hide SearchBar;
import 'package:provider/provider.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/search_bar.dart';
import '../../notes/providers/note_provider.dart';
import '../../notes/widgets/note_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();
    final results = _query.isEmpty
        ? provider.activeNotes
        : provider.search(_query);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search notes'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            children: [
              SearchBar(
                controller: _searchController,
                hintText: 'Search by title, content, or category',
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              if (results.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Center(
                    child: Text(
                      _query.isEmpty
                          ? 'No recent notes yet.'
                          : 'No notes match your search.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: results.length,
                  separatorBuilder: (_, index) =>
                      const SizedBox(height: 18),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final note = results[index];
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
            ],
          ),
        ),
      ),
    );
  }
}
