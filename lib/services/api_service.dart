import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../api/api_client.dart';

class ApiService {
  static Future<Map<String, dynamic>> generateMCQTest({
    required File file,
    required int totalQuestions,
    required String difficulty,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('${ApiClient.baseUrl}/api/test/mcq'));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['totalQuestions'] = totalQuestions.toString();
      request.fields['difficulty'] = difficulty;
      
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        throw Exception('Failed to generate MCQ test');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
  
  static Future<Map<String, dynamic>> getPrivacyPolicy() async {
    try {
      final response = await http.get(Uri.parse('${ApiClient.baseUrl}/api/info/privacy'));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load privacy policy');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
  
  static Future<Map<String, dynamic>> getTermsAndConditions() async {
    try {
      final response = await http.get(Uri.parse('${ApiClient.baseUrl}/api/info/terms'));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load terms and conditions');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
  
  static Future<Map<String, dynamic>> submitRating({
    String? userId,
    required int rating,
    String? comment,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiClient.baseUrl}/api/rate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'rating': rating,
          'comment': comment,
        }),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to submit rating');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
  
  static Future<Map<String, dynamic>> getRatingStats() async {
    try {
      final response = await http.get(Uri.parse('${ApiClient.baseUrl}/api/rate'));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load rating stats');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}