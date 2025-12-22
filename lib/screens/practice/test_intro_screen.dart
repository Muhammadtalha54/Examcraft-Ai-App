import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_colors.dart';
import '../../widgets/common/app_textfield.dart';
import 'mcq_practice_test_screen.dart';

class TestIntroScreen extends StatefulWidget {
  final File file;
  final int mcqCount;
  final String difficulty;
  final bool timerEnabled;
  final int timerMinutes;
  final Map<String, dynamic> mcqData;

  const TestIntroScreen({
    Key? key,
    required this.file,
    required this.mcqCount,
    required this.difficulty,
    required this.timerEnabled,
    required this.timerMinutes,
    required this.mcqData,
  }) : super(key: key);

  @override
  State<TestIntroScreen> createState() => _TestIntroScreenState();
}

class _TestIntroScreenState extends State<TestIntroScreen> {
  final _titleController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController.text =
        'Practice Test ${DateTime.now().day}/${DateTime.now().month}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _startTest() {
    setState(() => _isLoading = true);

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => MCQPracticeTestScreen(
              testTitle: _titleController.text,
              mcqCount: widget.mcqCount,
              difficulty: widget.difficulty,
              timerEnabled: widget.timerEnabled,
              timerMinutes: widget.timerMinutes,
              mcqData: widget.mcqData,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.pop(context),
          child: Icon(CupertinoIcons.back, color: AppColors.primary),
        ),
        middle: Text(
          'Test Preview',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Test Title Input
              Text(
                'Test Title',
                style: GoogleFonts.raleway(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              AppTextField(
                hintText: 'Enter test title',
                controller: _titleController,
              ),

              const SizedBox(height: 32),

              // Test Configuration Card
              Container(
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
                      'Test Configuration',
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildConfigRow('Questions', '${widget.mcqCount}',
                        CupertinoIcons.question_circle),
                    const SizedBox(height: 16),
                    _buildConfigRow(
                        'Difficulty', widget.difficulty, CupertinoIcons.gauge),
                    const SizedBox(height: 16),
                    _buildConfigRow(
                      'Timer',
                      widget.timerEnabled
                          ? '${widget.timerMinutes} minutes'
                          : 'Disabled',
                      CupertinoIcons.timer,
                    ),
                    const SizedBox(height: 16),
                    _buildConfigRow('Source', widget.file.path.split('/').last,
                        CupertinoIcons.doc_text),
                  ],
                ),
              ),

              const Spacer(),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 56,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      text: 'Start Test',
                      onPressed: _startTest,
                      isLoading: _isLoading,
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

  Widget _buildConfigRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
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
}
