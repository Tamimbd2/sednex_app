import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () {
      _checkLoginStatus();
    });
  }

  void _checkLoginStatus() {
    final box = GetStorage();
    final isLoggedIn = box.read('isLoggedIn') ?? false;
    final token = box.read('token') ?? '';
    final isFirstTime = box.read('isFirstTime') ?? true;

    if (isLoggedIn && token.toString().isNotEmpty) {
      // User is already logged in, go to dashboard
      Get.offAllNamed(Routes.DASHBOARD);
    } else if (isFirstTime) {
      // First time user, show onboarding
      Get.offAllNamed(Routes.ONBOARD);
    } else {
      // Not first time, go directly to sign in
      Get.offAllNamed(Routes.SIGNIN);
    }
  }
}
