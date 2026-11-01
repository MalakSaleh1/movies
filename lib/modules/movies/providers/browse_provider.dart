import 'package:flutter/foundation.dart';

import '../../../core/constants/genres.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/state/async_state.dart';
import '../../../core/state/safe_notifier.dart';
import '../data/models/movie.dart';
import '../data/repositories/movies_repository.dart';

/// state شاشة الـ Browse. بيتعمل لكل شاشة (مش global) عشان الـ Browse
/// اللي بتتفتح من "See More" ما تأثرش على التاب.
class BrowseProvider extends ChangeNotifier with SafeNotifier {
  BrowseProvider(this._repo, {int initialIndex = 0})
      : selectedIndex = initialIndex;

  final MoviesRepository _repo;
  final Map<String, AsyncState<List<Movie>>> _states = {};

  int selectedIndex;

  String get selectedGenre => AppGenres.all[selectedIndex];

  AsyncState<List<Movie>> get current =>
      _states[selectedGenre] ?? const AsyncState.initial();

  void select(int index) {
    if (index == selectedIndex) return;
    selectedIndex = index;
    notifyListeners();
    load();
  }

  Future<void> load({bool force = false}) async {
    final genre = selectedGenre;
    final state = _states[genre] ?? const AsyncState.initial();
    if (state.isLoading) return;
    if (!force && state.isSuccess) return;

    _states[genre] = AsyncState.loading(previous: state.data);
    notifyListeners();

    try {
      final movies = await _repo.getMovies(
        genre: genre,
        sortBy: 'like_count',
        limit: 30,
        forceRefresh: force,
      );
      _states[genre] = AsyncState.success(movies);
    } catch (e) {
      _states[genre] = AsyncState.error(errorMessage(e), previous: state.data);
    }
    notifyListeners();
  }

  Future<void> retry() => load(force: true);
}
