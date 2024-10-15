import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Static data for profile
  var profileName = 'Mahdi Mirzadeh'.obs;
  var location = 'Madagascar'.obs;
  var followers = 472.obs;
  var posts = 119.obs;
  var following = 860.obs;

  // Static post data
  var postLikes = 9.obs;
  var postComments = 14.obs;
  var postText = "The sun is a daily reminder that we too can rise from the darkness, that we too can shine our own light 🌞🌸".obs;
}
