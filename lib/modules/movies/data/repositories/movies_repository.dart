import '../../../../core/cache/cache_policy.dart';
import '../../../../core/cache/cached_fetch.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/network_info.dart';
import '../data_sources/movies_local_data_source.dart';
import '../data_sources/movies_remote_data_source.dart';
import '../models/movie.dart';

/// نقطة الدخول الوحيدة للأفلام. بتقرر تجيب من الكاش ولا من النت.
class MoviesRepository {
  MoviesRepository({
    required MoviesRemoteDataSource remote,
    required MoviesLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final MoviesRemoteDataSource _remote;
  final MoviesLocalDataSource _local;

  Future<List<Movie>> getMovies({
    String? genre,
    String? query,
    String sortBy = 'date_added',
    int limit = 10,
    int page = 1,
    bool forceRefresh = false,
  }) {
    final normalizedGenre = genre?.toLowerCase();
    final normalizedQuery = query?.trim().toLowerCase();
    final isSearch = normalizedQuery != null && normalizedQuery.isNotEmpty;

    final key = '${isSearch ? MoviesLocalDataSource.searchPrefix : MoviesLocalDataSource.listPrefix}'
        'genre=${normalizedGenre ?? ''}|q=${normalizedQuery ?? ''}'
        '|sort=$sortBy|limit=$limit|page=$page';

    return cachedFetch<List<Movie>>(
      readCache: (maxAge) => _local.getMovies(key, maxAge: maxAge),
      fetch: () => _remote.listMovies(
        genre: normalizedGenre,
        query: isSearch ? query!.trim() : null,
        sortBy: sortBy,
        limit: limit,
        page: page,
      ),
      writeCache: (movies) =>
          _local.saveMovies(key, movies, isSearch: isSearch),
      ttl: isSearch ? CachePolicy.search : CachePolicy.movieList,
      forceRefresh: forceRefresh,
    );
  }

  Future<Movie> getMovieDetails(int id, {bool forceRefresh = false}) async {
    // Keep the old cache-first behavior: a fresh cached movie is returned
    // immediately unless the caller explicitly asks for a refresh.
    if (!forceRefresh) {
      final fresh = _local.getDetails(id, maxAge: CachePolicy.movieDetails);
      if (fresh != null) return fresh;
    }

    // If the device is offline, use an older cached copy when available.
    // Only fail when this movie has never been cached on this device.
    final connected = await NetworkInfo.isConnected;
    if (!connected) {
      final stale = _local.getDetails(id);
      if (stale != null) return stale;

      throw const AppException(
        'No internet connection and this movie is not available offline.',
      );
    }

    try {
      final movie = await _remote.movieDetails(id);
      await _local.saveDetails(movie);
      return movie;
    } catch (_) {
      // Preserve the existing stale-cache fallback when the request fails.
      final stale = _local.getDetails(id);
      if (stale != null) return stale;
      rethrow;
    }
  }

  Future<List<Movie>> getSuggestions(int id, {bool forceRefresh = false}) {
    return cachedFetch<List<Movie>>(
      readCache: (maxAge) => _local.getSuggestions(id, maxAge: maxAge),
      fetch: () => _remote.suggestions(id),
      writeCache: (movies) => _local.saveSuggestions(id, movies),
      ttl: CachePolicy.suggestions,
      forceRefresh: forceRefresh,
    );
  }
}
