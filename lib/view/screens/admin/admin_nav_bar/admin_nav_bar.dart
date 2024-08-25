import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_fonts.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_alert/admin_alert.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_home/admin_home.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_location.dart';
import 'package:lanefocus/view/screens/admin/admin_nav_bar/admin_profile/admin_profile.dart';

class AdminNavBar extends StatefulWidget {
  const AdminNavBar({super.key});

  @override
  State<AdminNavBar> createState() => _AdminNavBarState();
}

class _AdminNavBarState extends State<AdminNavBar> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _items = [
    {
      'icon': Assets.imagesHome,
      'label': 'Home',
    },
    {
      'icon': Assets.imagesAlert,
      'label': 'Alert',
    },
    {
      'icon': Assets.imagesLocation,
      'label': 'Location',
    },
    {
      'icon': Assets.imagesProfile,
      'label': 'Profile',
    },
  ];

  void _getCurrentScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = [
    AdminHome(),
    AdminAlert(),
    AdminLocation(),
    AdminProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: Platform.isIOS ? null : 70,
        color: kPrimaryColor,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _getCurrentScreen,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconSize: 24,
          selectedItemColor: kSecondaryColor,
          unselectedItemColor: kQuaternaryColor,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.SPLINE_SANS,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.SPLINE_SANS,
          ),
          items: List.generate(
            _items.length,
            (index) {
              return BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: ImageIcon(
                    AssetImage(_items[index]['icon']),
                    size: 24,
                  ),
                ),
                label: _items[index]['label'],
              );
            },
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
    );
  }
}
