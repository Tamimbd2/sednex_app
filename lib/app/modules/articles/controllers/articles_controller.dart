import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Article {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime date;
  final String content;
  final String category;
  final String? authorName;
  var isSaved = false.obs;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.content,
    required this.category,
    this.authorName,
    bool isSaved = false,
  }) {
    this.isSaved.value = isSaved;
  }
}

class ArticlesController extends GetxController {
  final categories = <String>['All'].obs;
  final selectedCategory = 'All'.obs;
  final articles = <Article>[].obs;
  final isLoading = true.obs;

  final selectedFilterCategories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    isLoading.value = true;
    try {
      final connect = GetConnect();
      final response = await connect.get('https://sednex-zvk1.onrender.com/api/article/');

      if (response.statusCode == 200) {
        var body = response.body;
        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (e) {
            print('Articles JSON error: $e');
            return;
          }
        }

        if (body is Map && body['articles'] is List) {
          final List rawArticles = body['articles'];

          // Map API data to Article objects
          final List<Article> mappedArticles = rawArticles.map<Article>((item) {
            final author = item['author'];
            final createdAt = item['createdAt'] ?? '';
            DateTime parsedDate;
            try {
              parsedDate = DateTime.parse(createdAt).toLocal();
            } catch (_) {
              parsedDate = DateTime.now();
            }

            return Article(
              id: item['_id'] ?? '',
              title: item['title'] ?? 'Untitled',
              description: item['description'] ?? '',
              imageUrl: item['image'] ?? item['thumbnail'] ?? 'assets/essentialService/article.png',
              date: parsedDate,
              content: item['description'] ?? '',
              category: item['category'] ?? 'General',
              authorName: author != null ? author['name'] : null,
            );
          }).toList();

          articles.assignAll(mappedArticles);

          // Extract unique categories from API data and build chips
          final Set<String> uniqueCategories = {};
          for (var article in mappedArticles) {
            if (article.category.isNotEmpty) {
              uniqueCategories.add(article.category);
            }
          }

          // Build categories list: "All" + unique categories from API
          categories.assignAll(['All', ...uniqueCategories.toList()..sort()]);

          print('Articles loaded: ${mappedArticles.length}');
          print('Categories found: ${uniqueCategories.toList()}');
        }
      } else {
        print('Failed to fetch articles: ${response.statusCode} ${response.statusText}');
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

  void toggleSaved(Article article) {
    article.isSaved.value = !article.isSaved.value;
  }
}
