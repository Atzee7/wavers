import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sosmed/app/modules/home/controllers/edit_profile_controller.dart';

class EditProfileView extends StatelessWidget {
  final EditProfileController controller = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: false,
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Image Placeholder with Image Picker functionality
              GestureDetector(
                onTap: () {
                  Get.defaultDialog(
                    title: "Choose Option",
                    content: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            controller.pickImage(ImageSource.camera);
                            Get.back();
                          },
                          child: Text("Camera"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.pickImage(ImageSource.gallery);
                            Get.back();
                          },
                          child: Text("Gallery"),
                        ),
                      ],
                    ),
                  );
                },
                child: Obx(() {
                  return CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: controller.selectedImagePath.value == ''
                        ? null
                        : FileImage(File(controller.selectedImagePath.value)),
                    child: controller.selectedImagePath.value == ''
                        ? Icon(
                      Icons.camera_alt,
                      size: 40,
                      color: Colors.grey[700],
                    )
                        : null,
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Name Field
              TextField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  fillColor: Colors.grey,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Username Field
              TextField(
                controller: controller.usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  fillColor: Colors.grey,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Phone Number Field
              TextField(
                controller: controller.phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  fillColor: Colors.grey,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),

              // Location Field
              TextField(
                controller: controller.locationController,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  fillColor: Colors.grey,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Birthday Field
              TextField(
                controller: controller.birthdayController,
                decoration: const InputDecoration(
                  labelText: 'Birthday',
                  fillColor: Colors.grey,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Gender Radio Buttons
              Row(
                children: [
                  Obx(() => Radio<String>(
                    value: 'Male',
                    groupValue: controller.selectedGender.value,
                    onChanged: controller.selectedGender,
                  )),
                  const Text('Male'),

                  Obx(() => Radio<String>(
                    value: 'Female',
                    groupValue: controller.selectedGender.value,
                    onChanged: controller.selectedGender,
                  )),
                  const Text('Female'),

                  Obx(() => Radio<String>(
                    value: 'Other',
                    groupValue: controller.selectedGender.value,
                    onChanged: controller.selectedGender,
                  )),
                  const Text('Other'),
                ],
              ),
              const SizedBox(height: 10),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    textStyle: const TextStyle(color: Colors.black),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
