import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/mcq_model.dart';
import '../models/test_result_model.dart';
import '../utils/response_handler.dart';
import '../services/database_helper.dart';
import '../api/test_api.dart';

class TestRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<ApiResponse<Map<String, dynamic>>> evaluateMCQTest({
    required List<MCQ> questions,
    required List<String> answers,
  }) async {
    try {
      final response = await TestApi.evaluateMCQTest(
        questions: questions,
        answers: answers,
      );

      if (response.success && response.data != null) {
        // Save test result to SQLite
        final data = response.data!['data'];
        final testResult = TestResult(
          testTitle: 'MCQ Test',
          score: data['score'],
          total: data['total'],
          percentage: (data['percentage'] as num).toDouble(),
        );
        await _db.insertTestResult(testResult.toMap());
      }

      return response;
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error: $e',
      );
    }
  }

  Future<void> saveTestResultLocally(TestResult testResult) async {
    await _db.insertTestResult(testResult.toMap());
  }

  Future<List<TestResult>> getTestHistory() async {
    final maps = await _db.getAllTestResults();
    return maps.map((map) => TestResult.fromMap(map)).toList();
  }

  Future<void> clearHistory() async {
    final results = await _db.getAllTestResults();
    for (var result in results) {
      if (result['id'] != null) {
        await _db.deleteTestResult(result['id']);
      }
    }
  }
}
