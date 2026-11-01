import 'cast_member.dart';

class Movie {
  final int id;
  final String title;
  final int year;
  final double rating;
  final int runtime;
  final int likeCount;
  final List<String> genres;
  final String summary;
  final String coverImage; // للكروت الصغيرة
  final String largeCoverImage;
  final String backgroundImage; // لهيدر شاشة التفاصيل
  final List<String> screenshots;
  final List<CastMember> cast;

  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.likeCount,
    required this.genres,
    required this.summary,
    required this.coverImage,
    required this.largeCoverImage,
    required this.backgroundImage,
    required this.screenshots,
    required this.cast,
  });

  /// من الـ API
  factory Movie.fromJson(Map<String, dynamic> json) {
    String str(String key) => (json[key] ?? '') as String;

    final fullDescription = str('description_full');

    // لقطات الشاشة (بتيجي لما نبعت with_images=true)
    final shots = <String>[];
    for (var i = 1; i <= 3; i++) {
      final url = str('large_screenshot_image$i');
      if (url.isNotEmpty) shots.add(url);
    }

    return Movie(
      id: json['id'] as int,
      title: str('title'),
      year: (json['year'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      runtime: (json['runtime'] as num?)?.toInt() ?? 0,
      likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
      genres: ((json['genres'] as List?) ?? []).cast<String>(),
      summary: fullDescription.isNotEmpty ? fullDescription : str('summary'),
      coverImage: str('medium_cover_image'),
      largeCoverImage: str('large_cover_image'),
      backgroundImage: str('background_image_original').isNotEmpty
          ? str('background_image_original')
          : str('background_image'),
      screenshots: shots,
      // بتيجي لما نبعت with_cast=true
      cast: ((json['cast'] as List?) ?? [])
          .map((e) => CastMember.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// للكاش المحلي: كل الحقول (عشان شاشة التفاصيل تشتغل أوفلاين).
  factory Movie.fromCache(Map<String, dynamic> json) => Movie(
        id: json['id'] as int,
        title: (json['title'] ?? '') as String,
        year: (json['year'] as num?)?.toInt() ?? 0,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        runtime: (json['runtime'] as num?)?.toInt() ?? 0,
        likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
        genres: ((json['genres'] as List?) ?? []).cast<String>(),
        summary: (json['summary'] ?? '') as String,
        coverImage: (json['coverImage'] ?? '') as String,
        largeCoverImage: (json['largeCoverImage'] ?? '') as String,
        backgroundImage: (json['backgroundImage'] ?? '') as String,
        screenshots: ((json['screenshots'] as List?) ?? []).cast<String>(),
        cast: ((json['cast'] as List?) ?? [])
            .map((e) => CastMember.fromCache(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'year': year,
        'rating': rating,
        'runtime': runtime,
        'likeCount': likeCount,
        'genres': genres,
        'summary': summary,
        'coverImage': coverImage,
        'largeCoverImage': largeCoverImage,
        'backgroundImage': backgroundImage,
        'screenshots': screenshots,
        'cast': cast.map((c) => c.toJson()).toList(),
      };

  /// الحقول اللي بنخزنها في Firestore / كاش المكتبة (اللي الـ grid محتاجها بس)
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'year': year,
        'rating': rating,
        'coverImage': coverImage,
      };

  factory Movie.fromMap(Map<String, dynamic> map) => Movie(
        id: map['id'] as int,
        title: (map['title'] ?? '') as String,
        year: (map['year'] as num?)?.toInt() ?? 0,
        rating: (map['rating'] as num?)?.toDouble() ?? 0,
        coverImage: (map['coverImage'] ?? '') as String,
        // باقي الحقول بتتحمل من الـ API في شاشة التفاصيل
        runtime: 0,
        likeCount: 0,
        genres: const [],
        summary: '',
        largeCoverImage: '',
        backgroundImage: '',
        screenshots: const [],
        cast: const [],
      );
}
