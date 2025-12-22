import 'mcq_model.dart';

class TestModel {
  final String id;
  final String title;
  final DateTime date;
  final String difficulty;
  final List<MCQ> mcqs;
  final Map<int, String> userAnswers;
  final int totalQuestions;
  final int correctAnswers;
  final int timeLimit; // in seconds
  final bool isCompleted;

  TestModel({
    required this.id,
    required this.title,
    required this.date,
    required this.difficulty,
    required this.mcqs,
    required this.userAnswers,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeLimit,
    required this.isCompleted,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      difficulty: json['difficulty'] ?? 'medium',
      mcqs: (json['mcqs'] as List? ?? []).map((e) => MCQ.fromJson(e)).toList(),
      userAnswers: Map<int, String>.from(json['userAnswers'] ?? {}),
      totalQuestions: json['totalQuestions'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      timeLimit: json['timeLimit'] ?? 0,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'difficulty': difficulty,
      'mcqs': mcqs.map((e) => e.toJson()).toList(),
      'userAnswers': userAnswers,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'timeLimit': timeLimit,
      'isCompleted': isCompleted,
    };
  }

  double get scorePercentage => totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;
}