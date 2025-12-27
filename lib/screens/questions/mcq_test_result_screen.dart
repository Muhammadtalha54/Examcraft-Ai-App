import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/mcq_model.dart';
import '../../widgets/common/app_colors.dart';
import '../../widgets/common/media_query_helper.dart';

class MCQTestResultScreen extends StatelessWidget {
  final String testTitle;
  final int score;
  final int total;
  final int percentage;
  final List<MCQ> mcqs;
  final Map<int, String> userAnswers;
  final List<bool> answerResults;

  const MCQTestResultScreen({
    Key? key,
    required this.testTitle,
    required this.score,
    required this.total,
    required this.percentage,
    required this.mcqs,
    required this.userAnswers,
    required this.answerResults,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.glowBorder.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              CupertinoIcons.home,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
        middle: Text(
          'Test Result',
          style: GoogleFonts.raleway(
            fontSize: context.screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Result card
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: passed
                      ? [AppColors.success, AppColors.success.withOpacity(0.8)]
                      : [AppColors.error, AppColors.error.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: (passed ? AppColors.success : AppColors.error).withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                    spreadRadius: -4,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      passed ? CupertinoIcons.checkmark_alt : CupertinoIcons.xmark,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    passed ? 'Congratulations!' : 'Keep Practicing!',
                    style: GoogleFonts.raleway(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    testTitle,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Score', '$score/$total'),
                      _buildStatItem('Percentage', '$percentage%'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            // Review section header
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Review Answers',
                style: GoogleFonts.raleway(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            SizedBox(height: 16),

            ...mcqs.asMap().entries.map((entry) {
              final index = entry.key;
              final mcq = entry.value;
              final userAnswer = userAnswers[index] ?? '';
              final correctAnswer = mcq.options[mcq.correctAnswerIndex];
              final isCorrect = answerResults[index];

              return Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isCorrect 
                        ? AppColors.success.withOpacity(0.3) 
                        : AppColors.error.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                      spreadRadius: -4,
                    ),
                    BoxShadow(
                      color: (isCorrect ? AppColors.success : AppColors.error).withOpacity(0.1),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isCorrect 
                                  ? [AppColors.success, AppColors.success.withOpacity(0.8)]
                                  : [AppColors.error, AppColors.error.withOpacity(0.8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Q${index + 1}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (isCorrect ? AppColors.success : AppColors.error).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isCorrect ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.xmark_circle_fill,
                            color: isCorrect ? AppColors.success : AppColors.error,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      mcq.question,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Show user's answer if wrong
                    if (!isCorrect && userAnswer.isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.error.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(CupertinoIcons.xmark, color: AppColors.error, size: 18),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Your answer: $userAnswer',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                    ],

                    // Show correct answer
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.success.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.checkmark, color: AppColors.success, size: 18),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Correct answer: $correctAnswer',
                              style: GoogleFonts.inter(
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
