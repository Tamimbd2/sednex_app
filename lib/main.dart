import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/core/constants/app_constants.dart';
import 'app/routes/app_pages.dart';
import 'app/bindings/initial_binding.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/translations/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  final serverClientId = AppConstants.googleServerClientId.trim();
  await GoogleSignIn.instance.initialize(
    serverClientId: serverClientId.isEmpty ? null : serverClientId,
  );

  final box = GetStorage();
  String? savedLanguage = box.read('language');
  Locale initialLocale;
  if (savedLanguage == 'Bangla') {
    initialLocale = const Locale('bn', 'BD');
  } else if (savedLanguage == 'Arabic') {
    initialLocale = const Locale('ar', 'AE');
  } else {
    initialLocale = const Locale('en', 'US');
  }

  runApp(
    GetMaterialApp(
      title: "Sednex",
      initialRoute: AppPages.INITIAL,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: const Locale('en', 'US'),
      theme: AppTheme.lightTheme.copyWith(
        // Global font fallback: Poppins for Latin, Hind Siliguri for Bengali
        textTheme: AppTheme.lightTheme.textTheme.apply(
          fontFamilyFallback: [
            GoogleFonts.hindSiliguri().fontFamily ?? 'HindSiliguri',
            'Roboto', // Fallback for Arabic if needed, or specify an Arabic font
          ],
        ),
      ),
    ),
  );
}
