import '../api/auth_api.dart';
import '../models/user_model.dart';
import '../utils/response_handler.dart';

// Repository that handles user authentication business logic
// Acts as a bridge between the UI and the authentication API
class AuthRepository {
  // Logs in a user and returns their profile information
  // Throws error if email/password is wrong or network fails
  Future<User> login(String email, String password) async {
    final response = await AuthApi.login(email: email, password: password);
    
    if (response.success && response.data != null) {
      final userData = response.data!['data']?['user'];
      if (userData != null) {
        // Convert server response to User object
        return User.fromJson(userData);
      } else {
        throw ApiException('Invalid response format');
      }
    } else {
      // Login failed - wrong credentials or server error
      throw ApiException(response.message);
    }
  }

  // Creates a new user account and returns their profile information
  // Throws error if email already exists or validation fails
  Future<User> signup(String name, String email, String password) async {
    final response = await AuthApi.signup(
      name: name,
      email: email,
      password: password,
    );
    
    if (response.success && response.data != null) {
      final userData = response.data!['data']?['user'];
      if (userData != null) {
        // Convert server response to User object
        return User.fromJson(userData);
      } else {
        throw ApiException('Invalid response format');
      }
    } else {
      // Signup failed - email exists or validation error
      throw ApiException(response.message);
    }
  }

  // Sends password reset email to user's email address
  // Throws error if email doesn't exist in system
  Future<void> forgotPassword(String email) async {
    final response = await AuthApi.forgotPassword(email: email);
    
    if (!response.success) {
      // Email not found or server error
      throw ApiException(response.message);
    }
  }

  // Verifies user's email using the token sent to their email
  // Throws error if token is expired or invalid
  Future<void> verifyEmail(String token) async {
    final response = await AuthApi.verifyEmail(token: token);
    
    if (!response.success) {
      // Token expired or invalid
      throw ApiException(response.message);
    }
  }
}