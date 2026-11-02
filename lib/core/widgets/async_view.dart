import 'package:flutter/material.dart';

import '../state/async_state.dart';
import 'app_loading.dart';
import 'empty_state.dart';
import 'error_retry_view.dart';


class AsyncView<T> extends StatelessWidget {
  final AsyncState<T> state;
  final Widget Function(BuildContext context, T data) builder;
  final VoidCallback onRetry;
  final bool Function(T data)? isEmpty;
  final Widget? loading;
  final Widget? empty;

  const AsyncView({
    super.key,
    required this.state,
    required this.builder,
    required this.onRetry,
    this.isEmpty,
    this.loading,
    this.empty,
  });

  @override
  Widget build(BuildContext context) {
    final data = state.data;

    if (data != null) {
      if (isEmpty?.call(data) ?? false) return empty ?? const EmptyState();
      return builder(context, data);
    }

    if (state.hasError) {
      return ErrorRetryView(error: state.error, onRetry: onRetry);
    }

    return loading ?? const AppLoading();
  }
}
