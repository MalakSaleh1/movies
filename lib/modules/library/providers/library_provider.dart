import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/state/safe_notifier.dart';
import '../../movies/data/models/movie.dart';
import '../data/repositories/library_repository.dart';

class LibraryProvider extends ChangeNotifier with SafeNotifier {
  LibraryProvider(this._repo) {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        clear();
      } else {
        load();
      }
    });
  }

  final LibraryRepository _repo;
  StreamSubscription<User?>? _authSub;

  final List<Movie> _wishlist = [];
  final List<Movie> _history = [];

  bool isLoading = false;
  String? lastError;

  List<Movie> get wishlist => List.unmodifiable(_wishlist);
  List<Movie> get history => List.unmodifiable(_history);

  bool isInWishlist(int id) => _wishlist.any((m) => m.id == id);

  Future<void> load() async {
    if (FirebaseAuth.instance.currentUser == null) return;

    final cachedWishlist = _repo.cachedWishlist();
    final cachedHistory = _repo.cachedHistory();
    if (cachedWishlist.isNotEmpty || cachedHistory.isNotEmpty) {
      _replace(cachedWishlist, cachedHistory);
    }

    isLoading = true;
    lastError = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repo.fetchWishlist(),
        _repo.fetchHistory(),
      ]);
      _replace(results[0], results[1]);
    } catch (e) {
      lastError = e.toString();
      debugPrint('LIBRARY LOAD FAILED: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  void _replace(List<Movie> wishlist, List<Movie> history) {
    _wishlist
      ..clear()
      ..addAll(wishlist);
    _history
      ..clear()
      ..addAll(history);
    notifyListeners();
  }

  void clear() {
    _wishlist.clear();
    _history.clear();
    notifyListeners();
  }

  Future<void> toggleWishlist(Movie movie) async {
    final added = !isInWishlist(movie.id);

    if (added) {
      _wishlist.insert(0, movie);
    } else {
      _wishlist.removeWhere((m) => m.id == movie.id);
    }
    notifyListeners();
    unawaited(_repo.cacheWishlist(_wishlist));

    try {
      if (added) {
        await _repo.addToWishlist(movie);
      } else {
        await _repo.removeFromWishlist(movie.id);
      }
    } catch (e) {
      lastError = e.toString();
      debugPrint('WISHLIST WRITE FAILED: $e');
      if (added) {
        _wishlist.removeWhere((m) => m.id == movie.id);
      } else {
        _wishlist.insert(0, movie);
      }
      notifyListeners();
      unawaited(_repo.cacheWishlist(_wishlist));
    }
  }

  Future<void> addToHistory(Movie movie) async {
    _history.removeWhere((m) => m.id == movie.id);
    _history.insert(0, movie);
    notifyListeners();
    unawaited(_repo.cacheHistory(_history));

    try {
      await _repo.addToHistory(movie);
    } catch (e) {
      lastError = e.toString();
      debugPrint('HISTORY WRITE FAILED: $e');
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
