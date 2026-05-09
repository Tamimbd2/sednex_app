import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._(); // Prevent instantiation

  /// App default font family
  static String get fontFamily => GoogleFonts.poppins().fontFamily!;
  static String get bengaliFontFamily =>
      GoogleFonts.notoSansBengali().fontFamily!;

  static List<String> get fontFallbacks => [bengaliFontFamily];
  
  static TextStyle get appBarTitle => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ).copyWith(fontFamilyFallback: fontFallbacks);

  /// Headings
  static TextStyle get headingLarge => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.mainText,
  ).copyWith(fontFamilyFallback: fontFallbacks);

  static TextStyle get headingMedium => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.mainText,
  ).copyWith(fontFamilyFallback: fontFallbacks);

  static TextStyle get headingSmall => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.mainText,
  ).copyWith(fontFamilyFallback: fontFallbacks);

  /// Subheadings
  static TextStyle get subHeadingLarge => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.mainText,
  ).copyWith(fontFamilyFallback: fontFallbacks);

  static TextStyle get subHeadingMedium => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.mainText,
  ).copyWith(fontFamilyFallback: fontFallbacks);

  /// Body text
  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  ).copyWith(fontFamilyFallback: fontFallbacks);

  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  ).copyWith(fontFamilyFallback: fontFallbacks);

  static TextStyle get bodySmall => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
  ).copyWith(fontFamilyFallback: fontFallbacks);

  /// Buttons
  static TextStyle get button => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ).copyWith(fontFamilyFallback: fontFallbacks);

  /// Labels & captions
  static TextStyle get label => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.mainText,
  ).copyWith(fontFamilyFallback: fontFallbacks);

  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.hintText,
  ).copyWith(fontFamilyFallback: fontFallbacks);

  /// Input field text
  static TextStyle get inputText => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.mainText,
  ).copyWith(fontFamilyFallback: fontFallbacks);

  static TextStyle get hintText => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.hintText,
  ).copyWith(fontFamilyFallback: fontFallbacks);

  /// Arabic text (Quranic/Dua)
  static TextStyle get arabic => GoogleFonts.amiri(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    color: AppColors.mainText,
  );
}
