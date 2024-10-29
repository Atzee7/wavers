import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sosmed/app/modules/home/views/HalamanUtama/map_create_post_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'auth_controller.dart'; // Pastikan ini sudah diimpor

class CreatePostController extends GetxController {
  var postText = ''.obs;
  var location = ''.obs;
  var hashtags = ''.obs;
  var url = ''.obs;
  var imageFile = Rxn<File>();

  final picker = ImagePicker();

  // Ambil userId dari AuthController secara dinamis
  String get userId => AuthController.instance.userId.value;

  // Function to pick an image from gallery
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  // Function to clear the image
  void clearImage() {
    imageFile.value = null;
  }

  // Function to open MapView and get location
  Future<void> selectLocation(BuildContext context) async {
    LatLng? selectedLocation = await Get.to(() => MapView());
    if (selectedLocation != null) {
      location.value =
      "Lat: ${selectedLocation.latitude}, Long: ${selectedLocation.longitude}";
    }
  }

  // Function to upload image to Firebase Storage
  Future<String?> uploadImage(File image) async {
    try {
      String fileName = 'posts/${DateTime.now().millisecondsSinceEpoch}';
      UploadTask uploadTask =
      FirebaseStorage.instance.ref(fileName).putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Image upload failed: $e");
      return null;
    }
  }

  // Function to post to Firestore
  void post() async {
    try {
      // Pastikan userId tidak kosong
      if (userId.isEmpty) {
        print("Error: userId is empty. Please login first.");
        Get.snackbar("Error", "User ID is missing. Please login again.");
        return;
      }

      // Create a unique post ID
      String postId = FirebaseFirestore.instance.collection('Posts').doc().id;

      // Check if there is an image and upload it
      String? imageURL;
      if (imageFile.value != null) {
        imageURL = await uploadImage(imageFile.value!);
      }

      // Prepare the post data
      Map<String, dynamic> postData = {
        'postId': postId,
        'text': postText.value,
        'location': location.value,
        'hashtags': hashtags.value.split(' '),
        'URL': url.value,
        'timestamp': FieldValue.serverTimestamp(),
        'likeCount': 0,
        'commentCount': 0,
        'repostCount': 0,
        'userId': userId, // Menggunakan ID pengguna dari AuthController
        'imageURL': imageURL ?? "",
      };

      // Save the post data to the main collection (global Posts)
      await FirebaseFirestore.instance.collection('Posts').doc(postId).set(postData);

      // Save the same post data to the user's profile collection
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Posts')
          .doc(postId)
          .set(postData);

      // Clear all inputs after posting
      postText.value = '';
      location.value = '';
      hashtags.value = '';
      url.value = '';
      imageFile.value = null;

      print("Post successfully saved to Firestore.");
    } catch (e) {
      print("Failed to post to Firestore: $e");
    }
  }
}
