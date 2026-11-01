import 'dart:async';
import 'dart:io';

/// Checks whether the device can reach the internet.
///
/// This is intentionally kept small and package-free so it does not change
/// the existing dependency set of the app.
class NetworkInfo {
  NetworkInfo._();

  static Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
