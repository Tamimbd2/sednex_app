import 'package:get/get.dart';

class Hospital {
  final String name;
  final String logoPath;

  Hospital({required this.name, required this.logoPath});
}

class HospitalsController extends GetxController {
  final List<Hospital> hospitals = [
    Hospital(name: 'Al-Makassed\nHospital', logoPath: 'assets/hospital/makassed.png'),
    Hospital(name: 'American University\nHospital', logoPath: 'assets/hospital/auh.png'),
    Hospital(name: 'Rafik Hariri\nHospital', logoPath: 'assets/hospital/hariri.png'),
    Hospital(name: 'Hotel Dieu\nHospital', logoPath: 'assets/hospital/hoteldieu.png'),
    Hospital(name: 'Lebanese\nHospital', logoPath: 'assets/hospital/lebanese.png'),
    Hospital(name: 'St. George\nHospital', logoPath: 'assets/hospital/stgeorge.png'),
    Hospital(name: 'Al-Makassed\nHospital', logoPath: 'assets/hospital/makassed.png'),
    Hospital(name: 'American University\nHospital', logoPath: 'assets/hospital/auh.png'),
    Hospital(name: 'Rafik Hariri\nHospital', logoPath: 'assets/hospital/hariri.png'),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
