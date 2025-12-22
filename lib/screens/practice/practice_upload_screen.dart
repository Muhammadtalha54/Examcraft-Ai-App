import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_colors.dart';
import '../../widgets/common/media_query_helper.dart';
import '../../widgets/common/snackbar.dart';
import '../../services/api_service.dart';
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

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _selectedFile = File(image.path));
      }
    } catch (e) {
      AppSnackbar.show(context, 'Error picking image', isError: true);
    }
  }

  void _generateTest() async {
    if (_selectedFile == null) {
      AppSnackbar.show(context, 'Please select a file', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await ApiService.generateMCQTest(
        file: _selectedFile!,
        totalQuestions: _mcqCount,
        difficulty: _difficulties[_selectedDifficulty].toLowerCase(),
      );

      if (result['success'] == true && result['data'] != null) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => TestIntroScreen(
              file: _selectedFile!,
              mcqCount: _mcqCount,
              difficulty: _difficulties[_selectedDifficulty],
              timerEnabled: _timerEnabled,
              timerMinutes: _timerMinutes,
              mcqData: result['data'],
            ),
          ),
        );
      } else {
        AppSnackbar.show(
            context, result['message'] ?? 'Failed to generate test',
            isError: true);
      }
    } catch (e) {
      AppSnackbar.show(context, e.toString(), isError: true);
    } finally {
      setState(() => _isLoading = false);
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
          'Practice Test',
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Upload Content'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                      child: _buildUploadCard(
                          'PDF File', CupertinoIcons.doc_text, _pickFile)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildUploadCard(
                          'Image', CupertinoIcons.photo, _pickImage)),
                ],
              ),
              if (_selectedFile != null) ...[
                const SizedBox(height: 16),
                _buildSelectedFile(),
              ],
              const SizedBox(height: 32),
              _buildSectionTitle('Test Configuration'),
              const SizedBox(height: 20),
              _buildMCQCounter(),
              const SizedBox(height: 20),
              _buildDifficultySelector(),
              const SizedBox(height: 20),
              _buildTimerSection(),
              const SizedBox(height: 40),
              AppButton(
                text: 'Generate Test',
                onPressed: _generateTest,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.raleway(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildUploadCard(String title, IconData icon, VoidCallback onTap) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedFile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success),
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.checkmark_circle_fill, color: AppColors.success),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _selectedFile!.path.split('/').last,
              style: GoogleFonts.manrope(
                  fontSize: 14, color: AppColors.textPrimary),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => setState(() => _selectedFile = null),
            child: Icon(CupertinoIcons.xmark_circle, color: AppColors.error),
          ),
        ],
      ),
    );
  }

  Widget _buildMCQCounter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Number of Questions',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w500,
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
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(CupertinoIcons.minus,
                      size: 16, color: AppColors.primary),
                ),
              ),
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  '$_mcqCount',
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed:
                    _mcqCount < 50 ? () => setState(() => _mcqCount++) : null,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(CupertinoIcons.plus,
                      size: 16, color: AppColors.primary),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Difficulty Level',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          CupertinoSegmentedControl<int>(
            children: {
              0: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Easy', style: GoogleFonts.manrope(fontSize: 14)),
              ),
              1: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Medium', style: GoogleFonts.manrope(fontSize: 14)),
              ),
              2: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Hard', style: GoogleFonts.manrope(fontSize: 14)),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enable Timer',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Duration (minutes)',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: AppColors.textSecondary,
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
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(CupertinoIcons.minus,
                            size: 14, color: AppColors.primary),
                      ),
                    ),
                    Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: Text(
                        '$_timerMinutes',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: _timerMinutes < 120
                          ? () => setState(() => _timerMinutes += 5)
                          : null,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(CupertinoIcons.plus,
                            size: 14, color: AppColors.primary),
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
