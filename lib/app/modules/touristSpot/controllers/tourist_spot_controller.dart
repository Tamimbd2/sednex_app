import 'package:get/get.dart';

class TouristSpot {
  final String image;
  final String title;
  final String description;

  TouristSpot({
    required this.image,
    required this.title,
    required this.description,
  });
}

class TouristSpotController extends GetxController {
  final List<TouristSpot> touristSpots = [
    TouristSpot(
      image: 'assets/images/tourist1.jpg',
      title: 'Baalbek: Ancient Roman Ruins and Temple Complex',
      description: 'Best-preserved Roman ruins in Lebanon with magnificent Temple of Bacchus and Jupiter.',
    ),
    TouristSpot(
      image: 'assets/images/tourist2.jpg',
      title: 'Jeita Grotto: Stunning Underground Caves',
      description: 'Spectacular limestone caves with stunning formations and boat exploration.',
    ),
    TouristSpot(
      image: 'assets/images/tourist3.jpg',
      title: 'Cedars of God: Ancient Cedar Forest',
      description: 'UNESCO World Heritage site featuring ancient cedar trees and mountain scenery.',
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
