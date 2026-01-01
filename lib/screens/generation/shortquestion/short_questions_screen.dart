import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../../providers/generate_provider.dart';
import '../../../widgets/common/app_button.dart';
import '../../../widgets/common/app_colors.dart';
import '../../../widgets/common/app_textfield.dart';
import '../../../widgets/common/media_query_helper.dart';
import '../../../widgets/common/snackbar.dart';
import '../../../widgets/common/ios_transition.dart';
import '../../../utils/validators.dart';
import '../../../utils/pdf_helper.dart';
import '../../../models/question_model.dart';
import '../long_question/long_questions_display_screen.dart';

/// Screen where users upload PDF files and generate short answer questions
/// Lets users pick PDF, set question count and difficulty level
class ShortQuestionsScreen extends StatefulWidget {
  const ShortQuestionsScreen({Key? key}) : super(key: key);

  @override
  State<ShortQuestionsScreen> createState() => _ShortQuestionsScreenState();
}

class _ShortQuestionsScreenState extends State<ShortQuestionsScreen> {
  final _countController = TextEditingController(text: '5');
  File? _selectedFile;
  String _selectedDifficulty = 'medium';

  final List<String> _difficulties = ['easy', 'medium', 'hard'];

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  /// Opens file picker to let user select a PDF file
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      AppSnackbar.show(context, 'Error picking file: ${e.toString()}',
          isError: true);
    }
  }

  /// Sends PDF file to AI to generate short answer questions
  /// Checks if file is selected and question count is valid
  /// Shows generated questions on next screen if successful
  Future<void> _generateQuestions() async {
    if (_selectedFile == null) {
      AppSnackbar.show(context, 'Please select a PDF file', isError: true);
      return;
    }

    final count = int.tryParse(_countController.text);
    if (count == null || count <= 0) {
      AppSnackbar.show(context, 'Please enter a valid number of questions',
          isError: true);
      return;
    }

    try {
      final generateProvider =
          Provider.of<GenerateProvider>(context, listen: false);
      final message = await generateProvider.generateShortQuestions(
        pdfPath: _selectedFile!.path,
        count: count,
        difficulty: _selectedDifficulty,
      );

      if (mounted) {
        final success = generateProvider.questions != null;
        AppSnackbar.show(context, message, isError: !success);

        if (success && generateProvider.questions!.isNotEmpty) {
          // navigate to question display screen
          Navigator.push(
            context,
            IOSPageRoute(
              child: LongQuestionsDisplayScreen(
                questions: generateProvider.questions!,
                title: 'Short Answer Questions',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(context, e.toString(), isError: true);
      }
    }
  }

  /// Saves generated questions as PDF file to device storage
  Future<void> _exportToPDF(List<Question> questions) async {
    try {
      final questionMaps =
          questions.map((question) => question.toJson()).toList();
      final filePath = await PDFHelper.generateAndSavePDF(
        title:
            'Short Answer Questions - ${_selectedDifficulty.toUpperCase()} Level',
        questions: questionMaps,
        type: 'short',
      );
      AppSnackbar.show(context, 'PDF saved to: $filePath');
    } catch (e) {
      AppSnackbar.show(context, 'Error exporting PDF: ${e.toString()}',
          isError: true);
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
          'Short Questions',
          style: GoogleFonts.raleway(
            fontSize: context.screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload Content',
                      style: GoogleFonts.raleway(
                        fontSize: context.screenWidth * 0.055,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Upload a PDF file to generate concise short answer questions',
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

              // Upload Section
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _pickFile,
                child: Container(
                  height: 120,
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
                      BoxShadow(
                        color: AppColors.secondary.withOpacity(0.1),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.secondary,
                              AppColors.secondary.withOpacity(0.7)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.secondary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          CupertinoIcons.doc_text_fill,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        ' Upload PDF ',
                        style: GoogleFonts.inter(
                          fontSize: context.screenWidth * 0.035,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_selectedFile != null) ...[
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
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
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          CupertinoIcons.checkmark_circle_fill,
                          color: AppColors.success,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'File Selected',
                              style: GoogleFonts.inter(
                                fontSize: context.screenWidth * 0.032,
                                color: AppColors.success,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _selectedFile!.path.split('/').last,
                              style: GoogleFonts.inter(
                                fontSize: context.screenWidth * 0.035,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => setState(() => _selectedFile = null),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            CupertinoIcons.xmark,
                            color: AppColors.error,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 40),

              // Configuration Section
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
                      'Generation Options',
                      style: GoogleFonts.raleway(
                        fontSize: context.screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 20),
                    AppTextField(
                      hintText: 'Number of Questions',
                      controller: _countController,
                      keyboardType: TextInputType.number,
                      validator: Validators.number,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Difficulty Level',
                      style: GoogleFonts.inter(
                        fontSize: context.screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      height: 120,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.border.withOpacity(0.5),
                        ),
                      ),
                      child: CupertinoPicker(
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            _selectedDifficulty = _difficulties[index];
                          });
                        },
                        children: _difficulties.map((difficulty) {
                          return Center(
                            child: Text(
                              difficulty.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: context.screenWidth * 0.04,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),
              Consumer<GenerateProvider>(
                builder: (context, generateProvider, _) {
                  return AppButton(
                    text: 'Generate Short Questions',
                    onPressed: _generateQuestions,
                    isLoading: generateProvider.isLoading,
                  );
                },
              ),
              SizedBox(height: 16),
              Consumer<GenerateProvider>(
                builder: (context, generateProvider, _) {
                  if (generateProvider.questions != null &&
                      generateProvider.questions!.isNotEmpty) {
                    return AppButton(
                      text: 'Export to PDF',
                      onPressed: () =>
                          _exportToPDF(generateProvider.questions!),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
