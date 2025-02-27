import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tekpayapp/constants/colors.dart';

class StatusPage extends StatefulWidget {
  final String amount;
  final String status;
  final DateTime date;
  final String recipientId;
  final String transactionType;
  final String method;
  final String transactionId;
  final String transactionDate;

  const StatusPage({
    super.key,
    required this.amount,
    required this.status,
    required this.date,
    required this.recipientId,
    required this.transactionType,
    required this.method,
    required this.transactionId,
    required this.transactionDate,
  });

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  Color get statusColor {
    switch (widget.status.toLowerCase()) {
      case 'delivered':
      case 'successful':
        return Colors.green;
      case 'pending':
      case 'initiated':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Transaction Receipt',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Amount and Status
            Text(
              '₦${NumberFormat('#,##0.00').format(double.parse(widget.amount))}',
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Transaction ${widget.status}',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Today ${DateFormat('h:mma').format(widget.date).toLowerCase()}',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 32.h),

            // Transaction Details
            const Text(
              'Transaction Details:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),

            // Details List
            _buildDetailRow('Recipient ID:', widget.recipientId),
            _buildDetailRow('Transaction Type:', widget.transactionType),
            _buildDetailRow('Method:', widget.method),
            _buildDetailRow('Transaction Date:', widget.transactionDate),
            _buildDetailRow('Transaction ID:', widget.transactionId),

            SizedBox(height: 48.h),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement share receipt
                    },
                    icon: const Icon(Icons.share, color: primaryColor),
                    label: const Text('Share Receipt'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: primaryColor,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: primaryColor),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement download receipt
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download Receipt'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Flexible(
                flex: 3,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(height: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
