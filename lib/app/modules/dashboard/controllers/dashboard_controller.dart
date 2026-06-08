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

  var jobPostsList = <Map<String, dynamic>>[].obs;
  var isJobsLoading = false.obs;

  // Global Search State
  var isSearchLoading = false.obs;
  var searchError = ''.obs;
  String? _activeSearchQuery;
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
    
    // Listen for storage changes on the 'user' key to update the profile picture instantly
    _box.listenKey('user', (value) {
      fetchUserProfile();
    });

    fetchMarqueeText();
    fetchBanner();
    fetchServices();
    fetchLovedProducts();
    fetchJobPosts();

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
        searchError.value = '';
      }
    }, time: const Duration(milliseconds: 500));

    // Auto-scroll navigation to community feed removed as per request
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
      final user = userData is String ? jsonDecode(userData) : userData;
      userProfileImage.value = user['profileImage'];
    }
  }

  void fetchServices() async {
    debugPrint('fetchServices started');
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
    } finally {
      debugPrint('fetchServices completed');
    }
  }

  void fetchJobPosts() async {
    isJobsLoading.value = true;
    try {
      final response = await apiService.getData('api/post/category/jobs?page=1&limit=6');
      if (response.statusCode == 200) {
        var body = response.body;
        if (body is String) body = jsonDecode(body);
        if (body is Map) {
          final List rawPosts = body['posts'] ?? [];
          final List<Map<String, dynamic>> mapped = rawPosts.map<Map<String, dynamic>>((post) {
            final author = post['author'] ?? {};
            return {
              '_id': post['_id'] ?? '',
              'name': author['name'] ?? 'Unknown',
              'content': post['description'] ?? '',
              'avatar': author['profileImage'] ??
                  'https://ui-avatars.com/api/?name=${Uri.encodeComponent(author['name'] ?? 'U')}&background=1E63FF&color=fff&size=80',
            };
          }).toList();
          jobPostsList.assignAll(mapped);
        }
      }
    } catch (e) {
      debugPrint("Error fetching job posts on dashboard: $e");
    } finally {
      isJobsLoading.value = false;
    }
  }

  void fetchBanner() async {
    debugPrint('fetchBanner started');
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
    } finally {
      debugPrint('fetchBanner completed');
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
    debugPrint('fetchMarqueeText started');
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
    } finally {
      debugPrint('fetchMarqueeText completed');
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  Future<void> performGlobalSearch(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      expandedPosts.clear();
      searchError.value = '';
      return;
    }

    _activeSearchQuery = query;
    expandedPosts.clear(); // Reset expands on new search
    isSearchLoading.value = true;
    searchError.value = '';
    final results = <String, List<dynamic>>{};

    try {
      // Use the unified search API provided
      final response = await apiService.getData('api/search', query: {'q': query});
      
      // If a newer search has started, discard this result
      if (_activeSearchQuery != query) return;

      if (response.statusCode == 200) {
        final body = response.body;
        
        // Map the response keys to display titles as used in the View
        final sectionMap = {
          'articles': 'Articles',
          'products': 'Products',
          'posts': 'Community Posts',
          'hospitals': 'Hospitals',
          'restaurents': 'Restaurants',
          'organization': 'Organizations',
          'embassy': 'Embassies',
          'tours': 'Lebanon Tour',
        };

        if (body is Map) {
          final dataMap = (body['data'] is Map) ? body['data'] : body;

          // 1. Identify the list of items from various possible structures
          dynamic itemsList;
          if (body['items'] is List) {
            itemsList = body['items'];
          } else if (body['data'] is List) {
            itemsList = body['data'];
          } else if (body['data'] is Map && body['data']['items'] is List) {
            itemsList = body['data']['items'];
          } else if (body['items'] is Map && body['items']['items'] is List) {
            itemsList = body['items']['items'];
          }

          // 2. Process the flat list if found (New Unified API)
          if (itemsList is List) {
            for (var item in itemsList) {
              if (item is Map) {
                final model = item['model']?.toString().toLowerCase() ?? '';
                
                // Ignore structural/administrative/system models from general search results
                if (model == 'homepageslider' ||
                    model == 'slider' ||
                    model == 'marquee' ||
                    model == 'banner' ||
                    model == 'notification') {
                  continue;
                }
                
                // Use mapping for known models to match existing UI titles
                final sectionMapping = {
                  'article': 'Articles',
                  'product': 'Products',
                  'auctionitem': 'Products',
                  'item': 'Products',
                  'post': 'Community Posts',
                  'hospital': 'Hospitals',
                  'restaurent': 'Restaurants',
                  'organization': 'Organizations',
                  'embassy': 'Embassies',
                  'tour': 'Lebanon Tour',
                  'localtour': 'Lebanon Tour',
                  'touristspot': 'Tourist Spots',
                  'spot': 'Tourist Spots',
                  'user': 'Users',
                  'flightroute': 'Flight Routes',
                  'route': 'Flight Routes',
                  'busservice': 'Bus Services',
                  'texi-driver': 'Drivers',
                  'texi_driver': 'Drivers',
                  'taxi-driver': 'Drivers',
                  'taxidriver': 'Drivers',
                  'sports-team': 'Sports Team',
                  'sports_team': 'Sports Team',
                  'sportsteam': 'Sports Team',
                  'pharmacy': 'Pharmacy',
                  'grocery-store': 'Grocery Store',
                  'grocery_store': 'Grocery Store',
                  'grocerystore': 'Grocery Store',
                  'jewellery-shop': 'Jewellery Shop',
                  'jewellery_shop': 'Jewellery Shop',
                  'jewelleryshop': 'Jewellery Shop',
                  'influencer': 'Influencer',
                  'clothing-shop': 'Clothing Shop',
                  'clothing_shop': 'Clothing Shop',
                  'clothingshop': 'Clothing Shop',
                  'maker': 'Maker',
                  'local-market': 'Local Market',
                  'local_market': 'Local Market',
                  'localmarket': 'Local Market',
                  'local-business': 'Local Business',
                  'local_business': 'Local Business',
                  'localbusiness': 'Local Business',
                  'businessman': 'Businessman',
                  'ngo': 'NGO',
                };

                String section = 'Search Results';
                if (model == 'section' && item.containsKey('slug')) {
                  final slug = item['slug']?.toString() ?? '';
                  section = sectionMapping[slug] ?? slug.capitalizeFirst!;
                } else {
                  section = sectionMapping[model] ?? 
                                  (model.isNotEmpty ? model.capitalizeFirst! : 'Search Results');
                }
                
                // Special check for users if model is missing but role exists
                if ((model.isEmpty || section == 'Search Results') && item.containsKey('role')) {
                  section = 'Users';
                }

                results.putIfAbsent(section, () => []).add({
                  ...Map<String, dynamic>.from(item),
                  '_search_section': section,
                  'commentsList': <Map<String, dynamic>>[].obs,
                });
              }
            }
          }

          // Fallback: Check for grouped keys if 'items' is empty or not present
          sectionMap.forEach((apiKey, displayTitle) {
            var items = dataMap[apiKey];
            
            // Handle nested data structure if present
            if (items is Map && items['items'] is List) {
              items = items['items'];
            } else if (items is Map && items['data'] is List) {
              items = items['data'];
            }

            if (items is List && items.isNotEmpty) {
              // Only add if not already present from the 'items' loop to avoid duplicates
              for (var item in items) {
                final alreadyAdded = results[displayTitle]?.any((existing) => 
                    existing['_id'] == item['_id'] || existing['id'] == item['id']) ?? false;
                
                if (!alreadyAdded) {
                  results.putIfAbsent(displayTitle, () => []).add({
                    ...Map<String, dynamic>.from(item),
                    '_search_section': displayTitle,
                    'commentsList': <Map<String, dynamic>>[].obs,
                  });
                }
              }
            }
          });
        }
      } else {
        searchError.value = 'Failed to fetch search results. Server returned status ${response.statusCode}';
      }
      
      // Search in Services (locally available as they are fetched on init)
      final services = servicesList.where((s) {
        final name = (s['title'] ?? s['name'] ?? s['label'] ?? '')
            .toString()
            .toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
      
      if (services.isNotEmpty) {
        results['Services'] = services.map((s) => {
          ...Map<String, dynamic>.from(s),
          '_search_section': 'Services',
        }).toList();
      }

      if (_activeSearchQuery == query) {
        searchResults.assignAll(results);
      }
    } catch (e) {
      debugPrint("Global Search error: $e");
      if (_activeSearchQuery == query) {
        searchError.value = 'An error occurred while searching: $e';
      }
    } finally {
      if (_activeSearchQuery == query) {
        isSearchLoading.value = false;
      }
    }
  }

  // --- Post Interaction Proxies for Search Results ---

  String? get userId {
    final userData = _box.read('user');
    if (userData != null) {
      final user = userData is String ? jsonDecode(userData) : userData;
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
      Get.snackbar('login_required'.tr, 'please_login_to_react'.tr);
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
      if (text.trim().isEmpty) return;

      if (currentlySpeakingIndex.value == index) {
        currentlySpeakingIndex.value = -1;
        await flutterTts.stop();
        return;
      }

      await flutterTts.stop();
      currentlySpeakingIndex.value = index;

      await flutterTts.speak(text);
      
      flutterTts.setCompletionHandler(() {
        currentlySpeakingIndex.value = -1;
      });

      flutterTts.setErrorHandler((msg) {
        currentlySpeakingIndex.value = -1;
      });
    } catch (e) {
      currentlySpeakingIndex.value = -1;
      debugPrint("TTS Search Error: $e");
    }
  }

  final replyTargetCommentId = RxnString();
  final replyTargetName = RxnString();
  final isLoadingComments = false.obs;

  void setReplyTarget(String id, String name) {
    replyTargetCommentId.value = id;
    replyTargetName.value = name;
  }

  void clearReplyTarget() {
    replyTargetCommentId.value = null;
    replyTargetName.value = null;
  }

  Future<void> fetchComments(int index) async {
    final posts = searchResults['Community Posts'];
    if (posts == null || index >= posts.length) return;
    final post = posts[index];
    final postId = post['_id'];

    try {
      isLoadingComments.value = true;
      final response = await apiService.getData('api/post/comment/$postId');

      if (response.statusCode == 200) {
        final body = response.body;
        final List rawComments = body['comments'] ?? [];

        final List<Map<String, dynamic>> mappedComments = rawComments.map<Map<String, dynamic>>((c) {
          final author = c['author'] ?? {};
          return {
            '_id': c['_id'] ?? '',
            'name': author['name'] ?? 'Unknown',
            'text': c['content'] ?? '',
            'avatar': author['profileImage'] ??
                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(author['name'] ?? 'U')}&background=1E63FF&color=fff&size=60',
            'time': _timeAgo(c['createdAt'] ?? ''),
            'replies': <Map<String, dynamic>>[].obs,
            'isRepliesLoading': false.obs,
            'showReplies': false.obs,
          };
        }).toList();

        if (post['commentsList'] is RxList) {
          (post['commentsList'] as RxList).assignAll(mappedComments);
        } else {
          post['commentsList'] = RxList<Map<String, dynamic>>(mappedComments);
        }
        post['comments'] = mappedComments.length;
        searchResults.refresh();
      }
    } catch (e) {
      debugPrint('Error fetching comments in search: $e');
    } finally {
      isLoadingComments.value = false;
    }
  }

  Future<void> fetchReplies(int postIndex, int commentIndex) async {
    final posts = searchResults['Community Posts'];
    if (posts == null || postIndex >= posts.length) return;
    final post = posts[postIndex];
    final commentsList = post['commentsList'] as RxList?;
    if (commentsList == null || commentIndex >= commentsList.length) return;
    final comment = commentsList[commentIndex];
    final commentId = comment['_id'];

    try {
      comment['isRepliesLoading'].value = true;
      final response = await apiService.getData('api/post/comment/replies/$commentId');

      if (response.statusCode == 200) {
        final body = response.body;
        final List rawReplies = body['replies'] ?? [];

        final List<Map<String, dynamic>> mappedReplies = rawReplies.map<Map<String, dynamic>>((r) {
          final author = r['author'] ?? {};
          return {
            '_id': r['_id'] ?? '',
            'name': author['name'] ?? 'Unknown',
            'text': r['content'] ?? '',
            'avatar': author['profileImage'] ??
                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(author['name'] ?? 'U')}&background=1E63FF&color=fff&size=50',
            'time': _timeAgo(r['createdAt'] ?? ''),
          };
        }).toList();

        if (comment['replies'] is RxList) {
          (comment['replies'] as RxList<Map<String, dynamic>>).assignAll(mappedReplies);
        } else {
          comment['replies'] = RxList<Map<String, dynamic>>(mappedReplies);
        }
        comment['showReplies'].value = true;
        searchResults.refresh();
      }
    } catch (e) {
      debugPrint('Error fetching replies in search: $e');
    } finally {
      comment['isRepliesLoading'].value = false;
    }
  }

  Future<void> addComment(int index, String text) async {
    if (text.trim().isEmpty) return;

    final posts = searchResults['Community Posts'];
    if (posts == null || index >= posts.length) return;
    final post = posts[index];
    final postId = post['_id'];

    if (userId == null) {
      Get.snackbar('Login Required', 'Please login to comment');
      return;
    }

    try {
      final isReply = replyTargetCommentId.value != null;
      final url = 'api/post/comment/$postId';
      final Map<String, dynamic> body = {'content': text.trim()};

      if (isReply) {
        body['parentCommentId'] = replyTargetCommentId.value;
      }

      final response = await apiService.postData(url, body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        clearReplyTarget();
        fetchComments(index); // Refresh comments list
      } else {
        Get.snackbar('Error', 'Failed to post ${isReply ? 'reply' : 'comment'}');
      }
    } catch (e) {
      debugPrint('Error posting comment in search: $e');
    }
  }

  Future<void> savePost(int index) async {
    final posts = searchResults['Community Posts'];
    if (posts == null || index >= posts.length) return;
    final post = posts[index];
    final postId = post['_id'];

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Color(0xFF1E63FF))),
        barrierDismissible: false,
      );
      final response = await apiService.postData('api/post/save/$postId', {});
      if (Get.isDialogOpen ?? false) Get.back();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Post saved successfully');
      } else {
        var body = response.body;
        String message = body is Map ? (body['message'] ?? 'Failed to save post') : 'Failed to save post';
        Get.snackbar('Info', message);
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      debugPrint('Save error: $e');
      Get.snackbar('Error', 'An unexpected error occurred');
    }
  }

  Future<void> updatePost(int index, String newDescription) async {
    final posts = searchResults['Community Posts'];
    if (posts == null || index >= posts.length) return;
    final post = posts[index];
    final postId = post['_id'];

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Color(0xFF1E63FF))),
        barrierDismissible: false,
      );
      final response = await apiService.patchData('api/post/$postId', {
        'description': newDescription.trim(),
      });
      if (Get.isDialogOpen ?? false) Get.back();

      if (response.statusCode == 200) {
        post['content'] = newDescription.trim();
        posts[index] = Map<String, dynamic>.from(post);
        searchResults.refresh();
        Get.snackbar('Success', 'Post updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update post: ${response.statusText}');
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      debugPrint('Update error: $e');
      Get.snackbar('Error', 'An unexpected error occurred');
    }
  }

  Future<void> deletePost(int index) async {
    final posts = searchResults['Community Posts'];
    if (posts == null || index >= posts.length) return;
    final post = posts[index];
    final postId = post['_id'];

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Color(0xFF1E63FF))),
        barrierDismissible: false,
      );
      final response = await apiService.deleteData('api/post/$postId');
      if (Get.isDialogOpen ?? false) Get.back();

      if (response.statusCode == 200 || response.statusCode == 204) {
        posts.removeAt(index);
        searchResults.refresh();
        Get.snackbar('Success', 'Post deleted successfully');
      } else {
        Get.snackbar('Error', 'Failed to delete post: ${response.statusText}');
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      debugPrint('Delete error: $e');
      Get.snackbar('Error', 'An unexpected error occurred');
    }
  }

  Future<void> markAsCompleted(int index) async {
    final posts = searchResults['Community Posts'];
    if (posts == null || index >= posts.length) return;
    final post = posts[index];
    final postId = post['_id'];
    final bool currentStatus = post['isCompleted'] ?? false;
    final bool newStatus = !currentStatus;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Color(0xFF1E63FF))),
        barrierDismissible: false,
      );
      final response = await apiService.patchData(
        'api/post/$postId/completion',
        {'isCompleted': newStatus},
      );
      if (Get.isDialogOpen ?? false) Get.back();

      if (response.statusCode == 200) {
        post['isCompleted'] = newStatus;
        posts[index] = Map<String, dynamic>.from(post);
        searchResults.refresh();
        Get.snackbar('Success', newStatus ? 'Post marked as completed' : 'Post reopened');
      } else {
        Get.snackbar('Error', 'Failed to update status');
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      debugPrint('Mark completed error: $e');
    }
  }

  String _timeAgo(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString).toLocal();
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inSeconds < 60) return 'Just now';
      if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
      if (difference.inHours < 24) return '${difference.inHours}h ago';
      if (difference.inDays < 7) return '${difference.inDays}d ago';
      return '${(difference.inDays / 7).floor()}w ago';
    } catch (e) {
      return '';
    }
  }

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
