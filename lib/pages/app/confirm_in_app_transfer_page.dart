import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/controllers/virtual_account_controller.dart';
import 'package:tekpayapp/controllers/transfer_controller.dart';
import 'package:tekpayapp/pages/app/education/education_page.dart';

class ConfirmInAppTransferPage extends StatelessWidget {
  ConfirmInAppTransferPage({
    super.key,
    required this.recipientName,
    required this.accountNumber,
    required this.bankName,
    required this.bankCode,
    this.prefillAmount,
    this.isInAppTransfer = false,
    this.onConfirm,
    required this.recipientId,
  });

  final String recipientName;
  final String accountNumber;
  final String bankName;
  final String bankCode;
  final String? prefillAmount;
  final bool isInAppTransfer;
  final Function? onConfirm;
  final String recipientId;
  final amountController = TextEditingController();
  final remarkController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final virtualAccountController = Get.find<VirtualAccountController>();
  final userController = Get.find<UserController>();
  final transferController = Get.find<TransferController>();

  void _showTransactionConfirmation(BuildContext context) {
    final now = DateTime.now();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 24.w,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.w,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'NGN ${amountController.text}',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF8B3DFF),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      size: 24.sp,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              _buildDetailRow('Recipient', recipientName),
              SizedBox(height: 16.h),
              _buildDetailRow('Transaction Type',
                  isInAppTransfer ? 'In-App Transfer' : 'Bank Transfer'),
              SizedBox(height: 16.h),
              if (!isInAppTransfer) ...[
                _buildDetailRow('Bank', bankName),
                SizedBox(height: 16.h),
              ],
              _buildDetailRow('Paying', 'NGN ${amountController.text}'),
              SizedBox(height: 16.h),
              _buildDetailRow('Date', now.toString()),
              if (remarkController.text.isNotEmpty) ...[
                SizedBox(height: 16.h),
                _buildDetailRow('Remark', remarkController.text),
              ],
              SizedBox(height: 24.h),
              Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B3DFF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: const Color(0xFF8B3DFF),
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Balance',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          userController.user.value?.profile.wallet
                                  .toString() ??
                              '0.00',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_circle,
                      color: const Color(0xFF8B3DFF),
                      size: 24.sp,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => PinEntrySheet(
                        onPinComplete: (pin) async {
                          Navigator.pop(context);
                          final userPin = userController
                              .user.value?.profile.pinCode
                              .toString();
                          if (userPin == null) {
                            Get.snackbar(
                              'Error',
                              'Please set up your PIN in profile settings',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          if (pin != userPin) {
                            Get.snackbar(
                              'Error',
                              'Incorrect PIN. Please try again.',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          // Show loading dialog
                          Get.dialog(
                            PopScope(
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(16.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Color(0xFF8B3DFF),
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            barrierDismissible: false,
                          );

                          if (isInAppTransfer && onConfirm != null) {
                            await onConfirm!();
                          } else {
                            await transferController.initiateInAppTransfer(
                              recipientId: recipientId,
                              amount: double.parse(amountController.text),
                              narration: remarkController.text.isNotEmpty
                                  ? remarkController.text
                                  : null,
                            );
                          }
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B3DFF),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Pay',
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
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
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
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pre-fill amount if provided
    if (prefillAmount != null && amountController.text.isEmpty) {
      amountController.text = prefillAmount!;
      // Also update the transfer controller amount
      Get.find<TransferController>().amount.value =
          double.parse(prefillAmount!);
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF8F2FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          isInAppTransfer ? 'Confirm In-App Transfer' : 'Confirm Bank Transfer',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                margin: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isInAppTransfer ? 'Recipient Details' : 'Bank Details',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildDetailRow('Name', recipientName),
                    SizedBox(height: 8.h),
                    _buildDetailRow(
                      isInAppTransfer ? 'Email/Phone' : 'Account Number',
                      accountNumber,
                    ),
                    if (!isInAppTransfer) ...[
                      SizedBox(height: 8.h),
                      _buildDetailRow('Bank', bankName),
                    ],
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.w),
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter Amount',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter amount',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        prefixText: 'NGN ',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null) {
                          return 'Please enter a valid amount';
                        }
                        if (amount <= 0) {
                          return 'Amount must be greater than 0';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.w),
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remark',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: remarkController,
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter remark',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        _showTransactionConfirmation(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B3DFF),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Send Money',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
