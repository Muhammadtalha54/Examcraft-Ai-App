import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/test_provider.dart';
import '../widgets/common/app_colors.dart';
import '../widgets/common/media_query_helper.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Load test history when screen opens
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
          child: Icon(CupertinoIcons.back, color: AppColors.primary),
        ),
        middle: Text(
          'Test History',
          style: GoogleFonts.lato(
            fontSize: context.screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: Consumer<TestProvider>(
          builder: (context, testProvider, _) {
            if (testProvider.testHistory == null || testProvider.testHistory!.isEmpty) {
              return SizedBox.shrink();
            }
            return CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text('Clear History?', style: GoogleFonts.lato()),
                    content: Text('This will delete all test results.', style: GoogleFonts.lato()),
                    actions: [
                      CupertinoDialogAction(
                        child: Text('Cancel', style: GoogleFonts.lato()),
                        onPressed: () => Navigator.pop(context),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: Text('Clear', style: GoogleFonts.lato()),
                        onPressed: () async {
                          await testProvider.clearHistory();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Icon(CupertinoIcons.trash, color: AppColors.error),
            );
          },
        ),
      ),
      body: Consumer<TestProvider>(
        builder: (context, testProvider, _) {
          final testHistory = testProvider.testHistory;

          if (testHistory == null) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }

          if (testHistory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.clock,
                    size: 64,
                    color: AppColors.textSecondary.withOpacity(0.5),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No Test History',
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Complete a test to see your results here',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: AppColors.textSecondary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: testHistory.length,
            itemBuilder: (context, index) {
              final result = testHistory[index];
              final passed = result.percentage >= 50;
              final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

              return Container(
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: passed ? AppColors.success.withOpacity(0.3) : AppColors.error.withOpacity(0.3),
                    width: 2,
                  ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with status
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: passed ? AppColors.success : AppColors.error,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  passed ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.xmark_circle_fill,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  passed ? 'Passed' : 'Failed',
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Text(
                            dateFormat.format(result.createdAt),
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

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
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Percentage',
                              '${result.percentage.toStringAsFixed(1)}%',
                              CupertinoIcons.chart_bar,
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

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}