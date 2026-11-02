import 'package:flutter/material.dart';

import '../data/models/movie.dart';
import 'screens/movie_details_screen.dart';

void openMovieDetails(BuildContext context, Movie movie) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => MovieDetailsScreen(movieId: movie.id),
    ),
  );
}
