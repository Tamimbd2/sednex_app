import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/savepost_controller.dart';

class SavepostView extends GetView<SavepostController> {
  const SavepostView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SavepostView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SavepostView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
