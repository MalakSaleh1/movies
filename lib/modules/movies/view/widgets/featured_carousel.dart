import 'package:flutter/material.dart';

import '../../data/models/movie.dart';
import 'movie_card.dart';


class FeaturedCarousel extends StatelessWidget {
  final PageController controller;
  final List<Movie> movies;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<Movie> onTap;

  const FeaturedCarousel({
    super.key,
    required this.controller,
    required this.movies,
    required this.onPageChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: PageView.builder(
        controller: controller,
        itemCount: movies.length,
        onPageChanged: onPageChanged,
        itemBuilder: (_, i) {
          return AnimatedBuilder(
            animation: controller,
            builder: (_, child) {
              double page = 0;
              if (controller.hasClients && controller.position.haveDimensions) {
                page = controller.page ?? 0;
              }
              final scale = (1 - (page - i).abs() * 0.2).clamp(0.8, 1.0);
              return Center(
                child: SizedBox(height: 320 * scale, child: child),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: MovieCard(movie: movies[i], onTap: onTap),
            ),
          );
        },
      ),
    );
  }
}
