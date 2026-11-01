import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/state/async_state.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/search_field.dart';
import '../../data/models/movie.dart';
import '../../providers/search_provider.dart';
import '../movie_navigation.dart';
import '../widgets/movies_grid.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchProvider>();

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SearchField(
              controller: _controller,
              onChanged: search.onQueryChanged,
            ),
          ),
          Expanded(
            child: search.query.isEmpty && search.state.data == null
                ? const EmptyState()
                : AsyncView<List<Movie>>(
                    // أثناء الـ loading بنعرض loader بدل النتايج القديمة
                    state: search.state.isLoading
                        ? const AsyncState<List<Movie>>.loading()
                        : search.state,
                    onRetry: search.retry,
                    isEmpty: (movies) => movies.isEmpty,
                    builder: (context, movies) => MoviesGrid(
                      movies: movies,
                      onTap: (m) => openMovieDetails(context, m),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
