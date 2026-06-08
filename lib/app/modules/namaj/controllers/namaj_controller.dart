import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NamajController extends GetxController with WidgetsBindingObserver {
  // Namaj Schedule Data
  final schedule = {
    'day': '',
    'status': 'waqt',
    'lastUpdate': '',
    'prayers': [
      {'name': 'fajar', 'time': '৫:০৫'},
      {'name': 'zohar', 'time': '১২:১৫'},
      {'name': 'asar', 'time': '৪:৩৫'},
      {'name': 'magrib', 'time': '৫:৫৮'},
      {'name': 'esha', 'time': '৮:০০'},
    ]
  }.obs;

   RxInt currentPrayerIndex = (-1).obs;
  Timer? _timer;
  
  var userLocation = 'Beirut, Lebanon'.obs;
  double? _lat;
  double? _lon;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _updateScheduleDate();
    _fetchLocationAndPrayerTimes();
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
      _fetchLocationAndPrayerTimes();
      _checkCurrentPrayer();
    }
  }

  void _updateScheduleDate() {
    final now = DateTime.now();
    schedule['day'] = _getDayKey(now.weekday);
    schedule['lastUpdate'] = 'today';
  }

  void _fetchLocationAndPrayerTimes() async {
    await _detectLocation();
    fetchPrayerTimes();
  }

  Future<void> _detectLocation() async {
    final connect = GetConnect();
    // Try freeipapi.com (Fully Free, Open-Source & HTTPS)
    try {
      final response = await connect.get('https://freeipapi.com/api/json').timeout(const Duration(seconds: 4));
      debugPrint('detectLocation: freeipapi.com status = ${response.statusCode}, body = ${response.body}');
      if (response.statusCode == 200 && response.body != null) {
        final data = response.body;
        final city = data['cityName']?.toString() ?? '';
        final country = data['countryName']?.toString() ?? '';
        if (city.isNotEmpty) {
          userLocation.value = country.isNotEmpty ? '$city, $country' : city;
          _lat = double.tryParse(data['latitude']?.toString() ?? '');
          _lon = double.tryParse(data['longitude']?.toString() ?? '');
          debugPrint('detectLocation: successfully set location to ${userLocation.value} from freeipapi.com');
          return;
        }
      }
    } catch (e) {
      debugPrint('detectLocation: freeipapi.com failed: $e');
    }

    // Fallback to ipinfo.io
    try {
      final response = await connect.get('https://ipinfo.io/json').timeout(const Duration(seconds: 4));
      debugPrint('detectLocation: ipinfo.io status = ${response.statusCode}, body = ${response.body}');
      if (response.statusCode == 200 && response.body != null) {
        final data = response.body;
        final city = data['city']?.toString() ?? '';
        final countryCode = data['country']?.toString() ?? '';
        final country = countryCode == 'BD' ? 'Bangladesh' : countryCode;
        if (city.isNotEmpty) {
          userLocation.value = country.isNotEmpty ? '$city, $country' : city;
          
          final loc = data['loc']?.toString() ?? '';
          if (loc.contains(',')) {
            final coords = loc.split(',');
            _lat = double.tryParse(coords[0].trim());
            _lon = double.tryParse(coords[1].trim());
          }
          debugPrint('detectLocation: successfully set location to ${userLocation.value} from ipinfo.io');
          return;
        }
      }
    } catch (e) {
      debugPrint('detectLocation: ipinfo.io failed: $e');
    }
  }

  void fetchPrayerTimes() async {
    final connect = GetConnect();
    final now = DateTime.now();
    final dateStr = '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
    
    // Determine the calculation method and school based on user location country
    int method = 3; // Default: Muslim World League (MWL)
    int school = 0; // Default: Shafi'i, Maliki, Hanbali (Standard school)
    
    final locLower = userLocation.value.toLowerCase();
    if (locLower.contains('bangladesh') || locLower.contains('pakistan') || locLower.contains('india')) {
      method = 1; // University of Islamic Sciences, Karachi (standard for South Asia)
      school = 1; // Hanafi (standard school for South Asia)
    } else if (locLower.contains('saudi arabia') || locLower.contains('makkah') || locLower.contains('madinah')) {
      method = 4; // Umm Al-Qura University, Makkah
    } else if (locLower.contains('united arab emirates') || locLower.contains('uae') || locLower.contains('dubai') || locLower.contains('gulf')) {
      method = 8; // Gulf Region
    } else if (locLower.contains('egypt')) {
      method = 5; // Egyptian General Authority of Survey
    } else if (locLower.contains('turkey')) {
      method = 13; // Diyanet İşleri Başkanlığı, Turkey
    } else if (locLower.contains('singapore')) {
      method = 11; // Majlis Ugama Islam Singapura, Singapore
    } else if (locLower.contains('malaysia')) {
      method = 11; // JAKIM, Malaysia
    }
    
    String url;
    if (_lat != null && _lon != null) {
      url = 'https://api.aladhan.com/v1/timings/$dateStr?latitude=$_lat&longitude=$_lon&method=$method&school=$school';
    } else {
      final parts = userLocation.value.split(',');
      final city = parts[0].trim();
      final country = parts.length > 1 ? parts[1].trim() : 'Lebanon';
      url = 'https://api.aladhan.com/v1/timingsByCity/$dateStr?city=$city&country=$country&method=$method&school=$school';
    }
    
    try {
      final response = await connect.get(url);
      if (response.statusCode == 200 && response.body != null) {
        final data = response.body['data'];
        final timings = data['timings'];
        
        final newPrayers = [
          {'name': 'fajar', 'time': _formatTime12H(timings['Fajr']), 'raw': timings['Fajr']},
          {'name': 'zohar', 'time': _formatTime12H(timings['Dhuhr']), 'raw': timings['Dhuhr']},
          {'name': 'asar', 'time': _formatTime12H(timings['Asr']), 'raw': timings['Asr']},
          {'name': 'magrib', 'time': _formatTime12H(timings['Maghrib']), 'raw': timings['Maghrib']},
          {'name': 'esha', 'time': _formatTime12H(timings['Isha']), 'raw': timings['Isha']},
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
      if (Get.locale?.languageCode == 'bn') {
        return _toBengaliNumber(timeEn);
      }
      return timeEn;
    } catch (e) {
      if (Get.locale?.languageCode == 'bn') {
        return _toBengaliNumber(time24);
      }
      return time24;
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

  String _getDayKey(int weekday) {
    switch (weekday) {
      case DateTime.saturday:
        return 'saturday';
      case DateTime.sunday:
        return 'sunday';
      case DateTime.monday:
        return 'monday';
      case DateTime.tuesday:
        return 'tuesday';
      case DateTime.wednesday:
        return 'wednesday';
      case DateTime.thursday:
        return 'thursday';
      case DateTime.friday:
        return 'friday';
      default:
        return 'saturday';
    }
  }

  // Prayer Learning Sections
  final prayerSections = [
    {
      'title': 'fajar',
      'rakat': 'rakat_2',
      'icon': Icons.nights_stay_rounded,
      'color': 0xFFFFF8E1,
      'textColor': 0xFFF57F17,
    },
    {
      'title': 'zohar',
      'rakat': 'rakat_4',
      'icon': Icons.wb_sunny_rounded,
      'color': 0xFFFFF1F1,
      'textColor': 0xFFFFAB91,
    },
    {
      'title': 'asar',
      'rakat': 'rakat_4',
      'icon': Icons.wb_cloudy_rounded,
      'color': 0xFFE3F2FD,
      'textColor': 0xFF64B5F6,
    },
    {
      'title': 'magrib',
      'rakat': 'rakat_3',
      'icon': Icons.wb_twilight_rounded,
      'color': 0xFFFCE4EC,
      'textColor': 0xFFF06292,
    },
    {
      'title': 'esha',
      'rakat': 'rakat_4',
      'icon': Icons.bedtime_rounded,
      'color': 0xFFE8EAF6,
      'textColor': 0xFF7986CB,
    },
    {
      'title': 'quran',
      'rakat': 'quran_reading',
      'icon': Icons.menu_book_rounded,
      'color': 0xFFE8F5E9,
      'textColor': 0xFF43A047,
    },
  ].obs;

  // Essential Duas
  final duas = [
    {
      'title': 'dua_start',
      'arabic': 'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ وَتَبَارَكَ اسْمُكَ وَتَعَالَى جَدُّكَ وَلَا إِلَهَ غَيْرُكَ',
      'bangla': 'হে আল্লাহ! আমি তোমার প্রশংসা সহকারে তোমার পবিত্রতা বর্ণনা করছি। তোমার নাম বরকতময়, তোমার মর্যাদা অতি উচ্চ এবং তুমি ব্যতীত কোন ইলাহ নেই',
    },
    {
      'title': 'dua_ruku',
      'arabic': 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
      'bangla': 'আমার মহান প্রতিপালক পবিত্র, মহান',
    },
    {
      'title': 'dua_ruku_rise',
      'arabic': 'سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ - রَبَّنَا لَكَ الْحَمْدُ',
      'bangla': 'আল্লাহ তাঁর প্রশংসাকারীর প্রশংসা শোনেন। হে আমাদের প্রতিপালক! সকল প্রশংসা তোমারই',
    },
    {
      'title': 'dua_sujud',
      'arabic': 'سُبْحَانَ رَبِّيَ الْأَعْلَى',
      'bangla': 'আমার সর্বোচ্চ প্রতিপালক পবিত্র, মহান',
    },
    {
      'title': 'dua_between_sujud',
      'arabic': 'رَبِّ اغْفِرْ لِي وَارْحَمْنِي',
      'bangla': 'হে আমার প্রতিপালক! আমাকে ক্ষমা কর এবং আমার প্রতি দয়া কর',
    },
    {
      'title': 'dua_tashahhud',
      'arabic': 'التَّحِيَّاتُ لِلَّهِ وَالصَّلَاوَاتُ وَالطَّيِّبَاتُ، السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ',
      'bangla': 'সকল সম্মান, সকল নমন এবং সকল পবিত্রতা আল্লাহর জন্য। হে নবী! আপনার উপর শান্তি, আল্লাহর রহমত ও বরকত বর্ষিত হোক',
    },
  ].obs;
}
