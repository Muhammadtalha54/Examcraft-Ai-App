class LongQuestion {
  final String id;
  final String question;
  final String? suggestedAnswer;
  final String difficulty;
  final int marks;
  final int timeLimit; // in minutes

  LongQuestion({
    required this.id,
    required this.question,
    this.suggestedAnswer,
    required this.difficulty,
    required this.marks,
    required this.timeLimit,
  });

  factory LongQuestion.fromJson(Map<String, dynamic> json) {
    return LongQuestion(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      suggestedAnswer: json['suggestedAnswer'],
      difficulty: json['difficulty'] ?? 'medium',
      marks: json['marks'] ?? 10,
      timeLimit: json['timeLimit'] ?? 30,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'suggestedAnswer': suggestedAnswer,
      'difficulty': difficulty,
      'marks': marks,
      'timeLimit': timeLimit,
    };
  }
}