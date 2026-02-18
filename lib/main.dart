import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/routes/app_pages.dart';
import 'app/bindings/initial_binding.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Sednex App",
      initialRoute: AppPages.INITIAL,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        textTheme: _buildTextTheme(),
      ),
    ),
  );
}

TextTheme _buildTextTheme() {
  final baseTheme = GoogleFonts.poppinsTextTheme();
  final fallback = [GoogleFonts.hindSiliguri().fontFamily ?? 'Hind Siliguri'];

  return baseTheme.copyWith(
    displayLarge: baseTheme.displayLarge?.copyWith(fontFamilyFallback: fallback),
    displayMedium: baseTheme.displayMedium?.copyWith(fontFamilyFallback: fallback),
    displaySmall: baseTheme.displaySmall?.copyWith(fontFamilyFallback: fallback),
    headlineLarge: baseTheme.headlineLarge?.copyWith(fontFamilyFallback: fallback),
    headlineMedium: baseTheme.headlineMedium?.copyWith(fontFamilyFallback: fallback),
    headlineSmall: baseTheme.headlineSmall?.copyWith(fontFamilyFallback: fallback),
    titleLarge: baseTheme.titleLarge?.copyWith(fontFamilyFallback: fallback),
    titleMedium: baseTheme.titleMedium?.copyWith(fontFamilyFallback: fallback),
    titleSmall: baseTheme.titleSmall?.copyWith(fontFamilyFallback: fallback),
    bodyLarge: baseTheme.bodyLarge?.copyWith(fontFamilyFallback: fallback),
    bodyMedium: baseTheme.bodyMedium?.copyWith(fontFamilyFallback: fallback),
    bodySmall: baseTheme.bodySmall?.copyWith(fontFamilyFallback: fallback),
    labelLarge: baseTheme.labelLarge?.copyWith(fontFamilyFallback: fallback),
    labelMedium: baseTheme.labelMedium?.copyWith(fontFamilyFallback: fallback),
    labelSmall: baseTheme.labelSmall?.copyWith(fontFamilyFallback: fallback),
  );
}
