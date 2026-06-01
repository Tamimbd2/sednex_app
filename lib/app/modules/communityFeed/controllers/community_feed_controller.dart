import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../services/api_service.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CommunityFeedController extends GetxController {
  final apiService = Get.find<ApiService>();
  final box = GetStorage();

  final count = 0.obs;

  final List<String> filters = [
    "All Post",
    "Job Posts",
    "Buy & Sells",
    "Questions",
    "Home Rents",
    "Help Request",
    "Updates",
  ];
  final selectedFilter = "All Post".obs;

  final posts = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final isLoadingComments = false.obs;
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final expandedPosts = <int>{}.obs;

  // TTS State
  final flutterTts = FlutterTts();
  final currentlySpeakingIndex = (-1).obs;

  // Reply related states
  final replyTargetCommentId = RxnString();
  final replyTargetName = RxnString();

  String? get userId {
    final userData = box.read('user');
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

  @override
  void onInit() {
    super.onInit();
    _initTts();
    fetchPosts();

    // Listen to filter changes
    ever(selectedFilter, (_) {
      currentPage.value = 1;
      posts.clear();
      fetchPosts();
    });
  }

  void _initTts() async {
    try {
      if (GetPlatform.isAndroid) {
        // Dynamically find an available engine (important for non-Google devices like Chinese HyperOS)
        final dynamic engines = await flutterTts.getEngines;
        if (engines != null && (engines as List).isNotEmpty) {
          // Pick the first available engine (like XiaoAi or the default)
          await flutterTts.setEngine(engines.first as String);
        }
      }
      // Warm up the engine to prevent "not bound" errors on first use
      await flutterTts.awaitSpeakCompletion(true);
    } catch (e) {
      debugPrint("TTS Warmup Error: $e");
    }
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
      if (selectedFilter.value == "All Post") {
        url = 'api/post/';
      } else {
        // Map UI filter to API category
        String category = selectedFilter.value.toLowerCase();
        if (category == "buy & sells") category = "buy_sell";
        if (category == "home rents") category = "rentals";
        if (category == "job posts") category = "job";
        if (category == "questions") category = "question";
        if (category == "help request") category = "help";
        if (category == "updates") category = "update";

        url = 'api/post/category/$category';
      }

      // Add pagination params
      url += '?page=${currentPage.value}&limit=10';

      debugPrint('Fetching posts from: $url');
      final response = await apiService.getData(url);

      if (response.statusCode == 200) {
        var body = response.body;
        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (e) {
            debugPrint('Posts JSON error: $e');
            return;
          }
        }

        if (body is Map) {
          totalPages.value = body['totalPages'] ?? 1;

          final List rawPosts = body['posts'] ?? [];
          final currentUserId = userId;

          final List<Map<String, dynamic>>
          mappedPosts = rawPosts.map<Map<String, dynamic>>((post) {
            final author = post['author'] ?? {};
            final images = (post['images'] as List?)?.cast<String>() ?? [];
            final createdAt = post['createdAt'] ?? '';
            final lovedBy = (post['lovedBy'] as List?) ?? [];

            // Map API category to display category
            String displayCategory = _mapCategory(
              post['category'] ?? 'general',
            );

            return {
              '_id': post['_id'] ?? '',
              'author': author,
              'authorId': author['_id'] ?? '',
              'name': author['name'] ?? 'Unknown',
              'time': _timeAgo(createdAt),
              'content': post['description'] ?? '',
              'avatar':
                  author['profileImage'] ??
                  'https://ui-avatars.com/api/?name=${Uri.encodeComponent(author['name'] ?? 'U')}&background=1E63FF&color=fff&size=80',
              'likes': post['loveCount'] ?? 0,
              'comments': post['commentsCount'] ?? 0,
              'isLiked':
                  currentUserId != null && lovedBy.contains(currentUserId),
              'hasSave': false,
              'category': displayCategory,
              'images': images,
              'lovedBy': lovedBy,
              'isCompleted': post['isCompleted'] ?? false,
              'isVerified': author['isVerified'] == true || author['verified'] == true,
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
        debugPrint(
          'Failed to fetch posts: ${response.statusCode} - ${response.statusText}',
        );
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

        final List<Map<String, dynamic>>
        mappedComments = rawComments.map<Map<String, dynamic>>((c) {
          final author = c['author'] ?? {};
          return {
            '_id': c['_id'] ?? '',
            'name': author['name'] ?? 'Unknown',
            'text': c['content'] ?? '',
            'avatar':
                author['profileImage'] ??
                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(author['name'] ?? 'U')}&background=1E63FF&color=fff&size=60',
            'time': _timeAgo(c['createdAt'] ?? ''),
            'replies': <Map<String, dynamic>>[].obs,
            'isRepliesLoading': false.obs,
            'showReplies': false.obs,
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

  Future<void> fetchReplies(int postIndex, int commentIndex) async {
    final comment = (posts[postIndex]['commentsList'] as RxList)[commentIndex];
    final commentId = comment['_id'];

    try {
      comment['isRepliesLoading'].value = true;
      final response = await apiService.getData(
        'api/post/comment/replies/$commentId',
      );

      if (response.statusCode == 200) {
        final body = response.body;
        final List rawReplies = body['replies'] ?? [];

        final List<Map<String, dynamic>>
        mappedReplies = rawReplies.map<Map<String, dynamic>>((r) {
          final author = r['author'] ?? {};
          return {
            '_id': r['_id'] ?? '',
            'name': author['name'] ?? 'Unknown',
            'text': r['content'] ?? '',
            'avatar':
                author['profileImage'] ??
                'https://ui-avatars.com/api/?name=${Uri.encodeComponent(author['name'] ?? 'U')}&background=1E63FF&color=fff&size=50',
            'time': _timeAgo(r['createdAt'] ?? ''),
          };
        }).toList();

        if (comment['replies'] is RxList) {
          (comment['replies'] as RxList<Map<String, dynamic>>).assignAll(
            mappedReplies,
          );
        } else {
          comment['replies'] = RxList<Map<String, dynamic>>(mappedReplies);
        }
        comment['showReplies'].value = true;
      }
    } catch (e) {
      debugPrint('Error fetching replies: $e');
    } finally {
      comment['isRepliesLoading'].value = false;
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
      final url =
          'api/post/comment/$postId'; // Same URL for both as per your Postman

      final Map<String, dynamic> body = {'content': text.trim()};

      if (isReply) {
        body['parentCommentId'] = replyTargetCommentId.value;
      }

      final response = await apiService.postData(url, body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        clearReplyTarget();
        fetchComments(index); // Refresh comments list
      } else {
        Get.snackbar(
          'Error',
          'Failed to post ${isReply ? 'reply' : 'comment'}',
        );
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
    if (apiCategory.isEmpty) return 'All Post';
    String category = apiCategory.toLowerCase();
    if (category == 'rental' || category == 'rentals') return 'Home Rents';
    if (category == 'job' || category == 'jobs') return 'Job Posts';
    if (category == 'question' || category == 'questions') return 'Questions';
    if (category == 'sell' || category == 'buy_sell') return 'Buy & Sells';
    if (category == 'help') return 'Help Request';
    if (category == 'update') return 'Updates';
    return category.capitalizeFirst ?? 'All Post';
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
        const Center(
          child: CircularProgressIndicator(color: Color(0xFF1E63FF)),
        ),
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
        const Center(
          child: CircularProgressIndicator(color: Color(0xFF1E63FF)),
        ),
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
        const Center(
          child: CircularProgressIndicator(color: Color(0xFF1E63FF)),
        ),
        barrierDismissible: false,
      );

      final response = await apiService.postData('api/post/save/$postId', {});

      if (Get.isDialogOpen ?? false) Get.back(); // Close loading dialog

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Post saved successfully');
      } else {
        var body = response.body;
        String message = body is Map
            ? (body['message'] ?? 'Failed to save post')
            : 'Failed to save post';
        Get.snackbar('Info', message);
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back(); // Close loading dialog
      debugPrint('Save error: $e');
      Get.snackbar('Error', 'An unexpected error occurred');
    }
  }

  Future<void> markAsCompleted(int index) async {
    final post = posts[index];
    final postId = post['_id'];
    final bool currentStatus = post['isCompleted'] ?? false;
    final bool newStatus = !currentStatus;

    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: Color(0xFF1E63FF)),
        ),
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
        Get.snackbar(
          'Success',
          newStatus ? 'Post closed successfully' : 'Post opened successfully',
        );
      } else {
        Get.snackbar('Error', 'Failed to update post status');
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      debugPrint('Completion error: $e');
    }
  }

  void increment() => count.value++;

  // Text-to-Speech Implementation
  Future<void> speakPost(int index, String text) async {
    try {
      if (text.trim().isEmpty) return;

      // Immediate UI Feedback: If we're already speaking this post, stop it
      if (currentlySpeakingIndex.value == index) {
        currentlySpeakingIndex.value = -1;
        await flutterTts.stop();
        return;
      }

      // Stop any other active speech and update index
      await flutterTts.stop();
      currentlySpeakingIndex.value = index;

      // Configure and Speak
      String lang = _detectLanguage(text);
      await flutterTts.setLanguage(lang);
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);

      int result = await flutterTts.speak(text);
      if (result != 1) {
        // If speaking failed, reset the index
        currentlySpeakingIndex.value = -1;
      }

      flutterTts.setCompletionHandler(() {
        currentlySpeakingIndex.value = -1;
      });
      
      flutterTts.setErrorHandler((msg) {
        currentlySpeakingIndex.value = -1;
        debugPrint("TTS Error: $msg");
      });
    } catch (e) {
      currentlySpeakingIndex.value = -1;
      debugPrint("TTS Exception: $e");
    }
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }

  /// Detects the primary language/script in [text] using Unicode block ranges.
  /// Falls back to 'en-US' for Latin or unknown scripts.
  String _detectLanguage(String text) {
    if (text.isEmpty) return 'en-US';

    final counts = <String, int>{};

    void addCount(String lang) => counts[lang] = (counts[lang] ?? 0) + 1;

    for (final rune in text.runes) {
      if (rune >= 0x0980 && rune <= 0x09FF) {
        addCount('bn-BD');
      } // Bengali / Bangla
      else if (rune >= 0x0600 && rune <= 0x06FF) {
        addCount('ar-SA');
      } // Arabic
      else if (rune >= 0x3040 && rune <= 0x30FF) {
        addCount('ja-JP');
      } // Hiragana + Katakana
      else if (rune >= 0x4E00 && rune <= 0x9FFF) {
        addCount('zh-CN');
      } // CJK Unified Ideographs
      else if (rune >= 0xAC00 && rune <= 0xD7AF) {
        addCount('ko-KR');
      } // Hangul
      else if (rune >= 0x0400 && rune <= 0x04FF) {
        addCount('ru-RU');
      } // Cyrillic
      else if (rune >= 0x0900 && rune <= 0x097F) {
        addCount('hi-IN');
      } // Devanagari (Hindi)
      else if (rune >= 0x0E00 && rune <= 0x0E7F) {
        addCount('th-TH');
      } // Thai
    }

    if (counts.isEmpty) return 'en-US';

    // Return the language with the highest character count
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }
}
