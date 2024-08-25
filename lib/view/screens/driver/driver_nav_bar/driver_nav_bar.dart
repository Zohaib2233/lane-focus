import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lanefocus/constants/app_colors.dart';
import 'package:lanefocus/constants/app_fonts.dart';
import 'package:lanefocus/constants/app_images.dart';
import 'package:lanefocus/view/screens/driver/driver_nav_bar/driver_home.dart';
import 'package:lanefocus/view/screens/driver/driver_nav_bar/driver_permission.dart';
import 'package:lanefocus/view/screens/driver/driver_nav_bar/driver_profile/driver_profile.dart';
import 'package:lanefocus/view/screens/driver/driver_nav_bar/driver_user_guide.dart';

class DriverNavBar extends StatefulWidget {
  const DriverNavBar({super.key});

  @override
  State<DriverNavBar> createState() => _DriverNavBarState();
}

class _DriverNavBarState extends State<DriverNavBar> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _items = [
    {
      'icon': Assets.imagesLocation,
      'label': 'Location',
    },
    {
      'icon': Assets.imagesPermission,
      'label': 'Permission',
    },
    {
      'icon': Assets.imagesUserGuide,
      'label': 'User Guide',
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
    DriverHome(),
    DriverPermission(),
    DriverUserGuide(),
    DriverProfile(),
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
