import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: AppColors.primary),
        child: Center(
          child: SvgPicture.asset(
            'assets/logo/Sednex Logo For App Home.svg',
            width: 250,
            colorFilter: const ColorFilter.mode(
              Color(0xFFF5F5F5),
              BlendMode.srcIn,
            ),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
