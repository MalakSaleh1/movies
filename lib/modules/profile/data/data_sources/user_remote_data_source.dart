import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';

class UserRemoteDataSource {
  UserRemoteDataSource(this._db);

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection('users').doc(uid);

  Future<void> create(String uid, UserProfile profile) {
    return _doc(uid).set({
      ...profile.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createIfNew(String uid, UserProfile profile) async {
    final ref = _doc(uid);
    final snap = await ref.get();
    if (snap.exists) return;
    await create(uid, profile);
  }

  Future<UserProfile?> get(String uid) async {
    final data = (await _doc(uid).get()).data();
    return data == null ? null : UserProfile.fromMap(data);
  }

  Future<void> update(
    String uid, {
    required String name,
    required String avatar,
    required String phone,
  }) {
    return _doc(uid).set(
      {'name': name, 'avatar': avatar, 'phone': phone},
      SetOptions(merge: true),
    );
  }

  Future<void> delete(String uid) => _doc(uid).delete();
}
