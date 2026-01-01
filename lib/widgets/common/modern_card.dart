import 'package:flutter/material.dart';
import 'app_colors.dart';

// A fancy card widget that looks modern with animations and glow effects
// Used to wrap content and make it look nice with shadows and animations
class ModernCard extends StatefulWidget {
  final Widget child; // The content inside the card
  final EdgeInsetsGeometry? padding; // Space inside the card around content
  final EdgeInsetsGeometry? margin; // Space outside the card
  final double? width; // How wide the card should be
  final double? height; // How tall the card should be
  final VoidCallback? onTap; // What happens when user taps the card
  final bool hasGlow; // Whether to show a glowing effect
  final Color? glowColor; // What color the glow should be
  final double borderRadius; // How rounded the corners should be

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
  late AnimationController _controller; // Controls the animation timing
  late Animation<double> _scaleAnimation; // Makes the card shrink when pressed
  late Animation<double> _glowAnimation; // Makes the glow effect stronger when pressed

  @override
  void initState() {
    super.initState();
    // Set up animations when the widget is first created
    _controller = AnimationController(
      duration: Duration(milliseconds: 200), // Animation takes 200ms
      vsync: this,
    );
    // Scale animation: makes card slightly smaller when pressed (1.0 to 0.98)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    // Glow animation: makes glow effect stronger when pressed (0.1 to 0.25)
    _glowAnimation = Tween<double>(begin: 0.1, end: 0.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    // Clean up animation controller when widget is destroyed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Start animation when user presses down
      onTapDown: widget.onTap != null ? (_) => _controller.forward() : null,
      // Reverse animation when user lifts finger
      onTapUp: widget.onTap != null ? (_) => _controller.reverse() : null,
      // Reverse animation if user cancels tap
      onTapCancel: widget.onTap != null ? () => _controller.reverse() : null,
      // Execute the tap function when user taps
      onTap: widget.onTap,
      child: Container(
        margin: widget.margin,
        child: ScaleTransition(
          scale: _scaleAnimation, // Apply the shrinking animation
          child: AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: AppColors.surface, // Background color of the card
                  borderRadius: BorderRadius.circular(widget.borderRadius), // Rounded corners
                  border: Border.all(
                    color: AppColors.glowBorder.withOpacity(0.15), // Subtle border
                    width: 1,
                  ),
                  boxShadow: [
                    // Main shadow that gives depth to the card
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 24,
                      offset: Offset(0, 8), // Shadow appears below the card
                      spreadRadius: -4,
                    ),
                    // Glowing effect (only if hasGlow is true)
                    if (widget.hasGlow)
                      BoxShadow(
                        color: (widget.glowColor ?? AppColors.glowBorder)
                            .withOpacity(_glowAnimation.value), // Animated glow intensity
                        blurRadius: 20,
                        offset: Offset(0, 4),
                        spreadRadius: -2,
                      ),
                  ],
                ),
                child: Padding(
                  padding: widget.padding ?? EdgeInsets.all(20), // Default padding if none provided
                  child: widget.child, // The actual content inside the card
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}