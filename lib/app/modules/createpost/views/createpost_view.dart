import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/createpost_controller.dart';

class CreatepostView extends GetView<CreatepostController> {
  const CreatepostView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreatepostView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CreatepostView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
