import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sosmed/app/modules/home/views/HalamanUtama/map_create_post_view.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'auth_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'connectivity_controller.dart';

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

  // Dapatkan instance ConnectivityController
  final ConnectivityController connectivityController = Get.find<ConnectivityController>();

  // Dapatkan instance GetStorage
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Setiap kali isConnected berubah menjadi true, coba upload offline posts
    ever(connectivityController.isConnected, (connected) {
      if (connected == true) {
        uploadOfflinePosts();
      }
    });
  }

  Future<void> pickMedia(ImageSource source, bool isVideo) async {
    final pickedFile = isVideo
        ? await picker.pickVideo(source: source)
        : await picker.pickImage(source: source);

    if (pickedFile != null) {
      if (isVideo) {
        videoFile.value = File(pickedFile.path);
        videoController.value = VideoPlayerController.file(videoFile.value!)..initialize();
        imageFile.value = null; // Reset image if video is selected
      } else {
        imageFile.value = File(pickedFile.path);
        videoFile.value = null; // Reset video if image is selected
        videoController.value = null;
      }
    }
  }

  void clearMedia() {
    imageFile.value = null;
    videoFile.value = null;
    videoController.value = null;
  }

  Future<void> selectLocation(BuildContext context) async {
    LatLng? selectedLocation = await Get.to(() => MapView());
    if (selectedLocation != null) {
      location.value = "Lat: ${selectedLocation.latitude}, Long: ${selectedLocation.longitude}";
    }
  }

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

  void stopListening() {
    _speechToText.stop();
    isListening.value = false;
  }

  Future<String?> uploadMedia(File media, bool isVideo) async {
    try {
      String fileName = isVideo
          ? 'videos/${DateTime.now().millisecondsSinceEpoch}.mp4'
          : 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask uploadTask = FirebaseStorage.instance.ref(fileName).putFile(media);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Media upload failed: $e");
      return null;
    }
  }

  // Fungsi untuk menyimpan post ke Firestore
  Future<void> _savePostToFirestore(Map<String, dynamic> postData, String postId) async {
    // Simpan ke global 'Posts'
    await FirebaseFirestore.instance
        .collection('Posts')
        .doc(postId)
        .set(postData);

    // Simpan juga ke user profile
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Posts')
        .doc(postId)
        .set(postData);
  }

  // Fungsi utama untuk posting
  void post() async {
    try {
      if (userId.isEmpty) {
        print("Error: userId is empty. Please login first.");
        Get.snackbar("Error", "User ID is missing. Please login again.");
        return;
      }

      // Buat postId unik
      String postId = FirebaseFirestore.instance.collection('Posts').doc().id;

      // Siapkan data post
      bool isVideo = (videoFile.value != null);
      String? mediaURL;
      if (imageFile.value != null) {
        mediaURL = await uploadMedia(imageFile.value!, false);
      } else if (videoFile.value != null) {
        mediaURL = await uploadMedia(videoFile.value!, true);
      }

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

      if (connectivityController.isConnected.value) {
        // Jika online, langsung upload ke Firestore
        await _savePostToFirestore(postData, postId);

        // Clear data setelah posting
        _clearAllInputs();

        print("Post successfully saved to Firestore.");
      } else {
        // Jika offline, simpan ke local storage
        await _savePostOffline(postData);
        // Clear input setelah simpan offline
        _clearAllInputs();
        Get.snackbar("Offline", "Post disimpan sementara. Akan diupload saat koneksi tersedia.");
      }
    } catch (e) {
      print("Failed to post: $e");
      Get.snackbar("Error", "Gagal memposting data.");
    }
  }

  void _clearAllInputs() {
    postText.value = '';
    location.value = '';
    hashtags.value = '';
    url.value = '';
    clearMedia();
  }

  Future<void> _savePostOffline(Map<String, dynamic> postData) async {
    // Ambil list post offline yang sudah ada
    List<dynamic> offlinePosts = storage.read<List<dynamic>>('offline_posts') ?? [];

    // Tambahkan post baru
    offlinePosts.add(postData);

    // Simpan kembali ke storage
    await storage.write('offline_posts', offlinePosts);
  }

  Future<void> uploadOfflinePosts() async {
    // Ambil data offline
    List<dynamic>? offlinePosts = storage.read<List<dynamic>>('offline_posts');

    if (offlinePosts != null && offlinePosts.isNotEmpty) {
      // Coba upload satu per satu
      for (var postData in offlinePosts) {
        String postId = postData['postId'] ??
            FirebaseFirestore.instance.collection('Posts').doc().id;
        // postData['timestamp'] mungkin masih FieldValue.serverTimestamp().
        // Jika error, bisa diganti dengan Timestamp.now() atau handle sesuai kebutuhan.

        // Karena offline, timestamp belum terisi. Kita set manual jika diperlukan:
        postData['timestamp'] = FieldValue.serverTimestamp();

        try {
          await _savePostToFirestore(postData, postId);
        } catch (e) {
          // Jika gagal upload, tampilkan pesan dan break
          print("Gagal mengupload post offline: $e");
          Get.snackbar("Error", "Gagal mengupload data offline.");
          return;
        }
      }

      // Jika semua berhasil diupload, hapus data lokal
      await storage.remove('offline_posts');
      print("Semua post offline berhasil diupload ke Firestore.");
      Get.snackbar("Online", "Post offline berhasil diupload");
    }
  }
}
