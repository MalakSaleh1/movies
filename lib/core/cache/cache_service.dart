import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Entry {
  final dynamic data;
  final DateTime savedAt;
  const _Entry(this.data, this.savedAt);
}

class CacheService {
  CacheService._(this._prefs);

  static const _prefix = 'cache_v1:';

  final SharedPreferences _prefs;
  final Map<String, _Entry> _memory = {};

  static Future<CacheService> create() async {
    return CacheService._(await SharedPreferences.getInstance());
  }

  String _k(String key) => '$_prefix$key';

  Future<void> write(String key, Object data) async {
    final entry = _Entry(data, DateTime.now());
    _memory[key] = entry;
    try {
      await _prefs.setString(
        _k(key),
        jsonEncode({'t': entry.savedAt.millisecondsSinceEpoch, 'd': data}),
      );
    } catch (e) {
      debugPrint('CACHE WRITE FAILED ($key): $e');
    }
  }

  T? read<T>(String key, {Duration? maxAge}) {
    final entry = _entry(key);
    if (entry == null) return null;

    if (maxAge != null &&
        DateTime.now().difference(entry.savedAt) > maxAge) {
      return null;
    }

    final data = entry.data;
    return data is T ? data : null;
  }

  _Entry? _entry(String key) {
    final inMemory = _memory[key];
    if (inMemory != null) return inMemory;

    final raw = _prefs.getString(_k(key));
    if (raw == null) return null;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final entry = _Entry(
        map['d'],
        DateTime.fromMillisecondsSinceEpoch(map['t'] as int),
      );
      _memory[key] = entry;
      return entry;
    } catch (_) {

      _prefs.remove(_k(key));
      return null;
    }
  }

  Future<void> remove(String key) async {
    _memory.remove(key);
    await _prefs.remove(_k(key));
  }

  Future<void> removeByPrefix(String prefix) async {
    _memory.removeWhere((key, _) => key.startsWith(prefix));
    final full = _k(prefix);
    final keys = _prefs.getKeys().where((k) => k.startsWith(full)).toList();
    for (final k in keys) {
      await _prefs.remove(k);
    }
  }

  Future<void> prune(String prefix, {required int maxEntries}) async {
    final full = _k(prefix);
    final keys = _prefs
        .getKeys()
        .where((k) => k.startsWith(full))
        .map((k) => k.substring(_prefix.length))
        .toList();
    if (keys.length <= maxEntries) return;

    final dated = <MapEntry<String, DateTime>>[];
    for (final key in keys) {
      final entry = _entry(key);
      dated.add(MapEntry(key, entry?.savedAt ?? DateTime(1970)));
    }
    dated.sort((a, b) => b.value.compareTo(a.value)); // الأحدث الأول

    for (final old in dated.skip(maxEntries)) {
      await remove(old.key);
    }
  }

  Future<void> clearAll() => removeByPrefix('');
}
