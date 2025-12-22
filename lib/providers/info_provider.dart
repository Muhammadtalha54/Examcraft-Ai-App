import 'package:flutter/foundation.dart';
import '../repositories/info_repository.dart';

class InfoProvider extends ChangeNotifier {
  final InfoRepository _repository = InfoRepository();
  
  bool _isLoading = false;
  Map<String, String>? _privacyPolicy;
  Map<String, String>? _termsOfService;

  bool get isLoading => _isLoading;
  Map<String, String>? get privacyPolicy => _privacyPolicy;
  Map<String, String>? get termsOfService => _termsOfService;

  Future<String> loadPrivacyPolicy() async {
    _isLoading = true;
    notifyListeners();

    final response = await _repository.getPrivacyPolicy();

    if (response.success && response.data != null) {
      _privacyPolicy = response.data;
    }

    _isLoading = false;
    notifyListeners();
    return response.message;
  }

  Future<String> loadTermsOfService() async {
    _isLoading = true;
    notifyListeners();

    final response = await _repository.getTermsOfService();

    if (response.success && response.data != null) {
      _termsOfService = response.data;
    }

    _isLoading = false;
    notifyListeners();
    return response.message;
  }
}
