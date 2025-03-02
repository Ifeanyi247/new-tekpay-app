import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/auth_controller.dart';
import 'package:tekpayapp/pages/app/noAuthPage/reset_pin_no_auth.dart';
import 'package:tekpayapp/pages/app/password_reset/reset_password_otp_page.dart';

class VerifyForgotOtpPinPageNoAuth extends StatefulWidget {
  final String email;

  const VerifyForgotOtpPinPageNoAuth({
    super.key,
    required this.email,
  });

  @override
  State<VerifyForgotOtpPinPageNoAuth> createState() =>
      _VerifyForgotOtpPinPageNoAuthState();
}

class _VerifyForgotOtpPinPageNoAuthState
    extends State<VerifyForgotOtpPinPageNoAuth> {
  final authController = Get.find<AuthController>();
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFE8E8E8);
    const fillColor = Color(0xFFF8F8F8);

    final defaultPinTheme = PinTheme(
      width: 70.w,
      height: 70.w,
      textStyle: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
    );

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
          'Forgot Pin',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/images/support_agent.png',
                color: Colors.black,
                scale: 0.8,
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Text(
              '4-digit code has been sent to your email address',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              widget.email,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 40.h),
            Pinput(
              obscureText: true,
              obscuringCharacter: '*',
              length: 4,
              controller: pinController,
              focusNode: focusNode,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: primaryColor),
                ),
              ),
              onCompleted: (pin) async {
                final resetToken = await authController.verifyResetPinOtpNoAuth(
                  email: widget.email,
                  otp: pin,
                );

                if (resetToken != null) {
                  Get.offAll(() => ResetPinNoAuth(
                        pinToken: resetToken,
                      ));
                }
              },
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive the OTP?",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                TextButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () async {
                          print('Resending OTP for email: ${widget.email}');
                          await authController
                              .sendForgotPinOtpToMailNoAuth(widget.email);
                          pinController.clear();
                          focusNode.requestFocus();
                        },
                  child: Text(
                    'Resend code',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: authController.isLoading.value
                      ? null
                      : () async {
                          if (pinController.text.length == 4) {
                            final resetToken =
                                await authController.verifyResetPinOtpNoAuth(
                              email: widget.email,
                              otp: pinController.text,
                            );

                            print('Reset Token: $resetToken');
                            if (resetToken != null) {
                              print(
                                  'Navigating to ResetPinNoAuth with token: $resetToken');
                              await Get.off(
                                () => ResetPinNoAuth(pinToken: resetToken),
                                transition: Transition.rightToLeft,
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: authController.isLoading.value
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
