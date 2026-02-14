import 'package:get/get.dart';

import '../controllers/learnarabic_controller.dart';

class LearnarabicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LearnarabicController>(
      () => LearnarabicController(),
    );
  }
}
