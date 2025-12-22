import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/rating_provider.dart';
import '../widgets/common/app_colors.dart';
import '../widgets/common/snackbar.dart';

class RateAppScreen extends StatefulWidget {
  const RateAppScreen({Key? key}) : super(key: key);

  @override
  State<RateAppScreen> createState() => _RateAppScreenState();
}

class _RateAppScreenState extends State<RateAppScreen> {
  int _rating = 0;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitRating() async {
    if (_rating == 0) {
      AppSnackbar.show(context, 'Please select a rating', isError: true);
      return;
    }

    try {
      final ratingProvider = Provider.of<RatingProvider>(context, listen: false);
      final message = await ratingProvider.submitRating(
        rating: _rating,
        feedback: _commentController.text.isEmpty ? null : _commentController.text,
      );
      
      if (mounted) {
        AppSnackbar.show(context, message);
        Navigator.pop(context);
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
          'Rate App',
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Text(
                      'Rate ExamCraft AI',
                      style: GoogleFonts.raleway(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'How would you rate your experience?',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => setState(() => _rating = index + 1),
                          child: Icon(
                            _rating > index ? CupertinoIcons.star_fill : CupertinoIcons.star,
                            color: _rating > index ? Colors.amber : AppColors.border,
                            size: 32,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    CupertinoTextField(
                      controller: _commentController,
                      placeholder: 'Leave a comment (optional)',
                      maxLines: 3,
                      style: GoogleFonts.manrope(),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Consumer<RatingProvider>(
                      builder: (context, ratingProvider, _) {
                        return Container(
                          width: double.infinity,
                          height: 50,
                          child: CupertinoButton(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                            onPressed: ratingProvider.isLoading ? null : _submitRating,
                            child: ratingProvider.isLoading
                                ? const CupertinoActivityIndicator(color: Colors.white)
                                : Text(
                                    'Submit Rating',
                                    style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        );
                      },
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
}