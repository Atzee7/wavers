import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sosmed/app/modules/home/controllers/profile_controller.dart';
import 'package:sosmed/app/modules/home/controllers/auth_controller.dart';
import 'package:sosmed/app/modules/home/views/custom_bottom_nav_bar.dart';
import 'package:sosmed/app/modules/home/views/HalamanUtama/edit_profile_page.dart';
import 'package:sosmed/app/modules/home/views/HalamanUtama/create_post_view.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController _controller = Get.put(ProfileController());
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF1A2947),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'Edit Profile') {
                Get.to(() => EditProfileView());
              } else if (value == 'Logout') {
                _authController.logout();
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Edit Profile', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Color(0xFF1A2947),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Avatar dan nama profil
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[400],
                  child: Icon(Icons.person, color: Colors.white, size: 50),
                ),
                SizedBox(height: 10),
                Obx(() => Text(
                  _controller.profileName.value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.yellow[700], size: 16),
                    SizedBox(width: 5),
                    Obx(() => Text(
                      _controller.location.value,
                      style: TextStyle(color: Colors.grey[300], fontSize: 14),
                    )),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Info Followers, Posts, Following
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Obx(() => Text(
                    _controller.followers.value.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Text(
                    "Followers",
                    style: TextStyle(color: Colors.grey[300], fontSize: 14),
                  ),
                ],
              ),
              Column(
                children: [
                  Obx(() => Text(
                    _controller.posts.value.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Text(
                    "Posts",
                    style: TextStyle(color: Colors.grey[300], fontSize: 14),
                  ),
                ],
              ),
              Column(
                children: [
                  Obx(() => Text(
                    _controller.following.value.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Text(
                    "Following",
                    style: TextStyle(color: Colors.grey[300], fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          // Daftar Postingan Pengguna
          Obx(() {
            if (_controller.userPosts.isEmpty) {
              return Center(
                child: Text(
                  "No posts available",
                  style: TextStyle(color: Colors.grey[300], fontSize: 16),
                ),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _controller.userPosts.length,
                itemBuilder: (context, index) {
                  final post = _controller.userPosts[index];
                  return Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A2947),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tambahkan Row untuk teks dan menu
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                post['text'] ?? '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (String value) {
                                if (value == 'Delete') {
                                  // Konfirmasi sebelum menghapus
                                  Get.defaultDialog(
                                    title: "Delete Post",
                                    middleText: "Are you sure you want to delete this post?",
                                    textCancel: "Cancel",
                                    textConfirm: "Delete",
                                    confirmTextColor: Colors.white,
                                    onConfirm: () {
                                      Get.back(); // Tutup dialog
                                      _controller.deletePost(post['postId']);
                                    },
                                  );
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return {'Delete'}.map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice),
                                  );
                                }).toList();
                              },
                              icon: Icon(Icons.more_vert, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        // Bagian ikon likes, comments, reposts
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.favorite, color: Colors.white, size: 18),
                                SizedBox(width: 5),
                                Text(
                                  post['likeCount'].toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.comment, color: Colors.white, size: 18),
                                SizedBox(width: 5),
                                Text(
                                  post['commentCount'].toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.repeat, color: Colors.white, size: 18),
                                SizedBox(width: 5),
                                Text(
                                  post['repostCount'].toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CreatePostView()); // Navigasi ke halaman Create Post
        },
        backgroundColor: Colors.yellow[700],
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          // Handle navigation on tab switch
        },
      ),
    );
  }
}
