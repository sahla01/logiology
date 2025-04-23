import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logiology_task/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/profile_controller.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController controller = Get.put(ProfileController());

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordObscure = true;

  // Save username and password to SharedPreferences
  void saveCredentials(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  void showImagePickerOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Camera"),
              onTap: () {
                controller.pickImage(ImageSource.camera);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Gallery"),
              onTap: () {
                controller.pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscure = !_isPasswordObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sync username and password from the controller to the text fields
    usernameController.text = controller.username.value;
    passwordController.text = controller.password.value;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
            size: 22,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => showImagePickerOptions(context),
              child: Obx(() {
                return CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.teal,
                  backgroundImage: controller.imageFile.value != null
                      ? FileImage(controller.imageFile.value!)
                      : null,
                  child: controller.imageFile.value == null
                      ? Icon(Icons.camera_alt, size: 30, color: Colors.white)
                      : null,
                );
              }),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10.0),
                ),
                onChanged: (value) => controller.updateUsername(value),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: passwordController,
                obscureText: _isPasswordObscure,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10.0),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                onChanged: (value) => controller.updatePassword(value),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                saveCredentials(usernameController.text, passwordController.text);
                Get.snackbar("Success", "Profile updated!");
              },
              child: Container(
                width: 150,
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.cyan[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.yellow, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                controller.updateUsername('');
                controller.updatePassword('');
                Get.offAll(LoginScreen());
              },
              child: Container(
                width: 150,
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.cyan[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Log out",
                  style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
