import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/rating_provider.dart';
import '../../widgets/common/app_colors.dart';
import '../../widgets/common/snackbar.dart';

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
      final ratingProvider =
          Provider.of<RatingProvider>(context, listen: false);
      final message = await ratingProvider.submitRating(
        rating: _rating,
        feedback:
            _commentController.text.isEmpty ? null : _commentController.text,
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
          'Rate App',
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
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                         MediaQuery.of(context).padding.top - 
                         MediaQuery.of(context).padding.bottom - 100,
            ),
            child: Column(
              children: [
              // Header Section
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF10B981),
                            Color(0xFF10B981).withOpacity(0.7)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF10B981).withOpacity(0.3),
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        CupertinoIcons.star_fill,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Rate ExamCraft AI',
                      style: GoogleFonts.raleway(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'How would you rate your experience with our app?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              // Rating Container
              Container(
                padding: EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
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
                  children: [
                    // Star Rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Flexible(
                          child: CupertinoButton(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            onPressed: () => setState(() => _rating = index + 1),
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: _rating > index
                                    ? Colors.amber.withOpacity(0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _rating > index
                                    ? CupertinoIcons.star_fill
                                    : CupertinoIcons.star,
                                color: _rating > index
                                    ? Colors.amber
                                    : AppColors.border,
                                size: 32,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    if (_rating > 0) ...[
                      SizedBox(height: 20),
                      Text(
                        _getRatingText(_rating),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],

                    SizedBox(height: 32),

                    // Comment Field
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.border.withOpacity(0.5),
                        ),
                      ),
                      child: CupertinoTextField(
                        controller: _commentController,
                        placeholder: 'Share your thoughts (optional)',
                        maxLines: 4,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        placeholderStyle: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.all(16),
                      ),
                    ),

                    SizedBox(height: 32),

                    // Submit Button
                    Consumer<RatingProvider>(
                      builder: (context, ratingProvider, _) {
                        return Container(
                          width: double.infinity,
                          height: 56,
                          child: CupertinoButton(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                            onPressed:
                                ratingProvider.isLoading ? null : _submitRating,
                            child: ratingProvider.isLoading
                                ? CupertinoActivityIndicator(
                                    color: Colors.white)
                                : Text(
                                    'Submit Rating',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
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
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor - We\'ll do better!';
      case 2:
        return 'Fair - Room for improvement';
      case 3:
        return 'Good - Thanks for the feedback!';
      case 4:
        return 'Very Good - We\'re glad you like it!';
      case 5:
        return 'Excellent - You\'re awesome!';
      default:
        return '';
    }
  }
}
