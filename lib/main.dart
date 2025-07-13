import 'package:flutter/material.dart';
import 'home_page.dart'; // Add this
import 'skeleton.dart';  // Still needed for navigation

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Django Connect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(), // 👈 changed from `skeleton()`
      debugShowCheckedModeBanner: false,
    );
  }
}
