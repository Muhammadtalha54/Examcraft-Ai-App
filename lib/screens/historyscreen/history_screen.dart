import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/test_provider.dart';
import '../../widgets/common/app_colors.dart';
import '../../widgets/common/media_query_helper.dart';
import 'package:intl/intl.dart';

/// Screen that displays user's test history and results
/// Shows all completed tests with scores, percentages, and pass/fail status
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    /// Loads test history from local storage when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TestProvider>(context, listen: false).loadTestHistory();
    });
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
          'Test History',
          style: GoogleFonts.raleway(
            fontSize: context.screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 0.3,
          ),
        ),
        trailing: Consumer<TestProvider>(
          builder: (context, testProvider, _) {
            if (testProvider.testHistory == null ||
                testProvider.testHistory!.isEmpty) {
              return SizedBox.shrink();
            }
            /// Shows clear history button when there are test results
            /// Opens confirmation dialog before clearing all history
            return CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text('Clear History?', style: GoogleFonts.raleway()),
                    content: Text('This will delete all test results.',
                        style: GoogleFonts.inter()),
                    actions: [
                      CupertinoDialogAction(
                        child: Text('Cancel', style: GoogleFonts.inter()),
                        onPressed: () => Navigator.pop(context),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: Text('Clear', style: GoogleFonts.inter()),
                        onPressed: () async {
                          await testProvider.clearHistory();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  CupertinoIcons.trash,
                  color: AppColors.error,
                  size: 20,
                ),
              ),
            );
          },
        ),
      ),
      body: Consumer<TestProvider>(
        builder: (context, testProvider, _) {
          final testHistory = testProvider.testHistory;

          /// Shows loading indicator while fetching test history
          if (testHistory == null) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }

          /// Shows empty state when no tests have been completed
          if (testHistory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: Icon(
                      CupertinoIcons.clock_fill,
                      size: 48,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'No Test History',
                    style: GoogleFonts.raleway(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Complete a test to see your results here',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }

          /// Displays list of completed tests with results
          /// Each item shows test title, date, score, and pass/fail status
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: testHistory.length,
            itemBuilder: (context, index) {
              final result = testHistory[index];
              final passed = result.percentage >= 50;
              final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

              return Container(
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: passed
                        ? AppColors.success.withOpacity(0.3)
                        : AppColors.error.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                      spreadRadius: -4,
                    ),
                    BoxShadow(
                      color: (passed ? AppColors.success : AppColors.error)
                          .withOpacity(0.1),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with test title and status
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  result.testTitle,
                                  style: GoogleFonts.raleway(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  dateFormat.format(result.createdAt),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: passed
                                    ? [
                                        AppColors.success,
                                        AppColors.success.withOpacity(0.8)
                                      ]
                                    : [
                                        AppColors.error,
                                        AppColors.error.withOpacity(0.8)
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: (passed
                                          ? AppColors.success
                                          : AppColors.error)
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  passed
                                      ? CupertinoIcons.checkmark_circle_fill
                                      : CupertinoIcons.xmark_circle_fill,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  passed ? 'Passed' : 'Failed',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Score display
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Score',
                              '${result.score}/${result.total}',
                              CupertinoIcons.checkmark_alt,
                              AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Percentage',
                              '${result.percentage.toStringAsFixed(1)}%',
                              CupertinoIcons.chart_bar_fill,
                              passed ? AppColors.success : AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Creates a stat card widget showing test statistics
  /// Used to display score and percentage in a styled container
  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.raleway(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
