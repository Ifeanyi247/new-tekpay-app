import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/app/bank_selection_page.dart';
import 'package:tekpayapp/pages/app/confirm_transfer.dart';

class TransferPage extends StatelessWidget {
  TransferPage({super.key});

  final accountNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final selectedBank = Rxn<Bank>();
  final recipientName = ''.obs;

  Widget _buildAccountDetails() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                TextFormField(
                  controller: accountNumberController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter account number',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    suffixIcon: IconButton(
                      onPressed: () {
                        accountNumberController.clear();
                        recipientName.value = '';
                      },
                      icon: const Icon(Icons.close),
                      color: Colors.grey,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter account number';
                    }
                    if (value.length < 10) {
                      return 'Account number must be 10 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: () async {
                    final result = await Get.to(() => BankSelectionPage());
                    if (result != null && result is Bank) {
                      selectedBank.value = result;
                      // Here you would typically call your API to get recipient name
                      // For now, we'll just clear it
                      recipientName.value = '';
                    }
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.account_balance,
                            size: 20.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Obx(() => Text(
                              selectedBank.value?.name ?? 'Select Bank',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Obx(() => recipientName.value.isNotEmpty
                    ? Text(
                        recipientName.value,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : const SizedBox.shrink()),
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
                    if (selectedBank.value == null) {
                      Get.snackbar(
                        'Error',
                        'Please select a bank',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }
                    // Navigate to confirm transfer page
                    Get.to(() => ConfirmTransferPage(
                          recipientName: recipientName.value,
                          accountNumber: accountNumberController.text,
                          bankName: selectedBank.value!.name,
                        ));
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
                  'Proceed',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    final transactions = [
      {
        'name': 'AYOBAMI OLUWAMUYIWA',
        'date': 'Today (10:12)',
      },
      {
        'name': 'AYOMIDE JOHN FAVOUR',
        'date': 'Today (10:12)',
      },
      {
        'name': 'BLESSED SUNDAY',
        'date': 'Moniepoint (10:32)',
      },
      {
        'name': 'MIRABEL ENTERPRISE',
        'date': 'Moniepoint (10:32)',
      },
      {
        'name': 'EGBE OLUWAKEMI',
        'date': 'Moniepoint (10:32)',
      },
      {
        'name': 'IBUKUN WORTHY FUNSHO',
        'date': 'Moniepoint (10:32)',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transactions',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF8B3DFF),
                  ),
                ),
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: transactions.length,
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey[200],
            height: 1,
          ),
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.account_circle_outlined,
                    size: 20.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
              title: Text(
                transaction['name']!,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                transaction['date']!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ],
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
          'Transfer To Bank',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            _buildAccountDetails(),
            SizedBox(height: 32.h),
            _buildTransactionsList(),
          ],
        ),
      ),
    );
  }
}
