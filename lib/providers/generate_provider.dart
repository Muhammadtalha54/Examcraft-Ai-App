import 'package:flutter/foundation.dart';
import '../models/mcq_model.dart';
import '../models/question_model.dart';
import '../repositories/generate_repository.dart';

class GenerateProvider extends ChangeNotifier {
  final GenerateRepository _repository = GenerateRepository();
  
  bool _isLoading = false;
  List<MCQ>? _mcqs;
  List<Question>? _questions;

  bool get isLoading => _isLoading;
  List<MCQ>? get mcqs => _mcqs;
  List<Question>? get questions => _questions;

  Future<String> generateMCQs({
    required String pdfPath,
    int count = 5,
    String difficulty = 'medium',
  }) async {
    _isLoading = true;
    _mcqs = null;
    notifyListeners();

    final response = await _repository.generateMCQFromPDF(
      pdfPath: pdfPath,
      count: count,
      difficulty: difficulty,
    );

    if (response.success && response.data != null) {
      _mcqs = response.data;
    }

    _isLoading = false;
    notifyListeners();
    return response.message;
  }

  Future<String> generateShortQuestions({
    required String pdfPath,
    int count = 5,
    String difficulty = 'medium',
  }) async {
    _isLoading = true;
    _questions = null;
    notifyListeners();

    final response = await _repository.generateShortFromPDF(
      pdfPath: pdfPath,
      count: count,
      difficulty: difficulty,
    );

    if (response.success && response.data != null) {
      _questions = response.data;
    }

    _isLoading = false;
    notifyListeners();
    return response.message;
  }

  Future<String> generateLongQuestions({
    required String pdfPath,
    int count = 3,
    String difficulty = 'medium',
  }) async {
    _isLoading = true;
    _questions = null;
    notifyListeners();

    final response = await _repository.generateLongFromPDF(
      pdfPath: pdfPath,
      count: count,
      difficulty: difficulty,
    );

    if (response.success && response.data != null) {
      _questions = response.data;
    }

    _isLoading = false;
    notifyListeners();
    return response.message;
  }

  Future<void> loadOfflineMCQs() async {
    _mcqs = await _repository.getOfflineMCQs();
    notifyListeners();
  }

  Future<void> loadOfflineQuestions(String type) async {
    _questions = await _repository.getOfflineQuestions(type);
    notifyListeners();
  }

  Future<void> clearMCQs() async {
    await _repository.clearMCQs();
    _mcqs = null;
    notifyListeners();
  }

  Future<void> clearQuestions(String type) async {
    await _repository.clearQuestions(type);
    _questions = null;
    notifyListeners();
  }
}
