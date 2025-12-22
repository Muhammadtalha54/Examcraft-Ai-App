import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import '../utils/response_handler.dart';

class GenerationApi {
  static Future<ApiResponse<Map<String, dynamic>>> generateMCQ({
    required File file,
    required int count,
    required String difficulty,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiClient.baseUrl}/generation/mcq'),
      );
      
      final headers = await ApiClient.getHeaders();
      request.headers.addAll(headers);
      
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['count'] = count.toString();
      request.fields['difficulty'] = difficulty;
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      return ApiClient.handleResponse(response);
    } catch (e) {
      return ApiResponse.error('Failed to generate MCQs: ${e.toString()}');
    }
  }

  static Future<ApiResponse<Map<String, dynamic>>> generateShortQuestions({
    required File file,
    required int count,
    required String difficulty,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiClient.baseUrl}/generation/short'),
      );
      
      final headers = await ApiClient.getHeaders();
      request.headers.addAll(headers);
      
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['count'] = count.toString();
      request.fields['difficulty'] = difficulty;
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      return ApiClient.handleResponse(response);
    } catch (e) {
      return ApiResponse.error('Failed to generate short questions: ${e.toString()}');
    }
  }

  static Future<ApiResponse<Map<String, dynamic>>> generateLongQuestions({
    required File file,
    required int count,
    required String difficulty,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiClient.baseUrl}/generation/long'),
      );
      
      final headers = await ApiClient.getHeaders();
      request.headers.addAll(headers);
      
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['count'] = count.toString();
      request.fields['difficulty'] = difficulty;
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      return ApiClient.handleResponse(response);
    } catch (e) {
      return ApiResponse.error('Failed to generate long questions: ${e.toString()}');
    }
  }
}