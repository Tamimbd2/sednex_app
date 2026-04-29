import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_pages.dart';

class SelectLangController extends GetxController {
  final selectedLang = 'English'.obs;

  final List<Map<String, String>> languages = [
    {'name': 'English', 'displayName': 'English', 'code': 'en', 'country': 'US'},
    {'name': 'Bangla', 'displayName': 'বাংলা', 'code': 'bn', 'country': 'BD'},
    {'name': 'Arabic', 'displayName': 'العربية', 'code': 'ar', 'country': 'AE'},
  ];

  void changeLanguage(String langName) {
    selectedLang.value = langName;
  }

  void saveAndContinue() {
    final box = GetStorage();
    box.write('language', selectedLang.value);
    
    final langObj = languages.firstWhere((l) => l['name'] == selectedLang.value);
    Get.updateLocale(Locale(langObj['code']!, langObj['country']!));

    Get.offAllNamed(Routes.ONBOARD);
  }
}
