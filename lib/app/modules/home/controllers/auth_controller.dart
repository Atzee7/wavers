// auth_controller.dart

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sosmed/app/modules/home/views/HalamanUtama/Home_view.dart';
import 'package:sosmed/app/modules/home/views/HalamanLogin/login_page.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;

  var userId = ''.obs; // Menggunakan RxString untuk menyimpan userId
  var fcmToken = ''.obs; // Token FCM pengguna

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);

    // Listener untuk memperbarui FCM token jika berubah
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      fcmToken.value = newToken;
      if (userId.value.isNotEmpty) {
        await _updateFcmTokenInFirestore(newToken);
      }
    });
  }

  // Mengatur layar awal berdasarkan status login
  void _setInitialScreen(User? user) {
    if (user == null) {
      print('User is null, navigating to LoginPage');
      userId.value = ''; // Kosongkan userId
      Get.offAll(() => LoginPage());
    } else {
      print('User is logged in, navigating to HomeView');
      userId.value = user.uid; // Set userId dengan UID pengguna
      _saveFcmToken(); // Simpan token FCM saat pengguna login
      Get.offAll(() => HomeView());
    }
  }

  // Fungsi untuk registrasi pengguna
  void register(String email, String password, String firstname, String lastname) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      userId.value = userCredential.user?.uid ?? ''; // Set userId

      // Simpan data pengguna dan token FCM ke Firestore
      await firestore.collection('Users').doc(userId.value).set({
        'name': firstname,
        'username': lastname,
        'email': email,
        'uid': userId.value,
      });

      _saveFcmToken(); // Simpan token FCM setelah registrasi
      Get.offAll(() => HomeView()); // Navigasi ke halaman utama
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Fungsi untuk login pengguna
  void login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      userId.value = userCredential.user?.uid ?? ''; // Set userId
      print("Logged in userId: ${userId.value}");

      _saveFcmToken(); // Simpan token FCM saat login
      Get.offAll(() => HomeView()); // Navigasi ke halaman utama
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Fungsi untuk mendapatkan dan menyimpan token FCM
  void _saveFcmToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        fcmToken.value = token;
        print("FCM Token: $token"); // Tambahkan log ini untuk memeriksa token

        // Simpan token ke Firestore di dokumen pengguna
        await _updateFcmTokenInFirestore(token);
      } else {
        print("Failed to get FCM token: Token is null");
      }
    } catch (e) {
      print("Failed to get FCM token: $e");
    }
  }

  // Fungsi untuk memperbarui token FCM di Firestore
  Future<void> _updateFcmTokenInFirestore(String token) async {
    try {
      await firestore.collection('Users').doc(userId.value).update({
        'fcmToken': token,
      });
      print("FCM token updated in Firestore");
    } catch (e) {
      print("Error updating FCM token in Firestore: $e");
    }
  }

  // Fungsi untuk logout pengguna
  void logout() async {
    await auth.signOut();
    userId.value = ''; // Kosongkan userId saat logout
    fcmToken.value = ''; // Kosongkan token FCM
  }

}
