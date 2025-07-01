import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseApi {
  final Dio _dio = Dio();
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:5271/api';

  BaseApi() {
    _dio.options.baseUrl = baseUrl;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers["Content-Type"] = "application/json";
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: _handleError(e),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> get(String path) async {
    final response = await _dio.get(path);
    return response.data;
  }

  Future<dynamic> post(String path, Map<String, dynamic> data) async {
    final response = await _dio.post(path, data: data);
    return response.data;
  }

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return "Connection Timeout";
    } else if (e.type == DioExceptionType.badResponse) {
      return "Invalid Response: ${e.response?.statusCode}";
    } else if (e.type == DioExceptionType.unknown) {
      return "No Internet Connection";
    }
    return "Something went wrong";
  }
}
