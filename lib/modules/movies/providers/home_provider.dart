import 'package:flutter/foundation.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/state/async_state.dart';
import '../../../core/state/safe_notifier.dart';
import '../data/models/movie.dart';
import '../data/repositories/movies_repository.dart';

class HomeProvider extends ChangeNotifier with SafeNotifier {
  HomeProvider(this._repo);

  final MoviesRepository _repo;

  AsyncState<List<Movie>> featured = const AsyncState.initial();
  final Map<String, AsyncState<List<Movie>>> _genres = {};

  AsyncState<List<Movie>> genreState(String genre) =>
      _genres[genre] ?? const AsyncState.initial();

  Future<void> loadFeatured({bool force = false}) async {
    if (featured.isLoading) return;
    if (!force && featured.isSuccess) return;

    featured = AsyncState.loading(previous: featured.data);
    notifyListeners();

    try {
      final movies = await _repo.getMovies(limit: 8, forceRefresh: force);
      featured = AsyncState.success(movies);
    } catch (e) {
      featured = AsyncState.error(errorMessage(e), previous: featured.data);
    }
    notifyListeners();
  }

  Future<void> loadGenre(String genre, {bool force = false}) async {
    final current = genreState(genre);
    if (current.isLoading) return;
    if (!force && current.isSuccess) return;

    _genres[genre] = AsyncState.loading(previous: current.data);
    notifyListeners();

    try {
      final movies = await _repo.getMovies(
        genre: genre,
        sortBy: 'like_count',
        limit: 10,
        forceRefresh: force,
      );
      _genres[genre] = AsyncState.success(movies);
    } catch (e) {
      _genres[genre] =
          AsyncState.error(errorMessage(e), previous: current.data);
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    final loaded = _genres.keys.toList();
    await Future.wait([
      loadFeatured(force: true),
      for (final genre in loaded) loadGenre(genre, force: true),
    ]);
  }
}
