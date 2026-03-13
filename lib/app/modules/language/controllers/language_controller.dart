import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  //TODO: Implement LanguageController

  final selectedLanguage = 'English'.obs;
  
  final List<Map<String, String>> languages = [
    {'name': 'English', 'native': 'English'},
    {'name': 'Bangla', 'native': 'বাংলা'},
    {'name': 'Arabic', 'native': 'العربية'},
  ];

  void selectLanguage(String language) {
    selectedLanguage.value = language;
  }

  void applyLanguage() {
    Get.back();
    Get.snackbar(
      'Language Changed', 
      'Language set to ${selectedLanguage.value}. The app will restart to apply changes.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E63FF), // primary red
      colorText: Colors.white,
    );
  }
}

