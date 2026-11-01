import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../../library/data/repositories/library_repository.dart';
import '../../../profile/data/models/user_profile.dart';
import '../../../profile/data/repositories/user_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

/// بيربط الـ Auth بباقي البيانات: إنشاء وثيقة المستخدم بعد الدخول،
/// وتنظيف الكاش والـ Firestore عند الخروج أو حذف الحساب.
class AuthRepository {
  AuthRepository({
    required AuthRemoteDataSource remote,
    required UserRepository userRepository,
    required LibraryRepository libraryRepository,
  })  : _remote = remote,
        _userRepo = userRepository,
        _libraryRepo = libraryRepository;

  final AuthRemoteDataSource _remote;
  final UserRepository _userRepo;
  final LibraryRepository _libraryRepo;

  User? get currentUser => _remote.currentUser;
  bool get isPasswordUser => _remote.isPasswordUser;

  Future<User?> createAccount({
    required String email,
    required String password,
    required String name,
    required String avatar,
  }) async {
    final user = await _remote.createAccount(
      email: email,
      password: password,
      name: name,
      avatar: avatar,
    );

    if (user != null) {
      try {
        await _userRepo.createProfile(
          user.uid,
          UserProfile(name: name, email: email, phone: '', avatar: avatar),
        );
      } catch (e) {
        debugPrint('Saving user doc failed: $e');
      }
    }
    return user;
  }

  Future<User?> signIn({required String email, required String password}) async {
    final user = await _remote.signIn(email: email, password: password);
    await _ensureProfile(user);
    return user;
  }

  Future<User?> signInWithGoogle() async {
    final user = await _remote.signInWithGoogle();
    await _ensureProfile(user);
    return user;
  }

  Future<void> resetPassword({required String email}) =>
      _remote.resetPassword(email: email);

  Future<void> updateDisplayName(String name) =>
      _remote.updateDisplayName(name);

  Future<void> signOut() async {
    final uid = _remote.currentUser?.uid;
    await _remote.signOut();
    if (uid != null) await _clearLocal(uid);
  }

  /// 1) إعادة تحقق  2) مسح بيانات Firestore  3) حذف الحساب  4) مسح الكاش
  Future<void> deleteAccount({String? password}) async {
    final uid = _remote.currentUser?.uid;
    if (uid == null) throw Exception('No user is signed in');

    await _remote.reauthenticate(password: password);

    // لازم قبل حذف الحساب عشان الـ rules محتاجة المستخدم لسه مسجل
    await _libraryRepo.deleteRemote(uid);
    await _userRepo.deleteRemote(uid);

    await _remote.deleteUser();
    await _remote.signOutGoogleQuietly();
    await _clearLocal(uid);
  }

  /// بنحاول ننشئ وثيقة المستخدم لو ناقصة (الحسابات القديمة / جوجول).
  Future<void> _ensureProfile(User? user) async {
    if (user == null) return;
    try {
      await _userRepo.ensureProfile(user, avatar: user.photoURL ?? '');
    } catch (e) {
      debugPrint('Saving user doc failed: $e');
    }
  }

  Future<void> _clearLocal(String uid) async {
    await _userRepo.clearLocal(uid);
    await _libraryRepo.clearLocal(uid);
  }
}
