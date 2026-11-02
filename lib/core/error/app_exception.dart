
class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

String errorMessage(Object? error) {
  if (error == null) return 'Something went wrong';
  if (error is AppException) return error.message;
  return error.toString().replaceFirst('Exception: ', '');
}
