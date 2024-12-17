import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sosmed/app/modules/home/controllers/create_post_controller.dart';

class CreatePostView extends StatelessWidget {
  final CreatePostController controller = Get.put(CreatePostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.connectivityController.isConnected.value
            ? "Create Post (Online)"
            : "Create Post (Offline)"
        )),
        actions: [
          TextButton(
            onPressed: controller.post,
            child: const Text("POST", style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text Field with Speech-to-Text
              Obx(
                    () => TextField(
                  onChanged: (value) => controller.postText.value = value,
                  controller:
                  TextEditingController(text: controller.postText.value),
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isListening.value
                            ? Icons.mic
                            : Icons.mic_none,
                        color: controller.isListening.value
                            ? Colors.red
                            : Colors.grey,
                      ),
                      onPressed: () {
                        if (controller.isListening.value) {
                          controller.stopListening();
                        } else {
                          controller.startListening();
                        }
                      },
                    ),
                  ),
                ),
              ),
              const Divider(),

              // Add Photo/Video Section
              Obx(
                    () {
                  if (controller.imageFile.value != null) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: controller.clearMedia,
                          child: Image.file(
                            controller.imageFile.value!,
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  } else if (controller.videoFile.value != null &&
                      controller.videoController.value != null) {
                    return Column(
                      children: [
                        AspectRatio(
                          aspectRatio: controller
                              .videoController.value!.value.aspectRatio,
                          child: VideoPlayer(controller.videoController.value!),
                        ),
                        VideoProgressIndicator(
                          controller.videoController.value!,
                          allowScrubbing: true,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                controller.videoController.value!.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                              onPressed: () {
                                if (controller
                                    .videoController.value!.value.isPlaying) {
                                  controller.videoController.value!.pause();
                                } else {
                                  controller.videoController.value!.play();
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  } else {
                    return ListTile(
                      leading: const Icon(Icons.photo, color: Colors.blue),
                      title: const Text("Add Photo/Video"),
                      onTap: () => _showMediaSourceDialog(context),
                    );
                  }
                },
              ),
              const Divider(),

              // Add Location
              Obx(
                    () => ListTile(
                  leading: Icon(Icons.location_on, color: Colors.yellow[700]),
                  title: controller.location.value.isEmpty
                      ? const Text("Add Location")
                      : SizedBox(),
                  onTap: () => controller.selectLocation(context),
                  subtitle: controller.location.value.isNotEmpty
                      ? Text(controller.location.value)
                      : null,
                ),
              ),
              const Divider(),

              // Hashtags
              TextField(
                onChanged: (value) => controller.hashtags.value = value,
                decoration: const InputDecoration(
                  hintText: "Hashtag",
                  prefixIcon: Icon(Icons.tag, color: Colors.red),
                  border: InputBorder.none,
                ),
              ),
              const Divider(),

              // Add URL
              TextField(
                onChanged: (value) => controller.url.value = value,
                decoration: const InputDecoration(
                  hintText: "Add URL",
                  prefixText: "URL ",
                  border: InputBorder.none,
                ),
              ),
              const Divider(),

              // Preview of Data
              Obx(
                    () {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.location.isNotEmpty)
                        ListTile(
                          leading: Icon(Icons.location_on,
                              color: Colors.yellow[700]),
                          title: Text(controller.location.value),
                        ),
                      if (controller.hashtags.isNotEmpty)
                        Text(
                          controller.hashtags.value,
                          style: const TextStyle(color: Colors.blue),
                        ),
                      if (controller.url.isNotEmpty)
                        Text(
                          controller.url.value,
                          style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show dialog for selecting image or video source
  void _showMediaSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Media Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Capture Photo"),
                onTap: () {
                  controller.pickMedia(ImageSource.camera, false);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Pick Photo"),
                onTap: () {
                  controller.pickMedia(ImageSource.gallery, false);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text("Capture Video"),
                onTap: () {
                  controller.pickMedia(ImageSource.camera, true);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_library),
                title: const Text("Pick Video"),
                onTap: () {
                  controller.pickMedia(ImageSource.gallery, true);
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
