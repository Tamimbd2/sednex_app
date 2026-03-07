import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Contact {
  final String phone;
  final String email;
  final String website;
  final String address;

  Contact({
    required this.phone,
    required this.email,
    required this.website,
    required this.address,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      address: json['address'] ?? '',
    );
  }
}

class Embassy {
  final String id;
  final String name;
  final String icon;
  final String category;
  final String about;
  final Contact contact;
  final List<String> services;
  final List<String> offDays;

  Embassy({
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
    required this.about,
    required this.contact,
    required this.services,
    required this.offDays,
  });

  factory Embassy.fromJson(Map<String, dynamic> json) {
    return Embassy(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      icon: json['image'] ?? json['icon'] ?? '',
      category: json['category'] ?? 'Embassy',
      about: json['about'] ?? json['description'] ?? '',
      contact: Contact.fromJson(json['contact'] ?? {}),
      services: List<String>.from(json['services'] ?? []),
      offDays: List<String>.from(json['offDays'] ?? []),
    );
  }
}

class EmbassyController extends GetxController {
  final _connect = GetConnect();
  final _box = GetStorage();
  final isLoading = false.obs;
  final RxList<Embassy> embassies = <Embassy>[].obs;
  final RxString searchQuery = ''.obs;

  List<Embassy> get filteredEmbassies {
    if (searchQuery.value.isEmpty) return embassies;
    return embassies.where((e) => 
      e.name.toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }
  @override
  void onInit() {
    super.onInit();
    fetchEmbassies();
  }

  Future<void> fetchEmbassies() async {
    try {
      isLoading.value = true;
      final token = _box.read('token');
      
      final response = await _connect.get(
        'https://sednex-zvk1.onrender.com/api/sections/embassy/items',
        headers: {
          'Authorization': 'Bearer ${token ?? "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OTk5MzhmYjViNWJjMmM1YjEyMzYyY2QiLCJlbWFpbCI6ImFmc2FyQHNlZG5leC5jb20iLCJyb2xlIjoidXNlciIsImlhdCI6MTc3Mjg2MTYzMiwiZXhwIjoxNzczNDY2NDMyfQ.PuRUjybyM9EzP2ICL0X_SXoSx8PwDOlJh0XrSi5fiwU"}'
        },
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
          debugPrint('Embassy JSON parsing failed: $e');
          return;
        }
      }

      final List<dynamic> data = body['items'] ?? [];
      embassies.value = data.map((e) => Embassy.fromJson(e)).toList();
      debugPrint('Loaded ${embassies.length} embassies');

    } catch (e) {
      debugPrint('Error fetching embassies: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

