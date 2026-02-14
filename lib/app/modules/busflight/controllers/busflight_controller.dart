import 'package:get/get.dart';

class FlightRoute {
  final String from;
  final String fromCode;
  final String to;

  FlightRoute({
    required this.from,
    required this.fromCode,
    required this.to,
  });
}

class BusService {
  final String image;
  final String name;
  final String seats;

  BusService({
    required this.image,
    required this.name,
    required this.seats,
  });
}

class BusflightController extends GetxController {
  final List<FlightRoute> routes = [
    FlightRoute(from: 'Beirut', fromCode: 'Dubai (DXB)', to: 'Dhaka'),
    FlightRoute(from: 'Beirut', fromCode: 'Doha (DOH)', to: 'Dhaka'),
    FlightRoute(from: 'Beirut', fromCode: 'Kuwait (KWI)', to: 'Dhaka'),
    FlightRoute(from: 'Beirut', fromCode: 'Cairo (CAI)', to: 'Dhaka'),
    FlightRoute(from: 'Beirut', fromCode: 'Istanbul (IST)', to: 'Dhaka'),
    FlightRoute(from: 'Beirut', fromCode: 'Abu Dhabi (AUH)', to: 'Dhaka'),
  ];

  final List<BusService> busServices = [
    BusService(
      image: 'assets/images/bus1.jpg',
      name: 'নতুন যান',
      seats: '52 Seats',
    ),
    BusService(
      image: 'assets/images/bus2.jpg',
      name: 'হোটেল যান',
      seats: '52 Seats',
    ),
    BusService(
      image: 'assets/images/bus3.jpg',
      name: 'হোটেল যান',
      seats: '52 Seats',
    ),
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
