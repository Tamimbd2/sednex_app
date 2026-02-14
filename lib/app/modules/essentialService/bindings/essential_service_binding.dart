import 'package:get/get.dart';

import '../controllers/essential_service_controller.dart';

class EssentialServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EssentialServiceController>(
      () => EssentialServiceController(),
    );
  }
}
