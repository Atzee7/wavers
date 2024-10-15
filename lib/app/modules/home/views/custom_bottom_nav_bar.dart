import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sosmed/app/modules/home/views/HalamanUtama/Home_view.dart';
import 'package:sosmed/app/modules/home/views/HalamanUtama/profile_page.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(), // Creates the notch for the FAB
      notchMargin: 8.0, // Margin between the FAB and BottomAppBar
      color: Colors.white, // Set background color to white
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), // Ensure padding on sides
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent, // Transparent to allow BottomAppBar's color
          elevation: 0, // Remove elevation shadow for cleaner look
          selectedItemColor: Colors.yellow[700], // Color for the selected icon
          unselectedItemColor: Colors.grey, // Color for the unselected icons
          currentIndex: currentIndex, // Current selected index
          showSelectedLabels: false, // Hide labels for a minimalist look
          showUnselectedLabels: false, // Hide labels for a minimalist look
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add, color: Colors.transparent), // Placeholder for FAB
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Get.to(() => HomeView()); // Navigate to HomePage
                break;
              case 1:
              // Navigate to a Favorite Page if needed
                break;
              case 3:
              // Navigate to a Chat Page if needed
                break;
              case 4:
                Get.to(() => ProfilePage()); // Navigate to ProfilePage
                break;
            }
            onTap(index); // Update the selected index
          },
        ),
      ),
    );
  }
}
