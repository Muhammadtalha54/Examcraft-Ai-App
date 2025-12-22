import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../common/app_colors.dart';
import '../common/media_query_helper.dart';

class OptionWidget extends StatefulWidget {
  final String label;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isIncorrect;
  final VoidCallback onTap;

  const OptionWidget({
    Key? key,
    required this.label,
    required this.text,
    this.isSelected = false,
    this.isCorrect = false,
    this.isIncorrect = false,
    required this.onTap,
  }) : super(key: key);

  @override
  State<OptionWidget> createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    if (widget.isSelected || widget.isCorrect || widget.isIncorrect) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(OptionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected || widget.isCorrect || widget.isIncorrect) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = AppColors.surface;
    Color borderColor = AppColors.border;
    Color textColor = AppColors.textPrimary;
    Color glowColor = AppColors.glowBorder;
    IconData? icon;

    if (widget.isCorrect) {
      backgroundColor = AppColors.success.withOpacity(0.08);
      borderColor = AppColors.success;
      textColor = AppColors.success;
      glowColor = AppColors.success;
      icon = CupertinoIcons.checkmark_circle_fill;
    } else if (widget.isIncorrect) {
      backgroundColor = AppColors.error.withOpacity(0.08);
      borderColor = AppColors.error;
      textColor = AppColors.error;
      glowColor = AppColors.error;
      icon = CupertinoIcons.xmark_circle_fill;
    } else if (widget.isSelected) {
      backgroundColor = AppColors.primary.withOpacity(0.08);
      borderColor = AppColors.primary;
      textColor = AppColors.textPrimary;
      glowColor = AppColors.primary;
    }

    return Container(
      margin: EdgeInsets.only(bottom: context.screenHeight * 0.012),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: widget.onTap,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(context.screenWidth * 0.04),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: borderColor.withOpacity(
                    widget.isSelected || widget.isCorrect || widget.isIncorrect ? 0.8 : 0.3
                  ),
                  width: widget.isSelected || widget.isCorrect || widget.isIncorrect ? 1.5 : 1,
                ),
                boxShadow: widget.isSelected || widget.isCorrect || widget.isIncorrect ? [
                  BoxShadow(
                    color: glowColor.withOpacity(0.2 * _glowAnimation.value),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ] : [],
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: widget.isSelected || widget.isCorrect || widget.isIncorrect 
                          ? borderColor 
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: borderColor.withOpacity(0.6),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: icon != null
                          ? Icon(
                              icon,
                              color: AppColors.background,
                              size: 18,
                            )
                          : Text(
                              widget.label,
                              style: GoogleFonts.inter(
                                fontSize: context.screenWidth * 0.036,
                                fontWeight: FontWeight.w700,
                                color: widget.isSelected ? AppColors.background : borderColor,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: context.screenWidth * 0.04),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: GoogleFonts.inter(
                        fontSize: context.screenWidth * 0.04,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}