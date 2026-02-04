import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/termsandcondition_controller.dart';

class TermsandconditionView extends GetView<TermsandconditionController> {
  const TermsandconditionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TermsandconditionView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TermsandconditionView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
