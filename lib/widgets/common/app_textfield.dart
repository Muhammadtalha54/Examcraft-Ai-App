import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'media_query_helper.dart';

class AppTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool enabled;

  const AppTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  String? _errorText;
  bool _isFocused = false;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: context.screenWidth * 0.85,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _errorText != null 
                      ? AppColors.error 
                      : _isFocused 
                          ? AppColors.glowBorder.withOpacity(0.8)
                          : AppColors.border,
                  width: _isFocused ? 1.5 : 1,
                ),
                boxShadow: _isFocused ? [
                  BoxShadow(
                    color: AppColors.glowBorder.withOpacity(0.15 * _glowAnimation.value),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ] : [],
              ),
              child: Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    _isFocused = hasFocus;
                  });
                  if (hasFocus) {
                    _glowController.forward();
                  } else {
                    _glowController.reverse();
                  }
                },
                child: TextFormField(
                  controller: widget.controller,
                  obscureText: widget.isPassword ? _obscureText : false,
                  keyboardType: widget.keyboardType,
                  enabled: widget.enabled,
                  style: GoogleFonts.inter(
                    fontSize: context.screenWidth * 0.042,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.textMuted,
                      fontSize: context.screenWidth * 0.04,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.045,
                      vertical: context.screenHeight * 0.02,
                    ),
                    suffixIcon: widget.isPassword
                        ? CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => setState(() => _obscureText = !_obscureText),
                            child: Icon(
                              _obscureText ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    if (widget.validator != null) {
                      setState(() {
                        _errorText = widget.validator!(value);
                      });
                    }
                  },
                ),
              ),
            );
          },
        ),
        if (_errorText != null)
          Padding(
            padding: EdgeInsets.only(
              left: context.screenWidth * 0.045,
              top: context.screenHeight * 0.008,
            ),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.exclamationmark_triangle_fill,
                  size: 14,
                  color: AppColors.error,
                ),
                SizedBox(width: 6),
                Text(
                  _errorText!,
                  style: GoogleFonts.inter(
                    color: AppColors.error,
                    fontSize: context.screenWidth * 0.032,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}