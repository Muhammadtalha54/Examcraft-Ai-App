import 'api_client.dart';
import '../utils/response_handler.dart';

class AuthApi {
  static Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    return await ApiClient.post(
      '/api/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    return await ApiClient.post(
      '/api/auth/signup',
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> forgotPassword({
    required String email,
  }) async {
    return await ApiClient.post(
      '/api/auth/forgot-password',
      data: {'email': email},
    );
  }

  static Future<ApiResponse<Map<String, dynamic>>> verifyEmail({
    required String token,
  }) async {
    return await ApiClient.post(
      '/api/auth/verify-email',
      data: {'token': token},
    );
  }
}