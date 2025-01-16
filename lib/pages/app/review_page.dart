import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/app/review_status_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green.shade100,
                    width: 4,
                  ),
                ),
                child: Icon(
                  Icons.warning_rounded,
                  color: Colors.white,
                  size: 40.sp,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Your submission is under review',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                'Thank you for submitting your details, your details are under review. You can view the status of the review by clicking the "See Status" button below.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CustomButtonWidget(
                text: 'See Review Status',
                onTap: () {
                  Get.to(() => const ReviewStatusPage());
                },
              ),
              SizedBox(height: 16.h),
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
      ),
    );
  }
}
