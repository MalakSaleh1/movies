import 'package:flutter/foundation.dart';

import '../../../../core/cache/cache_policy.dart';
import '../../../../core/cache/cache_service.dart';
import '../models/movie.dart';

class MoviesLocalDataSource {
  MoviesLocalDataSource(this._cache);

  static const listPrefix = 'movies:list:';
  static const searchPrefix = 'movies:search:';
  static const _detailsPrefix = 'movies:details:';
  static const _suggestionsPrefix = 'movies:suggestions:';

  final CacheService _cache;


  List<Movie>? getMovies(String key, {Duration? maxAge}) {
    final raw = _cache.read<List<dynamic>>(key, maxAge: maxAge);
    if (raw == null) return null;
    try {
      return raw
          .map((e) => Movie.fromCache(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (e) {
      debugPrint('CACHE PARSE FAILED ($key): $e');
      _cache.remove(key);
      return null;
    }
  }

  Future<void> saveMovies(
    String key,
    List<Movie> movies, {
    bool isSearch = false,
  }) async {
    await _cache.write(key, movies.map((m) => m.toJson()).toList());
    if (isSearch) {
      await _cache.prune(
        searchPrefix,
        maxEntries: CachePolicy.maxSearchEntries,
      );
    }
  }


  Movie? getDetails(int id, {Duration? maxAge}) {
    final key = '$_detailsPrefix$id';
    final raw = _cache.read<Map<String, dynamic>>(key, maxAge: maxAge);
    if (raw == null) return null;
    try {
      return Movie.fromCache(raw);
    } catch (e) {
      debugPrint('CACHE PARSE FAILED ($key): $e');
      _cache.remove(key);
      return null;
    }
  }

  Future<void> saveDetails(Movie movie) =>
      _cache.write('$_detailsPrefix${movie.id}', movie.toJson());


  List<Movie>? getSuggestions(int id, {Duration? maxAge}) =>
      getMovies('$_suggestionsPrefix$id', maxAge: maxAge);

  Future<void> saveSuggestions(int id, List<Movie> movies) =>
      saveMovies('$_suggestionsPrefix$id', movies);

  Future<void> clear() async {
    await _cache.removeByPrefix('movies:');
  }
}
