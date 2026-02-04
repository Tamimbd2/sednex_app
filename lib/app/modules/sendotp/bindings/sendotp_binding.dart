import 'package:get/get.dart';

import '../controllers/sendotp_controller.dart';

class SendotpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendotpController>(
      () => SendotpController(),
    );
  }
}
