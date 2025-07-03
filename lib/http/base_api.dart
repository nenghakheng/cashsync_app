import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:japx/japx.dart';

class BaseApi {
  final Dio _dio = Dio();
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:5271/api';
  final storage = const FlutterSecureStorage();

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

  // Add Token to header request
  Future<Options> _getAuthOptions() async {
    final token = await storage.read(key: 'auth_token');
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<dynamic> get(String path, {bool withAuth = false}) async {
    Options? options;
    if (withAuth) {
      options = await _getAuthOptions();
    }

    final response = await _dio.get(path, options: options);

    // Flatten the response with Japx if needed
    if (response.data is Map<String, dynamic>) {
      // Japx.decode is a function to flatten the response
      response.data = Japx.decode(response.data);
    }

    return response.data;
  }

  // Combined post method with optional authentication
  Future<dynamic> post(
    String path,
    Map<String, dynamic> data, {
    bool withAuth = false,
  }) async {
    Options? options;
    if (withAuth) {
      options = await _getAuthOptions();
    }

    final response = await _dio.post(path, data: data, options: options);

    // Flatten the response with Japx if needed
    if (response.data is Map<String, dynamic>) {
      // Japx.decode is a function to flatten the response
      response.data = Japx.decode(response.data);
    }

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
