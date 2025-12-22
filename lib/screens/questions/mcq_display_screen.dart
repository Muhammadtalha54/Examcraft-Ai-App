import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/generate_provider.dart';
import '../../models/mcq_model.dart';
import '../../widgets/common/app_colors.dart';
import '../../widgets/common/snackbar.dart';
import '../../widgets/common/media_query_helper.dart';
import '../../widgets/common/ios_transition.dart';
import '../../utils/pdf_generator.dart';
import 'mcq_test_screen.dart';

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
        AppSnackbar.show(context, 'PDF saved to: ${pdfFile.path}');
        await PdfGenerator.sharePdf(pdfFile);
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(context, 'Error generating PDF: $e', isError: true);
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
        child: MCQTestScreen(
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
          child: Icon(CupertinoIcons.back, color: AppColors.primary),
        ),
        middle: Text(
          widget.title,
          style: GoogleFonts.lato(
            fontSize: context.screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Action buttons
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              children: [
                // Test button
                SizedBox(
                  width: double.infinity,
                  child: CupertinoButton(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    onPressed: _startTest,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.play_fill, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Start Test',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                // PDF download buttons
                Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        color: AppColors.primary.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                        onPressed: _isGeneratingPdf ? null : () => _downloadPdf(includeAnswers: true),
                        child: _isGeneratingPdf
                            ? CupertinoActivityIndicator(color: Colors.white)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.doc_text, size: 18),
                                  SizedBox(width: 6),
                                  Text('With Answers', style: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        color: AppColors.primary.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                        onPressed: _isGeneratingPdf ? null : () => _downloadPdf(includeAnswers: false),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.doc, size: 18),
                            SizedBox(width: 6),
                            Text('Questions Only', style: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // MCQs list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: widget.mcqs.length,
              itemBuilder: (context, index) {
                final mcq = widget.mcqs[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Q${index + 1}',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        mcq.question,
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Options
                      ...mcq.options.asMap().entries.map((entry) {
                        final optIndex = entry.key;
                        final option = entry.value;
                        final isCorrect = optIndex == mcq.correctAnswerIndex;
                        
                        return Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isCorrect ? AppColors.success.withOpacity(0.1) : AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isCorrect ? AppColors.success : AppColors.border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isCorrect ? AppColors.success : AppColors.border,
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + optIndex),
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  option,
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                    fontWeight: isCorrect ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (isCorrect)
                                Icon(CupertinoIcons.checkmark_circle_fill, color: AppColors.success, size: 20),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
