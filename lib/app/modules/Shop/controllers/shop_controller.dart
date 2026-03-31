import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/api_service.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class ShopController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final _box = GetStorage();
  
  final count = 0.obs;
  final isLoading = false.obs;
  final isCategoriesLoading = false.obs;
  final categories = <Map<String, dynamic>>[].obs;
  final products = <Map<String, dynamic>>[].obs;
  final favoriteIds = <String>{}.obs;

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

  Future<void> fetchFavoriteIds() async {
    try {
      final response = await _apiService.getData('api/products/love/');
      if (response.statusCode == 200) {
        final dynamic body = response.body;
        List<dynamic> items = [];
        if (body is Map && body['products'] is List) {
          items = body['products'];
        } else if (body is List) {
          items = body;
        }
        
        final ids = items.map((item) => item['_id']?.toString() ?? '').where((id) => id.isNotEmpty).toSet();
        favoriteIds.assignAll(ids);
        debugPrint("Fetched ${favoriteIds.length} favorited IDs");
      }
    } catch (e) {
      debugPrint("Error fetching favorite IDs: $e");
    }
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      await fetchFavoriteIds();
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

        final rawUser = _box.read('user');
        Map<String, dynamic>? userMap;
        if (rawUser != null) {
          try {
            final decoded = rawUser is String ? jsonDecode(rawUser) : rawUser;
            userMap = Map<String, dynamic>.from(decoded is Map ? decoded : {});
          } catch (e) {
            debugPrint("Error decoding user in shop: $e");
          }
        }
        final currentUserId = userMap?['_id']?.toString();
        debugPrint("Current User ID in Shop: $currentUserId");
        
        final fetchedProducts = data.map((item) {
          try {
            final productMap = Map<String, dynamic>.from(item is Map ? item : {});
            final productId = productMap['_id']?.toString() ?? '';
            final price = productMap['price'] ?? 0;
            final discountPrice = productMap['discountPrice'];
            
            final likedBy = productMap['likedBy'] is List ? productMap['likedBy'] as List : [];
            final serverSaysLoved = currentUserId != null && 
                likedBy.any((id) => id.toString().trim() == currentUserId.trim());
            
            final isLoved = serverSaysLoved || favoriteIds.contains(productId);
            
            if (isLoved) {
              debugPrint("Product ${productMap['name']} is marked as LOVED (ID: $productId)");
            }
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
              "id": productId,
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
          // Revert if API failed
          products[index] = product;
          products.refresh();
          Get.snackbar('Notice', 'You must be logged in to save products.');
        } else {
          final data = response.body;
          debugPrint("Love API Success: $data");
          if (data['success'] == true) {
            final isNowLoved = data['loved'];
            if (isNowLoved == true) {
              favoriteIds.add(productId);
            } else {
              favoriteIds.remove(productId);
            }
            
            products[index] = {
              ...products[index],
              'isLoved': isNowLoved,
              'loveCount': data['loveCount'],
            };
            products.refresh();
            
            // Refresh Dashboard loved products to update the Cart count and screen immediately
            try {
              final dashboardController = Get.find<DashboardController>();
              dashboardController.fetchLovedProducts();
            } catch (e) {
              debugPrint("DashboardController not found during toggleLove");
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error toggling save feature: $e");
    }
  }

  void increment() => count.value++;
}

