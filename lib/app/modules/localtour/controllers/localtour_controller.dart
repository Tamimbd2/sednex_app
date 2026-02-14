import 'package:get/get.dart';

class LocalTour {
  final String image;
  final String title;
  final String date;
  final String time;
  final String location;

  LocalTour({
    required this.image,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
  });
}

class LocaltourController extends GetxController {
  final List<LocalTour> tours = [
    LocalTour(
      image: 'assets/images/tour1.jpg',
      title: 'Beirut to Tripoli Tour',
      date: '5 Feb 2026',
      time: '7:00 AM – 7:00 PM',
      location: 'Beirut → Tripoli',
    ),
    LocalTour(
      image: 'assets/images/tour2.jpg',
      title: 'Scenic Mountain Bus Tour',
      date: '8 Feb 2026',
      time: '6:00 AM – 8:00 PM',
      location: 'Beirut → Byblos → Cedars',
    ),
    LocalTour(
      image: 'assets/images/tour3.jpg',
      title: 'Coastal Exploration Tour',
      date: '12 Feb 2026',
      time: '8:00 AM – 6:00 PM',
      location: 'Beirut → Sidon → Tyre',
    ),
  ];

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
