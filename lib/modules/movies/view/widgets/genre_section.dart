import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/state/async_state.dart';
import '../../../../core/theme/app_colors/app_colors.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../data/models/movie.dart';
import '../../providers/home_provider.dart';
import '../movie_navigation.dart';
import '../screens/browse_screen.dart';
import 'movie_card.dart';

class GenreSection extends StatefulWidget {
  final String genre;
  final int genreIndex;

  const GenreSection({
    super.key,
    required this.genre,
    required this.genreIndex,
  });

  @override
  State<GenreSection> createState() => _GenreSectionState();
}

class _GenreSectionState extends State<GenreSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<HomeProvider>().loadGenre(widget.genre);
    });
  }

  void _seeMore() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BrowseScreen(initialGenreIndex: widget.genreIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select<HomeProvider, AsyncState<List<Movie>>>(
      (p) => p.genreState(widget.genre),
    );
    final movies = state.data;

    Widget body;
    if (movies != null) {
      if (movies.isEmpty) return const SizedBox.shrink();
      body = SizedBox(
        height: 170,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: movies.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) => SizedBox(
            width: 115,
            child: MovieCard(
              movie: movies[i],
              onTap: (m) => openMovieDetails(context, m),
            ),
          ),
        ),
      );
    } else if (state.hasError) {
      body = SizedBox(
        height: 60,
        child: Center(
          child: TextButton(
            onPressed: () => context
                .read<HomeProvider>()
                .loadGenre(widget.genre, force: true),
            child: Text('Retry', style: TextStyle(color: AppColors.orange)),
          ),
        ),
      );
    } else {
      body = const SizedBox(height: 170, child: AppLoading(strokeWidth: 2));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: widget.genre, onSeeMore: _seeMore),
          const SizedBox(height: 12),
          body,
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeMore;

  const _SectionHeader({required this.title, required this.onSeeMore});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          GestureDetector(
            onTap: onSeeMore,
            child: Row(
              children: [
                Text(
                  'See More',
                  style: TextStyle(color: AppColors.orange, fontSize: 16),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward, color: AppColors.orange, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
