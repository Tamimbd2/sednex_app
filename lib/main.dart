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

import 'package:flutter_langdetect/flutter_langdetect.dart' as langdetect;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await langdetect.initLangDetect();
  await Firebase.initializeApp();
  await GetStorage.init();

  final serverClientId = AppConstants.googleServerClientId.trim();
  await GoogleSignIn.instance.initialize(
    serverClientId: serverClientId.isEmpty ? null : serverClientId,
  );
  runApp(
    GetMaterialApp(
      title: "Sednex",
      initialRoute: AppPages.INITIAL,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
        // Global font fallback: Poppins for Latin, Hind Siliguri for Bengali
        textTheme: AppTheme.lightTheme.textTheme.apply(
          fontFamilyFallback: [
            GoogleFonts.hindSiliguri().fontFamily ?? 'HindSiliguri',
          ],
        ),
      ),
    ),
  );
}
