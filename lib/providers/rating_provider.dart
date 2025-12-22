import 'package:flutter/foundation.dart';
import '../repositories/rating_repository.dart';

class RatingProvider extends ChangeNotifier {
  final RatingRepository _repository = RatingRepository();
  
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<String> submitRating({
    required int rating,
    String? feedback,
  }) async {
    _isLoading = true;
    notifyListeners();

    final response = await _repository.submitRating(
      rating: rating,
      feedback: feedback,
    );

    _isLoading = false;
    notifyListeners();
    return response.message;
  }
}
