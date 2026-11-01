import 'package:flutter/foundation.dart';

import '../../../../core/cache/cache_policy.dart';
import '../../../../core/cache/cache_service.dart';
import '../models/user_profile.dart';

/// كاش بيانات المستخدم (الاسم والصورة والموبايل) على الجهاز.
class UserLocalDataSource {
  UserLocalDataSource(this._cache);

  final CacheService _cache;

  String _key(String uid) => 'user:$uid:profile';

  UserProfile? get(String uid, {bool onlyFresh = false}) {
    final key = _key(uid);
    final raw = _cache.read<Map<String, dynamic>>(
      key,
      maxAge: onlyFresh ? CachePolicy.userProfile : null,
    );
    if (raw == null) return null;
    try {
      return UserProfile.fromMap(raw);
    } catch (e) {
      debugPrint('PROFILE CACHE PARSE FAILED: $e');
      _cache.remove(key);
      return null;
    }
  }

  Future<void> save(String uid, UserProfile profile) =>
      _cache.write(_key(uid), profile.toMap());

  Future<void> clear(String uid) => _cache.remove(_key(uid));
}
