import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityFeedController extends GetxController {
  final count = 0.obs;

  final List<String> filters = ["Recent", "Jobs", "Question", "Rentals", "Sell", "Info"];
  final selectedFilter = "Recent".obs;

  final posts = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final expandedPosts = <int>{}.obs;

  void toggleExpand(int index) {
    if (expandedPosts.contains(index)) {
      expandedPosts.remove(index);
    } else {
      expandedPosts.add(index);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchPosts();

    // Listen to filter changes
    ever(selectedFilter, (_) {
      currentPage.value = 1;
      posts.clear();
      fetchPosts();
    });
  }

  Future<void> fetchPosts({bool loadMore = false}) async {
    if (loadMore) {
      if (currentPage.value >= totalPages.value) return;
      isLoadingMore.value = true;
      currentPage.value++;
    } else {
      isLoading.value = true;
    }

    try {
      final connect = GetConnect();
      
      // Build query params
      String url = 'https://sednex-zvk1.onrender.com/api/post/?page=${currentPage.value}&limit=10';
      
      // Add category filter if not "Recent"
      if (selectedFilter.value != "Recent") {
        final categoryMap = {
          "Jobs": "jobs",
          "Question": "question",
          "Rentals": "rentals",
          "Sell": "sell",
          "Info": "general",
        };
        final category = categoryMap[selectedFilter.value] ?? selectedFilter.value.toLowerCase();
        url += '&category=$category';
      }

      print('Fetching posts from: $url');
      final response = await connect.get(url);

      if (response.statusCode == 200) {
        var body = response.body;
        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (e) {
            print('Posts JSON error: $e');
            return;
          }
        }

        if (body is Map) {
          totalPages.value = body['totalPages'] ?? 1;

          final List rawPosts = body['posts'] ?? [];
          final List<Map<String, dynamic>> mappedPosts = rawPosts.map<Map<String, dynamic>>((post) {
            final author = post['author'] ?? {};
            final images = (post['images'] as List?)?.cast<String>() ?? [];
            final createdAt = post['createdAt'] ?? '';
            
            // Map API category to display category
            String displayCategory = _mapCategory(post['category'] ?? 'general');

            return {
              '_id': post['_id'] ?? '',
              'name': author['name'] ?? 'Unknown',
              'time': _timeAgo(createdAt),
              'content': post['description'] ?? '',
              'avatar': 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(author['name'] ?? 'U')}&background=DC143C&color=fff&size=80',
              'likes': post['loveCount'] ?? 0,
              'comments': post['commentsCount'] ?? 0,
              'isLiked': false,
              'hasSave': false,
              'category': displayCategory,
              'images': images,
              'lovedBy': post['lovedBy'] ?? [],
              'commentsList': <Map<String, dynamic>>[],
            };
          }).toList();

          if (loadMore) {
            posts.addAll(mappedPosts);
          } else {
            posts.assignAll(mappedPosts);
          }
          
          print('Posts loaded: ${mappedPosts.length}, Total in list: ${posts.length}');
        }
      } else {
        print('Failed to fetch posts: ${response.statusCode} ${response.statusText}');
      }
    } catch (e) {
      debugPrint("Error fetching posts: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshPosts() async {
    currentPage.value = 1;
    await fetchPosts();
  }

  void loadMorePosts() {
    if (!isLoadingMore.value && currentPage.value < totalPages.value) {
      fetchPosts(loadMore: true);
    }
  }

  String _mapCategory(String apiCategory) {
    switch (apiCategory.toLowerCase()) {
      case 'jobs':
        return 'Jobs';
      case 'question':
        return 'Question';
      case 'rentals':
        return 'Rentals';
      case 'sell':
        return 'Sell';
      case 'general':
        return 'Info';
      default:
        return 'Info';
    }
  }

  String _timeAgo(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString).toLocal();
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${(difference.inDays / 7).floor()}w ago';
      }
    } catch (e) {
      return '';
    }
  }

  void addComment(int index, String comment) {
    if (comment.trim().isEmpty) return;
    
    var post = posts[index];
    Map<String, dynamic> newComment = {
      "name": "You",
      "text": comment,
      "avatar": "https://ui-avatars.com/api/?name=You&background=DC143C&color=fff&size=60",
      "time": "Just now"
    };

    List<dynamic> currentComments = post["commentsList"] ?? [];
    currentComments.add(newComment);
    
    post["commentsList"] = currentComments;
    post["comments"] = (post["comments"] ?? 0) + 1;
    
    posts[index] = post;
  }

  void toggleLike(int index) {
    var post = posts[index];
    bool isLiked = post['isLiked'] ?? false;
    
    if (isLiked) {
      post['likes'] = (post['likes'] ?? 1) - 1;
      post['isLiked'] = false;
    } else {
      post['likes'] = (post['likes'] ?? 0) + 1;
      post['isLiked'] = true;
    }
    
    posts[index] = post;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
