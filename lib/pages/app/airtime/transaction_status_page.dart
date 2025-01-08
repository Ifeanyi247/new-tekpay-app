import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/widgets/bottom_bar.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';

enum TransactionStatus { success, pending, failed }

class TransactionStatusPage extends StatelessWidget {
  final TransactionStatus status;
  final String amount;
  final String reference;
  final String date;
  final String recipient;
  final String network;
  final String productName;

  const TransactionStatusPage({
    super.key,
    required this.status,
    required this.amount,
    required this.reference,
    required this.date,
    required this.recipient,
    required this.network,
    required this.productName,
  });

  Color get statusColor {
    switch (status) {
      case TransactionStatus.success:
        return Colors.green;
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.failed:
        return Colors.red;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case TransactionStatus.success:
        return Icons.check_circle_outline;
      case TransactionStatus.pending:
        return Icons.pending_outlined;
      case TransactionStatus.failed:
        return Icons.error_outline;
    }
  }

  String get statusText {
    switch (status) {
      case TransactionStatus.success:
        return 'Transaction Completed';
      case TransactionStatus.pending:
        return 'Transaction Pending';
      case TransactionStatus.failed:
        return 'Transaction Failed';
    }
  }

  String get statusMessage {
    switch (status) {
      case TransactionStatus.success:
        return 'Transaction completed successfully';
      case TransactionStatus.pending:
        return 'Transaction is being processed';
      case TransactionStatus.failed:
        return 'Transaction failed';
    }
  }

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
              // Status Icon
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor.withOpacity(0.1),
                ),
                child: Icon(
                  statusIcon,
                  color: statusColor,
                  size: 40.sp,
                ),
              ),
              SizedBox(height: 24.h),
              // Transaction Status Text
              Text(
                statusText,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              // Status Message
              Text(
                statusMessage,
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
              // Action Button
              CustomButtonWidget(
                text: status == TransactionStatus.pending ? 'Check Status' : 'Done',
                onTap: () {
                  if (status == TransactionStatus.pending) {
                    // TODO: Implement check status
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
