import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/mypost_controller.dart';

class MypostView extends GetView<MypostController> {
  const MypostView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MypostView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MypostView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
