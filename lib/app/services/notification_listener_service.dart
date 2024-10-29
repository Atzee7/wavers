import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationListenerService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Inisialisasi listener untuk mendengarkan perubahan di Firestore
  void listenToPostInteractions(String userId) {
    _firestore
        .collection('Notifications')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.added) {
          // Dapatkan data notifikasi baru
          var notificationData = docChange.doc.data();

          // Panggil fungsi untuk menampilkan notifikasi lokal
          _showLocalNotification(
            title: 'New Notification',
            body: _getNotificationMessage(notificationData!),
          );
        }
      }
    });
  }

  // Fungsi untuk menginisialisasi konfigurasi notifikasi lokal
  Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _localNotificationsPlugin.initialize(initializationSettings);
  }

  // Fungsi untuk menampilkan notifikasi lokal
  Future<void> _showLocalNotification({required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id', // Ganti dengan ID channel Anda
      'Your Channel Name', // Ganti dengan nama channel Anda
      channelDescription: 'Your Channel description', // Ganti dengan deskripsi channel Anda
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await _localNotificationsPlugin.show(0, title, body, platformChannelSpecifics);
  }

  // Fungsi untuk mendapatkan pesan notifikasi sesuai jenis
  String _getNotificationMessage(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'like':
        return "Someone liked your post!";
      case 'comment':
        return "Someone commented on your post!";
      case 'repost':
        return "Someone reposted your post!";
      default:
        return "New interaction on your post!";
    }
  }
}
