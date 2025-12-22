class Question {
  final int? localId;
  final String id;
  final String question;
  final String answer;
  final String difficulty;
  final DateTime createdAt;

  Question({
    this.localId,
    required this.id,
    required this.question,
    required this.answer,
    required this.difficulty,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'] ?? json['id'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? json['suggestedAnswer'] ?? '',
      difficulty: json['difficulty'] ?? 'medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'difficulty': difficulty,
    };
  }

  Map<String, dynamic> toMap(String type) {
    return {
      'question': question,
      'answer': answer,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      localId: map['id'],
      id: map['id']?.toString() ?? '',
      question: map['question'],
      answer: map['answer'],
      difficulty: map['difficulty'] ?? 'medium',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
