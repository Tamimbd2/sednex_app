import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sednexapp/app/services/api_service.dart';

class Restaurant {
  final String id;
  final String name;
  final String image;

  Restaurant({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class RestaurentsController extends GetxController {
  late final ApiService _apiService;
  final isLoading = false.obs;
  final RxList<Restaurant> restaurants = <Restaurant>[].obs;
  final RxString searchQuery = ''.obs;

  List<Restaurant> get filteredRestaurants {
    if (searchQuery.value.isEmpty) return restaurants;
    return restaurants
        .where(
          (r) => r.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ApiService>();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getData(
        'api/sections/restaurents/items',
      );

      if (response.status.hasError) {
        debugPrint('Restaurants API Error: ${response.statusText}');
        return;
      }

      var body = response.body;
      if (body is String) {
        try {
          body = jsonDecode(body);
        } catch (e) {
          debugPrint('Restaurants JSON parsing failed: $e');
          return;
        }
      }

      final List<dynamic> data = body['items'] ?? [];
      restaurants.value = data.map((r) => Restaurant.fromJson(r)).toList();
      debugPrint('Loaded \${restaurants.length} restaurants');
    } catch (e) {
      debugPrint('Error fetching restaurants: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
