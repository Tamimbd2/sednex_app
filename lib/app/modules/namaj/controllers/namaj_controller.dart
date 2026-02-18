import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';

class NamajController extends GetxController with WidgetsBindingObserver {
  //TODO: Implement NamajController

  // Namaj Schedule Data
  // Namaj Schedule Data
  final schedule = {
    'day': '',
    'status': 'ওয়াক্ত',
    'lastUpdate': '',
    'prayers': [
      {'name': 'ফজর', 'time': '৫:০৫'},
      {'name': 'যোহর', 'time': '১২:১৫'},
      {'name': 'আছর', 'time': '৪:৩৫'},
      {'name': 'মাগরিব', 'time': '৫:৫৮'},
      {'name': 'ঈশা', 'time': '৮:০০'},
    ]
  }.obs;

  RxInt currentPrayerIndex = (-1).obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _updateScheduleDate();
    fetchPrayerTimes();
    _startTimer();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkCurrentPrayer();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _updateScheduleDate();
      fetchPrayerTimes();
      _checkCurrentPrayer();
    }
  }

  void _updateScheduleDate() {
    final now = DateTime.now();
    schedule['day'] = _getBengaliDay(now.weekday);
    schedule['lastUpdate'] = 'Today';
  }

  void fetchPrayerTimes() async {
    final connect = GetConnect();
    final now = DateTime.now();
    final dateStr = '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
    
    // Fixed location: Beirut, Lebanon
    final url = 'https://api.aladhan.com/v1/timingsByCity/$dateStr?city=Beirut&country=Lebanon&method=3&school=1';
    
    try {
      final response = await connect.get(url);
      if (response.statusCode == 200 && response.body != null) {
        final data = response.body['data'];
        final timings = data['timings'];
        
        final newPrayers = [
          {'name': 'ফজর', 'time': _formatTime12H(timings['Fajr']), 'raw': timings['Fajr']},
          {'name': 'যোহর', 'time': _formatTime12H(timings['Dhuhr']), 'raw': timings['Dhuhr']},
          {'name': 'আছর', 'time': _formatTime12H(timings['Asr']), 'raw': timings['Asr']},
          {'name': 'মাগরিব', 'time': _formatTime12H(timings['Maghrib']), 'raw': timings['Maghrib']},
          {'name': 'ঈশা', 'time': _formatTime12H(timings['Isha']), 'raw': timings['Isha']},
        ];
        
        schedule['prayers'] = newPrayers;
        schedule.refresh(); // Ensure UI updates
        _checkCurrentPrayer();
      }
    } catch (e) {
      debugPrint('Error fetching prayer times: $e');
    }
  }

  void _checkCurrentPrayer() {
    if (schedule['prayers'] == null) return;
    
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    
    int nextIndex = 0; // Default to Fajr (next cycle) if all passed
    final prayers = schedule['prayers'] as List;

    for (int i = 0; i < prayers.length; i++) {
        final prayer = prayers[i] as Map<String, dynamic>;
        final rawTime = prayer['raw'];
        if (rawTime != null) {
            final parts = rawTime.split(':');
            final pHour = int.parse(parts[0]);
            final pMinute = int.parse(parts[1]);
            final prayerMinutes = pHour * 60 + pMinute;

            if (prayerMinutes > currentMinutes) {
                nextIndex = i;
                break;
            }
        }
    }
    currentPrayerIndex.value = nextIndex;
  }

  Map<String, String> get nextPrayerDisplay {
    final defaultData = {'name': 'Fajr', 'time': '05:00 AM'};
    
    if (schedule['prayers'] == null) return defaultData;
    
    final prayers = schedule['prayers'] as List;
    final index = currentPrayerIndex.value;
    
    if (index >= 0 && index < prayers.length) {
        final prayer = prayers[index]; // Map<String, dynamic>
        // Use raw time to format in English 12h
        final raw = prayer['raw'] as String?;
        String timeStr = prayer['time']; // Bengali default
        
        // English Names mapping
        final enNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
        String name = (index < enNames.length) ? enNames[index] : 'Fajr';
        
        if (raw != null) {
            // Format raw (HH:mm) to 12h AM/PM
             try {
              final parts = raw.split(':');
              int h = int.parse(parts[0]);
              final m = parts[1];
              String suffix = h >= 12 ? 'PM' : 'AM';
              if (h > 12) h -= 12;
              if (h == 0) h = 12;
              timeStr = '$h:$m $suffix';
            } catch (e) {}
        }
        
        return {'name': name, 'time': timeStr};
    }
    return defaultData;
  }

  String _formatTime12H(String time24) {
    if (time24.isEmpty) return '';
    try {
      final parts = time24.split(':');
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12; // 00:xx is 12:xx AM
      
      // Formatting to En 12h first: "5:05"
      final timeEn = '$hour:${minute.toString().padLeft(2, '0')}';
      return _toBengaliNumber(timeEn);
    } catch (e) {
      return _toBengaliNumber(time24);
    }
  }

  String _toBengaliNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bengali = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], bengali[i]);
    }
    return input;
  }


  String _getBengaliDay(int weekday) {
    switch (weekday) {
      case DateTime.saturday:
        return 'শনিবার';
      case DateTime.sunday:
        return 'রবিবার';
      case DateTime.monday:
        return 'সোমবার';
      case DateTime.tuesday:
        return 'মঙ্গলবার';
      case DateTime.wednesday:
        return 'বুধবার';
      case DateTime.thursday:
        return 'বৃহস্পতিবার';
      case DateTime.friday:
        return 'শুক্রবার';
      default:
        return 'শনিবার';
    }
  }

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
    {
      'title': 'কুরআন',
      'rakat': 'তিলাওয়াত',
      'icon': Icons.menu_book_rounded,
      'color': 0xFFE8F5E9, // Light Green
      'textColor': 0xFF43A047, // Green
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
