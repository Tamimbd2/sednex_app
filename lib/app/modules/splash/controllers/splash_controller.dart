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

    if (isLoggedIn && token.toString().isNotEmpty) {
      // User is already logged in, go to dashboard
      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      // User is not logged in, go to onboard
      Get.offAllNamed(Routes.ONBOARD);
    }
  }
}
