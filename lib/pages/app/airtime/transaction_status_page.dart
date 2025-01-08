import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/widgets/bottom_bar.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';

class TransactionStatusPage extends StatelessWidget {
  final bool success;
  final String amount;
  final String reference;
  final String date;
  final String recipient;
  final String network;
  final String productName;

  const TransactionStatusPage({
    super.key,
    required this.success,
    required this.amount,
    required this.reference,
    required this.date,
    required this.recipient,
    required this.network,
    required this.productName,
  });

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

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
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (success ? Colors.green : Colors.red).withOpacity(0.1),
                ),
                child: Icon(
                  success ? Icons.check_circle_outline : Icons.error_outline,
                  color: success ? Colors.green : Colors.red,
                  size: 40.sp,
                ),
              ),
              SizedBox(height: 24.h),
              // Transaction Status Text
              Text(
                success ? 'Transaction Completed' : 'Transaction Failed',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              // Status Message
              Text(
                success ? 'Airtime topup was successful' : 'Airtime topup failed',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 32.h),
              // Transaction Details
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Amount', '₦$amount'),
                    _buildInfoRow('Reference', reference),
                    _buildInfoRow('Date', date),
                    _buildInfoRow('Recipient', recipient),
                    _buildInfoRow('Network', network.toUpperCase()),
                    _buildInfoRow('Product', productName),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              // Transactions Button
              CustomButtonWidget(
                text: 'Done',
                onTap: () {
                  Get.offAll(() => const BottomBar());
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
