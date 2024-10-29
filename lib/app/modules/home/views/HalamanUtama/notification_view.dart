// notification_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sosmed/app/modules/home/controllers/notifications_controller.dart';
import 'package:sosmed/app/modules/home/views/custom_bottom_nav_bar.dart';
import 'create_post_view.dart';

class NotificationView extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1B2A),
      appBar: AppBar(
        title: Text("Notifications", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1A2947),
      ),
      body: Obx(
            () => ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[400],
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.senderId, // Display the sender's ID
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getNotificationMessage(notification.type),
                          style: TextStyle(color: Colors.grey[300]),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    notification.timestamp,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CreatePostView());
        },
        backgroundColor: Colors.yellow[700],
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          // Handle navigation on tab switch
        },
      ),
    );
  }

  String _getNotificationMessage(String type) {
    switch (type) {
      case 'like':
        return "Liked your post";
      case 'comment':
        return "Commented on your post";
      case 'repost':
        return "Reposted your post";
      default:
        return "New notification";
    }
  }
}
