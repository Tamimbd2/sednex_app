import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sednexapp/app/core/constants/url.dart';

class ServiceItem {
  final String label;
  final String imagePath;
  final Color backgroundColor;
  final String? route;
  final dynamic arguments;

  ServiceItem({
    required this.label,
    required this.imagePath,
    required this.backgroundColor,
    this.route,
    this.arguments,
  });
}

// Unified model for "All" section cards from live APIs
class MixedCard {
  final String id;
  final String name;
  final String image;
  final String type; // 'embassy' | 'hospital' | 'restaurant' | 'organization'

  MixedCard({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
  });
}

class InformationsController extends GetxController {
  final _connect = GetConnect();
  final _box = GetStorage();
  final searchQuery = ''.obs;
  final isLoadingMixed = false.obs;
  final RxList<MixedCard> mixedCards = <MixedCard>[].obs;

  String get _token =>
      _box.read('token') ??
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OWE2NDc4NGFiMjQ3YTI0NTc2MGIxOGIiLCJlbWFpbCI6IlNha2liQHNlZG5leC5jb20iLCJyb2xlIjoiYWRtaW4iLCJpYXQiOjE3NzQ4NzkwNzUsImV4cCI6MTc3NTQ4Mzg3NX0.SYIpSj3uqab2J8EciPMW0nmb77xe-ld0NHruVyU1Ojs';

