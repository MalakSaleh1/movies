/// Exception موحّدة بتحمل رسالة تتعرض للمستخدم مباشرة.
class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

/// بتحوّل أي error لرسالة نظيفة للعرض.
String errorMessage(Object? error) {
  if (error == null) return 'Something went wrong';
  if (error is AppException) return error.message;
  return error.toString().replaceFirst('Exception: ', '');
}
