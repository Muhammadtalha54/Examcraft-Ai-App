import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../utils/shared_prefs_helper.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  final AuthRepository _authRepository = AuthRepository();

  AuthProvider() {
    _checkLoginStatus();
  }

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

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authRepository.login(email, password);
      _user = user;
      _isLoggedIn = true;
      
      // Save to shared preferences only
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

  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authRepository.signup(name, email, password);
      _user = user;
      _isLoggedIn = true;
      
      // Save to shared preferences only
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

  Future<void> logout() async {
    _user = null;
    _isLoggedIn = false;
    await SharedPrefsHelper.clearAll();
    notifyListeners();
  }
}