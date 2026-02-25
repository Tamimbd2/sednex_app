import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/api_service.dart';

class CommunityFeedController extends GetxController {
  final apiService = Get.find<ApiService>();
  final box = GetStorage();
  
  final count = 0.obs;

  final List<String> filters = [
    "Recent",
    "General",
    "Help",
    "Sell",
    "Job",
    "Question",
    "Announcement",
    "Information",
    "Rentals"
  ];
  final selectedFilter = "Recent".obs;

  final posts = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final isLoadingComments = false.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final expandedPosts = <int>{}.obs;

  // Reply related states
  final replyTargetCommentId = RxnString();
  final replyTargetName = RxnString();

  String? get userId {
    final userData = box.read('user');
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
      // Build base URL
      String url;
      if (selectedFilter.value == "Recent") {
        url = 'api/post/';
      } else {
        // Correct endpoint for category filtering
        url = 'api/post/category/${selectedFilter.value.toLowerCase()}';
      }

      // Add pagination params
      url += '?page=${currentPage.value}&limit=10';

      print('Fetching posts from: $url');
      final response = await apiService.getData(url);

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
          final currentUserId = userId;
          
          final List<Map<String, dynamic>> mappedPosts = rawPosts.map<Map<String, dynamic>>((post) {
            final author = post['author'] ?? {};
            final images = (post['images'] as List?)?.cast<String>() ?? [];
            final createdAt = post['createdAt'] ?? '';
            final lovedBy = (post['lovedBy'] as List?) ?? [];
            
            // Map API category to display category
            String displayCategory = _mapCategory(post['category'] ?? 'general');

            return {
              '_id': post['_id'] ?? '',
              'authorId': author['_id'] ?? '',
              'name': author['name'] ?? 'Unknown',
              'time': _timeAgo(createdAt),
              'content': post['description'] ?? '',
              'avatar': author['profileImage'] ?? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(author['name'] ?? 'U')}&background=DC143C&color=fff&size=80',
              'likes': post['loveCount'] ?? 0,
              'comments': post['commentsCount'] ?? 0,
              'isLiked': currentUserId != null && lovedBy.contains(currentUserId),
              'hasSave': false,
              'category': displayCategory,
              'images': images,
              'lovedBy': lovedBy,
              'commentsList': <Map<String, dynamic>>[].obs,
            };
          }).toList();

