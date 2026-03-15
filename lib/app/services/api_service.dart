import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sednexapp/app/core/constants/url.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = AppUrl.baseUrl;
    httpClient.timeout = const Duration(seconds: 60);

    // Attach token to all requests automatically
    httpClient.addRequestModifier<dynamic>((request) {
      final box = GetStorage();
      final token = box.read('token') ?? '';
      if (token.toString().isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    // Handle global responses (like 401 Unauthorized)
    httpClient.addResponseModifier((request, response) {
      if (response.statusCode == 401) {
        // Token expired or invalid
        final box = GetStorage();
        box.remove('token');
        box.remove('user');
        box.write('isLoggedIn', false);

        // Redirect to Login Screen
        Get.offAllNamed('/signin');

        Get.snackbar(
          'Session Expired',
          'Please log in again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return response;
    });

    super.onInit();
  }

  Future<Response> getData(String uri, {Map<String, dynamic>? query}) async {
    try {
      final response = await get(uri, query: query);
      return response;
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    try {
      final response = await post(uri, body);
      return response;
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }

  Future<Response> postMultipartData(String uri, FormData formData) async {
    try {
      final response = await post(uri, formData);
      return response;
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }

  Future<Response> patchData(String uri, dynamic body) async {
    try {
      final response = await patch(uri, body);
      return response;
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }

  Future<Response> deleteData(String uri) async {
    try {
      final response = await delete(uri);
      return response;
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }
}
