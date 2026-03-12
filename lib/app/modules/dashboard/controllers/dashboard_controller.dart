import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/api_service.dart';

class DashboardController extends GetxController {
  // Current selected index for bottom navigation
  final currentIndex = 0.obs;
  
  final apiService = Get.find<ApiService>();
  final _box = GetStorage();
  
  var marqueeText = 'Welcome to SedNex!'.obs; // Default text
  var bannerList = <String>[].obs; // Hero Banner URLs
  var currentBannerIndex = 0.obs;
  final bannerPageController = PageController();
  
  var servicesList = <dynamic>[].obs; // Dynamic Services List
  var userProfileImage = RxnString(); // Observable profile image

  var isMarqueeLoading = false.obs;
  Timer? _marqueeTimer;
  Timer? _bannerTimer;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchMarqueeText();
    fetchBanner();
    fetchServices();
    // Poll every 30 seconds for real-time updates
    _marqueeTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchMarqueeText();
    });
  }

  void loadUserData() {
    final rawUser = _box.read('user');
    if (rawUser != null) {
      try {
        final user = rawUser is String ? jsonDecode(rawUser) : rawUser;
        final img = user['profileImage']?.toString();
        userProfileImage.value = (img != null && img.isNotEmpty) ? img : null;
      } catch (e) {
        debugPrint('Dashboard user data error: $e');
      }
    }
  }

  void fetchServices() async {
    try {
      final response = await apiService.getData('api/homepage/services');
      
      if (response.statusCode == 200) {
        var body = response.body;
        if (body is String) {
          try {
             body = jsonDecode(body);
          } catch(e) {
             debugPrint('Services JSON error: $e');
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
      final response = await apiService.getData('api/homepage/sliders');
      
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
      final response = await apiService.getData('api/homepage/marquees');
      
      if (response.statusCode == 200) {
        var body = response.body;

        // Handle string response manually if needed
        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (e) {
            debugPrint('Marquee JSON Decode error: $e');
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
        
        // Map text directly as response might not have status/order
        final activeTexts = items
            .map((item) => item['text']?.toString() ?? '')
            .where((text) => text.isNotEmpty)
            .toList();

        if (activeTexts.isNotEmpty) {
          marqueeText.value = activeTexts.join('  •  ');
        }
      }
    } catch (e) {
      debugPrint("Error fetching marquee: $e");
    }
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
