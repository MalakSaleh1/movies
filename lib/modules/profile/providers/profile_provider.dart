import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/network/network_info.dart';
import '../../../core/state/safe_notifier.dart';
import '../../auth/data/repositories/auth_repository.dart';
import '../data/models/user_profile.dart';
import '../data/repositories/user_repository.dart';

class ProfileProvider extends ChangeNotifier with SafeNotifier {
  ProfileProvider(this._userRepo, this._authRepo) {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        clear();
      } else {
        load();
      }
    });
  }

  final UserRepository _userRepo;
  final AuthRepository _authRepo;
  StreamSubscription<User?>? _authSub;

  UserProfile? profile;
  bool isLoading = false;
  bool isSaving = false;
  String? error;

  Future<void> load() async {
    final cached = _userRepo.cachedProfile();
    if (cached != null) {
      profile = cached;
      notifyListeners();
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final fetched = await _userRepo.fetchProfile();
      if (fetched != null) profile = fetched;
    } catch (e) {
      error = errorMessage(e);
      debugPrint('PROFILE LOAD FAILED: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> update({
    required String name,
    required String avatar,
    required String phone,
  }) async {
    isSaving = true;
    error = null;
    notifyListeners();

    var ok = false;
    try {
      if (!await NetworkInfo.isConnected) {
        throw const AppException('No internet connection.');
      }

      await _authRepo.updateDisplayName(name);
      profile = await _userRepo.updateProfile(
        name: name,
        avatar: avatar,
        phone: phone,
      );
      ok = true;
    } catch (e) {
      error = errorMessage(e);
    }

    isSaving = false;
    notifyListeners();
    return ok;
  }

  void clear() {
    profile = null;
    error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
