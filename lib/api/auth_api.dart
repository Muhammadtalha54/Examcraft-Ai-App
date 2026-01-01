import 'api_client.dart';
import '../utils/response_handler.dart';

// Handles all authentication-related API calls (login, signup, password reset)
class AuthApi {
  // Logs in a user with their email and password
  // Returns user data if successful, error message if failed
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

  // Creates a new user account with name, email and password
  // Returns user data if successful, error message if email already exists
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

  // Sends a password reset email to the user
  // Returns success message if email exists, error if not found
  static Future<ApiResponse<Map<String, dynamic>>> forgotPassword({
    required String email,
  }) async {
    return await ApiClient.post(
      '/api/auth/forgot-password',
      data: {'email': email},
    );
  }

  // Verifies user's email address using a verification token
  // Returns success if token is valid, error if expired or invalid
  static Future<ApiResponse<Map<String, dynamic>>> verifyEmail({
    required String token,
  }) async {
    return await ApiClient.post(
      '/api/auth/verify-email',
      data: {'token': token},
    );
  }
}