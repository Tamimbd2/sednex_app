import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Current selected index for bottom navigation
  final currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Change page based on bottom navigation selection
  void changePage(int index) {
    currentIndex.value = index;
  }
}
