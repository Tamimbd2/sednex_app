import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sednexapp/app/services/api_service.dart';

class LocalTourInfo {
  final String date;
  final String distance;
  final String duration;
  final int ticketPrice;
  final String ticketPriceTag;
  final String begins;
  final String returnTime;

  LocalTourInfo({
    required this.date,
    required this.distance,
    required this.duration,
    required this.ticketPrice,
    required this.ticketPriceTag,
    required this.begins,
    required this.returnTime,
  });

  factory LocalTourInfo.fromJson(Map<String, dynamic> json) {
    return LocalTourInfo(
      date: json['date'] ?? '',
      distance: json['distance'] ?? '',
      duration: json['duration'] ?? '',
      ticketPrice: json['ticketPrice'] ?? 0,
      ticketPriceTag: json['ticketPriceTag'] ?? '',
      begins: json['begins'] ?? '',
      returnTime: json['returnTime'] ?? '',
    );
  }
}

class LocalTour {
  final String id;
  final String title;
  final String image;
  final List<String> includedWithTickets;
  final String locationDetails;
  final String tourStatus;
  final LocalTourInfo info;

  LocalTour({
    required this.id,
    required this.title,
    required this.image,
    required this.includedWithTickets,
    required this.locationDetails,
    required this.tourStatus,
    required this.info,
  });

  factory LocalTour.fromJson(Map<String, dynamic> json) {
    return LocalTour(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      includedWithTickets: List<String>.from(json['includedWithTickets'] ?? []),
      locationDetails: json['locationDetails'] ?? '',
      tourStatus: json['tourStatus'] ?? 'upcoming',
      info: LocalTourInfo.fromJson(json['info'] ?? {}),
    );
  }
}

class LocaltourController extends GetxController {
  late final ApiService _apiService;
  final RxList<LocalTour> tours = <LocalTour>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ApiService>();
    fetchTours();
  }

  Future<void> fetchTours() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getData('api/local-tour/');
      if (response.status.hasError) return;

      var body = response.body;
      if (body is String) {
        body = jsonDecode(body);
      }

      final List<dynamic> data = body['tours'] ?? [];
      final fetchedTours = data.map((e) => LocalTour.fromJson(e)).toList();
      
      // Sort: running > upcoming > completed
      fetchedTours.sort((a, b) {
        final statusOrder = {'running': 0, 'upcoming': 1, 'completed': 2};
        int orderA = statusOrder[a.tourStatus.toLowerCase()] ?? 3;
        int orderB = statusOrder[b.tourStatus.toLowerCase()] ?? 3;
        return orderA.compareTo(orderB);
      });
      
      tours.value = fetchedTours;
    } catch (e) {
      debugPrint('Error fetching local tours: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
