import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NamajController extends GetxController {
  //TODO: Implement NamajController

  // Namaj Schedule Data
  final schedule = {
    'day': 'শনিবার',
    'status': 'ওয়াক্ত',
    'lastUpdate': '15-03-2025',
    'prayers': [
      {'name': 'ফজর', 'time': '৫:০৫'},
      {'name': 'যোহর', 'time': '১২:১৫'},
      {'name': 'আছর', 'time': '৪:৩৫'},
      {'name': 'মাগরিব', 'time': '৫:৫৮'},
      {'name': 'ঈশা', 'time': '৮:০০'},
    ]
  }.obs;

  // Prayer Learning Sections
  // Prayer Learning Sections
  final prayerSections = [
    {
      'title': 'ফজর',
      'rakat': '২ রাকাত',
      'icon': Icons.nights_stay_rounded, // Night Vibe
      'color': 0xFFFFF8E1, // Light Yellow
      'textColor': 0xFFF57F17,
    },
    {
      'title': 'যোহর',
      'rakat': '৪ রাকাত',
      'icon': Icons.wb_sunny_rounded, // Day Vibe
      'color': 0xFFFFF1F1, // Light Pink
      'textColor': 0xFFFFAB91,
    },
    {
      'title': 'আছর',
      'rakat': '৪ রাকাত',
      'icon': Icons.wb_cloudy_rounded, // Day Vibe (Cloudy/Soft)
      'color': 0xFFE3F2FD, // Light Blue
      'textColor': 0xFF64B5F6,
    },
    {
      'title': 'মাগরিব',
      'rakat': '৩ রাকাত',
      'icon': Icons.wb_twilight_rounded, // Evening Vibe
      'color': 0xFFFCE4EC, // Very Light Pink
      'textColor': 0xFFF06292,
    },
    {
      'title': 'ঈশা',
      'rakat': '৪ রাকাত',
      'icon': Icons.bedtime_rounded, // Night Vibe
      'color': 0xFFE8EAF6, // Indigo Light
      'textColor': 0xFF7986CB,
    },
  ].obs;

  // Essential Duas
  final duas = [
    {
      'title': 'নামাজ শুরু করার দোয়া',
      'arabic': 'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ وَتَبَارَكَ اسْمُكَ وَتَعَالَى جَدُّكَ وَلَا إِلَهَ غَيْرُكَ',
      'bangla': 'হে আল্লাহ! আমি তোমার প্রশংসা সহকারে তোমার পবিত্রতা বর্ণনা করছি। তোমার নাম বরকতময়, তোমার মর্যাদা অতি উচ্চ এবং তুমি ব্যতীত কোন ইলাহ নেই',
    },
    {
      'title': 'রুকুর দোয়া',
      'arabic': 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
      'bangla': 'আমার মহান প্রতিপালক পবিত্র, মহান',
    },
    {
      'title': 'রুকু থেকে ওঠার দোয়া',
      'arabic': 'سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ - رَبَّنَا لَكَ الْحَمْدُ',
      'bangla': 'আল্লাহ তাঁর প্রশংসাকারীর প্রশংসা শোনেন। হে আমাদের প্রতিপালক! সকল প্রশংসা তোমারই',
    },
    {
      'title': 'সিজদাহ্ দোয়া',
      'arabic': 'سُبْحَانَ رَبِّيَ الْأَعْلَى',
      'bangla': 'আমার সর্বোচ্চ প্রতিপালক পবিত্র, মহান',
    },
    {
      'title': 'দুই সিজদার মাঝে',
      'arabic': 'رَبِّ اغْفِرْ لِي وَارْحَمْنِي',
      'bangla': 'হে আমার প্রতিপালক! আমাকে ক্ষমা কর এবং আমার প্রতি দয়া কর',
    },
    {
      'title': 'তাশাহুদ',
      'arabic': 'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ، السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ',
      'bangla': 'সকল সম্মান, সকল নমন এবং সকল পবিত্রতা আল্লাহর জন্য। হে নবী! আপনার উপর শান্তি, আল্লাহর রহমত ও বরকত বর্ষিত হোক',
    },
  ].obs;
}
