import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/mcq_model.dart';
import '../../widgets/common/app_colors.dart';
import '../../widgets/common/media_query_helper.dart';

class MCQTestResultScreen extends StatelessWidget {
  final String testTitle;
  final Map<String, dynamic> testResult;
  final List<MCQ> mcqs;
  final Map<int, String> userAnswers;

  const MCQTestResultScreen({
    Key? key,
    required this.testTitle,
    required this.testResult,
    required this.mcqs,
    required this.userAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final score = testResult['score'] as int;
    final total = testResult['total'] as int;
    final percentage = (testResult['percentage'] as num).toDouble();
    final passed = percentage >= 50;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: Icon(CupertinoIcons.home, color: AppColors.primary),
        ),
        middle: Text(
          'Test Result',
          style: GoogleFonts.lato(
            fontSize: context.screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Result card
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: passed
                      ? [AppColors.success, AppColors.success.withOpacity(0.7)]
                      : [AppColors.error, AppColors.error.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (passed ? AppColors.success : AppColors.error).withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    passed ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.xmark_circle_fill,
                    size: 64,
                    color: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    passed ? 'Congratulations!' : 'Keep Practicing!',
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    testTitle,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Score', '$score/$total'),
                      _buildStatItem('Percentage', '${percentage.toStringAsFixed(1)}%'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Review answers
            Text(
              'Review Answers',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16),

            ...mcqs.asMap().entries.map((entry) {
              final index = entry.key;
              final mcq = entry.value;
              final userAnswer = userAnswers[index] ?? '';
              final isCorrect = userAnswer == mcq.correctAnswer;

              return Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCorrect ? AppColors.success : AppColors.error,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isCorrect ? AppColors.success : AppColors.error,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Q${index + 1}',
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(
                          isCorrect ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.xmark_circle_fill,
                          color: isCorrect ? AppColors.success : AppColors.error,
                          size: 24,
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      mcq.question,
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12),

                    // Show user's answer
                    if (!isCorrect) ...[
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.xmark, color: AppColors.error, size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Your answer: $userAnswer',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                    ],

                    // Show correct answer
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.checkmark, color: AppColors.success, size: 16),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Correct answer: ${mcq.correctAnswer}',
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: AppColors.success,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 14,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
