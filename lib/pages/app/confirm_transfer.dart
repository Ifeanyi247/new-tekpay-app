import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ConfirmTransferPage extends StatelessWidget {
  final String recipientName;
  final String accountNumber;
  final String bankName;

  ConfirmTransferPage({
    super.key,
    required this.recipientName,
    required this.accountNumber,
    required this.bankName,
  });

  final amountController = TextEditingController();
  final remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Transfer To Bank',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.account_balance,
                      size: 24.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipientName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '$accountNumber $bankName',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            Text(
              'Amount',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: '0.00',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                prefixText: '₦ ',
                prefixStyle: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            SizedBox(height: 24.h),
            Text(
              'Remark',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: remarkController,
              decoration: InputDecoration(
                hintText: "What's this for? (Optional)",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14.sp,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[200]!,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[200]!,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8B3DFF),
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (amountController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Please enter amount',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  final amount = double.tryParse(amountController.text);
                  if (amount == null || amount <= 0) {
                    Get.snackbar(
                      'Error',
                      'Please enter a valid amount',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  // Handle confirm transfer
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B3DFF),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
