import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopController extends GetxController {
  final count = 0.obs;
  
  // Data for Special Offers
  final List<Map<String, dynamic>> specialOffers = [
    {
      "title": "Get Special Offer",
      "subtitle": "Up to 40%",
      "description": "All Services Available | T&C Applied",
      "gradientColors": [Color(0xFF101727), Color(0xFF354152)],
      "image": "https://via.placeholder.com/344x160.png",
    },
    {
      "title": "Flash Sale",
      "subtitle": "Up to 50%",
      "description": "Electronics Only | While Stocks Last",
      "gradientColors": [Color(0xFF59168B), Color(0xFF8200DA)],
      "image": "https://via.placeholder.com/344x160.png",
    },
    {
      "title": "Weekend Deal",
      "subtitle": "Up to 35%",
      "description": "Fashion & Accessories | Free Shipping",
      "gradientColors": [Color(0xFF1E63FF), Color(0xFF3575FF)],
      "image": "https://via.placeholder.com/344x160.png",
    },
  ];

  // Data for Categories
  final List<Map<String, dynamic>> categories = [
    {"name": "Clothes", "icon": Icons.checkroom, "color": Color(0xFFFEF2F2)},
    {"name": "Electronics", "icon": Icons.phone_android, "color": Color(0xFFEFF6FF)},
    {"name": "Shoes", "icon": Icons.hiking, "color": Color(0xFFFFF7ED)},
    {"name": "Watch", "icon": Icons.watch, "color": Color(0xFFFAF5FF)},
    {"name": "Home", "icon": Icons.home, "color": Color(0xFFF0FDF4)},
    {"name": "Gifts", "icon": Icons.card_giftcard, "color": Color(0xFFFDF2F8)},
    {"name": "Food", "icon": Icons.restaurant, "color": Color(0xFFFEFCE8)},
    {"name": "Beauty", "icon": Icons.brush, "color": Color(0xFFFCE7F3)},
    {"name": "Books", "icon": Icons.menu_book, "color": Color(0xFFE0F2FE)},
    {"name": "Baby", "icon": Icons.child_care, "color": Color(0xFFFFF1F2)},
    {"name": "Furniture", "icon": Icons.chair, "color": Color(0xFFF3F4F6)},
    {"name": "Gaming", "icon": Icons.sports_esports, "color": Color(0xFFEEF2FF)},
    {"name": "Automotive", "icon": Icons.directions_car, "color": Color(0xFFF1F5F9)},
    {"name": "Health", "icon": Icons.local_hospital, "color": Color(0xFFE6FFFA)},
    {"name": "Accessories", "icon": Icons.work_outline, "color": Color(0xFFFFFBEB)},
    {"name": "Stationery", "icon": Icons.edit, "color": Color(0xFFF0F9FF)},
    {"name": "Pet Care", "icon": Icons.pets, "color": Color(0xFFFFF7ED)},
    {"name": "Jewelry", "icon": Icons.diamond, "color": Color(0xFFFAF5FF)},
    {"name": "Tools", "icon": Icons.build, "color": Color(0xFFF5F5F4)},
    {"name": "Music", "icon": Icons.music_note, "color": Color(0xFFFDF4FF)},
    {"name": "Office", "icon": Icons.business_center, "color": Color(0xFFEFF6FF)},
    {"name": "Travel", "icon": Icons.flight_takeoff, "color": Color(0xFFF0FDFA)},
  ];

  // Data for Products
  final List<Map<String, dynamic>> products = [
    {
      "name": "Classic White Sneakers",
      "category": "Shoes",
      "price": "৳89.99",
      "originalPrice": "৳129.99",
      "image": "https://via.placeholder.com/164x164.png",
      "isSale": true,
      "saleText": "Sale",
      "saleColor": Color(0xFF1E63FF),
      "rating": 4.5,
      "reviews": 120,
      "description": "Step into comfort and style with these Classic White Sneakers. Made from premium leather, they feature a durable rubber sole and a cushioned insole for all-day wear.",
      "colors": [Color(0xFFFFFFFF), Color(0xFF000000)],
    },
    {
      "name": "Wireless Headphones Pro",
      "category": "Electronics",
      "price": "৳199.99",
      "originalPrice": "",
      "image": "https://via.placeholder.com/164x164.png",
      "isSale": true,
      "saleText": "New",
      "saleColor": Color(0xFF00C853), // Green for New
      "rating": 4.8,
      "reviews": 85,
      "description": "Experience premium sound quality with active noise cancellation. 30-hour battery life, comfortable over-ear design, and premium build quality. Perfect for music lovers and professionals.",
      "images": [
        "https://via.placeholder.com/344x344.png",
        "https://via.placeholder.com/344x344.png", 
        "https://via.placeholder.com/344x344.png"
      ],
      "colors": [Color(0xFF000000), Color(0xFFC0C0C0), Color(0xFF1A237E)],
      "specifications": {
        "Battery Life": "30 hours",
        "Connectivity": "Bluetooth 5.0",
        "Noise Cancellation": "Active ANC",
        "Weight": "250g",
      },
      "seller": {
        "name": "Sednex Store BD",
        "logo": "TSB", // Placeholder for initial if no image
        "rating": 4.8,
      },
    },
    {
      "name": "Smart Watch Series 5",
      "category": "Watch",
      "price": "৳299.99",
      "originalPrice": "৳399.00",
      "image": "https://via.placeholder.com/164x164.png",
      "isSale": true,
      "saleText": "-25%",
      "saleColor": Color(0xFFFFAB00), // Amber for discount percentage
      "rating": 4.7,
      "reviews": 432,
      "description": "Stay connected and active with the Smart Watch Series 5. Features include heart rate monitoring, GPS, water resistance, and a customizable always-on retina display.",
      "colors": [Color(0xFF000000), Color(0xFFE91E63), Color(0xFF2196F3)],
    },
    {
      "name": "Premium Backpack",
      "category": "Accessories",
      "price": "৳59.99",
      "originalPrice": "৳79.99",
      "image": "https://via.placeholder.com/164x164.png",
      "isSale": true,
      "saleText": "-25%",
      "saleColor": Color(0xFFFFAB00),
      "rating": 4.6,
      "reviews": 189,
      "description": "Carry your essentials in style with this Premium Backpack. It offers multiple compartments, a padded laptop sleeve, and ergonomic straps for maximum comfort.",
      "colors": [Color(0xFF3E2723), Color(0xFF212121), Color(0xFF1A237E)],
    },
    {
      "name": "Designer Sunglasses",
      "category": "Accessories",
      "price": "৳149.99",
      "originalPrice": "",
      "image": "https://via.placeholder.com/164x164.png",
      "isSale": true,
      "saleText": "New",
      "saleColor": Color(0xFF00C853),
      "rating": 4.8,
      "reviews": 312,
      "description": "Protect your eyes and look great with these Designer Sunglasses. UV400 protection, lightweight frame, and a trendy design that suits any face shape.",
      "colors": [Color(0xFF000000), Color(0xFF8D6E63)],
    },
    {
      "name": "MacBook Air 13\"",
      "category": "Electronics",
      "price": "৳999.99",
      "originalPrice": "৳1199.99",
      "image": "https://via.placeholder.com/164x164.png",
      "isSale": true,
      "saleText": "-17%",
      "saleColor": Color(0xFFFFAB00),
      "rating": 4.9,
      "reviews": 876,
      "description": "The MacBook Air 13\" combines power and portability. With the M1 chip, 8GB RAM, and 256GB SSD, it handles everything from professional editing to casual browsing with ease.",
      "colors": [Color(0xFFE0E0E0), Color(0xFFBDBDBD), Color(0xFFFFD54F)],
    },
  ];




  void increment() => count.value++;
}

