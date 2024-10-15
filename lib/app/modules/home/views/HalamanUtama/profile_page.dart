import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sosmed/app/modules/home/controllers/profile_controller.dart';
import 'package:sosmed/app/modules/home/controllers/auth_controller.dart'; // Import AuthController
import 'package:sosmed/app/modules/home/views/custom_bottom_nav_bar.dart';
import 'package:sosmed/app/modules/home/views/HalamanUtama/edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController _controller = Get.put(ProfileController());
  final AuthController _authController = Get.put(AuthController()); // Access AuthController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A2947),
        automaticallyImplyLeading: false, // Hide back button
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white, // Set text color to white
            fontWeight: FontWeight.bold, // Optional: bold text
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'Edit Profile') {
                Get.to(() => EditProfileView()); // Navigate to Edit Profile Page
              } else if (value == 'Logout') {
                _authController.logout(); // Call the logout function from AuthController
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
            icon: Icon(Icons.more_vert, color: Colors.white), // Three dots menu icon
          ),
        ],
      ),
      backgroundColor: Color(0xFF1A2947),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Avatar and profile name
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
          // Post (Placeholder)
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite, color: Colors.white, size: 18),
                  SizedBox(width: 5),
                  Obx(() => Text(
                    _controller.postLikes.value.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  )),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.comment, color: Colors.white, size: 18),
                  SizedBox(width: 5),
                  Obx(() => Text(
                    _controller.postComments.value.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  )),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Obx(() => Text(
            _controller.postText.value,
            style: TextStyle(color: Colors.white, fontSize: 14),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for FAB button
        },
        backgroundColor: Colors.yellow[700], // FAB color
        child: Icon(Icons.add, color: Colors.black), // FAB icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4, // Set the index to 4 for Profile
        onTap: (index) {
          // Handle navigation on tab switch
        },
      ),
    );
  }
}
