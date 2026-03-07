import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlightRoute {
  final String from;
  final List<String> via;
  final String to;

  FlightRoute({
    required this.from,
    required this.via,
    required this.to,
  });

  factory FlightRoute.fromJson(Map<String, dynamic> json) {
    return FlightRoute(
      from: json['from'] ?? '',
      via: List<String>.from(json['via'] ?? []),
      to: json['to'] ?? '',
    );
  }
}

class BusFlight {
  final String id;
  final String airlineName;
  final String airlineImage;

  BusFlight({
    required this.id,
    required this.airlineName,
    required this.airlineImage,
  });

  factory BusFlight.fromJson(Map<String, dynamic> json) {
    return BusFlight(
      id: json['_id'] ?? '',
      airlineName: json['airlineName'] ?? '',
      airlineImage: json['airlineImage'] ?? '',
    );
  }
}

class BusService {
  final String id;
  final String busName;
  final String busImage;
  final int busSitNo;
  final List<String> rentalDetails;
  final String note;
  final String aboutBusServices;
  final String contactNumber;

  BusService({
    required this.id,
    required this.busName,
    required this.busImage,
    required this.busSitNo,
    required this.rentalDetails,
    required this.note,
    required this.aboutBusServices,
    required this.contactNumber,
  });

  factory BusService.fromJson(Map<String, dynamic> json) {
    return BusService(
      id: json['_id'] ?? '',
      busName: json['busName'] ?? '',
      busImage: json['busImage'] ?? '',
      busSitNo: json['busSitNo'] ?? 0,
      rentalDetails: List<String>.from(json['rentalDetails'] ?? []),
      note: json['note'] ?? '',
      aboutBusServices: json['aboutBusServices'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
    );
  }
}

class BusflightController extends GetxController {
  final _connect = GetConnect();
  
  final RxList<FlightRoute> routes = <FlightRoute>[].obs;
  final RxList<BusFlight> activeAirlines = <BusFlight>[].obs;
  
  final isLoadingFlights = false.obs;
  final isLoadingRoutes = false.obs;

  final RxList<BusService> busServices = <BusService>[].obs;
  final isLoadingBus = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActiveAirlines();
    fetchRoutes();
    fetchBusServices();
  }

  Future<void> fetchBusServices() async {
    try {
      isLoadingBus.value = true;
      final response = await _connect.get('https://sednex-zvk1.onrender.com/api/bus-services/');
      
      if (response.status.hasError) return;

      var body = response.body;
      if (body is String) {
        body = jsonDecode(body);
      }

      final List<dynamic> data = body['services'] ?? [];
      busServices.value = data.map((e) => BusService.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error fetching bus services: $e');
    } finally {
      isLoadingBus.value = false;
    }
  }

  Future<void> fetchActiveAirlines() async {
    try {
      isLoadingFlights.value = true;
      final response = await _connect.get('https://sednex-zvk1.onrender.com/api/bus-flights/');
      
      if (response.status.hasError) return;

      var body = response.body;
      if (body is String) {
        body = jsonDecode(body);
      }

      final List<dynamic> data = body['flights'] ?? [];
      activeAirlines.value = data.map((e) => BusFlight.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error fetching airlines: $e');
    } finally {
      isLoadingFlights.value = false;
    }
  }

  Future<void> fetchRoutes() async {
    try {
      isLoadingRoutes.value = true;
      final response = await _connect.get('https://sednex-zvk1.onrender.com/api/flight-routes/');
      
      if (response.status.hasError) return;

      var body = response.body;
      if (body is String) {
        body = jsonDecode(body);
      }

      final List<dynamic> data = body['routes'] ?? [];
      routes.value = data.map((e) => FlightRoute.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error fetching routes: $e');
    } finally {
      isLoadingRoutes.value = false;
    }
  }
}
