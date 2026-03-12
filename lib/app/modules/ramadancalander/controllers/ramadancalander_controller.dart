import 'package:get/get.dart';

class RamadancalanderController extends GetxController {
  
  var ramadanData = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStaticData();
  }

  void loadStaticData() {
    final rawData = [
      ["1", "04:55 AM", "5:26 PM", "18 Feb 2026"],
      ["2", "04:54 AM", "5:27 PM", "19 Feb 2026"],
      ["3", "04:53 AM", "5:27 PM", "20 Feb 2026"],
      ["4", "04:52 AM", "5:28 PM", "21 Feb 2026"],
      ["5", "04:51 AM", "5:29 PM", "22 Feb 2026"],
      ["6", "04:50 AM", "5:30 PM", "23 Feb 2026"],
      ["7", "04:49 AM", "5:31 PM", "24 Feb 2026"],
      ["8", "04:48 AM", "5:32 PM", "25 Feb 2026"],
      ["9", "04:46 AM", "5:33 PM", "26 Feb 2026"],
      ["10", "04:45 AM", "5:34 PM", "27 Feb 2026"],
      ["11", "04:44 AM", "5:34 PM", "28 Feb 2026"],
      ["12", "04:43 AM", "5:35 PM", "01 Mar 2026"],
      ["13", "04:42 AM", "5:36 PM", "02 Mar 2026"],
      ["14", "04:41 AM", "5:37 PM", "03 Mar 2026"],
      ["15", "04:39 AM", "5:38 PM", "04 Mar 2026"],
      ["16", "04:38 AM", "5:39 PM", "05 Mar 2026"],
      ["17", "04:37 AM", "5:39 PM", "06 Mar 2026"],
      ["18", "04:35 AM", "5:40 PM", "07 Mar 2026"],
      ["19", "04:34 AM", "5:41 PM", "08 Mar 2026"],
      ["20", "04:33 AM", "5:42 PM", "09 Mar 2026"],
      ["21", "04:32 AM", "5:43 PM", "10 Mar 2026"],
      ["22", "04:30 AM", "5:43 PM", "11 Mar 2026"],
      ["23", "04:29 AM", "5:44 PM", "12 Mar 2026"],
      ["24", "04:28 AM", "5:45 PM", "13 Mar 2026"],
      ["25", "04:26 AM", "5:46 PM", "14 Mar 2026"],
      ["26", "04:25 AM", "5:47 PM", "15 Mar 2026"],
      ["27", "04:23 AM", "5:47 PM", "16 Mar 2026"],
      ["28", "04:22 AM", "5:48 PM", "17 Mar 2026"],
      ["29", "04:21 AM", "5:49 PM", "18 Mar 2026"],
      ["30", "04:19 AM", "5:50 PM", "19 Mar 2026"],
    ];

    final now = DateTime.now();
    List<Map<String, dynamic>> mapped = [];

    for (var row in rawData) {
      final dateStr = row[3];
      final parts = dateStr.split(' ');
      final day = int.parse(parts[0]);
      final monthStr = parts[1];
      final year = int.parse(parts[2]);
      
      final month = _getMonthNumber(monthStr);
      final dt = DateTime(year, month, day);
      
      // Determine weekday
      final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      final weekdayName = weekdays[dt.weekday - 1];
      
      // Check if today
      final isToday = (now.day == day && now.month == month && now.year == year);

      mapped.add({
        'no': row[0].padLeft(2, '0'),
        'seheri': row[1],
        'iftar': row[2],
        'date': '${parts[0]} ${parts[1]}',
        'day': weekdayName,
        'isToday': isToday,
      });
    }

    ramadanData.assignAll(mapped);
  }

  Map<String, String> get todayRamadanData {
    // Default fallback
    Map<String, dynamic> todayItem = ramadanData.isNotEmpty ? ramadanData.first : {
      'date': '18 Feb',
      'day': 'Wednesday',
      'seheri': '04:55 AM',
      'iftar': '5:26 PM'
    };

    // Find actual today
    final found = ramadanData.firstWhere(
      (item) => item['isToday'] == true, 
      orElse: () => todayItem
    );

    return {
      'date': found['date'].toString(),
      'day': found['day'].toString(),
      'seheri': found['seheri'].toString(),
      'iftar': found['iftar'].toString(),
      'location': 'Beirut',
    };
  }

  int _getMonthNumber(String m) {
    switch (m) {
      case 'Jan': return 1;
      case 'Feb': return 2;
      case 'Mar': return 3;
      case 'Apr': return 4;
      case 'May': return 5;
      case 'Jun': return 6;
      case 'Jul': return 7;
      case 'Aug': return 8;
      case 'Sep': return 9;
      case 'Oct': return 10;
      case 'Nov': return 11;
      case 'Dec': return 12;
      default: return 1;
    }
  }
}
