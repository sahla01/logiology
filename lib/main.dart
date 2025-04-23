import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logiology_task/screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart'; // Import the HomeScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,// Use GetMaterialApp instead of MaterialApp
      title: 'Flutter Demo',
      theme: ThemeData(
        // Customize your theme here
      ),
      initialRoute: '/', // Define initial route
      getPages: [
        GetPage(name: '/', page: () => LoginScreen()), // Login screen route
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/profile', page: () => ProfileScreen())// Home screen route
      ],
    );
  }
}
