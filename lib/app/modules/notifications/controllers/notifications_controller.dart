import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sednexapp/app/services/api_service.dart';
import 'package:sednexapp/app/core/constants/url.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    required this.isRead,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Notification',
      message: json['description'] ?? json['message'] ?? '',
      type: json['type'] ?? 'general',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
      data: json['data'] is Map<String, dynamic> ? json['data'] : null,
    );
  }
}

class NotificationsController extends GetxController {
  final apiService = Get.find<ApiService>();
  
  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;
  final error =RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    error.value = null;
    try {
      final response = await apiService.getData(AppUrl.notifications);
      if (response.statusCode == 200) {
        var body = response.body;
        if (body is String) {
          body = jsonDecode(body);
        }
        final List<dynamic> data = body['notifications'] ?? [];
        notifications.assignAll(data.map((e) => NotificationModel.fromJson(e)).toList());
      } else {
        error.value = 'Failed to load notifications: ${response.statusText}';
      }
    } catch (e) {
      error.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await apiService.patchData('${AppUrl.notifications}read/$id', {});
      // Refresh local state if needed
      final index = notifications.indexWhere((element) => element.id == id);
      if (index != -1) {
        notifications[index] = NotificationModel(
          id: notifications[index].id,
          title: notifications[index].title,
          message: notifications[index].message,
          type: notifications[index].type,
          createdAt: notifications[index].createdAt,
          isRead: true,
          data: notifications[index].data,
        );
      }
    } catch (e) {
      debugPrint('Error marking as read: $e');
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      final response = await apiService.deleteData('${AppUrl.notifications}$id');
      if (response.statusCode == 200) {
        notifications.removeWhere((element) => element.id == id);
      }
    } catch (e) {
       debugPrint('Error deleting notification: $e');
    }
  }

  void refreshNotifications() => fetchNotifications();
}
