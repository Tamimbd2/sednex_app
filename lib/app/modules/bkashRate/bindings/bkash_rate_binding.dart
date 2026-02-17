import 'package:get/get.dart';

import '../controllers/bkash_rate_controller.dart';

class BkashRateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BkashRateController>(
      () => BkashRateController(),
    );
  }
}
