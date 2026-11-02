class CastMember {
  final String name;
  final String character;
  final String image;

  const CastMember({
    required this.name,
    required this.character,
    required this.image,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) => CastMember(
        name: (json['name'] ?? '') as String,
        character: (json['character_name'] ?? '') as String,
        image: (json['url_small_image'] ?? '') as String,
      );

  factory CastMember.fromCache(Map<String, dynamic> json) => CastMember(
        name: (json['name'] ?? '') as String,
        character: (json['character'] ?? '') as String,
        image: (json['image'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'character': character,
        'image': image,
      };
}
