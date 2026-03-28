import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sednexapp/app/core/constants/url.dart';

class SignupController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  final countries = [
    'Lebanon',
    'Bangladesh',
    'India',
    'Pakistan',
    'United Arab Emirates',
    'United States',
  ];

  final selectedCountry = 'Lebanon'.obs;
  final isPasswordVisible = false.obs;

  Future<void> signup() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final connect = GetConnect();
      final response = await connect.post('${AppUrl.baseUrl}api/auth/register', {
        'fullName': nameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'country': selectedCountry.value,
      });

      var body = response.body;

      debugPrint("------------ SIGNUP BACKEND RESPONSE ------------");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Status Text: ${response.statusText}");
      debugPrint("Body: $body");
      debugPrint("-------------------------------------------------");

      if (body is String) {
        try { body = jsonDecode(body); } catch (_) {}
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Account created successfully. Please login.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF22C55E),
          colorText: Colors.white,
        );
        // Clear fields
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        
        // Navigate to login
        Get.offAllNamed('/signin');
      } else {
        final message = body is Map ? (body['message'] ?? 'Signup failed') : 'Signup failed';
        Get.snackbar(
          'Error',
          message.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFE53935),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Signup Error: $e');
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE53935),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      // 2. Grabs the secure authentication tokens
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
 
      // 3. Authenticate with Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
 
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final String? firebaseToken = await userCredential.user?.getIdToken(true);

      if (firebaseToken == null) {
        throw Exception("Failed to retrieve Firebase ID token.");
      }

      debugPrint("------------ GOOGLE SIGNUP TOKENS ------------");
      debugPrint("Google ID Token: ${googleAuth.idToken}");
      debugPrint("Firebase ID Token: $firebaseToken");
      debugPrint("---------------------------------------------");

      final connect = GetConnect();
      // Increase timeout to 30 seconds
      connect.timeout = const Duration(seconds: 30);
      
      final response = await connect.post(
        '${AppUrl.baseUrl}api/auth/google-login',
        {'token': firebaseToken}, // Updated to send firebaseToken
      );
      
      var body = response.body;

      debugPrint("------------ GOOGLE SIGNUP BACKEND RESPONSE ------------");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Status Text: ${response.statusText}");
      debugPrint("Has Error: ${response.hasError}");
      debugPrint("Body: $body");
      debugPrint("---------------------------------------------------------");
      if (body is String) {
        try {
          body = jsonDecode(body);
        } catch (_) {}
      }

      if (response.statusCode == 200 && body is Map) {
        final user = body['user'] ?? {};

        if (user['isActive'] == false) {
          Get.snackbar(
            'Account Suspended',
            'Your account is currently inactive. Please contact the administrator.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFFE53935),
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
          await GoogleSignIn.instance.signOut();
          return;
        }

        final token = body['token'] ?? '';
        final box = GetStorage();
        await box.write('token', token);
        await box.write('user', jsonEncode(user));
        await box.write('isLoggedIn', true);

        Get.snackbar(
          'Success',
          'Google Login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF22C55E),
          colorText: Colors.white,
        );

        Get.offAllNamed('/dashboard');
      } else {
        final message = body is Map
            ? (body['message'] ?? 'Login failed')
            : 'Login failed';
        throw Exception(message);
      }
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      debugPrint("------------ GOOGLE SIGN-IN FAILED ------------");
      Get.snackbar(
        'Error',
        'Google sign-in failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E63FF),
        colorText: Colors.white,
      );
      await GoogleSignIn.instance.signOut();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      isLoading.value = true;

      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final String facebookToken = accessToken.tokenString;

        // Authenticate with Firebase using Facebook Token
        final AuthCredential credential = FacebookAuthProvider.credential(
          facebookToken,
        );
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);
        final String? firebaseToken = await userCredential.user?.getIdToken();

        if (firebaseToken == null) {
          throw Exception("Failed to retrieve Firebase ID token.");
        }

        final connect = GetConnect();
        final response = await connect.post(
          '${AppUrl.baseUrl}api/auth/facebook-login',
          {'token': firebaseToken},
        );

        var body = response.body;
        
        debugPrint("Firebase Token Length: ${firebaseToken.length}");
        debugPrint("------------ FB SIGNUP BACKEND RESPONSE ------------");
        debugPrint("Status Code: ${response.statusCode}");
        debugPrint("Status Text: ${response.statusText}");
        debugPrint("Has Error: ${response.hasError}");
        debugPrint("Body: $body");
        debugPrint("-----------------------------------------------------");

        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (_) {}
        }

        if (response.statusCode == 200 && body is Map) {
          final user = body['user'] ?? {};

          if (user['isActive'] == false) {
            Get.snackbar(
              'Account Suspended',
              'Your account is currently inactive. Please contact the administrator.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFFE53935),
              colorText: Colors.white,
              duration: const Duration(seconds: 5),
            );
            await FacebookAuth.instance.logOut();
            return;
          }

          final authToken = body['token'] ?? '';
          final box = GetStorage();
          await box.write('token', authToken);
          await box.write('user', jsonEncode(user));
          await box.write('isLoggedIn', true);

          Get.snackbar(
            'Success',
            'Facebook Login successful',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF22C55E),
            colorText: Colors.white,
          );

          Get.offAllNamed('/dashboard');
        } else {
          final message = body is Map
              ? (body['message'] ?? 'Login failed')
              : 'Login failed';
          throw Exception(message);
        }
      } else if (result.status == LoginStatus.cancelled) {
        isLoading.value = false;
        return;
      } else {
        throw Exception(result.message);
      }
    } catch (e) {
      debugPrint('Facebook Sign-In Error: $e');
      Get.snackbar(
        'Error',
        'Facebook sign-in failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E63FF),
        colorText: Colors.white,
      );
      await FacebookAuth.instance.logOut();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
