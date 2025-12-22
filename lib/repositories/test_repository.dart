import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/mcq_model.dart';
import '../models/test_result_model.dart';
import '../utils/response_handler.dart';
import '../services/database_helper.dart';
import '../api/api_client.dart';

class TestRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<ApiResponse<Map<String, dynamic>>> evaluateMCQTest({
    required List<MCQ> questions,
    required List<String> answers,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiClient.baseUrl}/api/test/mcq'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'questions': questions.map((q) => {
            'question': q.question,
            'correctAnswer': q.correctAnswer,
          }).toList(),
          'answers': answers,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        // Save test result to SQLite
        final testResult = TestResult(
          score: data['data']['score'],
          total: data['data']['total'],
          percentage: (data['data']['percentage'] as num).toDouble(),
        );
        await _db.insertTestResult(testResult.toMap());

        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Test evaluated successfully',
          data: data['data'],
        );
      }

      return ApiResponse(
        success: false,
        message: data['message'] ?? 'Failed to evaluate test',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
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
