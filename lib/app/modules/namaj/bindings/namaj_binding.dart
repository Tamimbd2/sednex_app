import 'package:get/get.dart';

import '../controllers/namaj_controller.dart';

class NamajBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NamajController>(
      () => NamajController(),
    );
  }
}
