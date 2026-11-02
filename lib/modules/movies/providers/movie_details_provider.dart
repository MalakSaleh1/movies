import 'package:flutter/foundation.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/state/async_state.dart';
import '../../../core/state/safe_notifier.dart';
import '../data/models/movie.dart';
import '../data/repositories/movies_repository.dart';

class MovieDetailsData {
  final Movie movie;
  final List<Movie> similar;
  const MovieDetailsData(this.movie, this.similar);
}

class MovieDetailsProvider extends ChangeNotifier with SafeNotifier {
  MovieDetailsProvider(
    this._repo,
    this.movieId, {
    this.onLoaded,
  });

  final MoviesRepository _repo;
  final int movieId;

  final void Function(Movie movie)? onLoaded;

  AsyncState<MovieDetailsData> state = const AsyncState.initial();

  Future<void> load({bool force = false}) async {
    state = AsyncState.loading(previous: state.data);
    notifyListeners();

    try {
      final (movie, similar) = await (
        _repo.getMovieDetails(movieId, forceRefresh: force),
        _repo
            .getSuggestions(movieId, forceRefresh: force)
            .catchError((_) => <Movie>[]),
      ).wait;

      state = AsyncState.success(MovieDetailsData(movie, similar));
      if (!isDisposed) onLoaded?.call(movie);
    } catch (e) {
      state = AsyncState.error(errorMessage(e), previous: state.data);
    }
    notifyListeners();
  }
}
