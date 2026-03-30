import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/api_service.dart';

class ShopController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final _box = GetStorage();
  
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
        final dynamic body = response.body;
        debugPrint("API Response Body: $body");
        List<dynamic> data = [];

        if (body is Map && body.containsKey('products')) {
          data = body['products'] is List ? body['products'] : [];
        } else if (body is List) {
          data = body;
        } else {
          debugPrint("Unexpected response format: ${body.runtimeType}");
        }

        final currentUser = _box.read('user');
        final currentUserId = (currentUser is Map) ? currentUser['_id'] : null;

        final fetchedProducts = data.map((item) {
          try {
            final productMap = Map<String, dynamic>.from(item is Map ? item : {});
            final price = productMap['price'] ?? 0;
            final discountPrice = productMap['discountPrice'];
            
            final likedBy = productMap['likedBy'] is List ? productMap['likedBy'] as List : [];
            final isLoved = currentUserId != null && likedBy.contains(currentUserId);
            
            final images = productMap['images'];
            final imageUrl = (images is List && images.isNotEmpty) 
                ? images[0].toString() 
                : "https://via.placeholder.com/164x164.png";

            final String? whatsappUrl = productMap['whatsappUrl']?.toString();
            final safeWhatsappUrl = (whatsappUrl != null && whatsappUrl.contains('wa.me/0'))
                ? whatsappUrl.replaceFirst('wa.me/0', 'wa.me/880')
                : whatsappUrl;
            
            return {
              ...productMap,
              "id": productMap['_id'],
              "name": productMap['name']?.toString() ?? 'No Name',
              "category": productMap['category'] is Map ? (productMap['category']['name'] ?? 'General') : 'General',
              "price": "৳$price",
              "originalPrice": discountPrice != null ? "৳${(price is num ? price : 0) + 50}" : "", 
              "image": imageUrl,
              "isSale": discountPrice != null,
              "saleText": discountPrice != null ? "Sale" : "New",
              "saleColor": discountPrice != null ? const Color(0xFF1E63FF) : const Color(0xFF00C853),
              "rating": 4.5, 
              "reviews": 120,
              "description": productMap['description']?.toString() ?? '',
              "isLoved": isLoved,
              "colors": [const Color(0xFFFFFFFF), const Color(0xFF000000)],
              "whatsappUrl": safeWhatsappUrl,
            };
          } catch (e, stack) {
            debugPrint("Error mapping product: $e\n$stack");
            return <String, dynamic>{};
          }
        }).where((p) => p.isNotEmpty).cast<Map<String, dynamic>>().toList();
        
        debugPrint("API Products total: ${data.length}, Mapped: ${fetchedProducts.length}");
        products.assignAll(fetchedProducts);
      } else {
        debugPrint("Failed to fetch products: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching products entirely: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleLove(String productId) async {
    debugPrint("Toggle Love called for product: $productId");
    try {
      final index = products.indexWhere((p) => p['id'] == productId);
      if (index != -1) {
        final product = products[index];
        final bool currentlyLoved = product['isLoved'] ?? false;
        
        // Optimistic UI Update: change immediately
        products[index] = {
          ...product,
          'isLoved': !currentlyLoved,
          'loveCount': currentlyLoved ? (product['loveCount'] ?? 1) - 1 : (product['loveCount'] ?? 0) + 1,
        };
        products.refresh();

        // Make API Call using patchData
        final path = 'api/products/$productId/love';
        debugPrint("Calling PATCH: $path");
        final response = await _apiService.patchData(path, {});
        
        if (response.statusCode != 200) {
          debugPrint("Love API Failed: ${response.statusCode} - ${response.statusText}");
          // Revert if API failed (e.g., unauthorized)
          products[index] = product;
          products.refresh();
          Get.snackbar('Notice', 'You must be logged in to save products.');
        } else {
          // Sync with true backend response just to be sure
          final data = response.body;
          debugPrint("Love API Success: $data");
          if (data['success'] == true) {
            products[index] = {
              ...products[index],
              'isLoved': data['loved'],
              'loveCount': data['loveCount'],
            };
            products.refresh();
          }
        }
      }
    } catch (e) {
      debugPrint("Error toggling save feature: $e");
    }
  }

  void increment() => count.value++;
}

