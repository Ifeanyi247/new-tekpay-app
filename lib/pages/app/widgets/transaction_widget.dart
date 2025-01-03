import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:intl/intl.dart';

class TransactionConfirmationSheet extends StatelessWidget {
  final String amount;
  final String recipientId;
  final String network;
  final String transactionType;
  final VoidCallback onProceed;

  const TransactionConfirmationSheet({
    super.key,
    required this.amount,
    required this.recipientId,
    required this.network,
    required this.transactionType,
    required this.onProceed,
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₦$amount',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildInfoRow('Recipient ID', recipientId),
          _buildInfoRow('Transaction Type', transactionType),
          _buildInfoRow('Network', network),
          _buildInfoRow('Paying', '₦ $amount'),
          _buildInfoRow(
              'Date', DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())),
          SizedBox(height: 24.h),
          Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet,
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
                        'Balance',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '₦5,000.00',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.check_circle,
                  color: primaryColor,
                  size: 24.sp,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          CustomButtonWidget(
            text: 'Pay',
            onTap: onProceed,
          ),
        ],
      ),
    );
  }
}
