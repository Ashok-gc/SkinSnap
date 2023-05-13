import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../libb/src/screen/report_screen.dart';

import '../../model/users.dart';
import 'buttom_navigation_screen/google_map.dart';
import 'buttom_navigation_screen/home_screen.dart';
import 'buttom_navigation_screen/profile_screen.dart';
import 'buttom_navigation_screen/skin_camera.dart';

class Navigation extends StatefulWidget {
  Users? users;
  Navigation({super.key, this.users});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  String? profileURL;
  int index = 0;
  late var screens = [
    const HomeScreen(),
    const GoogleMapScreen(),
    const SkinCameraScreen(),
    const ReportScreen(),
    const ProfileScreen(),
  ];


  @override
  Widget build(BuildContext context) => Scaffold(
        body: screens[index],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: Colors.blue.shade100,
              labelTextStyle: const MaterialStatePropertyAll(
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              )),
          child: NavigationBar(
            height: 60,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            selectedIndex: index,
            animationDuration: const Duration(seconds: 3),
            onDestinationSelected: (index) =>
                setState(() => this.index = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map),
                label: 'Map',
              ),
              NavigationDestination(
                icon: Icon(Icons.camera_alt_outlined),
                selectedIcon: Icon(Icons.camera_alt),
                label: 'Camera',
              ),
              NavigationDestination(
                icon: Icon(Icons.description_outlined),
                selectedIcon: Icon(Icons.description),
                label: 'Reports',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      );
}
