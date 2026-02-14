import 'package:get/get.dart';

import '../controllers/localtour_controller.dart';

class LocaltourBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocaltourController>(
      () => LocaltourController(),
    );
  }
}
