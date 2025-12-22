class ShortQuestion {
  final String id;
  final String question;
  final String? suggestedAnswer;
  final String difficulty;
  final int marks;

  ShortQuestion({
    required this.id,
    required this.question,
    this.suggestedAnswer,
    required this.difficulty,
    required this.marks,
  });

  factory ShortQuestion.fromJson(Map<String, dynamic> json) {
    return ShortQuestion(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      suggestedAnswer: json['suggestedAnswer'],
      difficulty: json['difficulty'] ?? 'medium',
      marks: json['marks'] ?? 5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'suggestedAnswer': suggestedAnswer,
      'difficulty': difficulty,
      'marks': marks,
    };
  }
}