          if (loadMore) {
            posts.addAll(mappedPosts);
          } else {
            posts.assignAll(mappedPosts);
          }
        }
      } else {
        print('Failed to fetch posts: ${response.statusCode} - ${response.statusText}');
      }
    } catch (e) {
      debugPrint("Error fetching posts: $e");
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> fetchComments(int index) async {
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
            'avatar': author['profileImage'] ?? 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(author['name'] ?? 'U')}&background=DC143C&color=fff&size=60',
            'time': _timeAgo(c['createdAt'] ?? ''),
          };
        }).toList();

        (posts[index]['commentsList'] as RxList).assignAll(mappedComments);
        posts[index]['comments'] = mappedComments.length;
        posts.refresh();
      }
    } catch (e) {
      debugPrint('Error fetching comments: $e');
    } finally {
      isLoadingComments.value = false;
    }
  }

  void setReplyTarget(String commentId, String name) {
    replyTargetCommentId.value = commentId;
    replyTargetName.value = name;
  }

  void clearReplyTarget() {
    replyTargetCommentId.value = null;
    replyTargetName.value = null;
  }

  Future<void> addComment(int index, String text) async {
    if (text.trim().isEmpty) return;
    
    final post = posts[index];
    final postId = post['_id'];

    if (userId == null) {
      Get.snackbar('Login Required', 'Please login to comment');
      return;
    }

    try {
      final isReply = replyTargetCommentId.value != null;
      final url = isReply 
          ? 'api/post/comment/replies/${replyTargetCommentId.value}' 
          : 'api/post/comment/$postId';

      final response = await apiService.postData(url, {
        'content': text.trim(),
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        clearReplyTarget();
        fetchComments(index); // Refresh comments list
      } else {
        Get.snackbar('Error', 'Failed to post ${isReply ? 'reply' : 'comment'}');
      }
    } catch (e) {
      debugPrint('Error posting comment: $e');
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
    if (apiCategory.isEmpty) return 'General';
    return apiCategory.capitalizeFirst ?? 'General';
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

  Future<void> toggleLike(int index) async {
    final post = posts[index];
    final postId = post['_id'];
    final currentUserId = userId;

    if (currentUserId == null) {
      Get.snackbar('Login Required', 'Please login to react to posts');
      return;
    }

    // Optimistic Update
    bool isLiked = post['isLiked'] ?? false;
    if (isLiked) {
      post['likes'] = (post['likes'] ?? 1) - 1;
      post['isLiked'] = false;
    } else {
      post['likes'] = (post['likes'] ?? 0) + 1;
      post['isLiked'] = true;
    }
    posts[index] = Map<String, dynamic>.from(post);

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
        }
      } else {
        // Revert on failure
        if (isLiked) {
          post['likes'] = (post['likes'] ?? 0) + 1;
          post['isLiked'] = true;
        } else {
          post['likes'] = (post['likes'] ?? 1) - 1;
          post['isLiked'] = false;
        }
        posts[index] = Map<String, dynamic>.from(post);
        Get.snackbar('Error', 'Failed to update reaction');
      }
    } catch (e) {
      debugPrint('Like error: $e');
      // Revert on error
      if (isLiked) {
        post['likes'] = (post['likes'] ?? 0) + 1;
        post['isLiked'] = true;
      } else {
        post['likes'] = (post['likes'] ?? 1) - 1;
        post['isLiked'] = false;
      }
      posts[index] = Map<String, dynamic>.from(post);
    }
  }

  Future<void> updatePost(int index, String newDescription) async {
    final post = posts[index];
    final postId = post['_id'];

    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Color(0xFFDC143C))),
        barrierDismissible: false,
      );

      final response = await apiService.patchData('api/post/$postId', {
        'description': newDescription.trim(),
      });
      
      if (Get.isDialogOpen ?? false) Get.back(); // Close loading dialog

      if (response.statusCode == 200) {
        post['content'] = newDescription.trim();
        posts[index] = Map<String, dynamic>.from(post); // Trigger UI update
        Get.snackbar('Success', 'Post updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update post: ${response.statusText}');
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back(); // Close loading dialog
      debugPrint('Update error: $e');
      Get.snackbar('Error', 'An unexpected error occurred');
    }
  }

  Future<void> deletePost(int index) async {
    final post = posts[index];
    final postId = post['_id'];

    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Color(0xFFDC143C))),
        barrierDismissible: false,
      );

      final response = await apiService.deleteData('api/post/$postId');
      
      if (Get.isDialogOpen ?? false) Get.back(); // Close loading dialog

      if (response.statusCode == 200 || response.statusCode == 204) {
        posts.removeAt(index);
        Get.snackbar('Success', 'Post deleted successfully');
      } else {
        Get.snackbar('Error', 'Failed to delete post: ${response.statusText}');
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back(); // Close loading dialog
      debugPrint('Delete error: $e');
      Get.snackbar('Error', 'An unexpected error occurred');
    }
  }

  Future<void> savePost(int index) async {
    final post = posts[index];
    final postId = post['_id'];

    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Color(0xFFDC143C))),
        barrierDismissible: false,
      );

      final response = await apiService.postData('api/post/save/$postId', {});
      
      if (Get.isDialogOpen ?? false) Get.back(); // Close loading dialog

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Post saved successfully');
      } else {
        var body = response.body;
        String message = body is Map ? (body['message'] ?? 'Failed to save post') : 'Failed to save post';
        Get.snackbar('Info', message);
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back(); // Close loading dialog
      debugPrint('Save error: $e');
      Get.snackbar('Error', 'An unexpected error occurred');
    }
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
