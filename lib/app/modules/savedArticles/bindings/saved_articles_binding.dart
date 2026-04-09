import 'package:get/get.dart';
import '../controllers/saved_articles_controller.dart';

class SavedArticlesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SavedArticlesController>(
      () => SavedArticlesController(),
    );
  }
}
