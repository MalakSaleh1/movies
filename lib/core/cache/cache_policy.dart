/// مدد صلاحية الكاش. بعد انتهاءها بنحاول نجيب من النت،
/// ولو النت فاشل بنرجع للكاش القديم.
class CachePolicy {
  CachePolicy._();

  static const Duration movieList = Duration(hours: 6);
  static const Duration search = Duration(minutes: 30);
  static const Duration movieDetails = Duration(hours: 24);
  static const Duration suggestions = Duration(hours: 24);
  static const Duration userProfile = Duration(hours: 12);

  /// أقصى عدد نتايج بحث محفوظة.
  static const int maxSearchEntries = 20;
}
