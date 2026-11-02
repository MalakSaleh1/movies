import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../error/app_exception.dart';

class ApiClient {
  ApiClient({
    http.Client? client,
    this.timeout = const Duration(seconds: 20),
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final Duration timeout;

  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? params,
  }) async {
    final uri = Uri.parse(url).replace(queryParameters: params);

    try {
      final response = await _client.get(uri).timeout(timeout);

      if (response.statusCode != 200) {
        throw AppException('Server error (${response.statusCode})');
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const AppException('Unexpected server response');
      }
      return decoded;
    } on SocketException {
      throw const AppException('Check your internet connection.');
    } on http.ClientException {
      throw const AppException('Check your internet connection.');
    } on TimeoutException {
      throw const AppException('Request timed out. Try again.');
    } on FormatException {
      throw const AppException('Invalid server response');
    }
  }
}
