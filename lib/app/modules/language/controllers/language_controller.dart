import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  //TODO: Implement LanguageController

  final _box = GetStorage();
  final selectedLanguage = 'English'.obs;

  @override
  void onInit() {
    super.onInit();
    final saved = _box.read('language');
    if (saved != null) {
      selectedLanguage.value = saved;
    }
  }

  final List<Map<String, String>> languages = [
    {'name': 'English', 'native': 'English'},
    {'name': 'Bangla', 'native': 'বাংলা'},
    {'name': 'Arabic', 'native': 'العربية'},
  ];

  void selectLanguage(String language) {
    selectedLanguage.value = language;
  }

  void applyLanguage() async {
    // Save to storage
    await _box.write('language', selectedLanguage.value);

    // Update Locale
    Locale newLocale;
    if (selectedLanguage.value == 'Bangla') {
      newLocale = const Locale('bn', 'BD');
    } else if (selectedLanguage.value == 'Arabic') {
      newLocale = const Locale('ar', 'AE');
    } else {
      newLocale = const Locale('en', 'US');
    }
    
    Get.updateLocale(newLocale);

    Get.snackbar(
      'language_changed'.tr,
      '${'language_set_to'.tr} ${selectedLanguage.value}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E63FF),
      colorText: Colors.white,
    );
  }
}

