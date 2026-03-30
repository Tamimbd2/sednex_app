import 'package:get/get.dart';

import '../controllers/mypost_controller.dart';

class MypostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MypostController>(
      () => MypostController(),
    );
  }
}
