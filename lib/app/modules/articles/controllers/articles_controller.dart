import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sednexapp/app/services/api_service.dart';

class Article {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime date;
  final List<dynamic> fullContent;
  final String category;
  final String? authorName;
  var isSaved = false.obs;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.fullContent,
    required this.category,
    this.authorName,
    bool isSaved = false,
  }) {
    this.isSaved.value = isSaved;
  }
}

class ArticlesController extends GetxController {
  final apiService = Get.find<ApiService>();
  final categories = <String>['All'].obs;
  final categoriesMap = <String, String>{}.obs; // ID -> Name map
  final selectedCategory = 'All'.obs;
  final searchQuery = ''.obs;
  final articles = <Article>[].obs;
  final savedArticles = <Article>[].obs;
  final isLoading = true.obs;
  final isLoadingSaved = false.obs;

  final selectedFilterCategories = <String>[].obs;

  List<Article> get filteredArticles {
    final isFilterMode = selectedFilterCategories.isNotEmpty;
    return articles.where((a) {
      final matchesSearch =
          searchQuery.isEmpty ||
          a.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          a.category.toLowerCase().contains(searchQuery.value.toLowerCase());

      if (!matchesSearch) return false;

      if (isFilterMode) {
        return selectedFilterCategories.contains(a.category);
      }
      if (selectedCategory.value == 'All') {
        return true;
      }
      return a.category == selectedCategory.value;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    // Use a slight delay to allow navigation transition to complete smoothly
    Future.microtask(() => _initializeData());
  }

  void search(String query) {
    searchQuery.value = query;
  }

  Future<void> _initializeData() async {
    isLoading.value = true;
    try {
      await fetchCategories();
      await fetchArticles();
      await fetchSavedArticles();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSavedArticles() async {
    try {
      isLoadingSaved.value = true;
      final response = await apiService.getData('api/article/save/unsave');
      if (response.statusCode == 200) {
        final body = response.body;
        final List savedData = body['articles'] ?? body['data'] ?? [];

        final List<Article> mappedSaved = savedData.map<Article>((item) {
          final articleData = item['article'] ?? item;
          return _mapToArticle(articleData, isSaved: true);
        }).toList();

        savedArticles.assignAll(mappedSaved);

        // Update isSaved state in the main articles list
        final savedIds = mappedSaved.map((e) => e.id).toSet();
        for (var article in articles) {
          article.isSaved.value = savedIds.contains(article.id);
        }
      }
    } catch (e) {
      debugPrint('Error fetching saved articles: $e');
    } finally {
      isLoadingSaved.value = false;
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

    String catValue = item['category']?.toString() ?? '';
    String catName = 'General';

    if (categoriesMap.containsKey(catValue)) {
      catName = categoriesMap[catValue]!;
    } else if (item['category'] is Map) {
      catName = item['category']['name'] ?? 'General';
    } else if (catValue.isNotEmpty &&
        !catValue.contains(RegExp(r'^[0-9a-fA-F]{24}$'))) {
      catName = catValue;
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

  Future<void> fetchArticles() async {
    try {
      final response = await apiService.getData('api/article/');

      if (response.statusCode == 200) {
        var body = response.body;
        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (e) {
            debugPrint('Articles JSON error: $e');
            return;
          }
        }

        if (body is Map && (body['articles'] is List || body['data'] is List)) {
          final List rawArticles = body['articles'] ?? body['data'] ?? [];

          // Map API data to Article objects
          final List<Article> mappedArticles = rawArticles.map<Article>((item) {
            return _mapToArticle(item);
          }).toList();

          mappedArticles.sort((a, b) => b.date.compareTo(a.date));

          articles.assignAll(mappedArticles);

          final Set<String> uniqueCategoryNames = {};
          for (var article in mappedArticles) {
            if (article.category.isNotEmpty) {
              uniqueCategoryNames.add(article.category);
            }
          }

          categories.assignAll([
            'All',
            ...uniqueCategoryNames.toList()..sort(),
          ]);
        }
      }
    } catch (e) {
      debugPrint("Error fetching articles: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshArticles() async {
    await fetchArticles();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    // Clear filter mode when selecting a chip
    selectedFilterCategories.clear();
  }

  void toggleFilterCategory(String category) {
    if (selectedFilterCategories.contains(category)) {
      selectedFilterCategories.remove(category);
    } else {
      selectedFilterCategories.add(category);
    }
  }

  void selectAllFilters() {
    selectedFilterCategories.assignAll(categories.where((c) => c != 'All'));
  }

  void clearAllFilters() {
    selectedFilterCategories.clear();
  }

  void applyFilters() {
    if (selectedFilterCategories.isEmpty) {
      selectedCategory.value = 'All';
    }
    Get.back();
  }

  Future<void> toggleSaved(Article article) async {
    final originalState = article.isSaved.value;
    // Optimistic Update
    article.isSaved.value = !article.isSaved.value;

    try {
      final response = await apiService.postData(
        'api/article/${article.id}/save',
        {},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        // Revert if failed
        article.isSaved.value = originalState;
        Get.snackbar(
          'Error',
          'Failed to update article status',
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // Sync the savedArticles list
        await fetchSavedArticles();
        Get.snackbar(
          'Success',
          article.isSaved.value
              ? 'Article saved successfully'
              : 'Article removed from saved',
          backgroundColor: const Color(0xFF1E63FF),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
        );
      }
    } catch (e) {
      article.isSaved.value = originalState;
      debugPrint('Error toggling article save: $e');
    }
  }
}
