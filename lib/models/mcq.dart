class Mcq {
  final String question;
  final List<String> options;
  final String answer;

  Mcq({
    required this.question,
    required this.options,
    required this.answer,
  });

  factory Mcq.fromJson(Map<String, dynamic> json) {
    return Mcq(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'answer': answer,
    };
  }
}