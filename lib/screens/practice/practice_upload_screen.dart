import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_colors.dart';
import '../../widgets/common/media_query_helper.dart';
import '../../widgets/common/snackbar.dart';
import '../../providers/generate_provider.dart';
import '../../utils/pdf_helper.dart';
import '../../models/mcq_model.dart';
import 'test_intro_screen.dart';

class PracticeUploadScreen extends StatefulWidget {
  const PracticeUploadScreen({Key? key}) : super(key: key);

  @override
  State<PracticeUploadScreen> createState() => _PracticeUploadScreenState();
}

class _PracticeUploadScreenState extends State<PracticeUploadScreen> {
  File? _selectedFile;
  int _mcqCount = 10;
  int _selectedDifficulty = 1;
  bool _timerEnabled = false;
  int _timerMinutes = 15;
  bool _isLoading = false;

  final List<String> _difficulties = ['Easy', 'Medium', 'Hard'];

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        setState(() => _selectedFile = File(result.files.single.path!));
      }
    } catch (e) {
      AppSnackbar.show(context, 'Error picking file', isError: true);
    }
  }

  void _generateTest() async {
    if (_selectedFile == null) {
      AppSnackbar.show(context, 'Please select a file', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final generateProvider =
          Provider.of<GenerateProvider>(context, listen: false);

      final message = await generateProvider.generateMCQs(
        pdfPath: _selectedFile!.path,
        count: _mcqCount,
        difficulty: _difficulties[_selectedDifficulty].toLowerCase(),
      );

      if (generateProvider.mcqs != null && generateProvider.mcqs!.isNotEmpty) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => TestIntroScreen(
              file: _selectedFile!,
              mcqCount: _mcqCount,
              difficulty: _difficulties[_selectedDifficulty],
              timerEnabled: _timerEnabled,
              timerMinutes: _timerMinutes,
              mcqs: generateProvider.mcqs!,
            ),
          ),
        );
      } else {
        AppSnackbar.show(context, message, isError: true);
      }
    } catch (e) {
      AppSnackbar.show(context, e.toString(), isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _exportToPDF(List<MCQ> mcqs) async {
    try {
      final mcqMaps = mcqs.map((mcq) => mcq.toJson()).toList();
      final filePath = await PDFHelper.generateAndSavePDF(
        title: 'Practice Test - ${_difficulties[_selectedDifficulty]} Level',
        questions: mcqMaps,
        type: 'mcq',
      );
      AppSnackbar.show(context, 'PDF saved successfully to Downloads');
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
          'Practice Test',
          style: GoogleFonts.raleway(
            fontSize: 18,
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
                      'Choose content to create your personalized practice test',
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
                        color: Color(0xFFEF4444).withOpacity(0.1),
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
                              Color(0xFFEF4444),
                              Color(0xFFEF4444).withOpacity(0.7)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFEF4444).withOpacity(0.3),
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
                        'Upload PDF',
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
                _buildSelectedFile(),
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
                      'Test Configuration',
                      style: GoogleFonts.raleway(
                        fontSize: context.screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 24),
                    _buildMCQCounter(),
                    SizedBox(height: 24),
                    _buildDifficultySelector(),
                    SizedBox(height: 24),
                    _buildTimerSection(),
                  ],
                ),
              ),

              SizedBox(height: 32),
              AppButton(
                text: 'Generate Test',
                onPressed: _generateTest,
                isLoading: _isLoading,
              ),
              SizedBox(height: 16),
              Consumer<GenerateProvider>(
                builder: (context, generateProvider, _) {
                  if (generateProvider.mcqs != null &&
                      generateProvider.mcqs!.isNotEmpty) {
                    return AppButton(
                      text: 'Export to PDF',
                      onPressed: () => _exportToPDF(generateProvider.mcqs!),
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

  Widget _buildSelectedFile() {
    return Container(
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
                    fontSize: 12,
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _selectedFile!.path.split('/').last,
                  style: GoogleFonts.inter(
                    fontSize: 14,
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
    );
  }

  Widget _buildMCQCounter() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withOpacity(0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Number of Questions',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed:
                    _mcqCount > 5 ? () => setState(() => _mcqCount--) : null,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Icon(
                    CupertinoIcons.minus,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Container(
                width: 60,
                alignment: Alignment.center,
                child: Text(
                  '$_mcqCount',
                  style: GoogleFonts.raleway(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed:
                    _mcqCount < 50 ? () => setState(() => _mcqCount++) : null,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Icon(
                    CupertinoIcons.plus,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Difficulty Level',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          CupertinoSegmentedControl<int>(
            children: {
              0: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Easy',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              1: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Medium',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              2: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Hard',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            },
            onValueChanged: (value) =>
                setState(() => _selectedDifficulty = value),
            groupValue: _selectedDifficulty,
          ),
        ],
      ),
    );
  }

  Widget _buildTimerSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border.withOpacity(0.5),
        ),
      ),
      child: Column(
        children: [
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
                value: _timerEnabled,
                onChanged: (value) => setState(() => _timerEnabled = value),
              ),
            ],
          ),
          if (_timerEnabled) ...[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Duration (minutes)',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: _timerMinutes > 5
                          ? () => setState(() => _timerMinutes -= 5)
                          : null,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Icon(
                          CupertinoIcons.minus,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: Text(
                        '$_timerMinutes',
                        style: GoogleFonts.raleway(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: _timerMinutes < 120
                          ? () => setState(() => _timerMinutes += 5)
                          : null,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                        ),
                        child: Icon(
                          CupertinoIcons.plus,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
