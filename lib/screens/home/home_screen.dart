import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/app_colors.dart';
import '../../widgets/common/media_query_helper.dart';
import '../../widgets/common/ios_transition.dart';
import '../generation/mcq_generation_screen.dart';
import '../practice/practice_upload_screen.dart';
import '../short_questions_screen.dart';
import '../long_questions_screen.dart';
import '../history_screen.dart';
import '../rate_app_screen.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        middle: Text(
          'ExamCraft AI',
          style: GoogleFonts.raleway(
            fontSize: context.screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            await authProvider.logout();
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                IOSPageRoute(child: const LoginScreen()),
              );
            }
          },
          child: Icon(CupertinoIcons.power, color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return Text(
                    'Welcome, ${authProvider.user?.name ?? 'User'}!',
                    style: GoogleFonts.raleway(
                      fontSize: context.screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  );
                },
              ),
              SizedBox(height: 8),
              Text(
                'What would you like to generate today?',
                style: GoogleFonts.manrope(
                  fontSize: context.screenWidth * 0.04,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildFeatureCard(
                      context,
                      'MCQ Generation',
                      'Generate multiple choice questions',
                      CupertinoIcons.question_circle,
                      () => Navigator.push(
                        context,
                        IOSPageRoute(child: const MCQGenerationScreen()),
                      ),
                    ),
                    _buildFeatureCard(
                      context,
                      'Short Questions',
                      'Generate short answer questions',
                      CupertinoIcons.doc_text,
                      () => Navigator.push(
                        context,
                        IOSPageRoute(child: const ShortQuestionsScreen()),
                      ),
                    ),
                    _buildFeatureCard(
                      context,
                      'Long Questions',
                      'Generate essay questions',
                      CupertinoIcons.doc_richtext,
                      () => Navigator.push(
                        context,
                        IOSPageRoute(child: const LongQuestionsScreen()),
                      ),
                    ),
                    _buildFeatureCard(
                      context,
                      'Practice Test',
                      'Take a practice test',
                      CupertinoIcons.timer,
                      () => Navigator.push(
                        context,
                        IOSPageRoute(child: const PracticeUploadScreen()),
                      ),
                    ),
                    _buildFeatureCard(
                      context,
                      'History',
                      'View past generations',
                      CupertinoIcons.clock,
                      () => Navigator.push(
                        context,
                        IOSPageRoute(child: const HistoryScreen()),
                      ),
                    ),
                    _buildFeatureCard(
                      context,
                      'Rate App',
                      'Rate our app',
                      CupertinoIcons.star,
                      () => Navigator.push(
                        context,
                        IOSPageRoute(child: const RateAppScreen()),
                      ),
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

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: context.screenWidth * 0.08,
                color: AppColors.primary,
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.raleway(
                  fontSize: context.screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.manrope(
                  fontSize: context.screenWidth * 0.03,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}