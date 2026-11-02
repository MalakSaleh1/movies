enum LoadStatus { initial, loading, success, error }

class AsyncState<T> {
  final LoadStatus status;
  final T? data;
  final String? error;

  const AsyncState._(this.status, this.data, this.error);

  const AsyncState.initial() : this._(LoadStatus.initial, null, null);

  const AsyncState.loading({T? previous})
      : this._(LoadStatus.loading, previous, null);

  const AsyncState.success(T data) : this._(LoadStatus.success, data, null);

  const AsyncState.error(String message, {T? previous})
      : this._(LoadStatus.error, previous, message);

  bool get isLoading => status == LoadStatus.loading;
  bool get isSuccess => status == LoadStatus.success;
  bool get hasError => status == LoadStatus.error;
  bool get hasData => data != null;
}
