// notification_controller.dart

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_controller.dart'; // pastikan auth_controller terimport

class NotificationController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String userId = Get.find<AuthController>().userId.value; // Dapatkan userId dari AuthController

  // Observable list of notifications
  var notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  // Fetch notifications from Firestore
  void fetchNotifications() async {
    try {
      final snapshot = await firestore
          .collection('Users')
          .doc(userId)
          .collection('Notifications')
          .orderBy('timestamp', descending: true)
          .get();

      notifications.assignAll(snapshot.docs.map((doc) {
        final data = doc.data();
        return NotificationModel(
          senderId: data['senderId'] ?? '',
          type: data['type'] ?? 'unknown',
          timestamp: _timeAgo((data['timestamp'] as Timestamp).toDate()),
          relatedPostId: data['relatedPostId'] ?? '',
          isRead: data['isRead'] ?? false,
        );
      }).toList());
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }

  // Helper function to format time
  String _timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${difference.inDays ~/ 365} years ago';
    } else if (difference.inDays > 30) {
      return '${difference.inDays ~/ 30} months ago';
    } else if (difference.inDays > 7) {
      return '${difference.inDays ~/ 7} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }
}

// Model for Notification data
class NotificationModel {
  final String senderId;
  final String type;
  final String timestamp;
  final String relatedPostId;
  final bool isRead;

  NotificationModel({
    required this.senderId,
    required this.type,
    required this.timestamp,
    required this.relatedPostId,
    required this.isRead,
  });
}
