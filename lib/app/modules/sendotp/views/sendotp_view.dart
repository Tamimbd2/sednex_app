import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sendotp_controller.dart';

class SendotpView extends GetView<SendotpController> {
  const SendotpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SendotpView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SendotpView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
