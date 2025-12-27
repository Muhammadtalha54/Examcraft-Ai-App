import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/mcq_model.dart';
import '../../widgets/common/app_colors.dart';
import '../../widgets/common/app_textfield.dart';
import '../../widgets/common/media_query_helper.dart';
import '../../widgets/common/ios_transition.dart';
import 'mcq_test_screen.dart';

class MCQTestSetupScreen extends StatefulWidget {
  final List<MCQ> mcqs;
  final String testTitle;

  const MCQTestSetupScreen({
    Key? key,
    required this.mcqs,
    required this.testTitle,
  }) : super(key: key);

  @override
  State<MCQTestSetupScreen> createState() => _MCQTestSetupScreenState();
}

class _MCQTestSetupScreenState extends State<MCQTestSetupScreen> {
  final _titleController = TextEditingController();
  bool _enableTimer = false;
  int _minutes = 15;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.testTitle;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _startTest() {
    final testTitle = _titleController.text.trim().isEmpty 
        ? widget.testTitle 
        : _titleController.text.trim();
    
    final timeLimit = _enableTimer ? (_minutes * 60) + _seconds : null;
    
    Navigator.push(
      context,
      IOSPageRoute(
        child: MCQTestScreen(
          mcqs: widget.mcqs,
          testTitle: testTitle,
          timeLimit: timeLimit,
        ),
      ),
    );
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
              CupertinoIcons.back,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ),
        middle: Text(
          'Test Setup',
          style: GoogleFonts.raleway(
            fontSize: context.screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configure Your Test',
                      style: GoogleFonts.raleway(
                        fontSize: context.screenWidth * 0.055,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Set up your test preferences before starting',
                      style: GoogleFonts.inter(
                        fontSize: context.screenWidth * 0.038,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24),
              
              // Test info
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        CupertinoIcons.question_circle_fill,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Questions',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${widget.mcqs.length} MCQs',
                            style: GoogleFonts.raleway(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24),
              
              // Configuration form
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.glowBorder.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                      spreadRadius: -4,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Title',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12),
                    AppTextField(
                      controller: _titleController,
                      hintText: 'Enter test title',
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Timer section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enable Timer',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        CupertinoSwitch(
                          value: _enableTimer,
                          onChanged: (value) => setState(() => _enableTimer = value),
                        ),
                      ],
                    ),
                    
                    if (_enableTimer) ...[
                      SizedBox(height: 20),
                      Text(
                        'Time Limit',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          // Minutes
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.border.withOpacity(0.5),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Minutes',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: _minutes > 0 ? () => setState(() => _minutes--) : null,
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(CupertinoIcons.minus, size: 16, color: AppColors.primary),
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$_minutes',
                                          style: GoogleFonts.raleway(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: _minutes < 120 ? () => setState(() => _minutes++) : null,
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(CupertinoIcons.plus, size: 16, color: AppColors.primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          // Seconds
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.border.withOpacity(0.5),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Seconds',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: _seconds > 0 ? () => setState(() => _seconds -= 5) : null,
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(CupertinoIcons.minus, size: 16, color: AppColors.primary),
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$_seconds',
                                          style: GoogleFonts.raleway(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: _seconds < 55 ? () => setState(() => _seconds += 5) : null,
                                        child: Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(CupertinoIcons.plus, size: 16, color: AppColors.primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              Spacer(),
              
              // Start button
              Container(
                width: double.infinity,
                height: 56,
                child: CupertinoButton(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  onPressed: _startTest,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.play_fill, size: 20, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        'Start Test',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
}