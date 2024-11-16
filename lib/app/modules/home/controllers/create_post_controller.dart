import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sosmed/app/modules/home/views/HalamanUtama/map_create_post_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'auth_controller.dart'; // Pastikan ini sudah diimpor

class CreatePostController extends GetxController {
  var postText = ''.obs;
  var location = ''.obs;
  var hashtags = ''.obs;
  var url = ''.obs;
  var imageFile = Rxn<File>();
  var videoFile = Rxn<File>();
  var videoController = Rxn<VideoPlayerController>();
  var isListening = false.obs; // Status untuk mic (listening)

  final picker = ImagePicker();
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  // Ambil userId dari AuthController secara dinamis
  String get userId => AuthController.instance.userId.value;

  // Function to pick an image or video from gallery or camera
  Future<void> pickMedia(ImageSource source, bool isVideo) async {
    final pickedFile = isVideo
        ? await picker.pickVideo(source: source)
        : await picker.pickImage(source: source);

    if (pickedFile != null) {
      if (isVideo) {
        videoFile.value = File(pickedFile.path);
        videoController.value =
        VideoPlayerController.file(videoFile.value!)..initialize();
        imageFile.value = null; // Reset image if video is selected
      } else {
        imageFile.value = File(pickedFile.path);
        videoFile.value = null; // Reset video if image is selected
        videoController.value = null;
      }
    }
  }

  // Function to clear the selected image or video
  void clearMedia() {
    imageFile.value = null;
    videoFile.value = null;
    videoController.value = null;
  }

  // Function to open MapView and get location
  Future<void> selectLocation(BuildContext context) async {
    LatLng? selectedLocation = await Get.to(() => MapView());
    if (selectedLocation != null) {
      location.value =
      "Lat: ${selectedLocation.latitude}, Long: ${selectedLocation.longitude}";
    }
  }

  // Function to start speech-to-text recognition
  Future<void> startListening() async {
    if (await _speechToText.initialize()) {
      isListening.value = true;
      _speechToText.listen(onResult: (result) {
        postText.value = result.recognizedWords;
      });
    } else {
      print("Speech recognition not available");
      Get.snackbar("Error", "Speech recognition is not available.");
    }
  }

  // Function to stop speech-to-text recognition
  void stopListening() {
    _speechToText.stop();
    isListening.value = false;
  }

  // Function to upload image or video to Firebase Storage
  Future<String?> uploadMedia(File media, bool isVideo) async {
    try {
      String fileName = isVideo
          ? 'videos/${DateTime.now().millisecondsSinceEpoch}.mp4'
          : 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask uploadTask =
      FirebaseStorage.instance.ref(fileName).putFile(media);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Media upload failed: $e");
      return null;
    }
  }

  // Function to post to Firestore
  void post() async {
    try {
      // Ensure userId is not empty
      if (userId.isEmpty) {
        print("Error: userId is empty. Please login first.");
        Get.snackbar("Error", "User ID is missing. Please login again.");
        return;
      }

      // Create a unique post ID
      String postId = FirebaseFirestore.instance.collection('Posts').doc().id;

      // Check if there is an image or video and upload it
      String? mediaURL;
      bool isVideo = false;
      if (imageFile.value != null) {
        mediaURL = await uploadMedia(imageFile.value!, false);
      } else if (videoFile.value != null) {
        mediaURL = await uploadMedia(videoFile.value!, true);
        isVideo = true;
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
        'userId': userId,
        'mediaURL': mediaURL ?? "",
        'isVideo': isVideo,
      };

      // Save the post data to the main collection (global Posts)
      await FirebaseFirestore.instance
          .collection('Posts')
          .doc(postId)
          .set(postData);

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
      clearMedia();

      print("Post successfully saved to Firestore.");
    } catch (e) {
      print("Failed to post to Firestore: $e");
    }
  }
}
