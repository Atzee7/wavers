import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sosmed/app/modules/home/controllers/create_post_controller.dart';

class CreatePostView extends StatelessWidget {
  final CreatePostController controller = Get.put(CreatePostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A2947),
        title: Text("Create Post", style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: controller.post,
            child: Text("POST", style: TextStyle(color: Colors.blueAccent)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) => controller.postText.value = value,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                border: InputBorder.none,
              ),
            ),
            Divider(),
            Obx(() => ListTile(
              leading: Icon(Icons.photo, color: Colors.blue),
              title: controller.imageFile.value == null
                  ? Text("Add photo")
                  : SizedBox(),
              onTap: () => _showImageSourceDialog(context),
              trailing: controller.imageFile.value != null
                  ? GestureDetector(
                onTap: controller.clearImage,
                child: Image.file(controller.imageFile.value!, width: 100),
              )
                  : null,
            )),
            Divider(),
            Obx(() => ListTile(
              leading: Icon(Icons.location_on, color: Colors.yellow[700]),
              title: controller.location.value.isEmpty
                  ? Text("Add Location")
                  : SizedBox(),
              onTap: () => controller.selectLocation(context),
              subtitle: controller.location.value.isNotEmpty
                  ? Text(controller.location.value)
                  : null,
            )),
            Divider(),
            TextField(
              onChanged: (value) => controller.hashtags.value = value,
              decoration: InputDecoration(
                hintText: "Hashtag",
                prefixIcon: Icon(Icons.tag, color: Colors.red),
                border: InputBorder.none,
              ),
            ),
            Divider(),
            TextField(
              onChanged: (value) => controller.url.value = value,
              decoration: InputDecoration(
                hintText: "Add URL",
                prefixText: "URL ",
                border: InputBorder.none,
              ),
            ),
            Divider(),
            Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.location.isNotEmpty)
                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.yellow[700]),
                      title: Text(controller.location.value),
                    ),
                  if (controller.hashtags.isNotEmpty)
                    Text(
                      controller.hashtags.value,
                      style: TextStyle(color: Colors.blue),
                    ),
                  if (controller.url.isNotEmpty)
                    Text(
                      controller.url.value,
                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  // Show dialog for selecting image source
  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Camera"),
                onTap: () {
                  controller.pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Gallery"),
                onTap: () {
                  controller.pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
