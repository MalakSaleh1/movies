import 'package:flutter/foundation.dart';

import '../../../../core/cache/cache_service.dart';
import '../../../movies/data/models/movie.dart';

/// كاش الـ Watch List والـ History لكل مستخدم (بيفضل بعد قفل التطبيق).
class LibraryLocalDataSource {
  LibraryLocalDataSource(this._cache);

  final CacheService _cache;

  String _key(String uid, String name) => 'user:$uid:library:$name';

  List<Movie>? getWishlist(String uid) => _read(_key(uid, 'wishlist'));

  List<Movie>? getHistory(String uid) => _read(_key(uid, 'history'));

  Future<void> saveWishlist(String uid, List<Movie> movies) =>
      _write(_key(uid, 'wishlist'), movies);

  Future<void> saveHistory(String uid, List<Movie> movies) =>
      _write(_key(uid, 'history'), movies);

  Future<void> clear(String uid) => _cache.removeByPrefix('user:$uid:library:');

  List<Movie>? _read(String key) {
    final raw = _cache.read<List<dynamic>>(key);
    if (raw == null) return null;
    try {
      return raw
          .map((e) => Movie.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (e) {
      debugPrint('LIBRARY CACHE PARSE FAILED ($key): $e');
      _cache.remove(key);
      return null;
    }
  }

  Future<void> _write(String key, List<Movie> movies) =>
      _cache.write(key, movies.map((m) => m.toMap()).toList());
}
