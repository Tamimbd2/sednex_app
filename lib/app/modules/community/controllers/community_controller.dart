import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../../services/api_service.dart';

class CommunityController extends GetxController {
  final apiService = Get.find<ApiService>();

  // List of all members from API
  final members = <dynamic>[].obs;
  
  // Filtered members based on search
  final filteredMembers = <dynamic>[].obs;
  
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final response = await apiService.getData('api/users/');
      
      if (response.statusCode == 200) {
        final data = response.body;
        if (data != null && data['success'] == true) {
          final List usersList = data['users'] ?? [];
          members.assignAll(usersList);
          filteredMembers.assignAll(usersList);
        }
      } else {
        debugPrint('Error fetching users: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception fetching users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Search members by name
  void searchMembers(String query) {
    if (query.isEmpty) {
      filteredMembers.assignAll(members);
    } else {
      filteredMembers.assignAll(
        members.where((member) {
          final name = (member['name'] ?? '').toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList()
      );
    }
  }
}
