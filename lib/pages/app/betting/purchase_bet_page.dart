import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/app/betting/transaction_bet_status_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';

class PurchaseBetPage extends StatefulWidget {
  final String providerId;
  final String recipientId;
  final String amount;
  final String date;

  const PurchaseBetPage({
    super.key,
    required this.providerId,
    required this.recipientId,
    required this.amount,
    required this.date,
  });

  @override
  State<PurchaseBetPage> createState() => _PurchaseBetPageState();
}

class _PurchaseBetPageState extends State<PurchaseBetPage> {
  final List<TextEditingController> _pinControllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _pinFocusNodes =
      List.generate(4, (index) => FocusNode());
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    for (var node in _pinFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onPinInput(String value, int index) {
    if (value.length == 1 && index < 3) {
      _pinFocusNodes[index + 1].requestFocus();
    }
  }

  String get _pin => _pinControllers.map((c) => c.text).join();

  void _handleSubmit() {
    if (_pin.length != 4) {
      Get.snackbar(
        'Error',
        'Please enter your 4-digit PIN',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    Get.off(() => const TransactionBetStatusPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Transaction Summary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.h),
              Text(
                widget.providerId,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 32.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Recipient ID:', widget.recipientId),
                    Divider(color: Colors.grey[200]),
                    _buildInfoRow('Paying', '₦ ${widget.amount}'),
                    Divider(color: Colors.grey[200]),
                    _buildInfoRow('Date:', widget.date),
                  ],
                ),
              ),
              SizedBox(height: 48.h),
              Text(
                'Enter Transaction Pin',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () {
                  // TODO: Implement forgot PIN
                },
                child: Text(
                  'Forgot Pin',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => Container(
                      width: 60.w,
                      height: 60.w,
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: TextFormField(
                        controller: _pinControllers[index],
                        focusNode: _pinFocusNodes[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        obscureText: true,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) => _onPinInput(value, index),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 48.h),
              CustomButtonWidget(
                text: 'Proceed',
                onTap: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
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
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
