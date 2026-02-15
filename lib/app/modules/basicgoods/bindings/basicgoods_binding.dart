import 'package:get/get.dart';

import '../controllers/basicgoods_controller.dart';

class BasicgoodsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BasicgoodsController>(
      () => BasicgoodsController(),
    );
  }
}
