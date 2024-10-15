import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {

  var selectedImagePath=''.obs;
  var selectedImageSize=''.obs;

  void pickImage(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
      selectedImageSize.value = ((File(selectedImagePath.value)).lengthSync() / 1024 / 1024).toStringAsFixed(2) + " Mb";
    } else {
      Get.snackbar('Error', 'No image selected', snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  var firstName = ''.obs;
  var lastName = ''.obs;
  var phoneNumber = ''.obs;
  var location = ''.obs;
  var birthday = ''.obs;
  var selectedGender = ''.obs;
  var isProfileVisible = false.obs;

  void updateFirstName(String? value) {
    firstName.value = value ?? '';
  }

  void updateLastName(String? value) {
    lastName.value = value ?? '';
  }

  void updatePhoneNumber(String? value) {
    phoneNumber.value = value ?? '';
  }

  void updateLocation(String? value) {
    location.value = value ?? '';
  }

  void updateBirthday(String? value) {
    birthday.value = value ?? '';
  }

  void selectGender(String? gender) {
    selectedGender.value = gender ?? '';
  }

  void toggleProfileVisibility(bool? value) {
    isProfileVisible.value = value ?? false;
  }

  void saveProfile() {
    print("Profile saved!");
    print("First Name: ${firstName.value}");
    print("Last Name: ${lastName.value}");
    print("Phone Number: ${phoneNumber.value}");
    print("Location: ${location.value}");
    print("Birthday: ${birthday.value}");
    print("Gender: ${selectedGender.value}");
    print("Profile Visible: ${isProfileVisible.value}");
  }

  final count = 0.obs;

  void increment() => count.value++;
}
