import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // Pastikan ini sudah diimport
import 'package:sosmed/app/modules/home/controllers/edit_profile_controller.dart';

class EditProfileView extends StatelessWidget {
  // Inisialisasi controller secara manual
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
                  // Open image picker when tapped
                  Get.defaultDialog(
                    title: "Choose Option",
                    content: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            controller.pickImage(ImageSource.camera);
                            Get.back(); // Close the dialog after picking an option
                          },
                          child: Text("Camera"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.pickImage(ImageSource.gallery);
                            Get.back(); // Close the dialog after picking an option
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
                        : null, // Show camera icon if no image is selected
                  );
                }),
              ),
              const SizedBox(height: 20),

              // First Name Field
              TextField(
                decoration: const InputDecoration(
                  labelText: 'First name',
                  fillColor: Colors.grey,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                onChanged: controller.updateFirstName,
              ),
              const SizedBox(height: 10),

              // Last Name Field
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Last name',
                  fillColor: Colors.grey,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                onChanged: controller.updateLastName,
              ),
              const SizedBox(height: 10),

              // Phone Number Field
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  fillColor: Colors.grey,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                onChanged: controller.updatePhoneNumber,
              ),
              const SizedBox(height: 10),

              // Location Field
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Location',
                  fillColor: Colors.grey,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                onChanged: controller.updateLocation,
              ),
              const SizedBox(height: 10),

              // Birthday Field
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Birthday',
                  fillColor: Colors.grey,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                onChanged: controller.updateBirthday,
              ),
              const SizedBox(height: 20),

              // Gender Radio Buttons
              Row(
                children: [
                  Obx(() => Radio<String>(
                    value: 'Male',
                    groupValue: controller.selectedGender.value,
                    onChanged: controller.selectGender,
                  )),
                  const Text('Male'),

                  Obx(() => Radio<String>(
                    value: 'Female',
                    groupValue: controller.selectedGender.value,
                    onChanged: controller.selectGender,
                  )),
                  const Text('Female'),

                  Obx(() => Radio<String>(
                    value: 'Other',
                    groupValue: controller.selectedGender.value,
                    onChanged: controller.selectGender,
                  )),
                  const Text('Other'),
                ],
              ),
              const SizedBox(height: 10),

              // Profile Visibility Checkbox
              Obx(() => CheckboxListTile(
                title: const Text('Visible on your profile'),
                value: controller.isProfileVisible.value,
                onChanged: controller.toggleProfileVisibility,
              )),
              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700], // Similar to UI color
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
