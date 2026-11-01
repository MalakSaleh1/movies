class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String avatar;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
  });

  /// من وثيقة Firestore أو من الكاش (نفس المفاتيح).
  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        name: (map['name'] ?? '') as String,
        email: (map['email'] ?? '') as String,
        phone: (map['phone'] ?? '') as String,
        avatar: (map['avatar'] ?? '') as String,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'phone': phone,
        'avatar': avatar,
      };

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatar,
  }) =>
      UserProfile(
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        avatar: avatar ?? this.avatar,
      );
}
