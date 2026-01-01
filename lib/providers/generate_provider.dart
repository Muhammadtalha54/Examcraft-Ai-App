import 'package:flutter/foundation.dart';
import '../models/mcq_model.dart';
import '../models/question_model.dart';
import '../repositories/generate_repository.dart';

/// Manages question generation from PDF files
/// Handles MCQs, short questions, and long questions generation
class GenerateProvider extends ChangeNotifier {
  // Repository to handle question generation API calls
  final GenerateRepository _repository = GenerateRepository();
  
  // Private variables to store generation state
  bool _isLoading = false;
  List<MCQ>? _mcqs;
  List<Question>? _questions;

  // Public getters to access generation state
  bool get isLoading => _isLoading;
  List<MCQ>? get mcqs => _mcqs;
  List<Question>? get questions => _questions;

  /// Generates multiple choice questions from PDF file
  /// Takes PDF path, number of questions, and difficulty level
  /// Returns success/error message
  Future<String> generateMCQs({
    required String pdfPath,
    int count = 5,
    String difficulty = 'medium',
  }) async {
    _isLoading = true;
    _mcqs = null; // Clear previous MCQs
    notifyListeners();

    final response = await _repository.generateMCQFromPDF(
      pdfPath: pdfPath,
      count: count,
      difficulty: difficulty,
    );

    // Store generated MCQs if successful
    if (response.success && response.data != null) {
      _mcqs = response.data;
    }

    _isLoading = false;
    notifyListeners();
    return response.message;
  }

  /// Generates short answer questions from PDF file
  /// Takes PDF path, number of questions, and difficulty level
  /// Returns success/error message
  Future<String> generateShortQuestions({
    required String pdfPath,
    int count = 5,
    String difficulty = 'medium',
  }) async {
    _isLoading = true;
    _questions = null; // Clear previous questions
    notifyListeners();

    final response = await _repository.generateShortFromPDF(
      pdfPath: pdfPath,
      count: count,
      difficulty: difficulty,
    );

    // Store generated questions if successful
    if (response.success && response.data != null) {
      _questions = response.data;
    }

    _isLoading = false;
    notifyListeners();
    return response.message;
  }

  /// Generates long answer questions from PDF file
  /// Takes PDF path, number of questions, and difficulty level
  /// Returns success/error message
  Future<String> generateLongQuestions({
    required String pdfPath,
    int count = 3,
    String difficulty = 'medium',
  }) async {
    _isLoading = true;
    _questions = null; // Clear previous questions
    notifyListeners();

    final response = await _repository.generateLongFromPDF(
      pdfPath: pdfPath,
      count: count,
      difficulty: difficulty,
    );

    // Store generated questions if successful
    if (response.success && response.data != null) {
      _questions = response.data;
    }

    _isLoading = false;
    notifyListeners();
    return response.message;
  }

  /// Loads previously generated MCQs from local storage
  Future<void> loadOfflineMCQs() async {
    _mcqs = await _repository.getOfflineMCQs();
    notifyListeners();
  }

  /// Loads previously generated questions from local storage
  /// Takes question type (short/long) as parameter
  Future<void> loadOfflineQuestions(String type) async {
    _questions = await _repository.getOfflineQuestions(type);
    notifyListeners();
  }

  /// Clears all stored MCQs from local storage and memory
  Future<void> clearMCQs() async {
    await _repository.clearMCQs();
    _mcqs = null;
    notifyListeners();
  }

  /// Clears stored questions of specific type from local storage and memory
  /// Takes question type (short/long) as parameter
  Future<void> clearQuestions(String type) async {
    await _repository.clearQuestions(type);
    _questions = null;
    notifyListeners();
  }
}