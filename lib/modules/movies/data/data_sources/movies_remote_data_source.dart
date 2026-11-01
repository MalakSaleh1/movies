import '../../../../core/error/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/movie.dart';

/// بيكلّم الـ API بس. مفيش كاش ولا منطق هنا.
class MoviesRemoteDataSource {
  MoviesRemoteDataSource(this._api);

  static const _baseUrl = 'https://movies-api.accel.li/api/v2';

  final ApiClient _api;

  /// بيعمل GET ويرجّع الـ `data` بعد ما يتأكد إن status == ok
  Future<Map<String, dynamic>> _getData(
    String endpoint,
    Map<String, String> params,
  ) async {
    final body = await _api.get('$_baseUrl/$endpoint.json', params: params);

    if (body['status'] != 'ok') {
      throw AppException(
        (body['status_message'] ?? 'Something went wrong').toString(),
      );
    }
    return body['data'] as Map<String, dynamic>;
  }

  List<Movie> _parseMovies(Map<String, dynamic> data) {
    final movies = (data['movies'] as List?) ?? [];
    return movies
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// قائمة الأفلام (مع فلترة بالنوع والترتيب)
  Future<List<Movie>> listMovies({
    String? genre,
    String? query,
    required String sortBy,
    required int limit,
    required int page,
  }) async {
    final data = await _getData('list_movies', {
      'limit': '$limit',
      'page': '$page',
      'sort_by': sortBy,
      if (genre != null) 'genre': genre,
      if (query != null) 'query_term': query,
    });
    return _parseMovies(data);
  }

  /// تفاصيل فيلم (مع الصور والـ cast)
  Future<Movie> movieDetails(int id) async {
    final data = await _getData('movie_details', {
      'movie_id': '$id',
      'with_images': 'true',
      'with_cast': 'true',
    });
    return Movie.fromJson(data['movie'] as Map<String, dynamic>);
  }

  /// أفلام مشابهة (بترجع 4 أفلام)
  Future<List<Movie>> suggestions(int id) async {
    final data = await _getData('movie_suggestions', {'movie_id': '$id'});
    return _parseMovies(data);
  }
}
