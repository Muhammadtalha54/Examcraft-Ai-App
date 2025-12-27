import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_client.dart';
import '../utils/response_handler.dart';
import '../models/mcq_model.dart';

class TestApi {
  static Future<ApiResponse<Map<String, dynamic>>> evaluateMCQTest({
    required List<MCQ> questions,
    required List<String> answers,
  }) async {
    return await ApiClient.post(
      '/api/test/mcq',
      data: {
        'questions': questions.map((q) => {
          'question': q.question,
          'correctAnswer': q.correctAnswer,
        }).toList(),
        'answers': answers,
      },
    );
  }
}