import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/test_provider.dart';
import '../../models/mcq_model.dart';
import '../../widgets/common/app_colors.dart';
import '../../widgets/common/snackbar.dart';
import '../../widgets/common/media_query_helper.dart';
import '../../widgets/common/ios_transition.dart';
import 'mcq_test_result_screen.dart';

class MCQTestScreen extends StatefulWidget {
  final List<MCQ> mcqs;
  final String testTitle;

  const MCQTestScreen({
    Key? key,
    required this.mcqs,
    required this.testTitle,
  }) : super(key: key);

  @override
  State<MCQTestScreen> createState() => _MCQTestScreenState();
}

class _MCQTestScreenState extends State<MCQTestScreen> {
  final Map<int, String> _userAnswers = {};
  int _currentQuestionIndex = 0;

  void _selectAnswer(String answer) {
    setState(() {
      _userAnswers[_currentQuestionIndex] = answer;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.mcqs.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  Future<void> _submitTest() async {
    // Check if all questions are answered
    if (_userAnswers.length < widget.mcqs.length) {
      AppSnackbar.show(
        context,
        'Please answer all questions before submitting',
        isError: true,
      );
      return;
    }

    // Prepare answers list in order
    final answers = List.generate(
      widget.mcqs.length,
      (index) => _userAnswers[index] ?? '',
    );

    try {
      final testProvider = Provider.of<TestProvider>(context, listen: false);
      final message = await testProvider.evaluateTest(
        questions: widget.mcqs,
        answers: answers,
      );

      if (mounted) {
        final success = testProvider.testResult != null;
        
        if (success) {
          // Navigate to result screen
          Navigator.pushReplacement(
            context,
            IOSPageRoute(
              child: MCQTestResultScreen(
                testTitle: widget.testTitle,
                testResult: testProvider.testResult!,
                mcqs: widget.mcqs,
                userAnswers: _userAnswers,
              ),
            ),
          );
        } else {
          AppSnackbar.show(context, message, isError: true);
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(context, e.toString(), isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentMCQ = widget.mcqs[_currentQuestionIndex];
    final selectedAnswer = _userAnswers[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / widget.mcqs.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: Text('Exit Test?', style: GoogleFonts.lato()),
                content: Text('Your progress will be lost.', style: GoogleFonts.lato()),
                actions: [
                  CupertinoDialogAction(
                    child: Text('Cancel', style: GoogleFonts.lato()),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: Text('Exit', style: GoogleFonts.lato()),
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Exit test
                    },
                  ),
                ],
              ),
            );
          },
          child: Icon(CupertinoIcons.xmark, color: AppColors.error),
        ),
        middle: Text(
          widget.testTitle,
          style: GoogleFonts.lato(
            fontSize: context.screenWidth * 0.04,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Progress bar
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${_currentQuestionIndex + 1}/${widget.mcqs.length}',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${_userAnswers.length}/${widget.mcqs.length} Answered',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),

          // Question
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      currentMCQ.question,
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Options
                  ...currentMCQ.options.asMap().entries.map((entry) {
                    final option = entry.value;
                    final isSelected = selectedAnswer == option;
                    
                    return GestureDetector(
                      onTap: () => _selectAnswer(option),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? AppColors.primary : Colors.transparent,
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Icon(CupertinoIcons.checkmark, size: 14, color: Colors.white)
                                  : null,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option,
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // Navigation buttons
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                if (_currentQuestionIndex > 0)
                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(12),
                      onPressed: _previousQuestion,
                      child: Text(
                        'Previous',
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                if (_currentQuestionIndex > 0) SizedBox(width: 12),
                Expanded(
                  child: Consumer<TestProvider>(
                    builder: (context, testProvider, _) {
                      final isLastQuestion = _currentQuestionIndex == widget.mcqs.length - 1;
                      
                      return CupertinoButton(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                        onPressed: testProvider.isLoading
                            ? null
                            : (isLastQuestion ? _submitTest : _nextQuestion),
                        child: testProvider.isLoading
                            ? CupertinoActivityIndicator(color: Colors.white)
                            : Text(
                                isLastQuestion ? 'Submit Test' : 'Next',
                                style: GoogleFonts.lato(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
