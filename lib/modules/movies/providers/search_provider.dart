import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/state/async_state.dart';
import '../../../core/state/safe_notifier.dart';
import '../data/models/movie.dart';
import '../data/repositories/movies_repository.dart';

class SearchProvider extends ChangeNotifier with SafeNotifier {
  SearchProvider(this._repo);

  final MoviesRepository _repo;

  Timer? _debounce;
  int _token = 0; // عشان نتجاهل نتايج الطلبات القديمة

  String query = '';
  AsyncState<List<Movie>> state = const AsyncState.initial();

  void onQueryChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _search(text.trim());
    });
  }

  Future<void> retry() => _search(query, force: true);

  Future<void> _search(String text, {bool force = false}) async {
    query = text;

    if (text.isEmpty) {
      _token++;
      state = const AsyncState.initial();
      notifyListeners();
      return;
    }

    final token = ++_token;
    state = const AsyncState.loading();
    notifyListeners();

    try {
      final movies = await _repo.getMovies(
        query: text,
        limit: 30,
        forceRefresh: force,
      );
      if (token != _token) return;
      state = AsyncState.success(movies);
    } catch (e) {
      if (token != _token) return;
      state = AsyncState.error(errorMessage(e));
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
