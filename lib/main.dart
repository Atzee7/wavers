import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sosmed/app/modules/home/views/HalamanLogin/login_page.dart'; // Pastikan halaman login diimpor

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Harus menggunakan GetMaterialApp untuk navigasi dengan GetX
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Halaman login sebagai halaman awal
    );
  }
}
