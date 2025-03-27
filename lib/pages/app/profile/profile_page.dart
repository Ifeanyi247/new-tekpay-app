import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/auth_controller.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/app/kyc_page.dart';
import 'package:tekpayapp/pages/app/profile/edit_profile_page.dart';
import 'package:tekpayapp/pages/app/referral_page.dart';
import 'package:tekpayapp/pages/app/settings_page.dart';
import 'package:tekpayapp/pages/app/support_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authController = Get.put(AuthController());

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
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: primaryColor,
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

  void _showLogoutBottomSheet(BuildContext context) {
    final authController = Get.find<AuthController>();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to Logout?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.h),
            Obx(() => CustomButtonWidget(
                  text: 'Logout',
                  onTap: authController.isLoading.value
                      ? null
                      : () async {
                          await authController.logout();
                        },
                  bgColor: primaryColor,
                )),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: const Color(0xFF8B3DFF),
      body: SafeArea(
        child: Column(
          children: [
            // Profile Header
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Obx(() {
                final user = userController.user.value;
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 32.r,
                      backgroundImage: user != null
                          ? CachedNetworkImageProvider(user.profile.profileUrl)
                          : const NetworkImage(
                              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1000&auto=format&fit=crop',
                            ),
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user != null
                              ? '${user.firstName} ${user.lastName}'
                              : 'John Doe',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          user?.email ?? 'Johndoe1123@testmail.com',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          user?.phoneNumber ?? '08123456789',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
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
                child: RefreshIndicator(
                  onRefresh: () => userController.getProfile(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        _buildProfileOption(
                          title: 'Personal Information',
                          subtitle: 'Edit your informatioon',
                          icon: Icons.person_outline,
                          onTap: () {
                            Get.to(() => EditProfilePage());
                          },
                        ),
                        _buildProfileOption(
                          title: 'Settings',
                          subtitle: 'Account, notification, security',
                          icon: Icons.settings_outlined,
                          onTap: () {
                            Get.to(() => SettingsPage());
                          },
                        ),
                        _buildProfileOption(
                          title: 'My Referral',
                          subtitle: 'Referral bonuses',
                          icon: Icons.attach_money_outlined,
                          onTap: () {
                            Get.to(() => ReferralPage());
                          },
                        ),
                        // _buildProfileOption(
                        //   title: 'KYC',
                        //   subtitle: 'Identity verification',
                        //   icon: Icons.verified_user_outlined,
                        //   onTap: () {
                        //     Get.to(() => const KYCPage());
                        //   },
                        // ),
                        _buildProfileOption(
                          title: 'Help & Support',
                          subtitle: 'Help or contact Tekpay',
                          icon: Icons.help_outline,
                          onTap: () {
                            Get.to(() => const SupportPage());
                          },
                        ),
                        SizedBox(height: 16.h),
                        Obx(() {
                          return authController.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : _buildProfileOption(
                                  title: 'Logout',
                                  subtitle: 'logout of your account',
                                  icon: Icons.logout,
                                  onTap: () {
                                    _showLogoutBottomSheet(context);
                                  }
                                  // onTap: () async {
                                  //   await authController.logout();
                                  // },
                                );
                        }),
                      ],
                    ),
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
