import 'package:flutter/foundation.dart';

/// بيمنع `notifyListeners()` بعد الـ dispose (مثلاً لو المستخدم قفل الشاشة
/// قبل ما الـ request يخلص).
mixin SafeNotifier on ChangeNotifier {
  bool _disposed = false;

  bool get isDisposed => _disposed;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }
}
