import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sednexapp/app/core/constants/url.dart';

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
  final _connect = GetConnect();
  final _box = GetStorage();
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
    fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {
    try {
      isLoading.value = true;
      final token = _box.read('token');

      final response = await _connect.get(
        '${AppUrl.baseUrl}api/sections/organization/items',
        headers: {
          'Authorization':
              'Bearer ${token ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OWE2NDc4NGFiMjQ3YTI0NTc2MGIxOGIiLCJlbWFpbCI6IlNha2liQHNlZG5leC5jb20iLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3NzQ4NzkwNzUsImV4cCI6MTc3NTQ4Mzg3NX0.SYIpSj3uqab2J8EciPMW0nmb77xe-ld0NHruVyU1Ojs"}',
        },
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
