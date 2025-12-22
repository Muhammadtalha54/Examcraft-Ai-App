import '../api/api_client.dart';
import '../utils/response_handler.dart';

class InfoRepository {
  Future<ApiResponse<Map<String, String>>> getPrivacyPolicy() async {
    try {
      final response = await ApiClient.get('/api/info/privacy');
      
      if (response.success && response.data != null) {
        return ApiResponse(
          success: true,
          message: response.message,
          data: {
            'title': response.data!['data']['title'] ?? 'Privacy Policy',
            'content': response.data!['data']['content'] ?? '',
          },
        );
      }
      
      return ApiResponse(
        success: false,
        message: response.message,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }

  Future<ApiResponse<Map<String, String>>> getTermsOfService() async {
    try {
      final response = await ApiClient.get('/api/info/terms');
      
      if (response.success && response.data != null) {
        return ApiResponse(
          success: true,
          message: response.message,
          data: {
            'title': response.data!['data']['title'] ?? 'Terms of Service',
            'content': response.data!['data']['content'] ?? '',
          },
        );
      }
      
      return ApiResponse(
        success: false,
        message: response.message,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Network error: $e',
      );
    }
  }
}
