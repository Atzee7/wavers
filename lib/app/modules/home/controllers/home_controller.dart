import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';

class Post {
  final String userId;  // Gunakan userId
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
  });

  // Convert Firestore document to Post object
  factory Post.fromDocument(DocumentSnapshot doc, String profileName, String userId) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      userId: data['userId'],  // Ambil userId dari database
      profileName: profileName,
      timestamp: (data['timestamp'] != null) ? (data['timestamp'] as Timestamp).toDate() : DateTime.now(),
      postText: data['text'] ?? '',
      likesCount: data['likeCount'] ?? 0,
      commentsCount: data['commentCount'] ?? 0,
      repostCount: data['repostCount'] ?? 0,
      imagePlaceholder: data['imageURL'] != null && data['imageURL'] != '',
      url: data['URL'],
      postId: doc.id,
      isLiked: (data['Likes'] ?? {}).containsKey(userId),
      isReposted: (data['Reposts'] ?? {}).containsKey(userId),
    );
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

  // Fetch posts from Firestore
  void fetchPosts() async {
    final snapshot = await firestore.collection('Posts').get();

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final userId = data['userId'];

      final userSnapshot = await firestore.collection('Users').doc(userId).get();
      final profileName = userSnapshot.data()?['name'] ?? 'Unknown';

      final post = Post.fromDocument(doc, profileName, currentUserId);
      posts.add(post);
    }
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
