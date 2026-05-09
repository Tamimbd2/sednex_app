import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/api_service.dart';
import '../../articles/controllers/articles_controller.dart';

class SavedArticlesController extends GetxController {
  final apiService = Get.find<ApiService>();
  
  final articles = <Article>[].obs;
  final isLoading = true.obs;
  final categoriesMap = <String, String>{}.obs; // ID -> Name map

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    isLoading.value = true;
    try {
      await fetchCategories();
      await fetchSavedArticles();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await apiService.getData('api/article/category');
      if (response.statusCode == 200) {
        final body = response.body;
        if (body is Map && body['categories'] is List) {
          final List rawCats = body['categories'];
          final Map<String, String> newMap = {};
          for (var cat in rawCats) {
            final id = cat['_id']?.toString();
            final name = cat['name']?.toString();
            if (id != null && name != null) {
              newMap[id] = name;
            }
          }
          categoriesMap.assignAll(newMap);
        }
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
  }

  Future<void> fetchSavedArticles() async {
    // isLoading already set by _initializeData or for refresh
    try {
      final response = await apiService.getData('api/article/saved');
      debugPrint('Saved Articles Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        var body = response.body;
        
        // Ensure body is a Map
        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (e) {
            debugPrint('Saved Articles JSON Decode Error: $e');
          }
        }

        if (body is Map) {
          debugPrint('Saved Articles Body Keys: ${body.keys.toList()}');
          final List savedData = body['savedArticles'] ?? body['articles'] ?? body['data'] ?? [];
          debugPrint('Found ${savedData.length} saved articles in response');

          final List<Article> mappedSaved = [];
          for (var item in savedData) {
            try {
              if (item is! Map) continue;
              final articleData = item.containsKey('article') ? item['article'] : item;
              
              if (articleData == null) {
                debugPrint('Skipping null article data for item ID: ${item['_id']}');
                continue;
              }
              
              mappedSaved.add(_mapToArticle(articleData, isSaved: true));
            } catch (e) {
              debugPrint('Error mapping individual saved article: $e | Item: $item');
            }
          }

          articles.assignAll(mappedSaved);
          debugPrint('Assigned ${articles.length} articles to state');
        } else {
          debugPrint('Saved Articles Body is not a Map: $body');
        }
      } else {
        debugPrint('Saved Articles API Error: ${response.statusCode} - ${response.statusText}');
      }
    } catch (e) {
      debugPrint('Error fetching saved articles: $e');
    } finally {
      // Don't set isLoading here if called from _initializeData
    }
  }

  Article _mapToArticle(dynamic item, {bool isSaved = false}) {
    if (item == null || item is! Map) {
      throw Exception('Invalid article item: $item');
    }

    final author = item['author'];
    final createdAt = item['createdAt'] ?? '';
    final List contentList = item['content'] is List ? item['content'] : [];

    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(createdAt).toLocal();
    } catch (_) {
      parsedDate = DateTime.now();
    }

    String catValue = item['category']?.toString() ?? '';
    String catName = 'General';

    if (categoriesMap.containsKey(catValue)) {
      catName = categoriesMap[catValue]!;
    } else if (item['category'] is Map) {
      catName = item['category']['name'] ?? 'General';
    } else if (catValue.isNotEmpty && !catValue.contains(RegExp(r'^[0-9a-fA-F]{24}$'))) {
      catName = catValue;
    }

    String extractedImageUrl = '';
    String extractedDescription = '';

    for (var content in contentList) {
      if (content is! Map) continue;
      
      if (content['type'] == 'image' && extractedImageUrl.isEmpty) {
        extractedImageUrl = content['url'] ?? '';
      }
      if (content['type'] == 'paragraph' && extractedDescription.isEmpty) {
        extractedDescription = _stripHtmlTags(content['data'] ?? '');
      }
    }

    return Article(
      id: item['_id']?.toString() ?? '',
      title: item['title']?.toString() ?? 'Untitled',
      description: extractedDescription.isNotEmpty
          ? extractedDescription
          : (item['description']?.toString() ?? ''),
      imageUrl: extractedImageUrl,
      date: parsedDate,
      fullContent: contentList,
      category: catName,
      authorName: author != null && author is Map ? author['name']?.toString() : null,
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
