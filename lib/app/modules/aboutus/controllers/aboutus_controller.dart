import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
  final _connect = GetConnect();
  final _box = GetStorage();

  final isLoading = false.obs;
  final teamMembers = <TeamMember>[].obs;
  final contactData = {}.obs;

  @override
  void onInit() {
    super.onInit();
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
      final token =
          _box.read('token') ??
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OTk5MzhmYjViNWJjMmM1YjEyMzYyY2QiLCJlbWFpbCI6ImFmc2FyQHNlZG5leC5jb20iLCJyb2xlIjoidXNlciIsImlhdCI6MTc3Mjg2MTYzMiwiZXhwIjoxNzczNDY2NDMyfQ.PuRUjybyM9EzP2ICL0X_SXoSx8PwDOlJh0XrSi5fiwU';

      final response = await _connect.get(
        'https://sednex-zvk1.onrender.com/api/about/teams',
        headers: {'Authorization': 'Bearer $token'},
      );

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
      final response = await _connect.get(
        'https://sednex-zvk1.onrender.com/api/about/contact',
      );

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
