import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';

class DashboardController extends GetxController {
  // Current selected index for bottom navigation
  final currentIndex = 0.obs;
  
  final apiService = Get.find<ApiService>();
  var marqueeText = 'Welcome to SedNex!'.obs; // Default text
  var bannerList = <String>[].obs; // Hero Banner URLs
  var currentBannerIndex = 0.obs;
  final bannerPageController = PageController();
  
  var servicesList = <dynamic>[].obs; // Dynamic Services List

  var isMarqueeLoading = false.obs;
  Timer? _marqueeTimer;
  Timer? _bannerTimer;

  @override
  void onInit() {
    super.onInit();
    fetchMarqueeText();
    fetchBanner();
    fetchServices();
    // Poll every 30 seconds for real-time updates
    _marqueeTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchMarqueeText();
    });
  }

  void fetchServices() async {
    try {
      final connect = GetConnect();
      final response = await connect.get('https://sednex-zvk1.onrender.com/api/homepage/services');
      
      if (response.statusCode == 200) {
        var body = response.body;
        if (body is String) {
          try {
             body = jsonDecode(body);
          } catch(e) {
             print('Services JSON error: $e');
             return;
          }
        }
        
        List items = [];
        if (body is List) {
           items = body;
        } else if (body is Map) {
           if (body['cards'] is List) {
             items = body['cards'];
           } else if (body['services'] is List) {
             items = body['services'];
           } else if (body['data'] is List) {
             items = body['data'];
           }
        }
        
        print('Services found: ${items.length}');
        
        if (items.isNotEmpty) {
          servicesList.assignAll(items);
        }
      }
    } catch (e) {
      debugPrint("Error fetching services: $e");
    }
  }

  void fetchBanner() async {
    try {
      final connect = GetConnect();
      final response = await connect.get('https://sednex-zvk1.onrender.com/api/homepage/sliders');
      
      if (response.statusCode == 200) {
        var body = response.body;
        if (body is String) body = jsonDecode(body);
        
        List items = [];
        if (body is Map && body['sliders'] is List) {
           items = body['sliders'];
        } else if (body is List) {
           items = body;
        }

        // Get all active banner images
        if (items.isNotEmpty) {
           final urls = <String>[];
           for (var item in items) {
             if (item['image'] != null) {
               urls.add(item['image']);
             }
           }
           
           if (urls.isNotEmpty) {
             bannerList.value = urls;
             startBannerSlider();
           }
        }
      }
    } catch (e) {
      debugPrint("Error fetching banner: $e");
    }
  }

  void startBannerSlider() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (bannerList.isEmpty) return;
      
      int nextPage = currentBannerIndex.value + 1;
      if (nextPage >= bannerList.length) {
        nextPage = 0;
      }
      
      if (bannerPageController.hasClients) {
        bannerPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
        currentBannerIndex.value = nextPage;
      }
    });
  }

  void fetchMarqueeText() async {
    try {
      final connect = GetConnect();
      print('Fetching Marquee from: https://sednex-zvk1.onrender.com/api/homepage/marquees');
      final response = await connect.get('https://sednex-zvk1.onrender.com/api/homepage/marquees');
      
      print('Marquee Response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        var body = response.body;

        // Handle string response manually if needed
        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (e) {
            print('JSON Decode error: $e');
            return;
          }
        }
        
        List items = [];
        if (body is List) {
          items = body;
        } else if (body is Map) {
           if (body['marquees'] is List) {
             items = body['marquees'];
           } else if (body['data'] is List) {
             items = body['data'];
           }
        }

        print('Marquee Items found: ${items.length}');
        
        // Map text directly as response might not have status/order
        final activeTexts = items
            .map((item) => item['text']?.toString() ?? '')
            .where((text) => text.isNotEmpty)
            .toList();
            
        print('Active texts: $activeTexts');

        if (activeTexts.isNotEmpty) {
          marqueeText.value = activeTexts.join('  •  ');
        } else {
             print('No valid text found in items.');
        }
      } else {
        print('Marquee fetch failed: ${response.statusText}');
      }
    } catch (e) {
      debugPrint("Error fetching marquee: $e");
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _marqueeTimer?.cancel();
    _bannerTimer?.cancel();
    bannerPageController.dispose();
    super.onClose();
  }

  // Change page based on bottom navigation selection
  void changePage(int index) {
    currentIndex.value = index;
  }
}
