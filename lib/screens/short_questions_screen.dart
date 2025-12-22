import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../providers/generate_provider.dart';
import '../widgets/common/app_button.dart';
import '../widgets/common/app_colors.dart';
import '../widgets/common/app_textfield.dart';
import '../widgets/common/media_query_helper.dart';
import '../widgets/common/snackbar.dart';
import '../widgets/common/ios_transition.dart';
import '../utils/validators.dart';
import 'questions/long_questions_display_screen.dart';

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
      AppSnackbar.show(context, 'Error picking file: ${e.toString()}', isError: true);
    }
  }

  Future<void> _generateQuestions() async {
    if (_selectedFile == null) {
      AppSnackbar.show(context, 'Please select a PDF file', isError: true);
      return;
    }

    final count = int.tryParse(_countController.text);
    if (count == null || count <= 0) {
      AppSnackbar.show(context, 'Please enter a valid number of questions', isError: true);
      return;
    }

    try {
      final generateProvider = Provider.of<GenerateProvider>(context, listen: false);
      final message = await generateProvider.generateShortQuestions(
        pdfPath: _selectedFile!.path,
        count: count,
        difficulty: _selectedDifficulty,
      );
      
      if (mounted) {
        final success = generateProvider.questions != null;
        AppSnackbar.show(context, message, isError: !success);
        
        if (success && generateProvider.questions!.isNotEmpty) {
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
          'Short Questions',
          style: GoogleFonts.lato(
            fontSize: context.screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload PDF',
                style: GoogleFonts.lato(
                  fontSize: context.screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _pickFile,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.doc, size: 30, color: AppColors.primary),
                      SizedBox(height: 8),
                      Text(
                        'Upload PDF',
                        style: GoogleFonts.lato(
                          fontSize: context.screenWidth * 0.035,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_selectedFile != null) ...[
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.success),
                  ),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.checkmark_circle_fill, color: AppColors.success),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedFile!.path.split('/').last,
                          style: GoogleFonts.lato(
                            fontSize: context.screenWidth * 0.035,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => setState(() => _selectedFile = null),
                        child: Icon(CupertinoIcons.xmark_circle, color: AppColors.error),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 32),
              Text(
                'Generation Options',
                style: GoogleFonts.lato(
                  fontSize: context.screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16),
              AppTextField(
                hintText: 'Number of Questions',
                controller: _countController,
                keyboardType: TextInputType.number,
                validator: Validators.number,
              ),
              SizedBox(height: 16),
              Text(
                'Difficulty Level',
                style: GoogleFonts.lato(
                  fontSize: context.screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 120,
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
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
                        style: GoogleFonts.lato(
                          fontSize: context.screenWidth * 0.04,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 40),
              Consumer<GenerateProvider>(
                builder: (context, generateProvider, _) {
                  return AppButton(
                    text: 'Generate Short Questions',
                    onPressed: _generateQuestions,
                    isLoading: generateProvider.isLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}