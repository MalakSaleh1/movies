import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../movies/view/movie_navigation.dart';
import '../../../movies/view/widgets/movies_grid.dart';
import '../../providers/library_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movies = context.watch<LibraryProvider>().history;

    if (movies.isEmpty) return const EmptyState();

    return MoviesGrid(
      movies: movies,
      crossAxisCount: 3,
      onTap: (m) => openMovieDetails(context, m),
    );
  }
}
