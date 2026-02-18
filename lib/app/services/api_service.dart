import 'package:get/get.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://sednex-zvk1.onrender.com/';
    httpClient.timeout = const Duration(seconds: 30);
    
    // Optional: Add interceptors for headers like Authorization
    httpClient.addRequestModifier<dynamic>((request) {
      // request.headers['Authorization'] = 'Bearer token';
      return request;
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
}
