import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class Post {
  final String userId;
  final String profileName;
  final DateTime timestamp;
  final String postText;
  final int likesCount;
  final int commentsCount;
  final int repostCount;
  final bool imagePlaceholder;
  final String? url;
  final String postId;
  bool isLiked;
  bool isReposted;
  final double? latitude;
  final double? longitude;

  Post({
    required this.userId,
    required this.profileName,
    required this.timestamp,
    required this.postText,
    required this.likesCount,
    required this.commentsCount,
    required this.repostCount,
    required this.imagePlaceholder,
    this.url,
    required this.postId,
    this.isLiked = false,
    this.isReposted = false,
    this.latitude,
    this.longitude,
  });

  // Convert Firestore document to Post object
  factory Post.fromDocument(DocumentSnapshot doc, String profileName, String currentUserId) {
    final data = doc.data() as Map<String, dynamic>;
    final locationString = data['location'] as String?;
    final latitude = _parseLatitude(locationString);
    final longitude = _parseLongitude(locationString);

    return Post(
      userId: data['userId'],
      profileName: profileName,
      timestamp: (data['timestamp'] != null)
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      postText: data['text'] ?? '',
      likesCount: data['likeCount'] ?? 0,
      commentsCount: data['commentCount'] ?? 0,
      repostCount: data['repostCount'] ?? 0,
      imagePlaceholder: data['imageURL'] != null && data['imageURL'] != '',
      url: data['URL'],
      postId: doc.id,
      isLiked: (data['Likes'] ?? {}).containsKey(currentUserId),
      isReposted: (data['Reposts'] ?? {}).containsKey(currentUserId),
      latitude: latitude,
      longitude: longitude,
    );
  }

  // Static methods to parse latitude and longitude from the location string
  static double? _parseLatitude(String? location) {
    if (location == null) return null;
    try {
      final regex = RegExp(r'Lat:\s*([-+]?[0-9]*\.?[0-9]+)');
      final match = regex.firstMatch(location);
      if (match != null) {
        return double.parse(match.group(1)!);
      }
    } catch (e) {
      print('Error parsing latitude: $e');
    }
    return null;
  }

  static double? _parseLongitude(String? location) {
    if (location == null) return null;
    try {
      final regex = RegExp(r'Long:\s*([-+]?[0-9]*\.?[0-9]+)');
      final match = regex.firstMatch(location);
      if (match != null) {
        return double.parse(match.group(1)!);
      }
    } catch (e) {
      print('Error parsing longitude: $e');
    }
    return null;
  }

  String get timeAgo {
    final duration = DateTime.now().difference(timestamp);
    if (duration.inDays > 0) {
      return '${duration.inDays} days ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hours ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }
}

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var posts = <Post>[].obs;
  final String currentUserId = AuthController.instance.userId.value;

  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  // Fetch posts from Firestore in real-time
  void fetchPosts() {
    firestore.collection('Posts').snapshots().listen((snapshot) async {
      posts.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final userId = data['userId'];

        final userSnapshot = await firestore.collection('Users').doc(userId).get();
        final profileName = userSnapshot.data()?['name'] ?? 'Unknown';

        final post = Post.fromDocument(doc, profileName, currentUserId);
        posts.add(post);
      }
    });
  }

// Fungsi untuk menambah atau menghapus like pada postingan
  Future<void> toggleLike(String postId, String postOwnerId) async {
    final userId = currentUserId;

    if (userId.isEmpty) {
      Get.snackbar("Error", "User ID is missing. Please login again.");
      return;
    }

    final postRef = firestore.collection('Posts').doc(postId);
    final likeRef = postRef.collection('Likes').doc(userId);

    final isLiked = (await likeRef.get()).exists;

    if (isLiked) {
      await likeRef.delete();
      await postRef.update({
        'likeCount': FieldValue.increment(-1),
      });
      updateNotification(postOwnerId, postId, 'like', remove: true);
    } else {
      await likeRef.set({'timestamp': FieldValue.serverTimestamp()});
      await postRef.update({
        'likeCount': FieldValue.increment(1),
      });
      updateNotification(postOwnerId, postId, 'like');
    }
  }

  // Fungsi untuk menambah komentar pada postingan
  Future<void> commentOnPost(String postId, String commentText) async {
    final userId = currentUserId;

    if (userId.isEmpty) {
      Get.snackbar("Error", "User ID is missing. Please login again.");
      return;
    }

    await firestore.collection('Posts').doc(postId).collection('Comments').add({
      'userId': userId,
      'text': commentText,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await firestore.collection('Posts').doc(postId).update({
      'commentCount': FieldValue.increment(1),
    });
  }

  // Fungsi untuk repost
  Future<void> toggleRepost(String postId, String postOwnerId) async {
    final userId = currentUserId;

    if (userId.isEmpty) {
      Get.snackbar("Error", "User ID is missing. Please login again.");
      return;
    }

    final postRef = firestore.collection('Posts').doc(postId);
    final repostRef = postRef.collection('Reposts').doc(userId);

    final isReposted = (await repostRef.get()).exists;

    if (isReposted) {
      await repostRef.delete();
      await postRef.update({
        'repostCount': FieldValue.increment(-1),
      });
      updateNotification(postOwnerId, postId, 'repost', remove: true);
    } else {
      await repostRef.set({'timestamp': FieldValue.serverTimestamp()});
      await postRef.update({
        'repostCount': FieldValue.increment(1),
      });
      updateNotification(postOwnerId, postId, 'repost');
    }
  }

  Future<void> updateNotification(String userId, String postId, String type, {bool remove = false}) async {
    final notificationRef = firestore.collection('Users').doc(userId).collection('Notifications').doc(postId);

    if (remove) {
      await notificationRef.delete();
    } else {
      await notificationRef.set({
        'senderId': currentUserId,
        'type': type,
        'relatedPostId': postId,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    }
  }

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
