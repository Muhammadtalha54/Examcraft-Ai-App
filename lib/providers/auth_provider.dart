import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../utils/shared_prefs_helper.dart';

/// Manages user authentication state throughout the app
/// Handles login, signup, logout, and password reset functionality
class AuthProvider with ChangeNotifier {
  // Private variables to store user state
  User? _user;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  // Public getters to access user state
  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  // Repository to handle authentication API calls
  final AuthRepository _authRepository = AuthRepository();

  // Constructor - automatically checks if user is already logged in
  AuthProvider() {
    _checkLoginStatus();
  }

  /// Checks if user is already logged in when app starts
  /// Loads user data from shared preferences if available
  Future<void> _checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isLoggedIn = await SharedPrefsHelper.getLoginStatus();
      if (_isLoggedIn) {
        final name = await SharedPrefsHelper.getUserName();
        final email = await SharedPrefsHelper.getUserEmail();
        if (name != null && email != null) {
          _user = User(
            id: '',
            name: name,
            email: email,
            isVerified: false,
            createdAt: DateTime.now(),
          );
        }
      }
    } catch (e) {
      _isLoggedIn = false;
      _user = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Logs in user with email and password
  /// Returns true if successful, throws error if failed
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authRepository.login(email, password);
      _user = user;
      _isLoggedIn = true;
      
      // Save user login status and data to device storage
      await SharedPrefsHelper.setLoginStatus(true);
      await SharedPrefsHelper.saveUserName(user.name);
      await SharedPrefsHelper.saveUserEmail(user.email);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  /// Creates new user account with name, email and password
  /// Returns true if successful, throws error if failed
  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authRepository.signup(name, email, password);
      _user = user;
      _isLoggedIn = true;
      
      // Save new user data to device storage
      await SharedPrefsHelper.setLoginStatus(true);
      await SharedPrefsHelper.saveUserName(user.name);
      await SharedPrefsHelper.saveUserEmail(user.email);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  /// Sends password reset email to user
  /// Returns true if email sent successfully
  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.forgotPassword(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  /// Logs out user and clears all stored data
  Future<void> logout() async {
    _user = null;
    _isLoggedIn = false;
    await SharedPrefsHelper.clearAll();
    notifyListeners();
  }
}