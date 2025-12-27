import '../api/auth_api.dart';
import '../models/user_model.dart';
import '../utils/response_handler.dart';

class AuthRepository {
  Future<User> login(String email, String password) async {
    final response = await AuthApi.login(email: email, password: password);
    
    if (response.success && response.data != null) {
      final userData = response.data!['data']?['user'];
      if (userData != null) {
        return User.fromJson(userData);
      } else {
        throw ApiException('Invalid response format');
      }
    } else {
      throw ApiException(response.message);
    }
  }

  Future<User> signup(String name, String email, String password) async {
    final response = await AuthApi.signup(
      name: name,
      email: email,
      password: password,
    );
    
    if (response.success && response.data != null) {
      final userData = response.data!['data']?['user'];
      if (userData != null) {
        return User.fromJson(userData);
      } else {
        throw ApiException('Invalid response format');
      }
    } else {
      throw ApiException(response.message);
    }
  }

  Future<void> forgotPassword(String email) async {
    final response = await AuthApi.forgotPassword(email: email);
    
    if (!response.success) {
      throw ApiException(response.message);
    }
  }

  Future<void> verifyEmail(String token) async {
    final response = await AuthApi.verifyEmail(token: token);
    
    if (!response.success) {
      throw ApiException(response.message);
    }
  }
}