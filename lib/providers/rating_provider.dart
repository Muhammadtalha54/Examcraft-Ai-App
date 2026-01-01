import 'package:flutter/foundation.dart';
import '../repositories/rating_repository.dart';

/// Manages app rating and feedback functionality
/// Handles submitting user ratings and feedback to the server
class RatingProvider extends ChangeNotifier {
  // Repository to handle rating API calls
  final RatingRepository _repository = RatingRepository();
  
  // Private variable to track loading state
  bool _isLoading = false;

  // Public getter to access loading state
  bool get isLoading => _isLoading;

  /// Submits user rating and optional feedback to the server
  /// Takes rating (1-5) and optional feedback text
  /// Returns success/error message
  Future<String> submitRating({
    required int rating,
    String? feedback,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Send rating data to server
    final response = await _repository.submitRating(
      rating: rating,
      feedback: feedback,
    );

    _isLoading = false;
    notifyListeners();
    return response.message;
  }
}