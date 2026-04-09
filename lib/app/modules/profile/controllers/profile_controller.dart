import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/url.dart';

class ProfileController extends GetxController {
  final _box = GetStorage();

  // Observable user fields — populated from local storage
  final userName = ''.obs;
  final userHandle = ''.obs;
  final userEmail = ''.obs;
  final userProfileImage = RxnString(); // null means no image
  final userWarning = ''.obs; // latest warning message

  @override
  void onInit() {
    super.onInit();
    loadUserFromStorage();
    fetchUserWarning();
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
