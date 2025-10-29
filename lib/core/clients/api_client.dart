import 'package:dio/dio.dart';

/// Client for making API requests using Dio.
class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );
  }

  final Dio _dio;

  /// Makes a GET request to the specified [url].
  Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(url);

      if (response.statusCode == 200 && response.data != null) {
        return response.data!;
      }

      throw Exception(
        'Request failed with status: ${response.statusCode}\n${response.statusMessage}\n${response.data}',
      );
    } catch (e) {
      rethrow;
    }
  }
}
