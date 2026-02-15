import 'package:get/get.dart';

import '../controllers/embassy_controller.dart';

class EmbassyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmbassyController>(
      () => EmbassyController(),
    );
  }
}
