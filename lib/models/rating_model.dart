class Rating {
  final String id;
  final int rating;
  final String? feedback;
  final DateTime createdAt;

  Rating({
    required this.id,
    required this.rating,
    this.feedback,
    required this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'] ?? '',
      rating: json['rating'] ?? 5,
      feedback: json['feedback'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'feedback': feedback,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}