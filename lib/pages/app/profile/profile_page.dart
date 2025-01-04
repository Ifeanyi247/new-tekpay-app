import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Widget _buildProfileOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xFF8B3DFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF8B3DFF),
                size: 20.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B3DFF),
      body: SafeArea(
        child: Column(
          children: [
            // Profile Header
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32.r,
                    backgroundImage: const NetworkImage(
                      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1000&auto=format&fit=crop',
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Johndoe1123@testmail.com',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '08123456789',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Profile Options
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildProfileOption(
                        title: 'Personal Information',
                        subtitle: 'Edit your informatioon',
                        icon: Icons.person_outline,
                        onTap: () {},
                      ),
                      _buildProfileOption(
                        title: 'Settings',
                        subtitle: 'Account, notification, security',
                        icon: Icons.settings_outlined,
                        onTap: () {},
                      ),
                      _buildProfileOption(
                        title: 'My Referral',
                        subtitle: 'Referral bonuses',
                        icon: Icons.attach_money_outlined,
                        onTap: () {},
                      ),
                      _buildProfileOption(
                        title: 'KYC',
                        subtitle: 'Submit details to verify your account',
                        icon: Icons.verified_user_outlined,
                        onTap: () {},
                      ),
                      _buildProfileOption(
                        title: 'Help & Support',
                        subtitle: 'Help or contact vasel',
                        icon: Icons.help_outline,
                        onTap: () {},
                      ),
                      SizedBox(height: 16.h),
                      _buildProfileOption(
                        title: 'Logout',
                        subtitle: '',
                        icon: Icons.logout,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