  final List<ServiceItem> services = [
    ServiceItem(
      label: 'embassies',
      imagePath: 'assets/newessential/City-Hall--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFF9C27B0),
      route: '/embassy',
    ),
    ServiceItem(
      label: 'articles',
      imagePath: 'assets/newessential/Multiple-File-2--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFF00BFA5),
      route: '/articles',
    ),
    ServiceItem(
      label: 'basic_goods',
      imagePath: 'assets/newessential/Shopping-Basket-2--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFF448AFF),
      route: '/basicgoods',
    ),
    ServiceItem(
      label: 'community',
      imagePath: 'assets/newessential/User-Multiple-Group--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFF4CAF50),
      route: '/community',
    ),
    ServiceItem(
      label: 'grocery_store',
      imagePath: 'assets/newessential/Store-1--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFFFF9800),
      route: '/general-section',
      arguments: {'slug': 'grocery-store', 'title': 'Grocery Store'},
    ),
    ServiceItem(
      label: 'tourist_spots',
      imagePath: 'assets/newessential/Beach--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFF00BCD4),
      route: '/tourist-spot',
    ),
    ServiceItem(
      label: 'learn_arabic',
      imagePath: 'assets/newessential/Dictionary-Language-Book--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFF795548),
      route: '/learnarabic',
    ),
    ServiceItem(
      label: 'restaurants',
      imagePath: 'assets/newessential/Fork-Knife--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFFE91E63),
      route: '/restaurents',
    ),
    ServiceItem(
      label: 'hospitals',
      imagePath: 'assets/newessential/Ambulance--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFFE53935),
      route: '/hospitals',
    ),
    ServiceItem(
      label: 'local_business',
      imagePath: 'assets/newessential/Briefcase-Dollar--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFFFFD700),
      route: '/general-section',
      arguments: {'slug': 'local-business', 'title': 'Local Business'},
    ),
    ServiceItem(
      label: 'jewellery_shop',
      imagePath: 'assets/newessential/Gift-2--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFF00C853),
      route: '/general-section',
      arguments: {'slug': 'jewellery-shop', 'title': 'Jewellery shop'},
    ),
    ServiceItem(
      label: 'clothing_shop',
      imagePath: 'assets/newessential/Shopping-Bag-Hand-Bag-2--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFF4169E1),
      route: '/general-section',
      arguments: {'slug': 'clothing-shop', 'title': 'Clothing shop'},
    ),
    ServiceItem(
      label: 'organizations',
      imagePath: 'assets/newessential/Business-Profession-Home-Office--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFF3F51B5),
      route: '/organization',
    ),
    ServiceItem(
      label: 'sports_team',
      imagePath: 'assets/newessential/Flash-3--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFF8BC34A),
      route: '/general-section',
      arguments: {'slug': 'sports-team', 'title': 'Sports team'},
    ),
    ServiceItem(
      label: 'drivers',
      imagePath: 'assets/newessential/Car-Taxi-1--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFFFFEB3B),
      route: '/general-section',
      arguments: {'slug': 'texi-driver', 'title': 'Taxi Drivers'},
    ),
    ServiceItem(
      label: 'businessman',
      imagePath: 'assets/newessential/Necktie--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFF607D8B),
      route: '/general-section',
      arguments: {'slug': 'businessman', 'title': 'Businessman'},
    ),
    ServiceItem(
      label: 'influencer',
      imagePath: 'assets/newessential/Megaphone-2--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFFE91E63),
      route: '/general-section',
      arguments: {'slug': 'influencer', 'title': 'Influencer'},
    ),
    ServiceItem(
      label: 'local_market',
      imagePath: 'assets/newessential/Shopping-Cart-1--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFFFF5722),
      route: '/general-section',
      arguments: {'slug': 'local-market', 'title': 'Local Market'},
    ),
    ServiceItem(
      label: 'pharmacy',
      imagePath: 'assets/newessential/Tablet-Capsule--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFF009688),
      route: '/general-section',
      arguments: {'slug': 'pharmacy', 'title': 'Pharmacy'},
    ),
    ServiceItem(
      label: 'ngo',
      imagePath: 'assets/newessential/Decent-Work-And-Economic-Growth--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFF4CAF50),
      route: '/general-section',
      arguments: {'slug': 'ngo', 'title': 'NGO'},
    ),
    ServiceItem(
      label: 'bus_flight_booking',
      imagePath: 'assets/newessential/Bus--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFF2196F3),
      route: '/busflight',
    ),
    ServiceItem(
      label: 'local_tours',
      imagePath: 'assets/newessential/Location-Pin-3--Streamline-Core-Gradient.svg',
      backgroundColor: const Color(0xFF00BCD4),
      route: '/localtour',
    ),
    ServiceItem(
      label: 'maker',
      imagePath: 'assets/newessential/Shield-.svg',
      backgroundColor: const Color(0xFF1565C0),
      route: '/general-section',
      arguments: {'slug': 'maker', 'title': 'Maker'},
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _fetchAllMixed();
  }

  Future<void> _fetchAllMixed() async {
    isLoadingMixed.value = true;
    try {
      final results = await Future.wait([
        _fetchItems('embassy'),
        _fetchItems('hospitals'),
        _fetchItems('restaurents'),
        _fetchItems('organization'),
      ]);

      final all = <MixedCard>[];
      for (final list in results) {
        all.addAll(list);
      }

      // Shuffle randomly each visit
      all.shuffle(Random());
      mixedCards.value = all;
    } catch (e) {
      debugPrint('Mixed fetch error: $e');
    } finally {
      isLoadingMixed.value = false;
    }
  }

  Future<List<MixedCard>> _fetchItems(String slug) async {
    try {
      final response = await _connect.get(
        '${AppUrl.baseUrl}api/sections/$slug/items',
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.status.hasError) return [];
      var body = response.body;
      if (body is String) {
        try { body = jsonDecode(body); } catch (_) { return []; }
      }
      final List data = body['items'] ?? [];
      return data.map((item) => MixedCard(
        id: item['_id'] ?? '',
        name: item['name'] ?? '',
        image: item['image'] ?? '',
        type: slug,
      )).toList();
    } catch (_) {
      return [];
    }
  }

  // Filtered lists for search
  List<ServiceItem> get filteredServices {
    if (searchQuery.value.isEmpty) return services;
    return services
        .where((s) => s.label.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  List<MixedCard> get filteredMixedCards {
    if (searchQuery.value.isEmpty) return mixedCards;
    return mixedCards
        .where((c) => c.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  // Returns only first 6 for 2-row display (3 columns × 2 rows)
  List<MixedCard> get previewCards {
    final list = filteredMixedCards;
    return list.length > 6 ? list.sublist(0, 6) : list;
  }
}
