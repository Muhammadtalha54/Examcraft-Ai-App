// this is for offline handling
class MCQ {
  final int? localId;
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? userAnswer;
  final String? explanation;
  final String difficulty;
  final DateTime createdAt;

  MCQ({
    this.localId,
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.userAnswer,
    this.explanation,
    required this.difficulty,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory MCQ.fromJson(Map<String, dynamic> json) {
    return MCQ(
      id: json['_id'] ?? json['id'] ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswerIndex: json['correctAnswerIndex'] ?? 0,
      explanation: json['explanation'],
      difficulty: json['difficulty'] ?? 'medium',
    );
  }

  // New factory method for API MCQ generation response
  factory MCQ.fromApiResponse(Map<String, dynamic> json) {
    final options = List<String>.from(json['options'] ?? []);
    final correctAnswer = json['correctAnswer'] ?? '';
    final correctIndex = options.indexOf(correctAnswer);

    return MCQ(
      id: json['_id'] ??
          json['id'] ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      question: json['question'] ?? '',
      options: options,
      correctAnswerIndex: correctIndex >= 0 ? correctIndex : 0,
      explanation: json['explanation'],
      difficulty: json['difficulty'] ?? 'medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'difficulty': difficulty,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options.join('|||'),
      'correctAnswer': correctAnswer,
      'userAnswer': userAnswer,
      'difficulty': difficulty,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MCQ.fromMap(Map<String, dynamic> map) {
    final options = (map['options'] as String).split('|||');
    final correctAnswer = map['correctAnswer'] as String;
    final correctIndex = options.indexOf(correctAnswer);

    return MCQ(
      localId: map['id'],
      id: map['id']?.toString() ?? '',
      question: map['question'],
      options: options,
      correctAnswerIndex: correctIndex >= 0 ? correctIndex : 0,
      userAnswer: map['userAnswer'],
      difficulty: map['difficulty'] ?? 'medium',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String get correctAnswer => options[correctAnswerIndex];
}
