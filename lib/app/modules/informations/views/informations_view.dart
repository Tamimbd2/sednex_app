import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/informations_controller.dart';

class InformationsView extends GetView<InformationsController> {
  const InformationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InformationsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InformationsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
