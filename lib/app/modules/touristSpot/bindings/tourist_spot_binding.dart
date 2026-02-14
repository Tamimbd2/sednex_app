import 'package:get/get.dart';

import '../controllers/tourist_spot_controller.dart';

class TouristSpotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TouristSpotController>(
      () => TouristSpotController(),
    );
  }
}
