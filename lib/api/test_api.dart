import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_client.dart';
import '../utils/response_handler.dart';
import '../models/mcq_model.dart';

// Handles test evaluation API calls (checking answers and calculating scores)
class TestApi {
  // Evaluates MCQ test by sending questions and user answers to server
  // Returns score, percentage, and detailed results for each question
  static Future<ApiResponse<Map<String, dynamic>>> evaluateMCQTest({
    required List<MCQ> questions,
    required List<String> answers,
  }) async {
    return await ApiClient.post(
      '/api/test/mcq',
      data: {
        // Send question text and correct answers for verification
        'questions': questions.map((q) => {
          'question': q.question,
          'correctAnswer': q.correctAnswer,
        }).toList(),
        // Send user's selected answers
        'answers': answers,
      },
    );
  }
}