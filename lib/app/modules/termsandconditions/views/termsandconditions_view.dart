import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/termsandconditions_controller.dart';

class TermsandconditionsView extends GetView<TermsandconditionsController> {
  const TermsandconditionsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TermsandconditionsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TermsandconditionsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
