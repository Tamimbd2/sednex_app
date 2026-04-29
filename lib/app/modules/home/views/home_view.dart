import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/home_controller.dart';

/// The /home route is a legacy entry point.
/// Redirects to /dashboard if the user is logged in, or /signin otherwise.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = GetStorage();
      final isLoggedIn = box.read('isLoggedIn') == true;
      if (isLoggedIn) {
        Get.offAllNamed('/dashboard');
      } else {
        Get.offAllNamed('/signin');
      }
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
