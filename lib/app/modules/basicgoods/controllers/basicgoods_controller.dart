import 'package:get/get.dart';

class BasicGood {
  final String name;
  final String unit;
  final int price;
  final String updatedTime;
  final String emoji;
  final String category;

  BasicGood({
    required this.name,
    required this.unit,
    required this.price,
    required this.updatedTime,
    required this.emoji,
    required this.category,
  });
}

class BasicgoodsController extends GetxController {
  final selectedCategory = 'All'.obs;

  final List<String> categories = [
    'All',
    'Vegetables',
    'Rice',
    'Oil',
    'Fish',
  ];

  final List<BasicGood> allGoods = [
    BasicGood(
      name: 'Onion',
      unit: 'per kg',
      price: 55,
      updatedTime: '2 hours ago',
      emoji: '🧅',
      category: 'Vegetables',
    ),
    BasicGood(
      name: 'Potato',
      unit: 'per kg',
      price: 40,
      updatedTime: '2 hours ago',
      emoji: '🥔',
      category: 'Vegetables',
    ),
    BasicGood(
      name: 'Rice (Miniket)',
      unit: 'per kg',
      price: 68,
      updatedTime: '3 hours ago',
      emoji: '🍚',
      category: 'Rice',
    ),
    BasicGood(
      name: 'Rice (Nazirshail)',
      unit: 'per kg',
      price: 75,
      updatedTime: '3 hours ago',
      emoji: '🍚',
      category: 'Rice',
    ),
    BasicGood(
      name: 'Soybean Oil',
      unit: 'per litre',
      price: 190,
      updatedTime: '1 hour ago',
      emoji: '🛢️',
      category: 'Oil',
    ),
    BasicGood(
      name: 'Mustard Oil',
      unit: 'per litre',
      price: 220,
      updatedTime: '1 hour ago',
      emoji: '🛢️',
      category: 'Oil',
    ),
    BasicGood(
      name: 'Hilsa Fish',
      unit: 'per kg',
      price: 1200,
      updatedTime: '4 hours ago',
      emoji: '🐟',
      category: 'Fish',
    ),
    BasicGood(
      name: 'Rui Fish',
      unit: 'per kg',
      price: 350,
      updatedTime: '4 hours ago',
      emoji: '🐟',
      category: 'Fish',
    ),
    BasicGood(
      name: 'Egg',
      unit: 'per pcs',
      price: 12,
      updatedTime: '5 hours ago',
      emoji: '🥚',
      category: 'Vegetables',
    ),
    BasicGood(
      name: 'Bread',
      unit: 'per pcs',
      price: 45,
      updatedTime: '6 hours ago',
      emoji: '🍞',
      category: 'Vegetables',
    ),
    BasicGood(
      name: 'Milk',
      unit: 'per litre',
      price: 75,
      updatedTime: '3 hours ago',
      emoji: '🥛',
      category: 'Vegetables',
    ),
    BasicGood(
      name: 'Green Chili',
      unit: 'per kg',
      price: 120,
      updatedTime: '2 hours ago',
      emoji: '🌶️',
      category: 'Vegetables',
    ),
    BasicGood(
      name: 'Tomato',
      unit: 'per kg',
      price: 80,
      updatedTime: '2 hours ago',
      emoji: '🍅',
      category: 'Vegetables',
    ),
    BasicGood(
      name: 'Carrot',
      unit: 'per kg',
      price: 60,
      updatedTime: '2 hours ago',
      emoji: '🥕',
      category: 'Vegetables',
    ),
  ];

  List<BasicGood> get filteredGoods {
    if (selectedCategory.value == 'All') {
      return allGoods;
    }
    return allGoods.where((good) => good.category == selectedCategory.value).toList();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    update(); // Trigger GetBuilder rebuild
  }

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
