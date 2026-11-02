
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
