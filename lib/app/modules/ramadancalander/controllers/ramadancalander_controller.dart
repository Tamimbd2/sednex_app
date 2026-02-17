import 'package:get/get.dart';

class RamadancalanderController extends GetxController {
  
  final List<Map<String, dynamic>> ramadanData = List.generate(30, (index) {
    int day = index + 1;
    // Dummy progression for dates and times
    // Assuming Ramadan starts 1st March for demo purposes
    DateTime date = DateTime(2025, 3, 1).add(Duration(days: index));
    // Dummy time progression: Sehri -1 min each day, Iftar +1 min each day
    // Base: Sehri 4:45 AM, Iftar 6:15 PM
    DateTime sehriBase = DateTime(2025, 3, 1, 4, 45).subtract(Duration(minutes: index));
    DateTime iftarBase = DateTime(2025, 3, 1, 18, 15).add(Duration(minutes: index));
    
    // Formatting helper
    String formatTime(DateTime dt) {
      int hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
      if (hour == 0) hour = 12;
      String minute = dt.minute.toString().padLeft(2, '0');
      String period = dt.hour >= 12 ? 'PM' : 'AM';
      return "$hour:$minute $period";
    }

    String formatDate(DateTime dt) {
      List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return "${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]}";
    }

    List<String> days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    String dayName = days[date.weekday % 7];

    return {
      'no': day.toString().padLeft(2, '0'),
      'date': formatDate(date),
      'day': dayName,
      'seheri': formatTime(sehriBase),
      'iftar': formatTime(iftarBase),
      'isToday': day == 3, // Dummy "Today" is 3rd Ramadan
    };
  });

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
