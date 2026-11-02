import 'package:flutter/material.dart';

import '../../data/models/movie.dart';
import 'movie_card.dart';

class MoviesGrid extends StatelessWidget {
  final List<Movie> movies;
  final int crossAxisCount;
  final ValueChanged<Movie> onTap;
  final EdgeInsets padding;

  const MoviesGrid({
    super.key,
    required this.movies,
    required this.onTap,
    this.crossAxisCount = 2,
    this.padding =
        const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 120),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      itemCount: movies.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 16,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (_, i) => MovieCard(movie: movies[i], onTap: onTap),
    );
  }
}
