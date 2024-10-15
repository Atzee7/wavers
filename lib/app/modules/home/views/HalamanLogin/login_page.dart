import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sign_up_page.dart'; // Import halaman Sign Up
import 'package:sosmed/app/modules/home/views/HalamanUtama/main_menu_page.dart'; // Import halaman Main Menu

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A2947), // Warna latar belakang
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Hello, welcome back!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Login to continue",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            // Username Field
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Username',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Password Field
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Action for forgot password
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Login Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700], // Warna button login
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Navigasi ke halaman MainMenuPage setelah login
                  Get.to(MainMenuPage());
                },
                child: Text(
                  'Log In',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Or sign in with',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),
            // Social Buttons without Images
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google Login Button without icon
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    // Action for Google Login
                  },
                  child: Text(
                    'Login with Google',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 20),
                // Facebook Login Button without icon
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    // Action for Facebook Login
                  },
                  child: Text(
                    'Login with Facebook',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have account?",
                  style: TextStyle(color: Colors.grey[300]),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(SignUpPage()); // Navigasi ke SignUpPage
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.yellow[700],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
