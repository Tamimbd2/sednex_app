import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/api_service.dart';
import '../../Shop/controllers/shop_controller.dart';
import '../../communityFeed/controllers/community_feed_controller.dart';

class DashboardController extends GetxController {
  // Current selected index for bottom navigation
  var currentIndex = 0.obs;

  final searchQuery = ''.obs;

  final apiService = Get.find<ApiService>();
  final _box = GetStorage();

  var marqueeText = 'Welcome to SedNex!'.obs; // Default text
  var bannerList =
      <Map<String, dynamic>>[].obs; // Hero Banner Data (image, url)
  var currentBannerIndex = 0.obs;
  final bannerPageController = PageController(initialPage: 5000);

  var servicesList = <dynamic>[].obs; // Dynamic Services List
  var lovedProducts =
      <Map<String, dynamic>>[].obs; // Favorited products for Cart
  var userProfileImage = RxnString(); // Observable profile image
  var isLovedProductsLoading = false.obs;

  // Global Search State
  var isSearchLoading = false.obs;
  var searchResults = <String, List<dynamic>>{}.obs; // Section -> List of items

  // Community Post interactions in search
  final expandedPosts = <int>{}.obs;
  final currentlySpeakingIndex = (-1).obs;
  // Initialize lazily or during search
  dynamic get flutterTts => Get.find<CommunityFeedController>().flutterTts;

  Worker? _searchDebouncer;

  // Controllers for auto-scrolling
  final infoScrollController = ScrollController();
  final essentialScrollController = ScrollController();
  final homeScrollController = ScrollController();

  var isMarqueeLoading = false.obs;
  Timer? _marqueeTimer;
  Timer? _bannerTimer;
  Timer? _infoAutoScrollTimer;

