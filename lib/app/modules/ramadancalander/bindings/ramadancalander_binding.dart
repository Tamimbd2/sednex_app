import 'package:get/get.dart';

import '../controllers/ramadancalander_controller.dart';

class RamadancalanderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RamadancalanderController>(
      () => RamadancalanderController(),
    );
  }
}
