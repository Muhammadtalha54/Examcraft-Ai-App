import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/mcq_model.dart';
import '../common/app_colors.dart';
import '../common/media_query_helper.dart';
import 'option_widget.dart';

class MCQCard extends StatelessWidget {
  final MCQ mcq;
  final int questionNumber;
  final String? selectedAnswer;
  final bool showCorrectAnswer;
  final Function(String) onAnswerSelected;

  const MCQCard({
    Key? key,
    required this.mcq,
    required this.questionNumber,
    this.selectedAnswer,
    this.showCorrectAnswer = false,
    required this.onAnswerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Q$questionNumber',
                  style: GoogleFonts.lato(
                    fontSize: context.screenWidth * 0.035,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDifficultyColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  mcq.difficulty.toUpperCase(),
                  style: GoogleFonts.lato(
                    fontSize: context.screenWidth * 0.03,
                    fontWeight: FontWeight.w500,
                    color: _getDifficultyColor(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            mcq.question,
            style: GoogleFonts.lato(
              fontSize: context.screenWidth * 0.04,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          SizedBox(height: 20),
          ...mcq.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final optionLabel = String.fromCharCode(65 + index); // A, B, C, D
            
            return OptionWidget(
              label: optionLabel,
              text: option,
              isSelected: selectedAnswer == option,
              isCorrect: showCorrectAnswer && index == mcq.correctAnswerIndex,
              isIncorrect: showCorrectAnswer && 
                          selectedAnswer == option && 
                          index != mcq.correctAnswerIndex,
              onTap: () => onAnswerSelected(option),
            );
          }).toList(),
          if (showCorrectAnswer && mcq.explanation != null) ...[
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.success.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explanation:',
                    style: GoogleFonts.lato(
                      fontSize: context.screenWidth * 0.035,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    mcq.explanation!,
                    style: GoogleFonts.lato(
                      fontSize: context.screenWidth * 0.035,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getDifficultyColor() {
    switch (mcq.difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.success;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }
}