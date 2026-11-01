import 'package:firebase_auth/firebase_auth.dart';

import '../../../movies/data/models/movie.dart';
import '../data_sources/library_local_data_source.dart';
import '../data_sources/library_remote_data_source.dart';

/// الـ Watch List والـ History: Firestore هو المصدر الأساسي،
/// والكاش المحلي بيخلي الشاشة تظهر فوراً (حتى أوفلاين).
class LibraryRepository {
  LibraryRepository({
    required LibraryRemoteDataSource remote,
    required LibraryLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final LibraryRemoteDataSource _remote;
  final LibraryLocalDataSource _local;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  // ---- الكاش ----

  List<Movie> cachedWishlist() {
    final uid = _uid;
    return uid == null ? [] : (_local.getWishlist(uid) ?? []);
  }

  List<Movie> cachedHistory() {
    final uid = _uid;
    return uid == null ? [] : (_local.getHistory(uid) ?? []);
  }

  Future<void> cacheWishlist(List<Movie> movies) async {
    final uid = _uid;
    if (uid != null) await _local.saveWishlist(uid, movies);
  }

  Future<void> cacheHistory(List<Movie> movies) async {
    final uid = _uid;
    if (uid != null) await _local.saveHistory(uid, movies);
  }

  // ---- من Firestore (وبنحدّث الكاش) ----

  Future<List<Movie>> fetchWishlist() async {
    final uid = _uid;
    if (uid == null) return [];
    final movies = await _remote.getWishlist(uid);
    await _local.saveWishlist(uid, movies);
    return movies;
  }

  Future<List<Movie>> fetchHistory() async {
    final uid = _uid;
    if (uid == null) return [];
    final movies = await _remote.getHistory(uid);
    await _local.saveHistory(uid, movies);
    return movies;
  }

  Future<void> addToWishlist(Movie movie) async {
    final uid = _uid;
    if (uid != null) await _remote.addToWishlist(uid, movie);
  }

  Future<void> removeFromWishlist(int movieId) async {
    final uid = _uid;
    if (uid != null) await _remote.removeFromWishlist(uid, movieId);
  }

  Future<void> addToHistory(Movie movie) async {
    final uid = _uid;
    if (uid != null) await _remote.addToHistory(uid, movie);
  }

  // ---- تنظيف ----

  Future<void> deleteRemote(String uid) => _remote.deleteAll(uid);

  Future<void> clearLocal(String uid) => _local.clear(uid);
}
