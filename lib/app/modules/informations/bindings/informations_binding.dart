import 'package:get/get.dart';

import '../controllers/informations_controller.dart';

class InformationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InformationsController>(
      () => InformationsController(),
    );
  }
}
