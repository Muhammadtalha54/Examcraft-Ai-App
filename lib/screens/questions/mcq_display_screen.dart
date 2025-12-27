import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/mcq_model.dart';
import '../../widgets/common/app_colors.dart';
import '../../widgets/common/media_query_helper.dart';
import '../../widgets/common/ios_transition.dart';
import '../../utils/pdf_generator.dart';
import '../../widgets/common/snackbar.dart';
import 'mcq_test_setup_screen.dart';

class MCQDisplayScreen extends StatefulWidget {
  final List<MCQ> mcqs;
  final String title;

  const MCQDisplayScreen({
    Key? key,
    required this.mcqs,
    this.title = 'MCQ Questions',
  }) : super(key: key);

  @override
  State<MCQDisplayScreen> createState() => _MCQDisplayScreenState();
}

class _MCQDisplayScreenState extends State<MCQDisplayScreen> {
  bool _isGeneratingPdf = false;

  Future<void> _downloadPdf({required bool includeAnswers}) async {
    setState(() => _isGeneratingPdf = true);

    try {
      final pdfFile = await PdfGenerator.generateMCQsPdf(
        mcqs: widget.mcqs,
        title: widget.title,
        includeAnswers: includeAnswers,
      );

      if (mounted) {
        AppSnackbar.show(context, 'PDF saved successfully!');
        await PdfGenerator.sharePdf(pdfFile);
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(context, 'Error generating PDF', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPdf = false);
      }
    }
  }

  void _startTest() {
    Navigator.push(
      context,
      IOSPageRoute(
        child: MCQTestSetupScreen(
          mcqs: widget.mcqs,
          testTitle: widget.title,
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
          'MCQs Generated',
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
            children: [
              // Success message
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.success.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withOpacity(0.1),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.success, AppColors.success.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        CupertinoIcons.checkmark_alt,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'MCQs Generated Successfully!',
                      style: GoogleFonts.raleway(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${widget.mcqs.length} questions ready for you',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 32),
              
              // Action buttons
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
                  children: [
                    // Start Test Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                        onPressed: _startTest,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.play_fill, size: 20, color: Colors.white),
                            SizedBox(width: 12),
                            Text(
                              'Start MCQ Test',
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
                    
                    SizedBox(height: 16),
                    
                    // Download buttons
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(12),
                              onPressed: _isGeneratingPdf ? null : () => _downloadPdf(includeAnswers: true),
                              child: _isGeneratingPdf
                                  ? CupertinoActivityIndicator(color: Colors.white)
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(CupertinoIcons.doc_text_fill, size: 16, color: Colors.white),
                                        SizedBox(width: 8),
                                        Text(
                                          'With Answers',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 48,
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              color: AppColors.border,
                              borderRadius: BorderRadius.circular(12),
                              onPressed: _isGeneratingPdf ? null : () => _downloadPdf(includeAnswers: false),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.doc_fill, size: 16, color: AppColors.textPrimary),
                                  SizedBox(width: 8),
                                  Text(
                                    'Questions Only',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}