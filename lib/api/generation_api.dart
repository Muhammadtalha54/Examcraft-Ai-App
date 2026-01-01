import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import '../utils/response_handler.dart';

// Handles all question generation API calls (MCQ, short, long questions)
class GenerationApi {
  // Generates multiple choice questions from a PDF file
  // Uploads PDF to server and gets back MCQs with specified count and difficulty
  static Future<ApiResponse<Map<String, dynamic>>> generateMCQ({
    required File file,
    required int count,
    required String difficulty,
  }) async {
    try {
      // Create multipart request to upload file
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiClient.baseUrl}/generation/mcq'),
      );
      
      final headers = await ApiClient.getHeaders();
      request.headers.addAll(headers);
      
      // Add the PDF file to the request
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['count'] = count.toString();
      request.fields['difficulty'] = difficulty;
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      return ApiClient.handleResponse(response);
    } catch (e) {
      // If file upload or generation fails, return error
      return ApiResponse.error('Failed to generate MCQs: ${e.toString()}');
    }
  }

  // Generates short answer questions from a PDF file
  // Similar to MCQ but creates questions that need brief written answers
  static Future<ApiResponse<Map<String, dynamic>>> generateShortQuestions({
    required File file,
    required int count,
    required String difficulty,
  }) async {
    try {
      // Create multipart request to upload file
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiClient.baseUrl}/generation/short'),
      );
      
      final headers = await ApiClient.getHeaders();
      request.headers.addAll(headers);
      
      // Add the PDF file to the request
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['count'] = count.toString();
      request.fields['difficulty'] = difficulty;
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      return ApiClient.handleResponse(response);
    } catch (e) {
      // If file upload or generation fails, return error
      return ApiResponse.error('Failed to generate short questions: ${e.toString()}');
    }
  }

  // Generates long essay-type questions from a PDF file
  // Creates detailed questions that need comprehensive written answers
  static Future<ApiResponse<Map<String, dynamic>>> generateLongQuestions({
    required File file,
    required int count,
    required String difficulty,
  }) async {
    try {
      // Create multipart request to upload file
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiClient.baseUrl}/generation/long'),
      );
      
      final headers = await ApiClient.getHeaders();
      request.headers.addAll(headers);
      
      // Add the PDF file to the request
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['count'] = count.toString();
      request.fields['difficulty'] = difficulty;
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      return ApiClient.handleResponse(response);
    } catch (e) {
      // If file upload or generation fails, return error
      return ApiResponse.error('Failed to generate long questions: ${e.toString()}');
    }
  }
}