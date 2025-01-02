import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/auth/confirm_security_pin_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';

class SecurityPinPage extends StatefulWidget {
  const SecurityPinPage({super.key});

  @override
  State<SecurityPinPage> createState() => _SecurityPinPageState();
}

class _SecurityPinPageState extends State<SecurityPinPage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  void _onKeyTap(String value) {
    if (value == 'delete') {
      if (pinController.text.isNotEmpty) {
        pinController.text =
            pinController.text.substring(0, pinController.text.length - 1);
      }
    } else if (pinController.text.length < 4) {
      pinController.text = pinController.text + value;
    }
  }

  Widget _buildNumberButton(String number) {
    return InkWell(
      onTap: () => _onKeyTap(number),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 80.w,
        height: 80.w,
        alignment: Alignment.center,
        child: Text(
          number,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60.w,
      height: 60.w,
      textStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Security Pin',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create your security pin',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'We will require this pin to process your transactions',
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 32.h),
            Center(
              child: Pinput(
                length: 4,
                controller: pinController,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                obscureText: true,
                obscuringWidget: Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                readOnly: true,
                separatorBuilder: (index) => SizedBox(width: 16.w),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: primaryColor, width: 2),
                  ),
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final buttonSize = (constraints.maxWidth - 48.w) / 3;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildNumberButton('1'),
                          _buildNumberButton('2'),
                          _buildNumberButton('3'),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildNumberButton('4'),
                          _buildNumberButton('5'),
                          _buildNumberButton('6'),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildNumberButton('7'),
                          _buildNumberButton('8'),
                          _buildNumberButton('9'),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(width: buttonSize),
                          _buildNumberButton('0'),
                          InkWell(
                            onTap: () => _onKeyTap('delete'),
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: buttonSize,
                              height: buttonSize,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.backspace_outlined,
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            CustomButtonWidget(
              text: 'Continue',
              onTap: () {
                if (pinController.text.length == 4) {
                  Get.to(() => const ConfirmSecurityPinPage());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