  @override
  void onInit() {
    super.onInit();
    // Fetch initial data
    fetchUserProfile();
    fetchMarqueeText();
    fetchBanner();
    fetchServices();
    fetchLovedProducts();

    // Setup refresh timers
    _marqueeTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchMarqueeText();
    });

    // Start auto-scrolls
    startAutoScrolls();

    // Global Search listener with debounce
    _searchDebouncer = debounce(searchQuery, (query) {
      if (query.length >= 2) {
        performGlobalSearch(query);
      } else {
        searchResults.clear();
      }
    }, time: const Duration(milliseconds: 500));

    // Seamless scroll for community feed
    homeScrollController.addListener(() {
      if (homeScrollController.offset >=
          homeScrollController.position.maxScrollExtent) {
        // Debounce or ensure we only navigate once
        if (Get.currentRoute != '/community-feed') {
          Get.toNamed('/community-feed', preventDuplicates: true);
        }
      }
    });
  }

  void startAutoScrolls() {
    // Info Carousel Auto-scroll (Circular feel) - Disabled as requested
    // _infoAutoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
    //   if (servicesList.isEmpty) return;
    //   if (infoScrollController.hasClients) {
    //     double maxScroll = infoScrollController.position.maxScrollExtent;
    //     double currentScroll = infoScrollController.offset;
    //     double target = currentScroll + 120;
    //     if (target > maxScroll) target = 0;
    //
    //     infoScrollController.animateTo(
    //       target,
    //       duration: const Duration(milliseconds: 800),
    //       curve: Curves.easeInOut,
    //     );
    //   }
    // });
  }

  void fetchUserProfile() {
    final userData = _box.read('user');
    if (userData != null) {
      final user = jsonDecode(userData);
      userProfileImage.value = user['profileImage'];
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
          } catch (e) {
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
      debugPrint('Error fetching services: $e');
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
          final banners = <Map<String, dynamic>>[];
          for (var item in items) {
            if (item['image'] != null) {
              // The API uses buttonUrl for the redirection link
              final link =
                  item['buttonUrl'] ?? item['url'] ?? item['link'] ?? '';
              banners.add({'image': item['image'], 'url': link});
            }
          }

          if (banners.isNotEmpty) {
            bannerList.value = banners;
            startBannerSlider();
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching banners: $e');
    }
  }

  void startBannerSlider() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (bannerList.isEmpty) return;

      if (bannerPageController.hasClients) {
        bannerPageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void fetchMarqueeText() async {
    try {
      final response = await apiService.getData('api/homepage/marquees');

      if (response.statusCode == 200) {
        var body = response.body;

        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (e) {
            debugPrint('Marquee JSON error: $e');
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
          marqueeText.value = activeTexts.join(' • ');
        }
      }
    } catch (e) {
      debugPrint('Error fetching marquee: $e');
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  Future<void> performGlobalSearch(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      expandedPosts.clear();
      return;
    }

    expandedPosts.clear(); // Reset expands on new search
    isSearchLoading.value = true;
    final results = <String, List<dynamic>>{};

    try {
      // Parallel fetching for better performance
      await Future.wait([
        _searchSection(
          'Articles',
          'api/article/',
          query,
          (data) => data['articles'] ?? data['data'] ?? [],
        ),
        _searchSection(
          'Products',
          'api/products/',
          query,
          (data) => data['products'] ?? (data is List ? data : []),
        ),
        _searchSection(
          'Community Posts',
          'api/post/',
          query,
          (data) => data['posts'] ?? [],
        ),
        _searchSection(
          'Hospitals',
          'api/sections/hospitals/items',
          query,
          (data) => data['items'] ?? [],
        ),
        _searchSection(
          'Restaurants',
          'api/sections/restaurents/items',
          query,
          (data) => data['items'] ?? [],
        ),
        _searchSection(
          'Organizations',
          'api/sections/organization/items',
          query,
          (data) => data['items'] ?? [],
        ),
        _searchSection(
          'Embassies',
          'api/sections/embassy/items',
          query,
          (data) => data['items'] ?? [],
        ),
        _searchSection(
          'Local Tours',
          'api/local-tour/',
          query,
          (data) => data['tours'] ?? [],
        ),
      ]).then((lists) {
        final sections = [
          'Articles',
          'Products',
          'Community Posts',
          'Hospitals',
          'Restaurants',
          'Organizations',
          'Embassies',
          'Local Tours',
        ];
        for (int i = 0; i < lists.length; i++) {
          if (lists[i].isNotEmpty) {
            results[sections[i]] = lists[i];
          }
        }
      });

      // Search in Essential Services (locally available)
      final services = servicesList.where((s) {
        final name = (s['title'] ?? s['name'] ?? s['label'] ?? '')
            .toString()
            .toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
      if (services.isNotEmpty) results['Essential Services'] = services;

      searchResults.assignAll(results);
    } catch (e) {
      debugPrint("Global Search error: $e");
    } finally {
      isSearchLoading.value = false;
    }
  }

  Future<List<dynamic>> _searchSection(
    String section,
    String url,
    String query,
    List<dynamic> Function(dynamic) extractor,
  ) async {
    try {
      final response = await apiService.getData(url);
      if (response.statusCode == 200) {
        var body = response.body;
        if (body is String) body = jsonDecode(body);

        final List raw = extractor(body);
        final filtered = raw.where((item) {
          final mainText =
              (item['title'] ??
                      item['name'] ??
                      item['description'] ??
                      item['content'] ??
                      '')
                  .toString()
                  .toLowerCase();
          final authorName =
              (item['author'] is Map ? (item['author']['name'] ?? '') : '')
                  .toString()
                  .toLowerCase();
          final queryLower = query.toLowerCase();
          return mainText.contains(queryLower) ||
              authorName.contains(queryLower);
        }).toList();

        // Match the model expected by the UI for consistent display
        return filtered
            .map(
              (item) => {
                ...item,
                '_search_section': section, // Metadata for navigation if needed
              },
            )
            .toList();
      }
    } catch (e) {
      debugPrint("Error searching section $section: $e");
    }
    return [];
  }

  // --- Post Interaction Proxies for Search Results ---

  String? get userId {
    final userData = _box.read('user');
    if (userData != null) {
      final user = jsonDecode(userData);
      return user['_id'];
    }
    return null;
  }

  void toggleExpand(int index) {
    if (expandedPosts.contains(index)) {
      expandedPosts.remove(index);
    } else {
      expandedPosts.add(index);
    }
  }

  Future<void> toggleLike(int index) async {
    final posts = searchResults['Community Posts'];
    if (posts == null || index >= posts.length) return;

    final post = posts[index];
    final postId = post['_id'];
    final currentUserId = userId;

    if (currentUserId == null) {
      Get.snackbar('Login Required', 'Please login to react to posts');
      return;
    }

    // Proxy to CommunityFeedController or API
    try {
      final response = await apiService.patchData('api/post/$postId/love', {});
      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map && body['post'] != null) {
          final updatedPost = body['post'];
          final lovedBy = (updatedPost['lovedBy'] as List?) ?? [];

          post['likes'] = updatedPost['loveCount'] ?? 0;
          post['isLiked'] = lovedBy.contains(currentUserId);
          posts[index] = Map<String, dynamic>.from(post);
          searchResults.refresh();
        }
      }
    } catch (e) {
      debugPrint('Like error in search: $e');
    }
  }

  Future<void> speakPost(int index, String text) async {
    try {
      if (currentlySpeakingIndex.value == index) {
        await flutterTts.stop();
        currentlySpeakingIndex.value = -1;
        return;
      }

      await flutterTts.stop();
      // Use the logic from CommunityFeedController or define locally
      await flutterTts.speak(text);
      currentlySpeakingIndex.value = index;
      flutterTts.setCompletionHandler(() {
        currentlySpeakingIndex.value = -1;
      });
    } catch (e) {
      debugPrint("TTS Search Error: $e");
    }
  }

  // Placeholder methods for card buttons (can be fully implemented if needed)
  void fetchComments(int index) =>
      Get.find<CommunityFeedController>().fetchComments(index);
  dynamic get isLoadingComments =>
      Get.find<CommunityFeedController>().isLoadingComments;
  dynamic get replyTargetCommentId =>
      Get.find<CommunityFeedController>().replyTargetCommentId;
  dynamic get replyTargetName =>
      Get.find<CommunityFeedController>().replyTargetName;
  void addComment(int index, String text) =>
      Get.find<CommunityFeedController>().addComment(index, text);
  void setReplyTarget(String id, String name) =>
      Get.find<CommunityFeedController>().setReplyTarget(id, name);
  void clearReplyTarget() =>
      Get.find<CommunityFeedController>().clearReplyTarget();
  void savePost(int index) =>
      Get.find<CommunityFeedController>().savePost(index);
  void updatePost(int index, String text) =>
      Get.find<CommunityFeedController>().updatePost(index, text);
  void deletePost(int index) =>
      Get.find<CommunityFeedController>().deletePost(index);

  void fetchLovedProducts() async {
    try {
      const path = 'api/products/love/';
      final fullUrl = '${apiService.httpClient.baseUrl}$path';
      debugPrint("Favorites Full URL: $fullUrl");
      final response = await apiService.getData(path);

      debugPrint(
        "Favorites Status: ${response.statusCode} - ${response.statusText}",
      );

      if (response.statusCode == 200) {
        final dynamic body = response.body;
        debugPrint("Favorites API Response: $body");

        List items = [];
        if (body is Map && body['products'] is List) {
          items = body['products'];
        } else if (body is List) {
          items = body;
        }

        final mapped = items
            .map((item) {
              try {
                final productMap = Map<String, dynamic>.from(
                  item is Map ? item : {},
                );
                final price = productMap['price'] ?? 0;
                final discountPrice = productMap['discountPrice'];

                return {
                  ...productMap,
                  "id": productMap['_id'],
                  "name": productMap['name']?.toString() ?? 'No Name',
                  "price": "৳$price",
                  "originalPrice": discountPrice != null
                      ? "৳${(price is num ? price : 0) + 50}"
                      : "",
                  "image":
                      (productMap['images'] is List &&
                          (productMap['images'] as List).isNotEmpty)
                      ? productMap['images'][0]
                      : "https://via.placeholder.com/164x164.png",
                  "category": productMap['category'] is Map
                      ? (productMap['category']['name'] ?? 'General')
                      : 'General',
                };
              } catch (e) {
                debugPrint('Error mapping loved product: $e');
                return <String, dynamic>{};
              }
            })
            .where((p) => p.isNotEmpty)
            .cast<Map<String, dynamic>>()
            .toList();

        lovedProducts.assignAll(mapped);
      }
    } catch (e) {
      debugPrint('Error fetching loved products: $e');
    }
  }

  void toggleFavorite(String productId) async {
    try {
      // Optimistic UI Update: remove from list immediately
      final removedIndex = lovedProducts.indexWhere(
        (p) => (p['id'] ?? p['_id']) == productId,
      );
      if (removedIndex != -1) {
        final removedProduct = lovedProducts[removedIndex];
        lovedProducts.removeAt(removedIndex);

        final response = await apiService.patchData(
          'api/products/$productId/love',
          {},
        );

        if (response.statusCode != 200) {
          // Revert if API failed
          lovedProducts.insert(removedIndex, removedProduct);
        } else {
          debugPrint("Unsaved from cart: $productId");

          // Refresh Shop products to update the heart icons immediately
          try {
            final shopController = Get.find<ShopController>();
            shopController.fetchProducts();
          } catch (e) {
            debugPrint('Error syncing Shop favorites: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  @override
  void onClose() {
    _searchDebouncer?.dispose();
    _marqueeTimer?.cancel();
    _bannerTimer?.cancel();
    _infoAutoScrollTimer?.cancel();
    infoScrollController.dispose();
    essentialScrollController.dispose();
    homeScrollController.dispose();
    super.onClose();
  }
}
