import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/widgets/bottom_bar.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';

class EducationSuccessPage extends StatelessWidget {
  final String transactionType;
  final String amount;
  final String reference;

  const EducationSuccessPage({
    super.key,
    required this.transactionType,
    required this.amount,
    required this.reference,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.green,
                    width: 3.w,
                  ),
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 50.sp,
                ),
              ),
              SizedBox(height: 24.h),
              // Transaction Completed Text
              Text(
                'Transaction Completed',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              // Success Message
              Text(
                'Payment was successful',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 40.h),
              // Check Result PIN Button
              CustomButtonWidget(
                text: 'Check Result PIN',
                onTap: () {
                  Get.offAll(() => const BottomBar());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
