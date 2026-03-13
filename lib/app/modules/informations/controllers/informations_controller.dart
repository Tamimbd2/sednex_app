import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceItem {
  final String label;
  final String imagePath;
  final Color backgroundColor;
  final String? route;

  ServiceItem({
    required this.label,
    required this.imagePath,
    required this.backgroundColor,
    this.route,
  });
}

class InformationsController extends GetxController {
  final List<ServiceItem> services = [
    ServiceItem(
      label: 'Embassy',
      imagePath: 'assets/essentialService/embassy.png',
      backgroundColor: const Color(0xFF1E63FF),
      route: '/embassy',
    ),
    ServiceItem(
      label: 'Article',
      imagePath: 'assets/essentialService/article.png',
      backgroundColor: const Color(0xFFFFD700),
      route: '/articles',
    ),
    ServiceItem(
      label: 'Basic Gods',
      imagePath: 'assets/essentialService/basicgoods.png',
      backgroundColor: const Color(0xFF00C853),
      route: '/basicgoods',
    ),
    ServiceItem(
      label: 'Community',
      imagePath: 'assets/essentialService/community.png',
      backgroundColor: const Color(0xFF4169E1),
      route: '/community',
    ),
    ServiceItem(
      label: 'Grocery Store',
      imagePath: 'assets/essentialService/store.png',
      backgroundColor: const Color(0xFF1E63FF),
    ),
    ServiceItem(
      label: 'Tourist spot',
      imagePath: 'assets/essentialService/touristspot.png',
      backgroundColor: const Color(0xFFFFD700),
      route: '/tourist-spot',
    ),
    ServiceItem(
      label: 'Learn Arabic',
      imagePath: 'assets/essentialService/learnarabic.png',
      backgroundColor: const Color(0xFF4169E1),
      route: '/learnarabic',
    ),
    ServiceItem(
      label: 'Restaurants',
      imagePath: 'assets/essentialService/restaurent.png',
      backgroundColor: const Color(0xFF9C27B0),
      route: '/restaurents',
    ),
    ServiceItem(
      label: 'Hospitals',
      imagePath: 'assets/essentialService/hospital.png',
      backgroundColor: const Color(0xFF1E63FF),
      route: '/hospitals',
    ),
    ServiceItem(
      label: 'Local Business',
      imagePath: 'assets/essentialService/Business.png',
      backgroundColor: const Color(0xFFFFD700),
    ),
    ServiceItem(
      label: 'Jewellery shop',
      imagePath: 'assets/essentialService/Jeweller.png',
      backgroundColor: const Color(0xFF00C853),
    ),
    ServiceItem(
      label: 'Clothing shop',
      imagePath: 'assets/essentialService/clothshop.png',
      backgroundColor: const Color(0xFF4169E1),
    ),
  ];

  final List<ServiceItem> mixedServices = [
    ServiceItem(
      label: 'Beirut\nEmbassy',
      imagePath: 'assets/essentialService/embassy.png', // Placeholder
      backgroundColor: Colors.white, // Not used for mixed card style but good to have
      route: '/embassy-details', // Just a placeholder route
    ),
    ServiceItem(
      label: 'US\nEmbassy',
      imagePath: 'assets/essentialService/embassy.png', // Placeholder
      backgroundColor: Colors.white,
      route: '/embassy-details',
    ),
    ServiceItem(
      label: 'Indian\nEmbassy',
      imagePath: 'assets/essentialService/embassy.png', // Placeholder
      backgroundColor: Colors.white,
      route: '/embassy-details',
    ),
    ServiceItem(
      label: 'Dhaka\nKitchen',
      imagePath: 'assets/essentialService/restaurent.png', // Placeholder
      backgroundColor: Colors.white,
      route: '/restaurant-details',
    ),
    ServiceItem(
      label: 'City\nHospital',
      imagePath: 'assets/essentialService/hospital.png', // Placeholder
      backgroundColor: Colors.white,
      route: '/hospital-details',
    ),
  ];



}


