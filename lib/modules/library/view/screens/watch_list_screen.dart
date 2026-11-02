import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/empty_state.dart';
import '../../../movies/view/movie_navigation.dart';
import '../../../movies/view/widgets/movies_grid.dart';
import '../../providers/library_provider.dart';

class WatchListScreen extends StatelessWidget {
  const WatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movies = context.watch<LibraryProvider>().wishlist;

    if (movies.isEmpty) return const EmptyState();

    return MoviesGrid(
      movies: movies,
      crossAxisCount: 3,
      onTap: (m) => openMovieDetails(context, m),
    );
  }
}
