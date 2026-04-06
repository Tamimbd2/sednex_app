import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sednexapp/app/core/constants/url.dart';

class SectionContact {
  final String phone;
  final String email;
  final String website;
  final String address;

  SectionContact({
    required this.phone,
    required this.email,
    required this.website,
    required this.address,
  });

  factory SectionContact.fromJson(Map<String, dynamic> json) {
    return SectionContact(
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      address: json['address'] ?? '',
    );
  }
}

class SectionItem {
  final String id;
  final String name;
  final String image;
  final String? category;
  final String about;
  final SectionContact contact;
  final List<String> services;
  final List<String> offDays;

  SectionItem({
    required this.id,
    required this.name,
    required this.image,
    this.category,
    required this.about,
    required this.contact,
    required this.services,
    required this.offDays,
  });

  factory SectionItem.fromJson(Map<String, dynamic> json) {
    return SectionItem(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? json['icon'] ?? '',
      category: json['category'],
      about: json['about'] ?? json['description'] ?? '',
      contact: SectionContact.fromJson(json['contact'] ?? {}),
      services: List<String>.from(json['services'] ?? []),
      offDays: List<String>.from(json['offDays'] ?? []),
    );
  }
}

class GeneralSectionController extends GetxController {
  final _connect = GetConnect();
  final _box = GetStorage();
  final isLoading = false.obs;
  final RxList<SectionItem> items = <SectionItem>[].obs;
  final RxString searchQuery = ''.obs;
  
  late String slug;
  late String title;

  List<SectionItem> get filteredItems {
    if (searchQuery.value.isEmpty) return items;
    return items
        .where(
          (e) => e.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    slug = Get.arguments['slug'] ?? 'embassy';
    title = Get.arguments['title'] ?? 'Section';
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      isLoading.value = true;
      final token = _box.read('token');

      // Default fallback token as seen in other controllers
      final authToken = token ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OWE2NDc4NGFiMjQ3YTI0NTc2MGIxOGIiLCJlbWFpbCI6IlNha2liQHNlZG5leC5jb20iLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3NzQ4NzkwNzUsImV4cCI6MTc3NTQ4Mzg3NX0.SYIpSj3uqab2J8EciPMW0nmb77xe-ld0NHruVyU1Ojs";

      final response = await _connect.get(
        '${AppUrl.baseUrl}api/sections/$slug/items',
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.status.hasError) {
        debugPrint('$title API Error: ${response.statusText}');
        // If there's an error, clear items
        items.clear();
        return;
      }

      var body = response.body;
      if (body is String) {
        try {
          body = jsonDecode(body);
        } catch (e) {
          debugPrint('$title JSON parsing failed: $e');
          return;
        }
      }

      final List<dynamic> data = body['items'] ?? [];
      items.value = data.map((e) => SectionItem.fromJson(e)).toList();
      debugPrint('Loaded ${items.length} items for $slug');
    } catch (e) {
      debugPrint('Error fetching items for $slug: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
