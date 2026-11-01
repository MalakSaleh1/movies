/// استراتيجية "الكاش الأول":
/// 1) لو في كاش لسه صالح (أحدث من [ttl]) نرجّعه من غير ما نروح للنت.
/// 2) غير كده نجيب من المصدر الأصلي ونحدّث الكاش.
/// 3) لو المصدر فشل (مفيش نت مثلاً) نرجّع آخر كاش حتى لو قديم.
///
/// [forceRefresh] بيتخطى الخطوة 1 (للـ pull-to-refresh والـ retry).
Future<T> cachedFetch<T>({
  required T? Function(Duration? maxAge) readCache,
  required Future<T> Function() fetch,
  required Future<void> Function(T data) writeCache,
  required Duration ttl,
  bool forceRefresh = false,
}) async {
  if (!forceRefresh) {
    final fresh = readCache(ttl);
    if (fresh != null) return fresh;
  }

  try {
    final data = await fetch();
    await writeCache(data);
    return data;
  } catch (_) {
    final stale = readCache(null);
    if (stale != null) return stale;
    rethrow;
  }
}
