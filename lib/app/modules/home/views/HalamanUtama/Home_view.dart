// home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sosmed/app/modules/home/controllers/home_controller.dart';
import 'package:sosmed/app/modules/home/views/custom_bottom_nav_bar.dart';
// Import the WebViewPage
import 'package:sosmed/app/modules/home/views/webview/webview_page.dart';

class HomeView extends StatelessWidget {
  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A2947),
        automaticallyImplyLeading: false, // Hide back button
        title: Text(
          'wavers',
          style: TextStyle(
            color: Colors.white, // Set text color to white
            fontWeight: FontWeight.bold, // Optional: bold text
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            color: Colors.white, // White color for location icon
            onPressed: () {
              // Action for location button
            },
          ),
        ],
      ),
      body: Obx(
            () => ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _controller.posts.length,
          itemBuilder: (context, index) {
            final post = _controller.posts[index];
            return Column(
              children: [
                _buildPostItem(
                  profileName: post.profileName,
                  timeAgo: post.timeAgo,
                  postText: post.postText,
                  likesCount: post.likesCount,
                  commentsCount: post.commentsCount,
                  imagePlaceholder: post.imagePlaceholder,
                  url: post.url, // Pass the URL
                ),
                SizedBox(height: 20), // Space between posts
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for add post button
        },
        backgroundColor: Colors.yellow[700],
        child: Icon(Icons.add, color: Colors.black), // Black icon for FAB
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked, // Center the FAB
      bottomNavigationBar: Obx(
            () => CustomBottomNavBar(
          currentIndex: _controller.selectedIndex.value,
          onTap: _controller.onItemTapped,
        ),
      ),
    );
  }

  // Post item rendering function
  Widget _buildPostItem({
    required String profileName,
    required String timeAgo,
    required String postText,
    required int likesCount,
    required int commentsCount,
    required bool imagePlaceholder,
    String? url, // Add URL parameter
  }) {
    Widget postContent = Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A2947),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile section
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[400],
                child:
                Icon(Icons.person, color: Colors.white), // Avatar placeholder
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profileName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: TextStyle(color: Colors.grey[300], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          // Image placeholder for post
          if (imagePlaceholder)
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          if (postText.isNotEmpty) SizedBox(height: 10),
          // Post text
          if (postText.isNotEmpty)
            Text(
              postText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          SizedBox(height: 10),
          // Likes and comments section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite_border, color: Colors.white, size: 18),
                  SizedBox(width: 5),
                  Text(
                    likesCount.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.chat_bubble_outline,
                      color: Colors.white, size: 18),
                  SizedBox(width: 5),
                  Text(
                    commentsCount.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );

    // If URL is provided, wrap the postContent with GestureDetector
    if (url != null) {
      return GestureDetector(
        onTap: () {
          // Navigate to WebViewPage
          Get.to(() => WebViewPage(url: url));
        },
        child: postContent,
      );
    } else {
      return postContent;
    }
  }
}
