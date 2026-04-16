import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../articles/controllers/articles_controller.dart';

class SavedArticlesController extends GetxController {
  final apiService = Get.find<ApiService>();
  
  final articles = <Article>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSavedArticles();
  }

  Future<void> fetchSavedArticles() async {
    isLoading.value = true;
    try {
      // Reusing the same endpoint as in ArticlesController
      final response = await apiService.getData('api/article/save/unsave');
      if (response.statusCode == 200) {
        final body = response.body;
        final List savedData = body['articles'] ?? body['data'] ?? [];


        final List<Article> mappedSaved = savedData.map<Article>((item) {
          final articleData = item['article'] ?? item;
          return _mapToArticle(articleData, isSaved: true);
        }).toList();

        articles.assignAll(mappedSaved);
      }
    } catch (e) {
      debugPrint('Error fetching saved articles: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Article _mapToArticle(dynamic item, {bool isSaved = false}) {
    final author = item['author'];
    final createdAt = item['createdAt'] ?? '';
    final List contentList = item['content'] is List ? item['content'] : [];

    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(createdAt).toLocal();
    } catch (_) {
      parsedDate = DateTime.now();
    }

    String catName = 'General';
    if (item['category'] is Map) {
      catName = item['category']['name'] ?? 'General';
    } else if (item['category'] != null) {
      catName = item['category'].toString();
    }

    String extractedImageUrl = '';
    String extractedDescription = '';

    for (var content in contentList) {
      if (content['type'] == 'image' && extractedImageUrl.isEmpty) {
        extractedImageUrl = content['url'] ?? '';
      }
      if (content['type'] == 'paragraph' && extractedDescription.isEmpty) {
        extractedDescription = _stripHtmlTags(content['data'] ?? '');
      }
    }

    return Article(
      id: item['_id'] ?? '',
      title: item['title'] ?? 'Untitled',
      description: extractedDescription.isNotEmpty
          ? extractedDescription
          : (item['description'] ?? ''),
      imageUrl: extractedImageUrl,
      date: parsedDate,
      fullContent: contentList,
      category: catName,
      authorName: author != null ? author['name'] : null,
      isSaved: isSaved,
    );
  }

  String _stripHtmlTags(String htmlString) {
    if (htmlString.isEmpty) return "";
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').trim();
  }

  Future<void> toggleSaved(Article article) async {
    try {
      final response = await apiService.postData(
        'api/article/${article.id}/save',
        {},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        articles.removeWhere((element) => element.id == article.id);
        Get.snackbar(
          'Success',
          'Article removed from saved',
          backgroundColor: const Color(0xFF1E63FF),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
        
        // Sync with main ArticlesController if it exists
        if (Get.isRegistered<ArticlesController>()) {
          Get.find<ArticlesController>().fetchSavedArticles();
        }
      }
    } catch (e) {
      debugPrint('Error toggling article save: $e');
    }
  }
}
