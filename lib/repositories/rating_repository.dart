import '../api/api_client.dart';
import '../utils/response_handler.dart';

class RatingRepository {
  Future<ApiResponse<void>> submitRating({
    required int rating,
    String? feedback,
  }) async {
    try {
      final response = await ApiClient.post(
        '/api/rate',
        data: {
          'rating': rating,
          'feedback': feedback,
        },
      );

      return ApiResponse(
        success: response.success,
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
