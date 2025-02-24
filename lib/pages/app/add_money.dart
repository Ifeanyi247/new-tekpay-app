import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/controllers/virtual_account_controller.dart';
import 'package:tekpayapp/pages/app/account_details_page.dart';
import 'package:tekpayapp/pages/app/add_bank_page.dart';
import 'package:tekpayapp/pages/app/top_up_card_page.dart';

class AddMoneyPage extends StatelessWidget {
  final _virtualAccountController = Get.put(VirtualAccountController());

  AddMoneyPage({super.key});

  Widget _buildBankCard({
    required String bankName,
    required String accountNumber,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bankName,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Account Number',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          Row(
            children: [
              Text(
                accountNumber,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: accountNumber));
                  Get.snackbar(
                    'Success',
                    'Account number copied to clipboard',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.copy_outlined,
                      color: primaryColor,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Copy',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Money',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(() {
        if (_virtualAccountController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final virtualAccount =
            _virtualAccountController.virtualAccountDetails.value;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Virtual accounts',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Make a transfer to the generated account once.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 24.h),
              if (virtualAccount != null)
                _buildBankCard(
                  bankName: virtualAccount['bank_name'] ?? 'N/A',
                  accountNumber: virtualAccount['account_number'] ?? 'N/A',
                )
              else
                Center(
                  child: TextButton(
                    onPressed: () =>
                        _virtualAccountController.createVirtualAccount(),
                    child: Text(
                      'Create Virtual Account',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey[300],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.credit_card,
                      color: primaryColor,
                      size: 24.sp,
                    ),
                  ),
                  title: Text(
                    'Top-up with Card',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    'Add money from your bank card',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                    size: 24.sp,
                  ),
                  onTap: () {
                    Get.to(() => const TopUpCardPage());
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
