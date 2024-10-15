// auth_controller.dart

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sosmed/app/modules/home/views/HalamanUtama/Home_view.dart';
import 'package:sosmed/app/modules/home/views/HalamanLogin/login_page.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      print('User is null, navigating to LoginPage');
      Get.offAll(() => LoginPage());
    } else {
      print('User is logged in, navigating to MainMenuPage');
      Get.offAll(() => HomeView());
    }
  }

  void register(String email, String password, String firstname, String lastname) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Simpan data tambahan ke Firestore
      await firestore.collection('users').doc(userCredential.user?.uid).set({
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'uid': userCredential.user?.uid,
      });

      // Navigasi ke halaman utama
      Get.offAll(() => HomeView());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      // Navigasi ke halaman utama
      Get.offAll(() => HomeView());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void logout() async {
    await auth.signOut();
  }
}
