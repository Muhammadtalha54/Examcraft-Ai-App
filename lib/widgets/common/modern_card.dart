import 'package:flutter/material.dart';
import 'app_colors.dart';

class ModernCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool hasGlow;
  final Color? glowColor;
  final double borderRadius;

  const ModernCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.hasGlow = true,
    this.glowColor,
    this.borderRadius = 20,
  }) : super(key: key);

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard> with SingleTickerProviderStateMixin {
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _glowAnimation = Tween<double>(begin: 0.1, end: 0.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => _controller.forward() : null,
      onTapUp: widget.onTap != null ? (_) => _controller.reverse() : null,
      onTapCancel: widget.onTap != null ? () => _controller.reverse() : null,
      onTap: widget.onTap,
      child: Container(
        margin: widget.margin,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(
                    color: AppColors.glowBorder.withOpacity(0.15),
                    width: 1,
                  ),
                  boxShadow: [
                    // Depth shadow
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                      spreadRadius: -4,
                    ),
                    // Glow effect
                    if (widget.hasGlow)
                      BoxShadow(
                        color: (widget.glowColor ?? AppColors.glowBorder)
                            .withOpacity(_glowAnimation.value),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                        spreadRadius: -2,
                      ),
                  ],
                ),
                child: Padding(
                  padding: widget.padding ?? EdgeInsets.all(20),
                  child: widget.child,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}