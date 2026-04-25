import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/url.dart';
import '../../profile/controllers/profile_controller.dart';

class EditprofileController extends GetxController {
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  
  // New Fields
  final birthAddressController = TextEditingController();
  final currentAddressController = TextEditingController();
  final birthDateController = TextEditingController();
  // Reactive dropdown fields
  var selectedGender = ''.obs;
  var selectedMaritalStatus = ''.obs;
  var selectedBloodGroup = ''.obs;
  final jobTitleController = TextEditingController();
  final companyNameController = TextEditingController();
  final workAddressController = TextEditingController();
  final websiteLinkController = TextEditingController();

  final _box = GetStorage();
  final _picker = ImagePicker();

  var isLoading = false.obs;
  var selectedImageBytes = Rx<Uint8List?>(null);
  var selectedImageName = ''.obs;
  var currentAvatar = ''.obs;
  var userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  @override
  void onClose() {
    nameController.dispose();
    bioController.dispose();
    phoneController.dispose();
    locationController.dispose();
    birthAddressController.dispose();
    currentAddressController.dispose();
    birthDateController.dispose();
    super.onClose();
  }

  void _loadFromStorage() {
    final rawUser = _box.read('user');
    if (rawUser != null) {
      try {
        final user = rawUser is String ? jsonDecode(rawUser) : rawUser;
        userId.value = user['_id']?.toString() ?? user['id']?.toString() ?? '';
        nameController.text = user['name']?.toString() ?? '';
        phoneController.text = user['phone']?.toString() ?? '';
        locationController.text = user['country']?.toString() ?? '';
        bioController.text = user['bio']?.toString() ?? '';
        currentAvatar.value = user['profileImage']?.toString() ?? '';

        // Load new fields
        birthAddressController.text = user['birthAddress']?.toString() ?? '';
        currentAddressController.text = user['currentAddress']?.toString() ?? '';
        
        final bDate = user['birthDate']?.toString() ?? '';
        if (bDate.isNotEmpty) {
          try {
            // If it's in ISO format, format it nicely
            final parsedDate = DateTime.parse(bDate);
            birthDateController.text = DateFormat('dd MMM yyyy').format(parsedDate);
          } catch (_) {
            birthDateController.text = bDate;
          }
        }

        // Normalize and load Gender
        String gender = user['gender']?.toString() ?? '';
        if (gender.isNotEmpty) {
          gender = gender[0].toUpperCase() + gender.substring(1).toLowerCase();
          selectedGender.value = gender;
        }

        // Normalize and load Marital Status
        String status = user['maritalStatus']?.toString() ?? '';
        if (status.isNotEmpty) {
          status = status[0].toUpperCase() + status.substring(1).toLowerCase();
          selectedMaritalStatus.value = status;
        }

        // Normalize and load Blood Group (Upper Case)
        String blood = user['bloodGroup']?.toString() ?? '';
        if (blood.isNotEmpty) {
          selectedBloodGroup.value = blood.toUpperCase();
        }

        jobTitleController.text = user['jobTitle']?.toString() ?? '';
        companyNameController.text = user['companyName']?.toString() ?? '';
        workAddressController.text = user['workAddress']?.toString() ?? '';
        websiteLinkController.text = user['websiteLink']?.toString() ?? '';
      } catch (_) {}
    }
  }

  Future<void> chooseDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E63FF),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      birthDateController.text = DateFormat('dd MMM yyyy').format(pickedDate);
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      selectedImageBytes.value = await pickedFile.readAsBytes();
      selectedImageName.value = pickedFile.name;
    }
  }

  Future<void> saveChanges() async {
    debugPrint('--- saveChanges() called ---');
    debugPrint('userId: ${userId.value}');

    if (userId.value.isEmpty) {
      Get.snackbar('Error', 'User information not found. Please log in again.');
      return;
    }

    try {
      isLoading.value = true;

      final token = _box.read('token') ?? '';
      final uri = Uri.parse('${AppUrl.baseUrl}api/users/${userId.value}');

      // Convert birthDate back to ISO format for the API
      String formattedBirthDate = birthDateController.text.trim();
      if (formattedBirthDate.isNotEmpty) {
        try {
          final parsedDate = DateFormat('dd MMM yyyy').parse(formattedBirthDate);
          formattedBirthDate = DateFormat('yyyy-MM-dd').format(parsedDate);
        } catch (_) {
          // If parsing fails, send as is
        }
      }

      final request = http.MultipartRequest('PATCH', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['name'] = nameController.text.trim()
        ..fields['bio'] = bioController.text.trim()
        ..fields['phone'] = phoneController.text.trim()
        ..fields['country'] = locationController.text.trim()
        ..fields['birthAddress'] = birthAddressController.text.trim()
        ..fields['currentAddress'] = currentAddressController.text.trim()
        ..fields['birthDate'] = formattedBirthDate
        ..fields['gender'] = selectedGender.value.trim().toLowerCase()
        ..fields['maritalStatus'] = selectedMaritalStatus.value.trim().toLowerCase()
        ..fields['bloodGroup'] = selectedBloodGroup.value.trim()
        ..fields['jobTitle'] = jobTitleController.text.trim()
        ..fields['companyName'] = companyNameController.text.trim()
        ..fields['workAddress'] = workAddressController.text.trim()
        ..fields['websiteLink'] = websiteLinkController.text.trim();

      // Attach image if selected — field name is 'profileImage' (confirmed from Postman)
      if (selectedImageBytes.value != null) {
        final filename = selectedImageName.value.isNotEmpty
            ? selectedImageName.value
            : 'profile.jpg';
        request.files.add(http.MultipartFile.fromBytes(
          'profileImage',
          selectedImageBytes.value!,
          filename: filename,
        ));
      }

      debugPrint('Sending PATCH to $uri');
      final streamed = await request.send();
      final httpResponse = await http.Response.fromStream(streamed);

      debugPrint('Response status: ${httpResponse.statusCode}');
      debugPrint('Response body: ${httpResponse.body}');

      if (httpResponse.statusCode == 200) {
        final parsed = jsonDecode(httpResponse.body);
        final updatedUser = parsed['user'] ?? parsed;
        _box.write('user', jsonEncode(updatedUser));
        currentAvatar.value =
            updatedUser['profileImage']?.toString() ?? currentAvatar.value;

        // Instantly refresh ProfileController so the UI updates without restart
        _refreshProfile();

        Get.back();
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Map<String, dynamic>? parsed;
        try {
          parsed = jsonDecode(httpResponse.body);
        } catch (_) {}
        final msg = parsed?['message'] ?? 'Failed to update profile';
        Get.snackbar(
          'Error',
          msg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, st) {
      debugPrint('saveChanges error: $e\n$st');
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  void _refreshProfile() {
    try {
      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().loadUserFromStorage();
      }
    } catch (_) {}
  }
}
