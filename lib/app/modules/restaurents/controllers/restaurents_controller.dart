import 'package:get/get.dart';

class Restaurant {
  final String name;
  final String logoPath;

  Restaurant({required this.name, required this.logoPath});
}

class RestaurentsController extends GetxController {
  final List<Restaurant> restaurants = [
    Restaurant(name: 'Al-Saha\nRestaurant', logoPath: 'assets/restaurant/alsaha.png'),
    Restaurant(name: 'Zaatar W Zeit', logoPath: 'assets/restaurant/zaatar.png'),
    Restaurant(name: 'Barbar\nRestaurant', logoPath: 'assets/restaurant/barbar.png'),
    Restaurant(name: 'Em Sherif\nRestaurant', logoPath: 'assets/restaurant/emsherif.png'),
    Restaurant(name: 'Tawlet\nRestaurant', logoPath: 'assets/restaurant/tawlet.png'),
    Restaurant(name: 'Babel Bay\nRestaurant', logoPath: 'assets/restaurant/babelbay.png'),
    Restaurant(name: 'Al-Saha\nRestaurant', logoPath: 'assets/restaurant/alsaha.png'),
    Restaurant(name: 'Zaatar W Zeit', logoPath: 'assets/restaurant/zaatar.png'),
    Restaurant(name: 'Barbar\nRestaurant', logoPath: 'assets/restaurant/barbar.png'),
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
