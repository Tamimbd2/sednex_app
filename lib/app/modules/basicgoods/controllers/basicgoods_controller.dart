import 'package:get/get.dart';
import 'package:sednexapp/app/core/constants/url.dart';

class BasicGood {
  final String id;
  final String name;
  final int price;
  final String icon;
  final String category;
  final DateTime updatedAt;
  final String? pricetag;

  BasicGood({
    required this.id,
    required this.name,
    required this.price,
    required this.icon,
    required this.category,
    required this.updatedAt,
    this.pricetag,
  });

  factory BasicGood.fromJson(Map<String, dynamic> json) {
    return BasicGood(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      icon: json['icon'] ?? '',
      category: json['category'] ?? 'Others',
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      pricetag: json['pricetag'],
    );
  }
}

class BasicgoodsController extends GetxController {
  final _connect = GetConnect();
  final isLoading = false.obs;
  final selectedCategory = 'All'.obs;

  final RxList<BasicGood> allGoods = <BasicGood>[].obs;
  final RxList<String> categories = ['All'].obs;

  List<BasicGood> get filteredGoods {
    if (selectedCategory.value == 'All') {
      return allGoods;
    }
    return allGoods
        .where((good) => good.category == selectedCategory.value)
        .toList();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  Future<void> fetchGoods() async {
    try {
      isLoading.value = true;
      final response = await _connect.get('${AppUrl.baseUrl}api/goods/');

      if (response.status.hasError) {
        Get.snackbar('Error', 'Failed to fetch goods: ${response.statusText}');
        return;
      }

      final List<dynamic> goodsData = response.body['goods'] ?? [];
      allGoods.value = goodsData.map((e) => BasicGood.fromJson(e)).toList();

      // Update categories dynamically from data
      final Set<String> categoriesSet = {'All'};
      for (var good in allGoods) {
        categoriesSet.add(good.category);
      }
      categories.value = categoriesSet.toList();
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String getCurrencySymbol(String? tag) {
    if (tag == null) return '৳';
    switch (tag.toLowerCase()) {
      case 'bdt':
        return '৳';
      case 'usd':
        return '\$';
      case 'lbp':
        return 'ل.ل';
      case 'eur':
        return '€';
      default:
        return tag.toUpperCase();
    }
  }

  String getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchGoods();
  }
}
