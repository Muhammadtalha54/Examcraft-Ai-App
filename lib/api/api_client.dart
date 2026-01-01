import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/response_handler.dart';

// Main API client that handles all network requests to the backend server
class ApiClient {
  // The main server URL where all API requests are sent
  static const String baseUrl = 'https://examcraft-ai-backend.onrender.com';
  
  // Creates standard headers that every API request needs
  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Makes a GET request to fetch data from the server
  // Used when you want to retrieve information (like getting questions)
  static Future<ApiResponse<Map<String, dynamic>>> get(
    String endpoint,
  ) async {
    try {
      final headers = getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      
      return handleResponse(response);
    } catch (e) {
      // If network fails, return error message
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // Makes a POST request to send data to the server
  // Used when you want to create or submit something (like generating questions)
  static Future<ApiResponse<Map<String, dynamic>>> post(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final headers = getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: data != null ? jsonEncode(data) : null,
      );
      
      return handleResponse(response);
    } catch (e) {
      // If network fails, return error message
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // Processes the server response and converts it to a standard format
  // Checks if the request was successful or failed
  static ApiResponse<Map<String, dynamic>> handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      
      // Check if status code indicates success (200-299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(data);
      } else {
        // Server returned an error
        return ApiResponse.error(
          data['message'] ?? 'Request failed',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      // If response can't be parsed, return error
      return ApiResponse.error('Failed to parse response');
    }
  }
}