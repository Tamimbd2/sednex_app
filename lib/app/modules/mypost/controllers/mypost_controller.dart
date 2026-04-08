import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../services/api_service.dart';
import '../../../core/constants/url.dart';

class MypostController extends GetxController {
  final apiService = Get.find<ApiService>();
  final box = GetStorage();

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
      String url = AppUrl.postsMe;
      url += '?page=${currentPage.value}&limit=10';

      debugPrint('Fetching user posts from: $url');
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

            return {
              '_id': post['_id'] ?? '',
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
              'category':
                  (post['category']?.toString() ?? 'General').capitalizeFirst,
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
      }
    } catch (e) {
      debugPrint("Error fetching user posts: $e");
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
      final url = 'api/post/comment/$postId';

      final Map<String, dynamic> body = {'content': text.trim()};

      if (isReply) {
        body['parentCommentId'] = replyTargetCommentId.value;
      }

      final response = await apiService.postData(url, body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        clearReplyTarget();
        fetchComments(index);
      }
    } catch (e) {
      debugPrint('Error posting comment: $e');
    }
  }

  Future<void> toggleLike(int index) async {
    final post = posts[index];
    final postId = post['_id'];
    final currentUserId = userId;

    if (currentUserId == null) return;

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
          post['likes'] = updatedPost['loveCount'] ?? 0;
          post['isLiked'] =
              (updatedPost['lovedBy'] as List?)?.contains(currentUserId) ??
              false;
          posts[index] = Map<String, dynamic>.from(post);
        }
      }
    } catch (e) {
      debugPrint('Like error: $e');
    }
  }

  Future<void> updatePost(int index, String newDescription) async {
    final post = posts[index];
    final postId = post['_id'];

    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: Color(0xFF1E63FF)),
        ),
        barrierDismissible: false,
      );

      final response = await apiService.patchData('api/post/$postId', {
        'description': newDescription.trim(),
      });

      if (Get.isDialogOpen ?? false) Get.back();

      if (response.statusCode == 200) {
        post['content'] = newDescription.trim();
        posts[index] = Map<String, dynamic>.from(post);
        Get.snackbar('Success', 'Post updated successfully');
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
    }
  }

  Future<void> deletePost(int index) async {
    final post = posts[index];
    final postId = post['_id'];

    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: Color(0xFF1E63FF)),
        ),
        barrierDismissible: false,
      );

      final response = await apiService.deleteData('api/post/$postId');

      if (Get.isDialogOpen ?? false) Get.back();

      if (response.statusCode == 200 || response.statusCode == 204) {
        posts.removeAt(index);
        Get.snackbar('Success', 'Post deleted successfully');
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
    }
  }

  Future<void> savePost(int index) async {
    final post = posts[index];
    final postId = post['_id'];
    try {
      final response = await apiService.postData('api/post/save/$postId', {});
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Post saved successfully');
      }
    } catch (e) {
      debugPrint('Save error: $e');
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

  String _timeAgo(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString).toLocal();
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inSeconds < 60) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${(diff.inDays / 7).floor()}w ago';
    } catch (e) {
      return '';
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
      final bool hasBangla = RegExp(r"[\u0980-\u09FF]").hasMatch(text);
      await flutterTts.setLanguage(hasBangla ? "bn-BD" : "en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(text);
      currentlySpeakingIndex.value = index;
      flutterTts.setCompletionHandler(() => currentlySpeakingIndex.value = -1);
    } catch (e) {
      debugPrint("TTS Error: $e");
    }
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
