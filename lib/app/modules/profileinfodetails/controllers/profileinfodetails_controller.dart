import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileinfodetailsController extends GetxController {
  final _box = GetStorage();

  // Identity
  var name = ''.obs;
  var profileImage = ''.obs;

  // Personal
  var birthAddress = ''.obs;
  var currentAddress = ''.obs;
  var birthDate = ''.obs;
  var gender = ''.obs;
  var maritalStatus = ''.obs;
  var nationality = ''.obs;
  var bloodGroup = ''.obs;

  // Professional
  var jobTitle = ''.obs;
  var companyName = ''.obs;
  var workAddress = ''.obs;

  // Contact
  var phone = ''.obs;
  var email = ''.obs;
  var websiteLink = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserFromStorage();
  }

  void loadUserFromStorage() {
    final userData = _box.read('user');
    if (userData != null) {
      final user = userData is String ? jsonDecode(userData) : userData;
      
      // Identity
      name.value = user['name']?.toString() ?? 'User';
      profileImage.value = user['profileImage']?.toString() ?? '';

      // Personal
      birthAddress.value = user['birthAddress']?.toString() ?? '';
      currentAddress.value = user['currentAddress']?.toString() ?? '';
      birthDate.value = user['birthDate']?.toString() ?? '';
      gender.value = user['gender']?.toString() ?? '';
      maritalStatus.value = user['maritalStatus']?.toString() ?? '';
      nationality.value = user['nationality']?.toString() ?? '';
      bloodGroup.value = user['bloodGroup']?.toString() ?? '';

      // Professional
      jobTitle.value = user['jobTitle']?.toString() ?? '';
      companyName.value = user['companyName']?.toString() ?? '';
      workAddress.value = user['workAddress']?.toString() ?? '';

      // Contact
      phone.value = user['phone']?.toString() ?? '';
      email.value = user['email']?.toString() ?? '';
      websiteLink.value = user['websiteLink']?.toString() ?? '';
    }
  }
}
