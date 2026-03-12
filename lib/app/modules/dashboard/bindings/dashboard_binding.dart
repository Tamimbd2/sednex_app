import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../../namaj/controllers/namaj_controller.dart';
import '../../ramadancalander/controllers/ramadancalander_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
    // NamajController needed for Dashboard cards
    Get.put<NamajController>(NamajController(), permanent: true);
    // Ramadan Controller needed for Dashboard Sehri/Iftar card
    Get.put<RamadancalanderController>(RamadancalanderController(), permanent: true);
    // ProfileController needed for the Profile tab (rendered inline)
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
