import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';

class TwoFactorPage extends StatefulWidget {
  const TwoFactorPage({super.key});

  @override
  State<TwoFactorPage> createState() => _TwoFactorPageState();
}

class _TwoFactorPageState extends State<TwoFactorPage> {
  bool _emailEnabled = false;
  bool _phoneEnabled = false;

  Widget _build2FAOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
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
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (bool newValue) {
              if (newValue &&
                  ((_emailEnabled && title == 'Phone') ||
                      (_phoneEnabled && title == 'Email'))) {
                Get.snackbar(
                  'Note',
                  'You can only enable one option at a time',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
                return;
              }
              onChanged(newValue);
            },
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '2FA Settings',
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
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Protect you account by adding another layer of protection, receive a code when you login in a new device, account recovery or when you make a very high transaction.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Note: You can only choose one of the options below at a time.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),
            _build2FAOption(
              title: 'Email',
              subtitle: 'Receive a code via your email',
              icon: Icons.email_outlined,
              value: _emailEnabled,
              onChanged: (value) {
                setState(() {
                  _emailEnabled = value;
                  if (value) _phoneEnabled = false;
                });
              },
            ),
            _build2FAOption(
              title: 'Phone',
              subtitle: 'Receive a code via you phone',
              icon: Icons.phone_outlined,
              value: _phoneEnabled,
              onChanged: (value) {
                setState(() {
                  _phoneEnabled = value;
                  if (value) _emailEnabled = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
