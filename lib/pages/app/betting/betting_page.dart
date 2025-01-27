import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:tekpayapp/pages/widgets/custom_text_field.dart';
import 'package:tekpayapp/pages/app/betting/select_bet_provider_page.dart';
import 'package:tekpayapp/pages/app/betting/purchase_bet_page.dart';

class BettingPage extends StatefulWidget {
  const BettingPage({super.key});

  @override
  State<BettingPage> createState() => _BettingPageState();
}

class _BettingPageState extends State<BettingPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _userController = Get.find<UserController>();
  Map<String, String>? selectedProvider;

  void _handleProceed() {
    if (selectedProvider == null) {
      Get.snackbar(
        'Error',
        'Please select a betting provider',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_userIdController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a User ID',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_amountController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter an amount',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount < 50) {
      Get.snackbar(
        'Error',
        'Minimum amount is ₦50',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.to(() => PurchaseBetPage(
          providerId: selectedProvider?['name'] ?? '',
          recipientId: _userIdController.text,
          amount: _amountController.text,
          date: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        ));
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Betting Purchase'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Provider',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),
            InkWell(
              onTap: () async {
                final result = await Get.to<Map<String, String>>(
                    () => const SelectBetProviderPage());
                if (result != null) {
                  setState(() {
                    selectedProvider = result;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    if (selectedProvider != null) ...[
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.sports_basketball,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(width: 12.w),
                    ],
                    Text(
                      selectedProvider?['name'] ?? 'Select betting provider',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: selectedProvider != null
                            ? Colors.black
                            : Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            CustomTextFieldWidget(
              controller: _userIdController,
              label: 'User ID',
              icon: Icons.person_outline,
            ),
            SizedBox(height: 16.h),
            CustomTextFieldWidget(
              controller: _amountController,
              label: 'Amount',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 32.h),
            CustomButtonWidget(
              text: 'Proceed',
              onTap: _handleProceed,
            ),
          ],
        ),
      ),
    );
  }
}
