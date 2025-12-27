import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_colors.dart';

class TestResultScreen extends StatelessWidget {
  final String testTitle;
  final int totalQuestions;
  final int correctAnswers;
  final String difficulty;
  final int? timeTaken;
  final List<dynamic>? testResults;

  const TestResultScreen({
    Key? key,
    required this.testTitle,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.difficulty,
    this.timeTaken,
    this.testResults,
  }) : super(key: key);

  double get percentage => (correctAnswers / totalQuestions) * 100;
  int get wrongAnswers => totalQuestions - correctAnswers;

  Color get scoreColor {
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 60) return Colors.orange;
    return AppColors.error;
  }

  String get performanceText {
    if (percentage >= 90) return 'Excellent!';
    if (percentage >= 80) return 'Great Job!';
    if (percentage >= 70) return 'Good Work!';
    if (percentage >= 60) return 'Not Bad!';
    return 'Keep Practicing!';
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        middle: Text(
          'Test Results',
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Score Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Score Circle
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: scoreColor.withOpacity(0.1),
                        border: Border.all(color: scoreColor, width: 4),
                      ),
                      child: Center(
                        child: Text(
                          '${percentage.toInt()}%',
                          style: GoogleFonts.raleway(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: scoreColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      performanceText,
                      style: GoogleFonts.raleway(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      testTitle,
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem('Total', totalQuestions.toString(),
                            AppColors.primary),
                        _buildStatItem('Correct', correctAnswers.toString(),
                            AppColors.success),
                        _buildStatItem(
                            'Wrong', wrongAnswers.toString(), AppColors.error),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                        'Difficulty', difficulty, CupertinoIcons.gauge),
                    if (timeTaken != null) ...[
                      const SizedBox(height: 16),
                      _buildDetailRow('Time Taken', _formatTime(timeTaken!),
                          CupertinoIcons.timer),
                    ],
                    const SizedBox(height: 16),
                    _buildDetailRow('Date', _formatDate(DateTime.now()),
                        CupertinoIcons.calendar),
                  ],
                ),
              ),

              // Test Results Details (if available)
              if (testResults != null) ...[
                const SizedBox(height: 24),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question Details',
                          style: GoogleFonts.raleway(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: testResults!.length,
                            itemBuilder: (context, index) {
                              final result = testResults![index];
                              final isCorrect = result['isCorrect'] ?? false;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isCorrect
                                      ? AppColors.success.withOpacity(0.1)
                                      : AppColors.error.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isCorrect
                                        ? AppColors.success.withOpacity(0.3)
                                        : AppColors.error.withOpacity(0.3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          isCorrect
                                              ? CupertinoIcons
                                                  .checkmark_circle_fill
                                              : CupertinoIcons
                                                  .xmark_circle_fill,
                                          color: isCorrect
                                              ? AppColors.success
                                              : AppColors.error,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Q${index + 1}: ${result['question'] ?? ''}',
                                            style: GoogleFonts.manrope(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Your Answer: ${result['userAnswer'] ?? 'No answer'}',
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    if (!isCorrect) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Correct Answer: ${result['correctAnswer'] ?? ''}',
                                        style: GoogleFonts.manrope(
                                          fontSize: 12,
                                          color: AppColors.success,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else
                const Spacer(),

              // Action Buttons
              Column(
                children: [
                  AppButton(
                    text: 'Save Test',
                    onPressed: () => _saveTest(context),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 56,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () =>
                          Navigator.popUntil(context, (route) => route.isFirst),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Back to Home',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.raleway(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _saveTest(BuildContext context) {
    // TODO: Implement save to local database
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Test Saved!',
            style: GoogleFonts.raleway(fontWeight: FontWeight.w600)),
        content: Text('Your test results have been saved to history.',
            style: GoogleFonts.manrope()),
        actions: [
          CupertinoDialogAction(
            child: Text('OK', style: GoogleFonts.manrope()),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
