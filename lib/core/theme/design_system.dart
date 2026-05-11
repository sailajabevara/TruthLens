import 'package:flutter/material.dart';

/// Centralized Design System for TruthLens Platform
/// Prevents hardcoded UI tokens and enforces a consistent cybersecurity aesthetic.
class AppColors {
  // Brand & Surfaces
  static const Color backgroundDark = Color(0xFF0D1028);
  static const Color surfaceDark = Color(0xFF171B3A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  
  // Accents
  static const Color primaryBlue = Color(0xFF3D8BFF);
  static const Color accentCyan = Color(0xFF00D1FF);
  
  // Semantic Threat Indicators (XAI Layer)
  static const Color threatCritical = Color(0xFFFF4D4D);
  static const Color threatHigh = Color(0xFFFFB347);
  static const Color threatWarning = Color(0xFFFFD166);
  static const Color threatSafe = Color(0xFF00E676);

  // Text
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textMuted = Colors.white54;

  // Structural Gradients
  static const LinearGradient coreGradient = LinearGradient(
    colors: [Color(0xFF2B2F77), primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppTypography {
  static const TextStyle heading1 = TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary);
  static const TextStyle heading2 = TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary);
  static const TextStyle bodyText = TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textPrimary);
  static const TextStyle caption = TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: AppColors.textSecondary);
}
