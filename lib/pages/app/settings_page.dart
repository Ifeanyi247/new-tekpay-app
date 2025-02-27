import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/auth_controller.dart';
import 'package:tekpayapp/pages/app/account_security_page.dart';
import 'package:tekpayapp/pages/app/notification_setting_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:in_app_review/in_app_review.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final InAppReview _inAppReview = InAppReview.instance;

  // Store IDs
  static const String _appStoreId = 'YOUR_APP_STORE_ID';
  static const String _playStoreId = 'YOUR_PLAY_STORE_ID';

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          icon,
          color: iconColor ?? primaryColor,
          size: 24.sp,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey,
        size: 24.sp,
      ),
    );
  }

  void _showDeleteBottomSheet(BuildContext context) {
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
              'Delete your Tekpay\naccount?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'You will lose your data and account history in\nthe Tekpay app',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24.h),
            Obx(() => CustomButtonWidget(
                  text: 'Delete Account',
                  onTap: authController.isLoading.value
                      ? null
                      : () async {
                          await authController.deleteAccount();
                        },
                  bgColor: Colors.red,
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

  void _showDeactivateBottomSheet() {
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
              'Deactivate your Tekpay\naccount?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your Tekpay account will be temporarily closed until reactivation.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24.h),
            CustomButtonWidget(
              text: 'Deactivate Account',
              onTap: () {
                // TODO: Implement account deactivation
                Get.back();
              },
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Get.back(),
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

  void _showRatingDialog() {
    int selectedRating = 5;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  Text(
                    'Enjoying Tekpay?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Thank you for using Tekpay, please leave us\na positive reviews and a 5 star rating',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Icon(
                            index < selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 32.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  CustomButtonWidget(
                    text: 'OK, Rate Tekpay',
                    onTap: () async {
                      Get.back();
                      if (selectedRating >= 4) {
                        // For high ratings, direct to app store
                        if (await _inAppReview.isAvailable()) {
                          await _inAppReview.requestReview();
                        } else {
                          await _inAppReview.openStoreListing(
                            appStoreId: _appStoreId,
                            microsoftStoreId: null,
                          );
                        }
                      } else {
                        // For lower ratings, show feedback form
                        Get.snackbar(
                          'Thank You',
                          'Your feedback helps us improve Tekpay',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                        // TODO: Implement feedback form for ratings < 4
                      }
                    },
                  ),
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
            );
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          _buildSettingItem(
            title: 'Account Security',
            subtitle: 'Reset Password, Biometrics, 2FA',
            icon: Icons.security,
            onTap: () {
              Get.to(() => const AccountSecurityPage());
            },
          ),
          _buildSettingItem(
            title: 'Notification',
            subtitle: 'Push, email notification',
            icon: Icons.notifications,
            onTap: () {
              Get.to(() => const NotificationSettingPage());
            },
          ),
          _buildSettingItem(
            title: 'Rating',
            subtitle: 'Enjoying Vastel? Give a review',
            icon: Icons.star,
            onTap: _showRatingDialog,
          ),
          _buildSettingItem(
            title: 'Delete account',
            subtitle: 'Permanently delete my account',
            icon: Icons.delete_forever,
            iconColor: Colors.red,
            onTap: () => _showDeleteBottomSheet(context),
          ),
          // _buildSettingItem(
          //   title: 'Deactivate account',
          //   subtitle: 'Temporarily deactivate my account',
          //   icon: Icons.block,
          //   iconColor: Colors.orange,
          //   onTap: _showDeactivateBottomSheet,
          // ),
        ],
      ),
    );
  }
}
