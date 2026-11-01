import 'package:flutter/material.dart';

import '../data/models/movie.dart';
import 'screens/movie_details_screen.dart';

/// مكان واحد لفتح تفاصيل فيلم (بدل ما كل شاشة تكرر الكود).
void openMovieDetails(BuildContext context, Movie movie) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => MovieDetailsScreen(movieId: movie.id),
    ),
  );
}
