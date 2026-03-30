import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';

class ShopController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  final count = 0.obs;
  final isLoading = false.obs;
  final isCategoriesLoading = false.obs;
  final categories = <Map<String, dynamic>>[].obs;
  final products = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts();
  }

  Future<void> fetchCategories() async {
    try {
      isCategoriesLoading.value = true;
      final response = await _apiService.getData('api/categories/');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.body['categories'];
        final fetchedCategories = data.map((item) {
          final name = item['name'] ?? 'General';
          return {
            "id": item['_id'],
            "name": name,
            "slug": item['slug'],
            "icon": _getCategoryIcon(name),
            "color": _getCategoryColor(name),
          };
        }).toList();
        
        categories.assignAll(fetchedCategories);
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    } finally {
      isCategoriesLoading.value = false;
    }
  }

  IconData _getCategoryIcon(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('dress') || lowerName.contains('cloth')) return Icons.checkroom;
    if (lowerName.contains('electronic') || lowerName.contains('tech')) return Icons.phone_android;
    if (lowerName.contains('shoe')) return Icons.hiking;
    if (lowerName.contains('health')) return Icons.local_hospital;
    if (lowerName.contains('jewel')) return Icons.diamond;
    if (lowerName.contains('cycle')) return Icons.directions_bike;
    if (lowerName.contains('peripherals')) return Icons.mouse;
    if (lowerName.contains('watch')) return Icons.watch;
    if (lowerName.contains('home')) return Icons.home;
    if (lowerName.contains('gift')) return Icons.card_giftcard;
    if (lowerName.contains('food')) return Icons.restaurant;
    if (lowerName.contains('beauty')) return Icons.brush;
    return Icons.category; // Default icon
  }

  Color _getCategoryColor(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('dress')) return const Color(0xFFFEF2F2);
    if (lowerName.contains('electronic')) return const Color(0xFFEFF6FF);
    if (lowerName.contains('health')) return const Color(0xFFE6FFFA);
    if (lowerName.contains('jewel')) return const Color(0xFFFAF5FF);
    if (lowerName.contains('shoe')) return const Color(0xFFFFF7ED);
    if (lowerName.contains('cycle')) return const Color(0xFFF0FDF4);
    if (lowerName.contains('tech')) return const Color(0xFFE0F2FE);
    if (lowerName.contains('peripherals')) return const Color(0xFFEEF2FF);
    return const Color(0xFFF3F4F6); // Default color
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getData('api/products/');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.body['products'];
        final fetchedProducts = (data).map((item) {
          try {
            final price = item['price'] ?? 0;
            final discountPrice = item['discountPrice'];
            
            return {
              ...item as Map<String, dynamic>,
              "id": item['_id'],
              "name": item['name'] ?? 'No Name',
              "category": item['category'] is Map ? (item['category']['name'] ?? 'General') : 'General',
              "price": "৳$price",
              "originalPrice": discountPrice != null ? "৳${(price is num ? price : 0) + 50}" : "", 
              "image": (item['images'] != null && (item['images'] as List).isNotEmpty) 
                  ? item['images'][0] 
                  : "https://via.placeholder.com/164x164.png",
              "isSale": discountPrice != null,
              "saleText": discountPrice != null ? "Sale" : "New",
              "saleColor": discountPrice != null ? const Color(0xFF1E63FF) : const Color(0xFF00C853),
              "rating": 4.5, 
              "reviews": 120,
              "description": item['description'] ?? '',
              "colors": [const Color(0xFFFFFFFF), const Color(0xFF000000)],
              "whatsappUrl": item['whatsappUrl'] != null && (item['whatsappUrl'] as String).contains('wa.me/0')
                  ? (item['whatsappUrl'] as String).replaceFirst('wa.me/0', 'wa.me/880')
                  : item['whatsappUrl'],
            };
          } catch (e) {
            debugPrint("Error mapping product: $e");
            return <String, dynamic>{};
          }
        }).where((p) => p.isNotEmpty).cast<Map<String, dynamic>>().toList();
        
        products.assignAll(fetchedProducts);
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void increment() => count.value++;
}

