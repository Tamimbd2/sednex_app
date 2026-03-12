import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

/// The /home route is superseded by /signin.
/// This view immediately redirects to /signin to avoid confusion.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Redirect using post-frame callback so the navigator is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed('/signin');
    });
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
