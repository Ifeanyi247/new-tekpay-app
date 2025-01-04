import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/app/all_services_page.dart';
import 'package:tekpayapp/pages/app/home_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final _pages = [
    HomePage(),
    AllServicesPage(),
    Container(
      child: Center(
        child: Text(
          'Transactions',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    Container(
      child: Center(
        child: Text(
          'Profile',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ];

  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home,
                    color: _currentIndex == 0 ? primaryColor : Colors.grey,
                  ),
                  Text(
                    'Home',
                    style: TextStyle(
                      color: _currentIndex == 0 ? primaryColor : Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.grid_view,
                    color: _currentIndex == 1 ? primaryColor : Colors.grey,
                  ),
                  Text(
                    'Services',
                    style: TextStyle(
                      color: _currentIndex == 1 ? primaryColor : Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.swap_horiz,
                    color: _currentIndex == 2 ? primaryColor : Colors.grey,
                  ),
                  Text(
                    'Transactions',
                    style: TextStyle(
                      color: _currentIndex == 2 ? primaryColor : Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_outline,
                    color: _currentIndex == 3 ? primaryColor : Colors.grey,
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: _currentIndex == 3 ? primaryColor : Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
    );
  }
}
