import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors/app_colors.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/section_title.dart';
import '../../../library/providers/library_provider.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/movies_repository.dart';
import '../../providers/movie_details_provider.dart';
import '../widgets/cast_card.dart';
import '../widgets/genre_chip.dart';
import '../widgets/movie_header.dart';
import '../widgets/movie_stats_row.dart';
import '../widgets/screenshot_item.dart';
import '../widgets/similar_movies_grid.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late final MovieDetailsProvider _provider;

  @override
  void initState() {
    super.initState();
    final library = context.read<LibraryProvider>();
    _provider = MovieDetailsProvider(
      context.read<MoviesRepository>(),
      widget.movieId,
      onLoaded: library.addToHistory,
    )..load();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  void _openMovie(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailsScreen(movieId: movie.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: ListenableBuilder(
        listenable: _provider,
        builder: (context, _) => AsyncView<MovieDetailsData>(
          state: _provider.state,
          loading: const AppLoading(),
          onRetry: () => _provider.load(force: true),
          builder: (context, data) =>
              _DetailsContent(data: data, onOpenMovie: _openMovie),
        ),
      ),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  final MovieDetailsData data;
  final ValueChanged<Movie> onOpenMovie;

  const _DetailsContent({required this.data, required this.onOpenMovie});

  @override
  Widget build(BuildContext context) {
    final movie = data.movie;
    final similar = data.similar;
    final library = context.watch<LibraryProvider>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MovieHeader(
            imageUrl: movie.backgroundImage.isNotEmpty
                ? movie.backgroundImage
                : movie.largeCoverImage,
            isBookmarked: library.isInWishlist(movie.id),
            onBookmarkTap: () => library.toggleWishlist(movie),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    movie.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    '${movie.year}',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Watch',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                MovieStatsRow(movie: movie),
                if (movie.screenshots.isNotEmpty) ...[
                  const SectionTitle('Screen Shots'),
                  ...movie.screenshots.map(
                    (url) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: ScreenshotItem(imageUrl: url),
                    ),
                  ),
                ],
                if (similar.isNotEmpty) ...[
                  const SectionTitle('Similar'),
                  SimilarMoviesGrid(movies: similar, onTap: onOpenMovie),
                ],
                if (movie.summary.isNotEmpty) ...[
                  const SectionTitle('Summary'),
                  Text(
                    movie.summary,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                    ),
                  ),
                ],
                if (movie.cast.isNotEmpty) ...[
                  const SectionTitle('Cast'),
                  ...movie.cast.map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CastCard(member: c),
                    ),
                  ),
                ],
                if (movie.genres.isNotEmpty) ...[
                  const SectionTitle('Genres'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        movie.genres.map((g) => GenreChip(label: g)).toList(),
                  ),
                ],
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
