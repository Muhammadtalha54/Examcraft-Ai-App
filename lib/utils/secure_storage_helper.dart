import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const _storage = FlutterSecureStorage();
  
  static const String _tokenKey = 'jwt_token';
  static const String _userKey = 'user_data';
  static const String _loginStatusKey = 'is_logged_in';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> saveUserData(String userData) async {
    await _storage.write(key: _userKey, value: userData);
  }

  static Future<String?> getUserData() async {
    return await _storage.read(key: _userKey);
  }

  static Future<void> setLoginStatus(bool isLoggedIn) async {
    await _storage.write(key: _loginStatusKey, value: isLoggedIn.toString());
  }

  static Future<bool> getLoginStatus() async {
    final status = await _storage.read(key: _loginStatusKey);
    return status == 'true';
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}