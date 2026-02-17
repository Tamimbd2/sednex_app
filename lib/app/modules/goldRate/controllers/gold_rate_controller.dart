import 'package:get/get.dart';

class GoldRateController extends GetxController {
  
  final count = 0.obs;
  
  // For Tab State Management
  var selectedTabIndex = 0.obs;
  var selectedTabName = 'Vori'.obs;

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

  void increment() => count.value++;

  void changeTab(int index, String name) {
    selectedTabIndex.value = index;
    selectedTabName.value = name;
  }
}
