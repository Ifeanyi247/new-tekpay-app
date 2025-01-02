import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/pages/auth/notification_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';

class BiometricPage extends StatelessWidget {
  const BiometricPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Set Biometrics',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Biometrics',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Protect your account with biometrics. Set up fingerprint authentication for faster and more secure access to your Tekpay account',
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey,
              ),
            ),
            const Spacer(),
            Center(
              child: Image.asset(
                'assets/images/Biometrics.png',
                width: 200.w,
                height: 200.w,
              ),
            ),
            const Spacer(),
            CustomButtonWidget(
              text: 'Continue',
              onTap: () {
                // Handle biometric setup
              },
            ),
            SizedBox(height: 16.h),
            Center(
              child: TextButton(
                onPressed: () {
                  Get.to(() => const NotificationPage());
                },
                child: Text(
                  'Skip For Now',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
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
