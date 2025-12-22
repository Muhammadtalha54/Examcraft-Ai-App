import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'media_query_helper.dart';

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPrimary;
  final double? width;
  final double? height;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isPrimary = true,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _glowAnimation = Tween<double>(begin: 0.15, end: 0.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: widget.width ?? context.screenWidth * 0.85,
              height: widget.height ?? context.screenHeight * 0.065,
              decoration: BoxDecoration(
                gradient: widget.isPrimary ? LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ) : null,
                color: widget.isPrimary ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: widget.isPrimary ? null : Border.all(
                  color: AppColors.glowBorder.withOpacity(0.6),
                  width: 1.5,
                ),
                boxShadow: widget.isPrimary ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(_glowAnimation.value),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ] : [
                  BoxShadow(
                    color: AppColors.glowBorder.withOpacity(_glowAnimation.value * 0.5),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.isPrimary ? Colors.white : AppColors.primary,
                          ),
                        ),
                      )
                    : Text(
                        widget.text,
                        style: GoogleFonts.inter(
                          fontSize: context.screenWidth * 0.042,
                          fontWeight: FontWeight.w600,
                          color: widget.isPrimary ? Colors.white : AppColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}