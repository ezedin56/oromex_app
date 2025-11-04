import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBackground = Color(0xFF000000);
  static const Color accentColor = Color(0xFFE53935);
  static const Color primaryText = Color(0xFFFFFFFF);

  // Secondary Colors
  static const Color secondaryBackground = Color(0xFF1A1A1A);
  static const Color cardBackground = Color(0xFF2D2D2D);
  static const Color borderColor = Color(0xFF404040);

  // Status Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);

  // Gradients
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE53935), Color(0xFFFF6B6B)],
  );
}
