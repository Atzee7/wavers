import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sosmed/app/modules/home/views/custom_bottom_nav_bar.dart'; // Import custom bottom nav bar

class MainMenuPage extends StatefulWidget {
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page'),
    Text('Likes Page'),
    Text('Add Post'),
    Text('Notifications Page'),
    Text('Profile Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A2947),
        automaticallyImplyLeading: false, // Menyembunyikan tombol back
        title: Text(
          'wavers',
          style: TextStyle(
            color: Colors.white, // Mengubah warna teks menjadi putih
            fontWeight: FontWeight.bold, // Opsional: menambahkan ketebalan teks
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.location_on),
            color: Colors.white, // Warna putih untuk ikon lokasi
            onPressed: () {
              // Action for location button
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Post 1
          _buildPostItem(
            profileName: "Sarah Fernandez",
            timeAgo: "1 hrs ago",
            postText: "",
            likesCount: 9,
            commentsCount: 14,
            imagePlaceholder: true,
          ),
          SizedBox(height: 20),
          // Post 2
          _buildPostItem(
            profileName: "Emilia Wirtz",
            timeAgo: "4 hrs ago",
            postText:
            "The sun is a daily reminder that we too can rise from the darkness, that we too can shine our own light 🌞🌸",
            likesCount: 31,
            commentsCount: 7,
            imagePlaceholder: false,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for add post button
        },
        backgroundColor: Colors.yellow[700],
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Widget untuk menampilkan satu item post
  Widget _buildPostItem({
    required String profileName,
    required String timeAgo,
    required String postText,
    required int likesCount,
    required int commentsCount,
    required bool imagePlaceholder,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A2947),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profil dan waktu post
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[400],
                child: Icon(Icons.person, color: Colors.white), // Placeholder for avatar
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
          // Placeholder for post image
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
          // Likes and comments
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite, color: Colors.white, size: 18),
                  SizedBox(width: 5),
                  Text(
                    likesCount.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.comment, color: Colors.white, size: 18),
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
  }
}
