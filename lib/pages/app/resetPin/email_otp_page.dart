import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/app/resetPin/transaction_pin_page.dart';
import 'package:tekpayapp/pages/app/settings_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';

class EmailOtpPage extends StatefulWidget {
  final String email;

  const EmailOtpPage({Key? key, required this.email}) : super(key: key);

  @override
  State<EmailOtpPage> createState() => _EmailOtpPageState();
}

class _EmailOtpPageState extends State<EmailOtpPage> {
  final UserController _userController = Get.find<UserController>();
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _handleResendOtp() async {
    _userController.isResendingOtp.value = true;
    final success =
        await _userController.resendPinChangeOtp(email: widget.email);
    print('Resend OTP Response: $success');
    _userController.isResendingOtp.value = false;

    if (success) {
      pinController.clear();
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = primaryColor;
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Colors.grey;

    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
        color: fillColor,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP verification'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.to(() => SettingsPage()),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            SizedBox(height: 24.h),
            Text(
              '4-digit code has been sent to your email address',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              widget.email,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 32.h),
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: 4,
                      controller: pinController,
                      focusNode: focusNode,
                      defaultPinTheme: defaultPinTheme,
                      separatorBuilder: (index) => SizedBox(width: 8.w),
                      validator: (value) {
                        return value?.length == 4 ? null : 'Pin is incorrect';
                      },
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: focusedBorderColor),
                        ),
                      ),
                      submittedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: focusedBorderColor),
                        ),
                      ),
                      errorPinTheme: defaultPinTheme.copyBorderWith(
                        border: Border.all(color: Colors.redAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Didn\'t receive the OTP?',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            Obx(
              () => TextButton(
                onPressed: _userController.isResendingOtp.value
                    ? null
                    : _handleResendOtp,
                child: Text(
                  _userController.isResendingOtp.value
                      ? 'Sending OTP...'
                      : 'Resend code',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Obx(
              () => _isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    )
                  : CustomButtonWidget(
                      text: 'Continue',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          _isLoading.value = true;
                          final pinToken =
                              await _userController.verifyPinChangeOtp(
                            otp: pinController.text,
                          );
                          _isLoading.value = false;
                          if (pinToken != null) {
                            Get.to(
                                () => TransactionPinPage(pinToken: pinToken));
                          }
                        }
                      },
                    ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
