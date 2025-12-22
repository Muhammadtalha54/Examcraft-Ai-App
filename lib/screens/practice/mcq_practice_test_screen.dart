import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/common/app_colors.dart';
import '../../models/mcq.dart';
import 'test_result_screen.dart';

class MCQPracticeTestScreen extends StatefulWidget {
  final String testTitle;
  final int mcqCount;
  final String difficulty;
  final bool timerEnabled;
  final int timerMinutes;
  final Map<String, dynamic> mcqData;

  const MCQPracticeTestScreen({
    Key? key,
    required this.testTitle,
    required this.mcqCount,
    required this.difficulty,
    required this.timerEnabled,
    required this.timerMinutes,
    required this.mcqData,
  }) : super(key: key);

  @override
  State<MCQPracticeTestScreen> createState() => _MCQPracticeTestScreenState();
}

class _MCQPracticeTestScreenState extends State<MCQPracticeTestScreen>
    with TickerProviderStateMixin {
  List<Mcq> _mcqs = [];
  int _currentIndex = 0;
  int _score = 0;
  List<int?> _selectedAnswers = [];
  bool _isAnswered = false;
  Timer? _countdownTimer;
  int _remainingSeconds = 0;
  late AnimationController _optionAnimationController;
  late Animation<double> _optionAnimation;

  @override
  void initState() {
    super.initState();
    _generateSampleMCQs();
    _selectedAnswers = List.filled(widget.mcqCount, null);

    if (widget.timerEnabled) {
      _remainingSeconds = widget.timerMinutes * 60;
      _startTimer();
    }

    _optionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _optionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _optionAnimationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _optionAnimationController.dispose();
    super.dispose();
  }

  void _generateSampleMCQs() {
    // Sample MCQs - replace with API call
    _mcqs = [
      Mcq(
          question: "What is the capital of France?",
          options: ["London", "Paris", "Berlin", "Madrid"],
          answer: "B"),
      Mcq(
          question: "Which planet is known as the Red Planet?",
          options: ["Venus", "Mars", "Jupiter", "Saturn"],
          answer: "B"),
      Mcq(
          question: "What is 2 + 2?",
          options: ["3", "4", "5", "6"],
          answer: "B"),
      Mcq(
          question: "Who painted the Mona Lisa?",
          options: ["Van Gogh", "Picasso", "Da Vinci", "Monet"],
          answer: "C"),
      Mcq(
          question: "What is the largest ocean?",
          options: ["Atlantic", "Indian", "Arctic", "Pacific"],
          answer: "D"),
    ];
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) {
          _endTest();
        }
      });
    });
  }

  void _selectOption(int index) {
    if (_isAnswered) return;

    HapticFeedback.lightImpact();

    setState(() {
      _selectedAnswers[_currentIndex] = index;
      _isAnswered = true;

      String selectedLetter = String.fromCharCode(65 + index);
      if (selectedLetter == _mcqs[_currentIndex].answer) {
        _score++;
      }
    });

    _optionAnimationController.forward();

    // Auto advance after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _mcqs.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
      });
      _optionAnimationController.reset();
    } else {
      _endTest();
    }
  }

  void _endTest() {
    _countdownTimer?.cancel();
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => TestResultScreen(
          testTitle: widget.testTitle,
          totalQuestions: _mcqs.length,
          correctAnswers: _score,
          difficulty: widget.difficulty,
          timeTaken: widget.timerEnabled
              ? (widget.timerMinutes * 60 - _remainingSeconds)
              : null,
        ),
      ),
    );
  }

  Color _getOptionColor(int optionIndex) {
    if (!_isAnswered) return AppColors.surface;

    String correctLetter = _mcqs[_currentIndex].answer;
    int correctIndex = correctLetter.codeUnitAt(0) - 65;

    if (optionIndex == correctIndex) {
      return AppColors.success;
    }

    if (optionIndex == _selectedAnswers[_currentIndex]) {
      return AppColors.error;
    }

    return AppColors.surface.withOpacity(0.5);
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_mcqs.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CupertinoActivityIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _showExitDialog(),
          child: Icon(CupertinoIcons.xmark, color: AppColors.error),
        ),
        middle: Text(
          'Question ${_currentIndex + 1} / ${_mcqs.length}',
          style: GoogleFonts.raleway(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: widget.timerEnabled
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _remainingSeconds < 60
                      ? AppColors.error
                      : AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _formatTime(_remainingSeconds),
                  style: GoogleFonts.raleway(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Progress Bar
              Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (_currentIndex + 1) / _mcqs.length,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Question Card
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _mcqs[_currentIndex].question,
                        style: GoogleFonts.raleway(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Options
                      Expanded(
                        child: ListView.builder(
                          itemCount: _mcqs[_currentIndex].options.length,
                          itemBuilder: (context, index) {
                            String optionLetter =
                                String.fromCharCode(65 + index);
                            String option = _mcqs[_currentIndex].options[index];

                            return AnimatedBuilder(
                              animation: _optionAnimation,
                              builder: (context, child) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: _isAnswered
                                        ? null
                                        : () => _selectOption(index),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: _getOptionColor(index),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: _isAnswered &&
                                                  _selectedAnswers[
                                                          _currentIndex] ==
                                                      index
                                              ? (_getOptionColor(index) ==
                                                      AppColors.success
                                                  ? AppColors.success
                                                  : AppColors.error)
                                              : AppColors.border,
                                          width: 2,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: _isAnswered &&
                                                      _selectedAnswers[
                                                              _currentIndex] ==
                                                          index
                                                  ? Colors.white
                                                  : AppColors.primary
                                                      .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Center(
                                              child: Text(
                                                optionLetter,
                                                style: GoogleFonts.raleway(
                                                  fontWeight: FontWeight.w600,
                                                  color: _isAnswered &&
                                                          _selectedAnswers[
                                                                  _currentIndex] ==
                                                              index
                                                      ? (_getOptionColor(
                                                                  index) ==
                                                              AppColors.success
                                                          ? AppColors.success
                                                          : AppColors.error)
                                                      : AppColors.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              option,
                                              style: GoogleFonts.manrope(
                                                fontSize: 16,
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          if (_isAnswered &&
                                              _selectedAnswers[_currentIndex] ==
                                                  index) ...[
                                            Icon(
                                              _getOptionColor(index) ==
                                                      AppColors.success
                                                  ? CupertinoIcons
                                                      .checkmark_circle_fill
                                                  : CupertinoIcons
                                                      .xmark_circle_fill,
                                              color: _getOptionColor(index) ==
                                                      AppColors.success
                                                  ? AppColors.success
                                                  : AppColors.error,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Exit Test?',
            style: GoogleFonts.raleway(fontWeight: FontWeight.w600)),
        content:
            Text('Your progress will be lost.', style: GoogleFonts.manrope()),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel', style: GoogleFonts.manrope()),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text('Exit', style: GoogleFonts.manrope()),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
