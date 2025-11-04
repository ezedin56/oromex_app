import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Basic Theme
      primaryColor: AppColors.accentColor,
      scaffoldBackgroundColor: AppColors.primaryBackground,
      fontFamily: 'Poppins',
      useMaterial3: true,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primaryText),
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
      ),

      // Card Theme - Corrected
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        color: AppColors.cardBackground,
        margin: EdgeInsets.zero,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.secondaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accentColor),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor,
          foregroundColor: AppColors.primaryText,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: TextStyles.buttonText,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyles.headline1,
        displayMedium: TextStyles.headline2,
        displaySmall: TextStyles.headline3,
        bodyLarge: TextStyles.bodyLarge,
        bodyMedium: TextStyles.bodyMedium,
        bodySmall: TextStyles.bodySmall,
        labelLarge: TextStyles.buttonText,
      ),

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentColor,
        onPrimary: AppColors.primaryText,
        secondary: AppColors.accentColor,
        onSecondary: AppColors.primaryText,
        surface: AppColors.cardBackground,
        onSurface: AppColors.primaryText,
        background: AppColors.primaryBackground,
        onBackground: AppColors.primaryText,
        error: AppColors.errorColor,
        onError: AppColors.primaryText,
      ),
    );
  }

  static ThemeData get darkTheme => lightTheme;
}
