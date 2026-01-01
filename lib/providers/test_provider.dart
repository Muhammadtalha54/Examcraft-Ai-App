import 'package:flutter/foundation.dart';
import '../models/mcq_model.dart';
import '../models/test_result_model.dart';
import '../repositories/test_repository.dart';

/// Manages test evaluation and test history functionality
/// Handles MCQ test evaluation, results storage, and history management
class TestProvider extends ChangeNotifier {
  // Repository to handle test-related API calls
  final TestRepository _repository = TestRepository();

  // Private variables to store test state
  bool _isLoading = false;
  Map<String, dynamic>? _testResult;
  List<TestResult>? _testHistory;

  // Public getters to access test state
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get testResult => _testResult;
  List<TestResult>? get testHistory => _testHistory;

  /// Evaluates MCQ test by comparing user answers with correct answers
  /// Takes list of questions and user answers
  /// Returns success/error message and stores result
  Future<String> evaluateTest({
    required List<MCQ> questions,
    required List<String> answers,
  }) async {
    _isLoading = true;
    _testResult = null; // Clear previous result
    notifyListeners();

    // Send test data for evaluation
    final response = await _repository.evaluateMCQTest(
      questions: questions,
      answers: answers,
    );

    // Store evaluation result if successful
    if (response.success && response.data != null) {
      _testResult = response.data;
    }

    _isLoading = false;
    notifyListeners();
    return response.message;
  }

  /// Loads all previous test results from local storage
  Future<void> loadTestHistory() async {
    _testHistory = await _repository.getTestHistory();
    notifyListeners();
  }

  /// Clears all test history from local storage and memory
  Future<void> clearHistory() async {
    await _repository.clearHistory();
    _testHistory = null;
    notifyListeners();
  }

  /// Saves test result to local storage for history tracking
  /// Takes test details like title, score, total questions, and percentage
  Future<void> saveTestResultLocally({
    required String testTitle,
    required int score,
    required int total,
    required double percentage,
  }) async {
    // Create test result object
    final testResult = TestResult(
      testTitle: testTitle,
      score: score,
      total: total,
      percentage: percentage,
    );
    // Save to local storage
    await _repository.saveTestResultLocally(testResult);
  }

  /// Clears current test result from memory (not from storage)
  void clearTestResult() {
    _testResult = null;
    notifyListeners();
  }
}