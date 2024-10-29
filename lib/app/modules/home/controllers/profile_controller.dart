import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'auth_controller.dart'; // Pastikan untuk mengimpor AuthController

class ProfileController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Mengambil userId dari AuthController secara dinamis
  String get userId => AuthController.instance.userId.value;

  // Data profil
  var profileName = ''.obs;
  var location = ''.obs;
  var followers = 0.obs;
  var posts = 0.obs;
  var following = 0.obs;

  // Data postingan pengguna
  var userPosts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    fetchUserPosts();
  }

  // Mengambil data profil pengguna dari Firestore
  void fetchUserProfile() async {
    if (userId.isEmpty) {
      print("User ID is empty, unable to fetch profile.");
      return;
    }

    final docSnapshot = await firestore.collection('Users').doc(userId).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data()!;
      profileName.value = data['name'] ?? 'Unknown';
      location.value = data['location'] ?? 'Unknown';
      followers.value = data['followerCount'] ?? 0;
      posts.value = data['postCount'] ?? 0;
      following.value = data['followingCount'] ?? 0;
    } else {
      print("No profile data found for userId: $userId");
    }
  }

  // Mengambil postingan pengguna dari sub-koleksi 'Users > userId > Posts'
  void fetchUserPosts() async {
    if (userId.isEmpty) {
      print("User ID is empty, unable to fetch user posts.");
      return;
    }

    final querySnapshot = await firestore
        .collection('Users')
        .doc(userId)
        .collection('Posts')
        .get();

    userPosts.assignAll(querySnapshot.docs.map((doc) => doc.data()).toList());
  }

  // Fungsi untuk logout
  void logout() {
    // Implementasikan fungsi logout menggunakan Firebase Authentication atau lainnya
    AuthController.instance.logout();
  }
}
