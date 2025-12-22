import 'package:flutter/foundation.dart';
import '../models/mcq_model.dart';
import '../models/test_result_model.dart';
import '../repositories/test_repository.dart';

class TestProvider extends ChangeNotifier {
  final TestRepository _repository = TestRepository();
  
  bool _isLoading = false;
  Map<String, dynamic>? _testResult;
  List<TestResult>? _testHistory;

  bool get isLoading => _isLoading;
  Map<String, dynamic>? get testResult => _testResult;
  List<TestResult>? get testHistory => _testHistory;

  Future<String> evaluateTest({
    required List<MCQ> questions,
    required List<String> answers,
  }) async {
    _isLoading = true;
    _testResult = null;
    notifyListeners();

    final response = await _repository.evaluateMCQTest(
      questions: questions,
      answers: answers,
    );

    if (response.success && response.data != null) {
      _testResult = response.data;
    }

    _isLoading = false;
    notifyListeners();
    return response.message;
  }

  Future<void> loadTestHistory() async {
    _testHistory = await _repository.getTestHistory();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    await _repository.clearHistory();
    _testHistory = null;
    notifyListeners();
  }

  void clearTestResult() {
    _testResult = null;
    notifyListeners();
  }
}
