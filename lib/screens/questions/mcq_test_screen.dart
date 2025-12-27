import 'dart:async';
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
  final int? timeLimit; // in seconds

  const MCQTestScreen({
    Key? key,
    required this.mcqs,
    required this.testTitle,
    this.timeLimit,
  }) : super(key: key);

  @override
  State<MCQTestScreen> createState() => _MCQTestScreenState();
}

class _MCQTestScreenState extends State<MCQTestScreen> {
  final Map<int, String> _userAnswers = {};
  int _currentQuestionIndex = 0;
  Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    if (widget.timeLimit != null) {
      _remainingSeconds = widget.timeLimit!;
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        _autoSubmitTest();
      }
    });
  }

  void _autoSubmitTest() {
    AppSnackbar.show(
      context,
      'Time\'s up! Test submitted automatically.',
      isError: false,
    );
    _submitTest(isAutoSubmit: true);
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

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

  Future<void> _submitTest({bool isAutoSubmit = false}) async {
    // Stop timer if running
    _timer?.cancel();

    // Check if all questions are answered (only for manual submit)
    if (!isAutoSubmit && _userAnswers.length < widget.mcqs.length) {
      AppSnackbar.show(
        context,
        'Please answer all questions before submitting',
        isError: true,
      );
      return;
    }

    try {
      // Calculate results locally
      int correctAnswers = 0;
      final List<bool> answerResults = [];
      
      for (int i = 0; i < widget.mcqs.length; i++) {
        final userAnswer = _userAnswers[i] ?? '';
        final correctAnswer = widget.mcqs[i].options[widget.mcqs[i].correctAnswerIndex];
        final isCorrect = userAnswer == correctAnswer;
        
        answerResults.add(isCorrect);
        if (isCorrect) correctAnswers++;
      }
      
      final percentage = widget.mcqs.length > 0 
          ? (correctAnswers / widget.mcqs.length * 100).round() 
          : 0;
      
      // Save to local database
      final testProvider = Provider.of<TestProvider>(context, listen: false);
      await testProvider.saveTestResultLocally(
        testTitle: widget.testTitle,
        score: correctAnswers,
        total: widget.mcqs.length,
        percentage: percentage.toDouble(),
      );

      if (mounted) {
        // Navigate to result screen
        Navigator.pushReplacement(
          context,
          IOSPageRoute(
            child: MCQTestResultScreen(
              testTitle: widget.testTitle,
              score: correctAnswers,
              total: widget.mcqs.length,
              percentage: percentage,
              mcqs: widget.mcqs,
              userAnswers: _userAnswers,
              answerResults: answerResults,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(context, 'Error saving test result', isError: true);
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
                content: Text('Your progress will be lost.',
                    style: GoogleFonts.lato()),
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
        middle: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.testTitle,
              style: GoogleFonts.lato(
                fontSize: context.screenWidth * 0.04,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            if (widget.timeLimit != null) ...[
              SizedBox(height: 2),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _remainingSeconds <= 60
                      ? AppColors.error.withOpacity(0.1)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _formatTime(_remainingSeconds),
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _remainingSeconds <= 60
                        ? AppColors.error
                        : AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
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
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
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
                    final optionIndex = entry.key;
                    final option = entry.value;
                    final isSelected = selectedAnswer == option;
                    final isCorrect = optionIndex == currentMCQ.correctAnswerIndex;
                    final showFeedback = isSelected && selectedAnswer != null;
                    
                    Color? backgroundColor;
                    Color? borderColor;
                    
                    if (showFeedback) {
                      if (isCorrect) {
                        backgroundColor = AppColors.success.withOpacity(0.1);
                        borderColor = AppColors.success;
                      } else {
                        backgroundColor = AppColors.error.withOpacity(0.1);
                        borderColor = AppColors.error;
                      }
                    } else if (isSelected) {
                      backgroundColor = AppColors.primary.withOpacity(0.1);
                      borderColor = AppColors.primary;
                    } else {
                      backgroundColor = AppColors.surface;
                      borderColor = AppColors.border;
                    }
                    
                    return GestureDetector(
                      onTap: () => _selectAnswer(option),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor!,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: showFeedback
                                    ? (isCorrect ? AppColors.success : AppColors.error)
                                    : (isSelected ? AppColors.primary : Colors.transparent),
                                border: Border.all(
                                  color: showFeedback
                                      ? (isCorrect ? AppColors.success : AppColors.error)
                                      : (isSelected ? AppColors.primary : AppColors.border),
                                  width: 2,
                                ),
                              ),
                              child: showFeedback
                                  ? Icon(
                                      isCorrect ? CupertinoIcons.checkmark : CupertinoIcons.xmark,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : (isSelected
                                      ? Icon(CupertinoIcons.checkmark, size: 14, color: Colors.white)
                                      : null),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                if (_currentQuestionIndex > 0) SizedBox(width: 12),
                Expanded(
                  child: CupertinoButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    onPressed: () {
                      final isLastQuestion = _currentQuestionIndex == widget.mcqs.length - 1;
                      if (isLastQuestion) {
                        _submitTest();
                      } else {
                        _nextQuestion();
                      }
                    },
                    child: Text(
                      _currentQuestionIndex == widget.mcqs.length - 1 ? 'Submit Test' : 'Next',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
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
