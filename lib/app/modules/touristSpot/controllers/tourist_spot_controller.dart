import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sednexapp/app/core/constants/url.dart';

class TouristSpot {
  final String id;
  final String image;
  final String title;
  final String description;

  TouristSpot({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
  });

  factory TouristSpot.fromJson(Map<String, dynamic> json) {
    return TouristSpot(
      id: json['_id'] ?? '',
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class TouristSpotController extends GetxController {
  final _connect = GetConnect();
  final RxList<TouristSpot> touristSpots = <TouristSpot>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTouristSpots();
  }

  Future<void> fetchTouristSpots() async {
    try {
      isLoading.value = true;
      final response = await _connect.get('${AppUrl.baseUrl}api/tourist/');

      if (response.status.hasError) {
        debugPrint('API Error: ${response.statusText}');
        return;
      }

      var body = response.body;
      if (body is String) {
        try {
          body = jsonDecode(body);
        } catch (e) {
          debugPrint('TouristSpot JSON parsing failed: $e');
          return;
        }
      }

      final List<dynamic> data = body['spots'] ?? [];
      touristSpots.value = data.map((e) => TouristSpot.fromJson(e)).toList();
      debugPrint('Loaded ${touristSpots.length} tourist spots');
    } catch (e) {
      debugPrint('Error fetching tourist spots: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
