import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF2196F3);
  static const secondary = Color(0xFFEE6B4D);
  static const background = Color(0xFFFFFFFF);
  static const text = Color(0xFF212121);
  static const textLight = Color(0xFF757575);
  static const cardBackground = Color(0xFFF5F5F5);
  static const yellow = Color(0xFFFFC107);
  static const error = Color(0xFFE53935);
  static const success = Color(0xFF43A047);
}

class AppStyles {
  static final _baseTextStyle = GoogleFonts.poppins();

  static TextStyle get titleLarge => _baseTextStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static TextStyle get titleMedium => _baseTextStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static TextStyle get bodyLarge => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  );

  static TextStyle get bodyMedium => _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  );

  static TextStyle get bodySmall => _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  );

  static TextStyle get button => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.background,
  );

  // Fallback method in case Google Fonts fails
  static TextStyle getFallbackStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.text,
      fontFamily: 'Roboto', // System default
    );
  }
} 