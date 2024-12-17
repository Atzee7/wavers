import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  var isConnected = true.obs;
  late StreamSubscription<ConnectivityResult> _subscription;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      bool previouslyConnected = isConnected.value;
      isConnected.value = (result != ConnectivityResult.none);
      // Tampilkan snackbar jika status koneksi berubah
      if (previouslyConnected != isConnected.value) {
        if (isConnected.value) {
          Get.snackbar("Koneksi", "Anda terhubung ke internet",
              snackPosition: SnackPosition.TOP);
        } else {
          Get.snackbar("Koneksi", "Koneksi internet terputus",
              snackPosition: SnackPosition.TOP);
        }
      }
    });
  }

  Future<void> _checkInitialConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    isConnected.value = (connectivityResult != ConnectivityResult.none);
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
