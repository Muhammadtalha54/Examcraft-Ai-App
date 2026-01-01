import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/app_colors.dart';
import '../../widgets/common/app_text_styles.dart';
import '../../widgets/common/app_spacing.dart';
import '../../widgets/common/media_query_helper.dart';
import '../../widgets/common/ios_transition.dart';
import '../../widgets/common/modern_feature_card.dart';
import '../../widgets/common/app_drawer.dart';
import '../generation/mcqscreens/mcq_generation_screen.dart';

import '../generation/shortquestion/short_questions_screen.dart';
import '../generation/long_question/long_questions_screen.dart';
import '../historyscreen/history_screen.dart';
import '../rateappscreen/rate_app_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Builder(
          builder: (context) => Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.glowBorder.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(
                CupertinoIcons.line_horizontal_3,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          'ExamCraft AI',
          style: GoogleFonts.raleway(
            fontSize: context.screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
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
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return Text(
                          'Welcome back,',
                          style: GoogleFonts.inter(
                            fontSize: context.screenWidth * 0.04,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 4),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, _) {
                        return Text(
                          '${authProvider.user?.name ?? 'User'}!',
                          style: GoogleFonts.raleway(
                            fontSize: context.screenWidth * 0.065,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.3,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 12),
                    Text(
                      'What would you like to create today?',
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
              // Grid Section
              Expanded(
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final features = [
                      {
                        'title': 'MCQ Generation',
                        'subtitle': 'Create multiple choice questions',
                        'icon': CupertinoIcons.question_circle_fill,
                        'gradient': [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.7)
                        ],
                        'onTap': () => Navigator.push(
                              context,
                              IOSPageRoute(child: const MCQGenerationScreen()),
                            ),
                      },
                      {
                        'title': 'Short Questions',
                        'subtitle': 'Generate short answer questions',
                        'icon': CupertinoIcons.doc_text_fill,
                        'gradient': [
                          AppColors.secondary,
                          AppColors.secondary.withOpacity(0.7)
                        ],
                        'onTap': () => Navigator.push(
                              context,
                              IOSPageRoute(child: const ShortQuestionsScreen()),
                            ),
                      },
                      {
                        'title': 'Long Questions',
                        'subtitle': 'Create detailed essay questions',
                        'icon': CupertinoIcons.doc_text,
                        'gradient': [
                          Color(0xFF8B5CF6),
                          Color(0xFF8B5CF6).withOpacity(0.7)
                        ],
                        'onTap': () => Navigator.push(
                              context,
                              IOSPageRoute(child: const LongQuestionsScreen()),
                            ),
                      },
                      // {
                      //   'title': 'Practice Test',
                      //   'subtitle': 'Take interactive practice tests',
                      //   'icon': CupertinoIcons.timer_fill,
                      //   'gradient': [Color(0xFFEF4444), Color(0xFFEF4444).withOpacity(0.7)],
                      //   'onTap': () => Navigator.push(
                      //     context,
                      //     IOSPageRoute(child: const PracticeUploadScreen()),
                      //   ),
                      // },
                      {
                        'title': 'History',
                        'subtitle': 'View your past generations',
                        'icon': CupertinoIcons.clock_fill,
                        'gradient': [
                          Color(0xFFF59E0B),
                          Color(0xFFF59E0B).withOpacity(0.7)
                        ],
                        'onTap': () => Navigator.push(
                              context,
                              IOSPageRoute(child: const HistoryScreen()),
                            ),
                      },
                      {
                        'title': 'Rate App',
                        'subtitle': 'Share your feedback with us',
                        'icon': CupertinoIcons.star_fill,
                        'gradient': [
                          Color(0xFF10B981),
                          Color(0xFF10B981).withOpacity(0.7)
                        ],
                        'onTap': () => Navigator.push(
                              context,
                              IOSPageRoute(child: const RateAppScreen()),
                            ),
                      },
                    ];

                    return _buildFeatureCard(
                      context,
                      features[index]['title'] as String,
                      features[index]['subtitle'] as String,
                      features[index]['icon'] as IconData,
                      features[index]['gradient'] as List<Color>,
                      features[index]['onTap'] as VoidCallback,
                    );
                  },
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
    List<Color> gradientColors,
    VoidCallback onTap,
  ) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
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
              color: gradientColors[0].withOpacity(0.1),
              blurRadius: 16,
              offset: Offset(0, 4),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon Container with Gradient Background
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              // Title
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: context.screenWidth * 0.038,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6),
              // Subtitle
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: context.screenWidth * 0.032,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
