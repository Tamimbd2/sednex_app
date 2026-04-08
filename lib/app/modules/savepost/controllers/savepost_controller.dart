import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../services/api_service.dart';

class SavepostController extends GetxController {
  final apiService = Get.find<ApiService>();
  final box = GetStorage();

  final posts = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final isLoadingComments = false.obs;
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
    _initTts();
    fetchSavedPosts();
  }

  void _initTts() async {
    try {
      if (GetPlatform.isAndroid) {
        final dynamic engines = await flutterTts.getEngines;
        if (engines != null && (engines as List).isNotEmpty) {
          await flutterTts.setEngine(engines.first as String);
        }
      }
      await flutterTts.awaitSpeakCompletion(true);
    } catch (e) {
      debugPrint("TTS Warmup Error: $e");
    }
  }

  Future<void> fetchSavedPosts() async {
    isLoading.value = true;
    try {
      debugPrint('Fetching saved posts from: api/post/saved');
      final response = await apiService.getData('api/post/saved');

      if (response.statusCode == 200) {
        var body = response.body;
        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (e) {
            debugPrint('Saved Posts JSON error: $e');
            return;
          }
        }

        if (body is Map) {
          final List rawPosts =
              body['savedPosts'] ?? []; // Corrected to match your API response
          final currentUserId = userId;

          final List<Map<String, dynamic>>
          mappedPosts = rawPosts.map<Map<String, dynamic>>((post) {
            final postData = post['post'] ?? post;
            final author = postData['author'];

            // Handle if author is a Map (populated) or String (not populated)
            final String name = author is Map
                ? (author['name'] ?? 'User')
                : 'User';
            final String avatar = author is Map
                ? (author['profileImage'] ??
                      'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=1E63FF&color=fff&size=80')
                : 'https://ui-avatars.com/api/?name=U&background=1E63FF&color=fff&size=80';

            final images = (postData['images'] as List?)?.cast<String>() ?? [];
            final createdAt = postData['createdAt'] ?? '';
            final lovedBy = (postData['lovedBy'] as List?) ?? [];

            return {
              '_id': postData['_id'] ?? '',
              'authorId': author is Map
                  ? (author['_id'] ?? '')
                  : (author ?? ''),
              'name': name,
              'time': _timeAgo(createdAt),
              'content': postData['description'] ?? '',
              'avatar': avatar,
              'likes': postData['loveCount'] ?? 0,
              'comments': postData['commentsCount'] ?? 0,
              'isLiked':
                  currentUserId != null && lovedBy.contains(currentUserId),
              'category': (postData['category'] ?? 'general')
                  .toString()
                  .capitalizeFirst,
              'images': images,
              'commentsList': <Map<String, dynamic>>[].obs,
            };
          }).toList();

          posts.assignAll(mappedPosts);
        }
      } else {
        debugPrint('Failed to fetch saved posts: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error fetching saved posts: $e");
    } finally {
      isLoading.value = false;
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

  Future<void> toggleLike(int index) async {
    final post = posts[index];
    final postId = post['_id'];
    final currentUserId = userId;

    if (currentUserId == null) return;

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
      await apiService.patchData('api/post/$postId/love', {});
    } catch (e) {
      debugPrint('Like error: $e');
    }
  }

  Future<void> savePost(int index) async {
    // Post is already saved if it's in this list, but user might want to unsave?
    // For now, let's just implement the snackbar
    Get.snackbar('Info', 'Post is already in your saved collection');
  }

  Future<void> speakPost(int index, String text) async {
    try {
      if (currentlySpeakingIndex.value == index) {
        await flutterTts.stop();
        currentlySpeakingIndex.value = -1;
        return;
      }
      await flutterTts.stop();
      String lang = _detectLanguage(text);
      await flutterTts.setLanguage(lang);
      await flutterTts.speak(text);
      currentlySpeakingIndex.value = index;
      flutterTts.setCompletionHandler(() {
        currentlySpeakingIndex.value = -1;
      });
    } catch (e) {
      debugPrint("TTS Error: $e");
    }
  }

  String _detectLanguage(String text) {
    if (text.isEmpty) return 'en-US';
    for (final rune in text.runes) {
      if (rune >= 0x0980 && rune <= 0x09FF) return 'bn-BD';
    }
    return 'en-US';
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}
