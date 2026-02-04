import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/verifyotp_controller.dart';

class VerifyotpView extends GetView<VerifyotpController> {
  const VerifyotpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VerifyotpView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VerifyotpView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
