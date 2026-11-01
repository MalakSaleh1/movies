import 'package:flutter/material.dart';

import '../../data/models/movie.dart';
import 'movie_card.dart';

class SimilarMoviesGrid extends StatelessWidget {
  final List<Movie> movies;
  final ValueChanged<Movie> onTap;

  const SimilarMoviesGrid({
    super.key,
    required this.movies,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (_, i) => MovieCard(movie: movies[i], onTap: onTap),
    );
  }
}
