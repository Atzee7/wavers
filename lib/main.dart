
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/modules/home/controllers/auth_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'app/services/notification_listener_service.dart';FirebaseMessaging messaging = FirebaseMessaging.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Inisialisasi AuthController dan NotificationListenerService
  Get.put(AuthController());
  final notificationService = Get.put(NotificationListenerService());
  await notificationService.initLocalNotifications();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Aplikasi Media Sosial',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

