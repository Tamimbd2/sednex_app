import 'package:get/get.dart';
import '../controllers/generalsection_controller.dart';

class GeneralSectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GeneralSectionController>(
      () => GeneralSectionController(),
    );
  }
}
