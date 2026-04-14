import 'package:get/get.dart';

import '../controllers/profileinfodetails_controller.dart';

class ProfileinfodetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileinfodetailsController>(
      () => ProfileinfodetailsController(),
    );
  }
}
