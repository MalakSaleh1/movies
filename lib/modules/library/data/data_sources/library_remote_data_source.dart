import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../movies/data/models/movie.dart';

/// الهيكل في Firestore:
/// users/{uid}
///   ├─ wishlist/{movieId} → بيانات الفيلم + addedAt
///   └─ history/{movieId}  → بيانات الفيلم + viewedAt
class LibraryRemoteDataSource {
  LibraryRemoteDataSource(this._db);

  final FirebaseFirestore _db;

  static const wishlistCollection = 'wishlist';
  static const historyCollection = 'history';

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  Future<List<Movie>> getWishlist(String uid) =>
      _getMovies(uid, wishlistCollection, 'addedAt');

  Future<List<Movie>> getHistory(String uid) =>
      _getMovies(uid, historyCollection, 'viewedAt', limit: 50);

  Future<void> addToWishlist(String uid, Movie movie) =>
      _putMovie(uid, wishlistCollection, movie, 'addedAt');

  Future<void> addToHistory(String uid, Movie movie) =>
      _putMovie(uid, historyCollection, movie, 'viewedAt');

  Future<void> removeFromWishlist(String uid, int movieId) =>
      _userDoc(uid).collection(wishlistCollection).doc('$movieId').delete();

  /// بيمسح الـ wishlist والـ history كلهم (عند حذف الحساب).
  Future<void> deleteAll(String uid) async {
    for (final name in [wishlistCollection, historyCollection]) {
      final snap = await _userDoc(uid).collection(name).get();
      final batch = _db.batch();
      for (final d in snap.docs) {
        batch.delete(d.reference);
      }
      await batch.commit();
    }
  }

  Future<List<Movie>> _getMovies(
    String uid,
    String collection,
    String orderField, {
    int? limit,
  }) async {
    var query = _userDoc(uid)
        .collection(collection)
        .orderBy(orderField, descending: true);
    if (limit != null) query = query.limit(limit);

    final snap = await query.get();
    return snap.docs.map((d) => Movie.fromMap(d.data())).toList();
  }

  Future<void> _putMovie(
    String uid,
    String collection,
    Movie movie,
    String timeField,
  ) {
    return _userDoc(uid).collection(collection).doc('${movie.id}').set({
      ...movie.toMap(),
      timeField: FieldValue.serverTimestamp(),
    });
  }
}
