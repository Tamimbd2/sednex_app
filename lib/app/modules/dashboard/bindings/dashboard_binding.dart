import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';
import '../../namaj/controllers/namaj_controller.dart';
import '../../ramadancalander/controllers/ramadancalander_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../Shop/controllers/shop_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../communityFeed/controllers/community_feed_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DashboardController>(DashboardController());
    // NamajController needed for Dashboard cards
    Get.put<NamajController>(NamajController(), permanent: true);
    // Ramadan Controller needed for Dashboard Sehri/Iftar card
    Get.put<RamadancalanderController>(
      RamadancalanderController(),
      permanent: true,
    );
    // Needed for Dashboard tabs
    Get.put<ProfileController>(ProfileController(), permanent: true);
    Get.put<ShopController>(ShopController(), permanent: true);
    Get.put<NotificationsController>(
      NotificationsController(),
      permanent: true,
    );
    Get.put<CommunityFeedController>(
      CommunityFeedController(),
      permanent: true,
    );
  }
}
