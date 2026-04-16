import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/url.dart';

class ProfileController extends GetxController {
  final _box = GetStorage();

  // Observable user fields — populated from local storage
  final userName = ''.obs;
  final userHandle = ''.obs;
  final userEmail = ''.obs;
  final userProfileImage = RxnString();
  final userWarning = ''.obs;

  // Personal Information
  final birthAddress = ''.obs;
  final currentAddress = ''.obs;
  final birthDate = ''.obs;
  final gender = ''.obs;
  final maritalStatus = ''.obs;
  final nationality = ''.obs;
  final bloodGroup = ''.obs;

  // Professional Information
  final jobTitle = ''.obs;
  final companyName = ''.obs;
  final workAddress = ''.obs;

  // Contact Information
  final userPhone = ''.obs;
  final websiteLink = ''.obs;
  final isPhoneVerified = false.obs;
  final isEmailVerified = false.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserFromStorage();
    fetchUserWarning();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    final token = _box.read('token');
    if (token == null) return;

    isLoading.value = true;
    final connect = GetConnect();
    
    try {
      final response = await connect.get(
        '${AppUrl.baseUrl}api/users/me',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 && response.body['success'] == true) {
        final user = response.body['user'];
        if (user == null) return;
        
        // Update basic info
        userName.value = user['name']?.toString() ?? '';
        userEmail.value = user['email']?.toString() ?? '';
        
        final handle = (user['username']?.toString() ?? user['name']?.toString() ?? '').toLowerCase().replaceAll(' ', '');
        userHandle.value = handle.isNotEmpty ? '@$handle' : '';
        
        final img = user['profileImage']?.toString();
        userProfileImage.value = (img != null && img.isNotEmpty) ? img : null;

        // Update Personal Info
        birthAddress.value = user['birthAddress']?.toString() ?? '';
        currentAddress.value = user['currentAddress']?.toString() ?? '';
        birthDate.value = user['birthDate']?.toString() ?? '';
        gender.value = user['gender']?.toString() ?? '';
        maritalStatus.value = user['maritalStatus']?.toString() ?? '';
        nationality.value = user['nationality']?.toString() ?? '';
        bloodGroup.value = user['bloodGroup']?.toString() ?? '';

        // Update Professional Info
        jobTitle.value = user['jobTitle']?.toString() ?? '';
        companyName.value = user['companyName']?.toString() ?? '';
        workAddress.value = user['workAddress']?.toString() ?? '';

        // Update Contact Info
        userPhone.value = user['phone']?.toString() ?? '';
        websiteLink.value = user['websiteLink']?.toString() ?? ''; // Notice websiteLink matches screenshot
        isPhoneVerified.value = user['isPhoneVerified'] ?? false;
        isEmailVerified.value = user['isEmailVerified'] ?? false;

        // Also update local storage with fresh data as a JSON string for compatibility
        _box.write('user', jsonEncode(user));
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void loadUserFromStorage() {
    final rawUser = _box.read('user');
    if (rawUser != null) {
      try {
        final user = rawUser is String ? jsonDecode(rawUser) : rawUser;
        userName.value = user['name']?.toString() ?? '';
        userEmail.value = user['email']?.toString() ?? '';

        // Build a handle from the name (e.g. "Shamim Islam" → "@shamimislam")
        final handle = (user['username']?.toString() ??
                user['name']?.toString() ??
                '')
            .toLowerCase()
            .replaceAll(' ', '');
        userHandle.value = handle.isNotEmpty ? '@$handle' : '';

        // Profile image — null if not present
        final img = user['profileImage']?.toString();
        userProfileImage.value =
            (img != null && img.isNotEmpty) ? img : null;
      } catch (e) {
        // Storage data malformed — leave defaults
      }
    }
  }

  void fetchUserWarning() async {
    final rawUser = _box.read('user');
    final token = _box.read('token');

    if (rawUser != null && token != null) {
      final user = rawUser is String ? jsonDecode(rawUser) : rawUser;
      final userId = user['_id'];

      if (userId != null) {
        final connect = GetConnect();
        try {
          final response = await connect.get(
            '${AppUrl.baseUrl}api/users/$userId/warnings',
            headers: {'Authorization': 'Bearer $token'},
          );

          if (response.statusCode == 200 && response.body['success'] == true) {
            final List warnings = response.body['warnings'];
            if (warnings.isNotEmpty) {
              // Take the first one as latest (assuming API returns sorted or just need one)
              userWarning.value = warnings.first['message'].toString();
            } else {
              userWarning.value = '';
            }
          }
        } catch (e) {
          userWarning.value = '';
        }
      }
    }
  }

  void logout() {
    _box.remove('token');
    _box.remove('user');
    _box.write('isLoggedIn', false);
    Get.offAllNamed('/signin');
  }
}
