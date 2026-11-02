import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/error/app_exception.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  bool get isPasswordUser =>
      _auth.currentUser?.providerData.any((p) => p.providerId == 'password') ??
      false;

  Future<User?> createAccount({
    required String email,
    required String password,
    required String name,
    required String avatar,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);
      await credential.user?.updatePhotoURL(avatar);
      await credential.user?.reload();

      return _auth.currentUser;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw const AppException('The password provided is too weak.');
        case 'email-already-in-use':
          throw const AppException('The account already exists for that email.');
        case 'invalid-email':
          throw const AppException('Invalid email.');
        case 'network-request-failed':
          throw const AppException('Check your internet connection.');
        default:
          throw AppException(e.message ?? 'Something went wrong.');
      }
    }
  }

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw const AppException('Check your internet connection.');
      }
      throw const AppException('Invalid email or password');
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        throw const AppException('Check your internet connection.');
      }
      throw const AppException('Invalid email');
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final credential = await _googleCredential();
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } on GoogleSignInException catch (e) {
      debugPrint(
        'GoogleSignInException => code=${e.code}, '
        'description=${e.description}, details=${e.details}',
      );
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AppException('Sign in was cancelled');
      }
      throw AppException('Google sign in failed: ${e.code.name}');
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException => code=${e.code}, message=${e.message}');
      throw AppException(e.message ?? 'Google sign in failed');
    }
  }

  Future<OAuthCredential> _googleCredential() async {
    final googleUser = await GoogleSignIn.instance.authenticate();
    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw const AppException('Failed to get Google ID token');
    }
    return GoogleAuthProvider.credential(idToken: idToken);
  }

  Future<void> updateDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user == null) throw const AppException('No user is signed in');
    await user.updateDisplayName(name);
    await user.reload();
  }

  Future<void> reauthenticate({String? password}) async {
    final user = _auth.currentUser;
    if (user == null) throw const AppException('No user is signed in');

    try {
      final providers = user.providerData.map((p) => p.providerId).toList();

      if (providers.contains('password')) {
        if (password == null || password.isEmpty) {
          throw const AppException('Please enter your password');
        }
        await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: user.email!, password: password),
        );
      } else if (providers.contains('google.com')) {
        await user.reauthenticateWithCredential(await _googleCredential());
      }
    } on GoogleSignInException catch (e) {
      debugPrint('Reauth GoogleSignInException => ${e.code}');
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AppException('Verification was cancelled');
      }
      throw const AppException('Google verification failed');
    } on FirebaseAuthException catch (e) {
      throw _mapDeleteError(e);
    }
  }

  Future<void> deleteUser() async {
    final user = _auth.currentUser;
    if (user == null) throw const AppException('No user is signed in');

    try {
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _mapDeleteError(e);
    }
  }

  AppException _mapDeleteError(FirebaseAuthException e) {
    debugPrint('Auth FirebaseAuthException => ${e.code}: ${e.message}');
    switch (e.code) {
      case 'wrong-password':
      case 'invalid-credential':
        return const AppException('Wrong password');
      case 'network-request-failed':
        return const AppException('Check your internet connection.');
      case 'requires-recent-login':
        return const AppException(
          'For security, sign in again, then delete your account',
        );
      default:
        return AppException(e.message ?? 'Something went wrong');
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  Future<void> signOutGoogleQuietly() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }
}
