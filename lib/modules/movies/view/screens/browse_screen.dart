import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/genres.dart';
import '../../../../core/theme/app_colors/app_colors.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/genre_filter_chip.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/movies_repository.dart';
import '../../providers/browse_provider.dart';
import '../movie_navigation.dart';
import '../widgets/movies_grid.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key, this.initialGenreIndex = 0});

  final int initialGenreIndex;

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final BrowseProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = BrowseProvider(
      context.read<MoviesRepository>(),
      initialIndex: widget.initialGenreIndex,
    )..load();

    _tabController = TabController(
      length: AppGenres.all.length,
      vsync: this,
      initialIndex: widget.initialGenreIndex,
    )..addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    _provider.select(_tabController.index);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.black,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          bottom: false,
          child: ListenableBuilder(
            listenable: _provider,
            builder: (context, _) => Column(
              children: [
                const SizedBox(height: 12),
                _GenreTabs(
                  controller: _tabController,
                  selected: _provider.selectedIndex,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: AsyncView<List<Movie>>(
                    state: _provider.current,
                    onRetry: _provider.retry,
                    isEmpty: (movies) => movies.isEmpty,
                    builder: (context, movies) => MoviesGrid(
                      movies: movies,
                      onTap: (m) => openMovieDetails(context, m),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GenreTabs extends StatelessWidget {
  final TabController controller;
  final int selected;

  const _GenreTabs({required this.controller, required this.selected});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      labelPadding: const EdgeInsets.only(right: 10),
      dividerColor: Colors.transparent,
      indicatorColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      indicator: const BoxDecoration(),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      tabs: [
        for (int i = 0; i < AppGenres.all.length; i++)
          Tab(
            height: 42,
            child: GenreFilterChip(
              label: AppGenres.all[i],
              selected: i == selected,
              onTap: () => controller.animateTo(i),
            ),
          ),
      ],
    );
  }
}
