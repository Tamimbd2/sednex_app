import 'package:get/get.dart';

import '../controllers/savepost_controller.dart';

class SavepostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavepostController>(
      () => SavepostController(),
    );
  }
}
