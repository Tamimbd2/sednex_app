import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sednexapp/app/core/constants/url.dart';

class TermItem {
  final String id;
  final String title;
  final String content;
  final String version;
  final DateTime lastUpdated;

  TermItem({
    required this.id,
    required this.title,
    required this.content,
    required this.version,
    required this.lastUpdated,
  });

  factory TermItem.fromJson(Map<String, dynamic> json) {
    return TermItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      version: json['version'] ?? '',
      lastUpdated: DateTime.parse(
        json['lastUpdated'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class TermsandconditionController extends GetxController {
  final _connect = GetConnect();

  final isLoading = false.obs;
  final terms = <TermItem>[].obs;
  final lastUpdated = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchTerms();
  }

  Future<void> fetchTerms() async {
    try {
      isLoading.value = true;
      final response = await _connect.get('${AppUrl.baseUrl}api/about/terms');

      if (response.status.hasError) {
        debugPrint('Error fetching terms: ${response.statusText}');
        return;
      }

      var body = response.body;
      if (body is String) {
        body = jsonDecode(body);
      }

      if (body['success'] == true && body['terms'] != null) {
        final List<dynamic> data = body['terms'];
        final List<TermItem> items = data
            .map((e) => TermItem.fromJson(e))
            .toList();

        // Sort by lastUpdated ascending (oldest first) as requested by user
        items.sort((a, b) => a.lastUpdated.compareTo(b.lastUpdated));

        terms.value = items;

        if (items.isNotEmpty) {
          // Find the latest update date for the "Last updated" text
          final latestUpdate = items
              .map((e) => e.lastUpdated)
              .reduce((a, b) => a.isAfter(b) ? a : b);
          lastUpdated.value = latestUpdate;
        }
      }
    } catch (e) {
      debugPrint('Exception fetching terms: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
