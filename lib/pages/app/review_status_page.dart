import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';

class ReviewStatusPage extends StatelessWidget {
  const ReviewStatusPage({super.key});

  Widget _buildStatusItem({
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
    required String title,
    required String subtitle,
    bool showLine = true,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor,
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24.sp,
              ),
            ),
            if (showLine)
              Container(
                width: 2,
                height: 40.h,
                color: primaryColor,
              ),
          ],
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
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: showLine ? 24.h : 0),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your submission is under review',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your personal information and address is being reviewed.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Progress',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            SizedBox(height: 24.h),
            _buildStatusItem(
              icon: Icons.check,
              iconColor: Colors.green,
              borderColor: Colors.green,
              title: 'Personal Information',
              subtitle:
                  'Your personal information and NIN has been verified on NIMC.',
            ),
            _buildStatusItem(
              icon: Icons.circle,
              iconColor: primaryColor,
              borderColor: primaryColor,
              title: 'BVN Verification',
              subtitle:
                  'Your details are being checked and will be verified within 2 minutes.',
            ),
            _buildStatusItem(
              icon: Icons.circle,
              iconColor: primaryColor,
              borderColor: primaryColor,
              title: 'Address verification',
              subtitle:
                  'Your details are being checked and will be verified within 2 minutes.',
              showLine: false,
            ),
            const Spacer(),
            CustomButtonWidget(
              text: 'Go Back To Profile',
              onTap: () {
                Get.until((route) => route.isFirst);
              },
              bgColor: Colors.white,
              textColor: primaryColor,
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
