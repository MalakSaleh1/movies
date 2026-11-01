import 'package:firebase_auth/firebase_auth.dart';

import '../data_sources/user_local_data_source.dart';
import '../data_sources/user_remote_data_source.dart';
import '../models/user_profile.dart';

class UserRepository {
  UserRepository({
    required UserRemoteDataSource remote,
    required UserLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final UserRemoteDataSource _remote;
  final UserLocalDataSource _local;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  /// آخر بيانات محفوظة على الجهاز (فورية).
  UserProfile? cachedProfile() {
    final uid = _uid;
    return uid == null ? null : _local.get(uid);
  }

  /// من Firestore (وبنحدّث الكاش).
  Future<UserProfile?> fetchProfile() async {
    final uid = _uid;
    if (uid == null) return null;
    final profile = await _remote.get(uid);
    if (profile != null) await _local.save(uid, profile);
    return profile;
  }

  Future<void> createProfile(String uid, UserProfile profile) async {
    await _remote.create(uid, profile);
    await _local.save(uid, profile);
  }

  /// بعد تسجيل الدخول: بيتأكد إن وثيقة المستخدم موجودة.
  Future<void> ensureProfile(User user, {required String avatar}) async {
    final profile = UserProfile(
      name: user.displayName ?? '',
      email: user.email ?? '',
      phone: user.phoneNumber ?? '',
      avatar: avatar,
    );
    await _remote.createIfNew(user.uid, profile);
  }

  Future<UserProfile> updateProfile({
    required String name,
    required String avatar,
    required String phone,
  }) async {
    final uid = _uid;
    if (uid == null) throw Exception('No user is currently signed in');

    await _remote.update(uid, name: name, avatar: avatar, phone: phone);

    final updated = (_local.get(uid) ??
            UserProfile(
              name: name,
              email: FirebaseAuth.instance.currentUser?.email ?? '',
              phone: phone,
              avatar: avatar,
            ))
        .copyWith(name: name, avatar: avatar, phone: phone);

    await _local.save(uid, updated);
    return updated;
  }

  Future<void> deleteRemote(String uid) => _remote.delete(uid);

  Future<void> clearLocal(String uid) => _local.clear(uid);
}
