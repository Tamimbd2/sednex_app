import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sednexapp/app/services/api_service.dart';

class TeamMember {
  final String id;
  final String name;
  final String image;
  final String designation;
  final String about;

  TeamMember({
    required this.id,
    required this.name,
    required this.image,
    required this.designation,
    required this.about,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      designation: json['designation'] ?? '',
      about: json['about'] ?? '',
    );
  }
}

class AboutusController extends GetxController {
  late final ApiService _apiService;

  final isLoading = false.obs;
  final teamMembers = <TeamMember>[].obs;
  final contactData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ApiService>();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      await Future.wait([fetchTeams(), fetchContact()]);
    } catch (e) {
      debugPrint('Error fetching about data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTeams() async {
    try {
      final response = await _apiService.getData('api/about/teams');

      if (response.status.hasError) {
        debugPrint('Error fetching teams: ${response.statusText}');
        return;
      }

      var body = response.body;
      if (body is String) {
        body = jsonDecode(body);
      }

      if (body['success'] == true && body['members'] != null) {
        final List<dynamic> data = body['members'];
        teamMembers.value = data.map((e) => TeamMember.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Exception fetching teams: $e');
    }
  }

  Future<void> fetchContact() async {
    try {
      final response = await _apiService.getData('api/about/contact');

      if (response.status.hasError) {
        debugPrint('Error fetching contact: ${response.statusText}');
        return;
      }

      var body = response.body;
      if (body is String) {
        body = jsonDecode(body);
      }

      if (body['success'] == true && body['contact'] != null) {
        contactData.value = body['contact'];
      }
    } catch (e) {
      debugPrint('Exception fetching contact: $e');
    }
  }

  void openUrl(String url) {
    // Implement URL launching logic here
    debugPrint("Launching $url");
  }
}
