import 'package:get/get.dart';

import '../controllers/community_feed_controller.dart';

class CommunityFeedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommunityFeedController>(
      () => CommunityFeedController(),
    );
  }
}
