import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/app/biometric_setting_page.dart';
import 'package:tekpayapp/pages/app/resetPin/email_otp_page.dart';
import 'package:tekpayapp/pages/app/reset_password_page.dart';
// import 'package:tekpayapp/pages/app/settings_page.dart';
import 'package:tekpayapp/pages/app/two_factor_page.dart';

class AccountSecurityPage extends StatelessWidget {
  const AccountSecurityPage({super.key});

  Widget _buildSecurityItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
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
          color: primaryColor,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Security',
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildSecurityItem(
            title: 'Reset Password',
            subtitle: 'Update your password',
            icon: Icons.lock_reset,
            onTap: () {
              Get.to(() => const ResetPasswordPage());
            },
          ),
          _buildSecurityItem(
            title: 'Reset Security Pin',
            subtitle: 'Update your security pin',
            icon: Icons.pin_outlined,
            onTap: () async {
              final userController = Get.find<UserController>();
              final userEmail = userController.user.value?.email ?? '';

              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
                barrierDismissible: false,
              );

              await userController.sendPinChangeOtp(email: userEmail);
              Get.back(); // Close loading dialog

              if (userController.error.value == null) {
                Get.to(() => EmailOtpPage(email: userEmail));
              }
            },
          ),
          _buildSecurityItem(
            title: '2FA',
            subtitle: '2 Factor Authentication',
            icon: Icons.security,
            onTap: () {
              Get.to(() => const TwoFactorPage());
            },
          ),
          _buildSecurityItem(
            title: 'Biometrics',
            subtitle: 'Activate biometrics',
            icon: Icons.fingerprint,
            onTap: () {
              Get.to(() => const BiometricSettingPage());
            },
          ),
        ],
      ),
    );
  }
}
