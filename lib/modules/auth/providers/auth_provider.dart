import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/state/safe_notifier.dart';
import '../data/repositories/auth_repository.dart';
class AppAuthProvider extends ChangeNotifier with SafeNotifier {
  AppAuthProvider(this._repo) : user = _repo.currentUser;

  final AuthRepository _repo;

  bool isLoading = false;
  bool isLoadingForGoogle = false;
  String? errorMessageText;

  User? user;

  bool get isPasswordUser => _repo.isPasswordUser;

  Future<bool> _run(
    Future<void> Function() action, {
    bool google = false,
  }) async {
    if (google) {
      isLoadingForGoogle = true;
    } else {
      isLoading = true;
    }
    errorMessageText = null;
    notifyListeners();

    var success = false;
    try {
      await action();
      success = true;
    } catch (e) {
      errorMessageText = errorMessage(e);
    }

    if (google) {
      isLoadingForGoogle = false;
    } else {
      isLoading = false;
    }
    notifyListeners();
    return success;
  }

  Future<bool> createAccount({
    required String email,
    required String password,
    required String name,
    required String avatar,
  }) {
    return _run(() async {
      user = await _repo.createAccount(
        email: email,
        password: password,
        name: name,
        avatar: avatar,
      );
    });
  }

  Future<bool> signIn({required String email, required String password}) {
    return _run(() async {
      user = await _repo.signIn(email: email, password: password);
    });
  }

  Future<bool> signInWithGoogle() {
    return _run(() async {
      user = await _repo.signInWithGoogle();
    }, google: true);
  }

  Future<bool> resetPassword({required String email}) {
    return _run(() => _repo.resetPassword(email: email));
  }

  Future<bool> deleteAccount({String? password}) {
    return _run(() async {
      await _repo.deleteAccount(password: password);
      user = null;
    });
  }

  Future<void> signOut() async {
    await _repo.signOut();
    user = null;
    notifyListeners();
  }

  void updateUser() {
    user = _repo.currentUser;
    notifyListeners();
  }
}
