import 'package:get/get.dart';

import '../controllers/busflight_controller.dart';

class BusflightBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BusflightController>(
      () => BusflightController(),
    );
  }
}
