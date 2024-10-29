import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_controller.dart';

class EditProfileController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Mengambil userId dari AuthController
  String get userId => AuthController.instance.userId.value;

  var selectedImagePath = ''.obs;
  var selectedImageSize = ''.obs;

  var name = ''.obs;
  var username = ''.obs;
  var phoneNumber = ''.obs;
  var location = ''.obs;
  var birthday = ''.obs;
  var selectedGender = ''.obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(() {
      name.value = nameController.text;
    });
    usernameController.addListener(() {
      username.value = usernameController.text;
    });
    phoneNumberController.addListener(() {
      phoneNumber.value = phoneNumberController.text;
    });
    locationController.addListener(() {
      location.value = locationController.text;
    });
    birthdayController.addListener(() {
      birthday.value = birthdayController.text;
    });

    fetchUserProfile();
  }

  // Fungsi untuk mengambil data profil dari Firestore
  void fetchUserProfile() async {
    print("Fetching user profile for userId: $userId");
    try {
      final docSnapshot = await firestore.collection('Users').doc(userId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        name.value = data['name'] ?? '';
        username.value = data['username'] ?? '';
        phoneNumber.value = data['phoneNumber'] ?? '';
        location.value = data['location'] ?? '';
        birthday.value = data['birthDate'] != null
            ? (data['birthDate'] as Timestamp).toDate().toString()
            : '';
        selectedGender.value = data['gender'] ?? '';

        nameController.text = name.value;
        usernameController.text = username.value;
        phoneNumberController.text = phoneNumber.value;
        locationController.text = location.value;
        birthdayController.text = birthday.value;
      }
    } catch (e) {
      print("Error fetching profile: $e");
      Get.snackbar("Error", "Failed to fetch profile data.");
    }
  }

  // Fungsi untuk memperbarui data profil di Firestore
  void saveProfile() async {
    print("Attempting to save profile for userId: $userId");
    try {
      if (userId.isEmpty) {
        throw Exception("User ID is empty. Make sure user is logged in.");
      }

      Map<String, dynamic> updatedData = {
        'name': name.value,
        'username': username.value,
        'phoneNumber': phoneNumber.value,
        'location': location.value,
        'birthDate': birthday.value != '' ? Timestamp.fromDate(DateTime.parse(birthday.value)) : null,
        'gender': selectedGender.value,
      };

      print("Data to save: $updatedData");

      await firestore.collection('Users').doc(userId).update(updatedData);
      Get.snackbar("Success", "Profile updated successfully.");
    } catch (e) {
      print("Error updating profile: $e");
      Get.snackbar("Error", "Failed to update profile: $e");
    }
  }

  // Fungsi untuk memilih gambar dari galeri atau kamera
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
}
