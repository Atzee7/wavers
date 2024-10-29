import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sosmed/app/modules/home/controllers/home_controller.dart';
import 'package:sosmed/app/modules/home/views/custom_bottom_nav_bar.dart';
import 'package:sosmed/app/modules/home/views/webview/webview_page.dart';
import 'package:sosmed/app/modules/home/views/HalamanUtama/map_page.dart';
import 'package:sosmed/app/modules/home/views/HalamanUtama/create_post_view.dart';

class HomeView extends StatelessWidget {
  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A2947),
        automaticallyImplyLeading: false,
        title: Text(
          'Wavers',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            color: Colors.white,
            onPressed: () {
              Get.to(() => MapPage());
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
                _buildPostItem(post: post),
                SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CreatePostView());
        },
        backgroundColor: Colors.yellow[700],
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: Obx(
            () => CustomBottomNavBar(
          currentIndex: _controller.selectedIndex.value,
          onTap: _controller.onItemTapped,
        ),
      ),
    );
  }

  Widget _buildPostItem({required Post post}) {
    Widget postContent = Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A2947),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[400],
                child: Icon(Icons.person, color: Colors.white),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.profileName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    post.timeAgo,
                    style: TextStyle(color: Colors.grey[300], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),

          if (post.imagePlaceholder)
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),

          if (post.postText.isNotEmpty) SizedBox(height: 10),
          if (post.postText.isNotEmpty)
            Text(
              post.postText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  _controller.toggleLike(post.postId, post.userId);
                },
                child: Row(
                  children: [
                    Icon(
                      post.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: post.isLiked ? Colors.red : Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 5),
                    Text(
                      post.likesCount.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _controller.commentOnPost(post.postId, 'Your comment text here');
                },
                child: Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
                    SizedBox(width: 5),
                    Text(
                      post.commentsCount.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _controller.toggleRepost(post.postId, post.userId);
                },
                child: Row(
                  children: [
                    Icon(
                      post.isReposted ? Icons.repeat : Icons.repeat,
                      color: post.isReposted ? Colors.green : Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 5),
                    Text(
                      post.repostCount.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (post.url != null && post.url!.isNotEmpty) {
      return GestureDetector(
        onTap: () {
          Get.to(() => WebViewPage(url: post.url!));
        },
        child: postContent,
      );
    } else {
      return postContent;
    }
  }
}
