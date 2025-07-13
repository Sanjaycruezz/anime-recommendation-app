import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'get_page.dart';
import 'post_page.dart';




class skeleton extends StatefulWidget {
  const skeleton({super.key});

  @override
  State<skeleton> createState() => _skeletonState();
}

class _skeletonState extends State<skeleton> {
  int currentIndex = 0;
  List pages = [
    const GetPage(),
    const PostPage(),
  ];
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: pages.elementAt(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index){
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Get'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Post'),
        ],
      ),
    );
  }
 }

