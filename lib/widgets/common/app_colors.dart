import 'package:flutter/material.dart';

class AppColors {
  // Dark Neon Palette - Professional Dark Theme
  
  // Backgrounds
  static const Color background = Color(0xFF0B0F1A);    // Deep charcoal blue
  static const Color surface = Color(0xFF121826);        // Card surface
  
  // Neon Accents
  static const Color primary = Color(0xFF4F46E5);        // Neon Indigo
  static const Color secondary = Color(0xFF22D3EE);      // Neon Cyan
  static const Color glowBorder = Color(0xFF6366F1);     // Soft glow edge
  
  // Text Colors
  static const Color textPrimary = Color(0xFFE5E7EB);    // High contrast
  static const Color textSecondary = Color(0xFF9CA3AF);  // Medium contrast
  static const Color textMuted = Color(0xFF6B7280);      // Low contrast
  
  // Status Colors
  static const Color success = Color(0xFF22D3EE);        // Neon Cyan (AI/Success)
  static const Color error = Color(0xFFEF4444);          // Bright red
  static const Color warning = Color(0xFFF59E0B);        // Amber
  static const Color info = Color(0xFF4F46E5);           // Neon Indigo
  
  // Border & Divider
  static const Color border = Color(0xFF1F2937);         // Subtle dark border
  static const Color divider = Color(0xFF374151);        // Divider
  
  // Overlay & Glow
  static Color overlay = Colors.black.withOpacity(0.7);
  static Color shadow = Colors.black.withOpacity(0.4);
  static Color glowShadow = Color(0xFF6366F1).withOpacity(0.15);
  
  // Neon Glow Effects
  static BoxShadow get primaryGlow => BoxShadow(
    color: primary.withOpacity(0.3),
    blurRadius: 16,
    spreadRadius: 2,
  );
  
  static BoxShadow get secondaryGlow => BoxShadow(
    color: secondary.withOpacity(0.3),
    blurRadius: 16,
    spreadRadius: 2,
  );
  
  static BoxShadow get subtleGlow => BoxShadow(
    color: glowBorder.withOpacity(0.15),
    blurRadius: 12,
    spreadRadius: 1,
  );
}