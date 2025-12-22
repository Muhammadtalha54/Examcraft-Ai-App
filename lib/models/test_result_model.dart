class TestResult {
  final int? localId;
  final int score;
  final int total;
  final double percentage;
  final DateTime createdAt;

  TestResult({
    this.localId,
    required this.score,
    required this.total,
    required this.percentage,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'total': total,
      'percentage': percentage,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TestResult.fromMap(Map<String, dynamic> map) {
    return TestResult(
      localId: map['id'],
      score: map['score'],
      total: map['total'],
      percentage: (map['percentage'] as num).toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
