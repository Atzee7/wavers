// home_controller.dart
import 'package:get/get.dart';

class Post {
  final String profileName;
  final String timeAgo;
  final String postText;
  final int likesCount;
  final int commentsCount;
  final bool imagePlaceholder;
  final String? url; // Add this line

  Post({
    required this.profileName,
    required this.timeAgo,
    required this.postText,
    required this.likesCount,
    required this.commentsCount,
    required this.imagePlaceholder,
    this.url, // Add this line
  });
}

class HomeController extends GetxController {
  // Observable list of posts
  var posts = <Post>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Static data for posts
    posts.assignAll([
      Post(
        profileName: 'Sarah Fernandez',
        timeAgo: '1 hrs ago',
        postText: '',
        likesCount: 9,
        commentsCount: 14,
        imagePlaceholder: true,
        url: 'https://www.idntimes.com/news/indonesia/yosafat-diva-bagus/ridwan-kamil-janji-bikin-program-kredit-tanpa-bunga', // Add URL for sponsored post
      ),
      Post(
        profileName: 'Emilia Wirtz',
        timeAgo: '4 hrs ago',
        postText:
        'The sun is a daily reminder that we too can rise from the darkness, that we too can shine our own light 🌞🌸',
        likesCount: 31,
        commentsCount: 7,
        imagePlaceholder: false,
        // No URL for regular post
      ),
      // Add more static posts here if needed
    ]);
  }

  // Manage selected index for bottom navigation
  var selectedIndex = 0.obs;

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
