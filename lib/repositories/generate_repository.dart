import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import '../models/mcq_model.dart';
import '../models/question_model.dart';
import '../utils/response_handler.dart';
import '../services/database_helper.dart';
import '../api/api_client.dart';

// Repository that handles question generation from PDF files
// Manages both API calls to generate questions and local database storage
class GenerateRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // Generates multiple choice questions from a PDF file
  // Uploads PDF to server, gets MCQs back, and saves them locally
  Future<ApiResponse<List<MCQ>>> generateMCQFromPDF({
    required String pdfPath,
    int count = 5,
    String difficulty = 'medium',
  }) async {
    try {
      // Create file upload request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiClient.baseUrl}/api/generate/mcq'),
      );
      
      // Add PDF file to request
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        pdfPath,
        contentType: MediaType('application', 'pdf'),
      ));
      
      // Add generation parameters
      request.fields['count'] = count.toString();
      request.fields['difficulty'] = difficulty;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        // Convert server response to MCQ objects
        final mcqs = (data['data']['mcqs'] as List)
            .map((json) => MCQ.fromApiResponse(json))
            .toList();
        
        // Save generated MCQs to local database for offline access
        for (var mcq in mcqs) {
          await _db.insertMCQ(mcq.toMap());
        }

        return ApiResponse(
          success: true,
          message: data['message'] ?? 'MCQs generated successfully',
          data: mcqs,
        );
      }

      // Server returned error
      return ApiResponse(
        success: false,
        message: data['message'] ?? 'Failed to generate MCQs',
      );
    } catch (e) {
      // Network or file upload error
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }

  // Generates short answer questions from a PDF file
  // Similar to MCQ but creates questions requiring brief written answers
  Future<ApiResponse<List<Question>>> generateShortFromPDF({
    required String pdfPath,
    int count = 5,
    String difficulty = 'medium',
  }) async {
    try {
      // Create file upload request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiClient.baseUrl}/api/generate/short'),
      );
      
      // Add PDF file to request
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        pdfPath,
        contentType: MediaType('application', 'pdf'),
      ));
      
      // Add generation parameters
      request.fields['count'] = count.toString();
      request.fields['difficulty'] = difficulty;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        // Convert server response to Question objects
        final questions = (data['data']['questions'] as List)
            .map((json) => Question.fromJson(json))
            .toList();
        
        // Save generated questions to local database
        for (var question in questions) {
          await _db.insertQuestion(question.toMap('short'));
        }

        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Short questions generated successfully',
          data: questions,
        );
      }

      // Server returned error
      return ApiResponse(
        success: false,
        message: data['message'] ?? 'Failed to generate questions',
      );
    } catch (e) {
      // Network or file upload error
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }

  // Generates long essay-type questions from a PDF file
  // Creates detailed questions requiring comprehensive written answers
  Future<ApiResponse<List<Question>>> generateLongFromPDF({
    required String pdfPath,
    int count = 3,
    String difficulty = 'medium',
  }) async {
    try {
      // Create file upload request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiClient.baseUrl}/api/generate/long'),
      );
      
      // Add PDF file to request
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        pdfPath,
        contentType: MediaType('application', 'pdf'),
      ));
      
      // Add generation parameters
      request.fields['count'] = count.toString();
      request.fields['difficulty'] = difficulty;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        // Convert server response to Question objects
        final questions = (data['data']['questions'] as List)
            .map((json) => Question.fromJson(json))
            .toList();
        
        // Save generated questions to local database
        for (var question in questions) {
          await _db.insertQuestion(question.toMap('long'));
        }

        return ApiResponse(
          success: true,
          message: data['message'] ?? 'Long questions generated successfully',
          data: questions,
        );
      }

      // Server returned error
      return ApiResponse(
        success: false,
        message: data['message'] ?? 'Failed to generate questions',
      );
    } catch (e) {
      // Network or file upload error
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }

  // Retrieves previously generated MCQs from local database
  // Used when user wants to view history or work offline
  Future<List<MCQ>> getOfflineMCQs() async {
    final maps = await _db.getAllMCQs();
    return maps.map((map) => MCQ.fromMap(map)).toList();
  }

  // Retrieves previously generated questions by type (short/long)
  // Used for viewing question history or offline access
  Future<List<Question>> getOfflineQuestions(String type) async {
    final maps = await _db.getQuestionsByType(type);
    return maps.map((map) => Question.fromMap(map)).toList();
  }

  // Deletes all stored MCQs from local database
  // Used when user wants to clear their MCQ history
  Future<void> clearMCQs() async {
    await _db.deleteAllMCQs();
  }

  // Deletes all questions of specific type from local database
  // Used when user wants to clear short or long question history
  Future<void> clearQuestions(String type) async {
    await _db.deleteQuestionsByType(type);
  }
}
