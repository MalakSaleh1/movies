import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/genres.dart';
import '../../../../core/state/async_state.dart';
import '../../../../core/theme/app_colors/app_colors.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../data/models/movie.dart';
import '../../providers/home_provider.dart';
import '../movie_navigation.dart';
import '../widgets/featured_carousel.dart';
import '../widgets/genre_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _controller;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.58);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<HomeProvider>().loadFeatured();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featured = context.select<HomeProvider, AsyncState<List<Movie>>>(
      (p) => p.featured,
    );

    return AsyncView<List<Movie>>(
      state: featured,
      onRetry: () => context.read<HomeProvider>().loadFeatured(force: true),
      isEmpty: (movies) => movies.isEmpty,
      empty: const EmptyState(message: 'No movies found'),
      builder: (context, movies) {
        final current = movies[_current.clamp(0, movies.length - 1)];

        return Stack(
          fit: StackFit.expand,
          children: [
            _Backdrop(movie: current),
            SafeArea(
              child: RefreshIndicator(
                color: AppColors.orange,
                backgroundColor: AppColors.darkGrey,
                onRefresh: context.read<HomeProvider>().refresh,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: _Header(
                        controller: _controller,
                        movies: movies,
                        onPageChanged: (i) => setState(() => _current = i),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => GenreSection(
                          key: ValueKey(AppGenres.all[i]),
                          genre: AppGenres.all[i],
                          genreIndex: i,
                        ),
                        childCount: AppGenres.all.length,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Backdrop extends StatelessWidget {
  final Movie movie;
  const _Backdrop({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: SizedBox.expand(
            key: ValueKey(movie.id),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: AppImage(url: movie.coverImage),
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.black.withOpacity(.6),
                AppColors.black.withOpacity(.85),
                AppColors.black,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final PageController controller;
  final List<Movie> movies;
  final ValueChanged<int> onPageChanged;

  const _Header({
    required this.controller,
    required this.movies,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38),
            child: Image.asset(
              "assets/Text/0c5e9a732005a8c14492ae830b4da544d75cac19.png",
            ),
          ),
        ),
        const SizedBox(height: 12),
        FeaturedCarousel(
          controller: controller,
          movies: movies,
          onPageChanged: onPageChanged,
          onTap: (m) => openMovieDetails(context, m),
        ),
        const SizedBox(height: 8),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38),
            child: Image.asset(
              "assets/Text/97ab5fb2e4e76c640b21b6db578a86b1e22877ec.png",
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
