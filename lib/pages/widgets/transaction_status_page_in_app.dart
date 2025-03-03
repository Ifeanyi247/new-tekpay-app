import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/widgets/bottom_bar.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';

enum TransactionStatus { success, pending, failed }

class TransactionStatusPageInApp extends StatelessWidget {
  final status;
  final String amount;
  final String reference;
  final String date;
  final String recipient;
  final String network;
  final String productName;
  final String? lightToken;
  final bool error;

  const TransactionStatusPageInApp({
    super.key,
    required this.status,
    required this.amount,
    required this.reference,
    required this.date,
    required this.recipient,
    required this.network,
    required this.productName,
    this.lightToken,
    this.error = false,
  });

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
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
              // Status Icon
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: error ? Colors.red : Colors.green,
                ),
                child: Icon(
                  error ? Icons.error : Icons.check,
                  color: error ? Colors.red : Colors.green,
                  size: 40.sp,
                ),
              ),
              SizedBox(height: 24.h),
              // Transaction Status Text
              Text(
                error ? 'Error' : 'Success',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: error ? Colors.red : Colors.green,
                ),
              ),
              SizedBox(height: 8.h),
              // Status Message
              Text(
                error ? 'Something went wrong' : 'Transaction successful',
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
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoRow('Token', lightToken.toString()),
                        ),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: lightToken.toString()));
                          },
                          icon: Icon(Icons.copy),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),
              // Action Button
              CustomButtonWidget(
                text: status == TransactionStatus.pending
                    ? 'Check Status'
                    : 'Done',
                onTap: () {
                  if (status == TransactionStatus.pending) {
                    Get.offAll(() => const BottomBar());
                  } else {
                    Get.offAll(() => const BottomBar());
                  }
                },
              ),
              if (status == TransactionStatus.failed)
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: CustomButtonWidget(
                    text: 'Try Again',
                    onTap: () => Get.back(),
                  ),
                ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
