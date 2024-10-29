import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sosmed/app/modules/home/views/HalamanUtama/Home_view.dart';
import 'package:sosmed/app/modules/home/views/HalamanUtama/profile_page.dart';
import 'package:sosmed/app/modules/home/views/HalamanUtama/notification_view.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 56, // Set a fixed height to ensure enough space for icons
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.yellow[700],
            unselectedItemColor: Colors.grey,
            currentIndex: currentIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
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
                  Get.off(() => HomeView());
                  break;
                case 1:
                  Get.off(() => NotificationView());
                  break;
                case 3:
                // Navigate to Chat Page if needed
                  break;
                case 4:
                  Get.off(() => ProfilePage());
                  break;
              }
              onTap(index);
            },
          ),
        ),
      ),
    );
  }
}
