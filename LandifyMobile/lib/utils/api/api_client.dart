import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:landifymobile/utils/constants/api_constants.dart';

class ApiClient {
  // THÊM LẠI: Một Dio instance cho các request public
  final Dio _publicDio;

  ApiClient()
      : _publicDio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  ));

  // Phương thức để repository có thể gọi các request public
  Dio get publicDio => _publicDio;

  // Phương thức cốt lõi để tạo Dio instance đã được xác thực
  Future<Dio> _getAuthenticatedDio() async {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ));

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken(true);
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    return dio;
  }

  // --- Các phương thức tiện lợi cho request đã xác thực ---
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final dio = await _getAuthenticatedDio();
    return dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    final dio = await _getAuthenticatedDio();
    return dio.post(path, data: data);
  }

  Future<Response> patch(String path, {dynamic data}) async {
    final dio = await _getAuthenticatedDio();
    return dio.patch(path, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) async {
    final dio = await _getAuthenticatedDio();
    return dio.delete(path, data: data);
  }
}