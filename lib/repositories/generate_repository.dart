import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import '../models/mcq_model.dart';
import '../models/question_model.dart';
import '../utils/response_handler.dart';
import '../services/database_helper.dart';
import '../api/api_client.dart';

class GenerateRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // Generate MCQs from PDF
  Future<ApiResponse<List<MCQ>>> generateMCQFromPDF({
    required String pdfPath,
    int count = 5,
    String difficulty = 'medium',
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiClient.baseUrl}/api/generate/mcq'),
      );
      
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        pdfPath,
        contentType: MediaType('application', 'pdf'),
      ));
      
      request.fields['count'] = count.toString();
      request.fields['difficulty'] = difficulty;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        final mcqs = (data['data']['mcqs'] as List)
            .map((json) => MCQ.fromApiResponse(json))
            .toList();
        
        // Save to SQLite
        for (var mcq in mcqs) {
          await _db.insertMCQ(mcq.toMap());
        }

        return ApiResponse(
          success: true,
          message: data['message'] ?? 'MCQs generated successfully',
          data: mcqs,
        );
      }

      return ApiResponse(
        success: false,
        message: data['message'] ?? 'Failed to generate MCQs',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }

  // Generate Short Questions from PDF
  Future<ApiResponse<List<Question>>> generateShortFromPDF({
    required String pdfPath,
    int count = 5,
    String difficulty = 'medium',
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiClient.baseUrl}/api/generate/short'),
      );
      
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        pdfPath,
        contentType: MediaType('application', 'pdf'),
      ));
      
      request.fields['count'] = count.toString();
      request.fields['difficulty'] = difficulty;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        final questions = (data['data']['questions'] as List)
            .map((json) => Question.fromJson(json))
            .toList();
        
        // Save to SQLite
        for (var question in questions) {
          await _db.insertQuestion(question.toMap('short'));
        }

        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Short questions generated successfully',
          data: questions,
        );
      }

      return ApiResponse(
        success: false,
        message: data['message'] ?? 'Failed to generate questions',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }

  // Generate Long Questions from PDF
  Future<ApiResponse<List<Question>>> generateLongFromPDF({
    required String pdfPath,
    int count = 3,
    String difficulty = 'medium',
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiClient.baseUrl}/api/generate/long'),
      );
      
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        pdfPath,
        contentType: MediaType('application', 'pdf'),
      ));
      
      request.fields['count'] = count.toString();
      request.fields['difficulty'] = difficulty;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        final questions = (data['data']['questions'] as List)
            .map((json) => Question.fromJson(json))
            .toList();
        
        // Save to SQLite
        for (var question in questions) {
          await _db.insertQuestion(question.toMap('long'));
        }

        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Long questions generated successfully',
          data: questions,
        );
      }

      return ApiResponse(
        success: false,
        message: data['message'] ?? 'Failed to generate questions',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }

  // Get offline MCQs
  Future<List<MCQ>> getOfflineMCQs() async {
    final maps = await _db.getAllMCQs();
    return maps.map((map) => MCQ.fromMap(map)).toList();
  }

  // Get offline questions by type
  Future<List<Question>> getOfflineQuestions(String type) async {
    final maps = await _db.getQuestionsByType(type);
    return maps.map((map) => Question.fromMap(map)).toList();
  }

  // Delete all MCQs
  Future<void> clearMCQs() async {
    await _db.deleteAllMCQs();
  }

  // Delete questions by type
  Future<void> clearQuestions(String type) async {
    await _db.deleteQuestionsByType(type);
  }
}
