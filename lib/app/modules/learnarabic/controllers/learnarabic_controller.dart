import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sednexapp/app/core/constants/url.dart';

class LearnArabicCategory {
  final String id;
  final String name;

  LearnArabicCategory({required this.id, required this.name});

  factory LearnArabicCategory.fromJson(Map<String, dynamic> json) {
    return LearnArabicCategory(id: json['_id'] ?? '', name: json['name'] ?? '');
  }
}

class LearnArabicWord {
  final String id;
  final String categoryId;
  final String english;
  final String arabic;
  final String pronunciation;
  final String example;

  LearnArabicWord({
    required this.id,
    required this.categoryId,
    required this.english,
    required this.arabic,
    required this.pronunciation,
    required this.example,
  });

  factory LearnArabicWord.fromJson(Map<String, dynamic> json) {
    return LearnArabicWord(
      id: json['_id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      english: json['english'] ?? '',
      arabic: json['arabic'] ?? '',
      pronunciation: json['pronunciation'] ?? '',
      example: json['example'] ?? '',
    );
  }
}

class LearnarabicController extends GetxController {
  final _connect = GetConnect();

  final selectedTab = (-1).obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  final categories = <LearnArabicCategory>[].obs;
  final allWords = <LearnArabicWord>[].obs;
  final currentWords = <LearnArabicWord>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      await Future.wait([fetchCategories(), fetchWords()]);
      changeTab(-1);
    } catch (e) {
      debugPrint('Error fetching learn arabic data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await _connect.get(
        '${AppUrl.baseUrl}api/learn-arabic/categories',
      );
      if (response.status.hasError) return;

      var body = response.body;
      if (body is String) {
        body = jsonDecode(body);
      }

      final List<dynamic> data = body['categories'] ?? [];
      categories.value = data
          .map((e) => LearnArabicCategory.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
  }

  Future<void> fetchWords() async {
    try {
      final response = await _connect.get(
        '${AppUrl.baseUrl}api/learn-arabic/words',
      );
      if (response.status.hasError) return;

      var body = response.body;
      if (body is String) {
        body = jsonDecode(body);
      }

      final List<dynamic> data = body['words'] ?? [];
      allWords.value = data.map((e) => LearnArabicWord.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error fetching words: $e');
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _filterWords();
  }

  void changeTab(int index) {
    selectedTab.value = index;
    _filterWords();
  }

  void _filterWords() {
    List<LearnArabicWord> tempWords = [];
    if (selectedTab.value == -1) {
      tempWords = allWords.toList();
    } else {
      if (categories.isEmpty) {
        currentWords.value = [];
        return;
      }
      final currentCategoryId = categories[selectedTab.value].id;
      tempWords = allWords
          .where((word) => word.categoryId == currentCategoryId)
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      tempWords = tempWords.where((word) {
        return word.example.toLowerCase().contains(query) ||
            word.english.toLowerCase().contains(query) ||
            word.arabic.toLowerCase().contains(query) ||
            word.pronunciation.toLowerCase().contains(query);
      }).toList();
    }

    currentWords.value = tempWords;
  }
}
