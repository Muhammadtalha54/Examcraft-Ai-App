import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/generate_provider.dart';
import '../../../models/question_model.dart';
import '../../../widgets/common/app_colors.dart';
import '../../../widgets/common/snackbar.dart';
import '../../../widgets/common/media_query_helper.dart';
import '../../../utils/pdf_generator.dart';

/// Screen that displays generated long/short answer questions
/// Shows questions with answers and allows PDF download
class LongQuestionsDisplayScreen extends StatefulWidget {
  final List<Question> questions;
  final String title;

  const LongQuestionsDisplayScreen({
    Key? key,
    required this.questions,
    this.title = 'Long Answer Questions',
  }) : super(key: key);

  @override
  State<LongQuestionsDisplayScreen> createState() =>
      _LongQuestionsDisplayScreenState();
}

class _LongQuestionsDisplayScreenState
    extends State<LongQuestionsDisplayScreen> {
  bool _isGeneratingPdf = false;

  /// Creates PDF file from questions and saves it to device
  /// User can choose to include answers or just questions
  Future<void> _downloadPdf({required bool includeAnswers}) async {
    setState(() => _isGeneratingPdf = true);

    try {
      final pdfFile = await PdfGenerator.generateQuestionsPdf(
        questions: widget.questions,
        title: widget.title,
        includeAnswers: includeAnswers,
      );

      if (mounted) {
        AppSnackbar.show(
          context,
          'PDF saved to: ${pdfFile.path}',
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(
          context,
          'Error generating PDF: $e',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPdf = false);
      }
    }
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
          // Download buttons
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    onPressed: _isGeneratingPdf
                        ? null
                        : () => _downloadPdf(includeAnswers: true),
                    child: _isGeneratingPdf
                        ? CupertinoActivityIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.doc_text, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'With Answers',
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: CupertinoButton(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    color: AppColors.primary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    onPressed: _isGeneratingPdf
                        ? null
                        : () => _downloadPdf(includeAnswers: false),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.doc, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Questions Only',
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Questions list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: widget.questions.length,
              itemBuilder: (context, index) {
                final question = widget.questions[index];
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
                      // Question number and text
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
                        question.question,
                        style: GoogleFonts.lato(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Answer
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Answer:',
                              style: GoogleFonts.lato(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              question.answer,
                              style: GoogleFonts.lato(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
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
