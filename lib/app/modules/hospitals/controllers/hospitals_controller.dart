import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sednexapp/app/services/api_service.dart';

class Hospital {
  final String id;
  final String name;
  final String image;

  Hospital({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class HospitalsController extends GetxController {
  late final ApiService _apiService;
  final isLoading = false.obs;
  final RxList<Hospital> hospitals = <Hospital>[].obs;
  final RxString searchQuery = ''.obs;

  List<Hospital> get filteredHospitals {
    if (searchQuery.value.isEmpty) return hospitals;
    return hospitals
        .where(
          (h) => h.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ApiService>();
    fetchHospitals();
  }

  Future<void> fetchHospitals() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getData(
        'api/sections/hospitals/items',
      );

      if (response.status.hasError) {
        debugPrint('API Error: ${response.statusText}');
        return;
      }

      var body = response.body;
      if (body is String) {
        try {
          body = jsonDecode(body);
        } catch (e) {
          debugPrint('Hospitals JSON parsing failed: $e');
          return;
        }
      }

      final List<dynamic> data = body['items'] ?? [];
      hospitals.value = data.map((h) => Hospital.fromJson(h)).toList();
      debugPrint('Loaded \${hospitals.length} hospitals');
    } catch (e) {
      debugPrint('Error fetching hospitals: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
