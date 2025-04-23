import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var username = 'admin'.obs;
  var password = 'Pass@123'.obs;
  var imageFile = Rxn<File>();

  final ImagePicker picker = ImagePicker();

  void updateUsername(String newUsername) {
    username.value = newUsername;
  }

  void updatePassword(String newPassword) {
    password.value = newPassword;
  }

  // Function to pick image from either camera or gallery
  void pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path); // Update imageFile with the picked image
    }

  }
  @override
  void onInit() async {
    super.onInit();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    String? savedPassword = prefs.getString('password');

    if (savedUsername != null) {
      username.value = savedUsername;
    }
    if (savedPassword != null) {
      password.value = savedPassword;
    }
  }
}