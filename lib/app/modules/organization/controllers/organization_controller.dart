import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sednexapp/app/services/api_service.dart';

class Organization {
  final String id;
  final String name;
  final String image;

  Organization({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class OrganizationController extends GetxController {
  late final ApiService _apiService;
  final isLoading = false.obs;
  final RxList<Organization> organizations = <Organization>[].obs;
  final RxString searchQuery = ''.obs;

  List<Organization> get filteredOrganizations {
    if (searchQuery.value.isEmpty) return organizations;
    return organizations
        .where(
          (o) => o.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ApiService>();
    fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getData(
        'api/sections/organization/items',
      );

      if (response.status.hasError) {
        debugPrint('Organizations API Error: ${response.statusText}');
        return;
      }

      var body = response.body;
      if (body is String) {
        try {
          body = jsonDecode(body);
        } catch (e) {
          debugPrint('Organizations JSON parsing failed: $e');
          return;
        }
      }

      final List<dynamic> data = body['items'] ?? [];
      organizations.value =
          data.map((o) => Organization.fromJson(o)).toList();
      debugPrint('Loaded \${organizations.length} organizations');
    } catch (e) {
      debugPrint('Error fetching organizations: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
