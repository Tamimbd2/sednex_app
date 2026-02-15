import 'package:get/get.dart';

import '../controllers/restaurents_controller.dart';

class RestaurentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestaurentsController>(
      () => RestaurentsController(),
    );
  }
}
