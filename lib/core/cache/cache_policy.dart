
class CachePolicy {
  CachePolicy._();

  static const Duration movieList = Duration(hours: 6);
  static const Duration search = Duration(minutes: 30);
  static const Duration movieDetails = Duration(hours: 24);
  static const Duration suggestions = Duration(hours: 24);
  static const Duration userProfile = Duration(hours: 12);


  static const int maxSearchEntries = 20;
}
