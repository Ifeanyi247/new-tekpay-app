import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/auth_controller.dart';
import 'package:tekpayapp/pages/auth/confirm_security_pin_page.dart';

class SecurityPinPage extends StatefulWidget {
  final String pinToken;
  final String email;

  const SecurityPinPage({
    super.key,
    required this.pinToken,
    required this.email,
  });

  @override
  State<SecurityPinPage> createState() => _SecurityPinPageState();
}

class _SecurityPinPageState extends State<SecurityPinPage> {
  final _pinController = TextEditingController();
  final _authController = Get.find<AuthController>();
  final _pin = ''.obs;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _onKeyPressed(String value) {
    if (_pin.value.length < 4) {
      _pin.value += value;
      if (_pin.value.length == 4) {
        Get.to(() => ConfirmSecurityPinPage(
              email: widget.email,
              pinToken: widget.pinToken,
              firstPin: _pin.value,
            ));
      }
    }
  }

  void _onBackspacePressed() {
    if (_pin.value.isNotEmpty) {
      _pin.value = _pin.value.substring(0, _pin.value.length - 1);
    }
  }

  Widget _buildKeyboardButton(String text, {bool isBackspace = false}) {
    return InkWell(
      onTap: () {
        if (isBackspace) {
          _onBackspacePressed();
        } else {
          _onKeyPressed(text);
        }
      },
      child: Container(
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: isBackspace
              ? Icon(
                  Icons.backspace_outlined,
                  color: Colors.grey[600],
                  size: 24.sp,
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey[800],
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              SizedBox(height: 32.h),
              Text(
                'Create Security PIN',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Create a 4-digit PIN to secure your account',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48.h),
              // PIN dots
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      bool isFilled = index < _pin.value.length;
                      return Container(
                        width: 16.w,
                        height: 16.w,
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFilled ? primaryColor : Colors.grey[200],
                        ),
                      );
                    }),
                  )),
              SizedBox(height: 48.h),
              // Number pad
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16.h,
                  crossAxisSpacing: 16.w,
                  childAspectRatio: 1.5,
                  children: [
                    _buildKeyboardButton('1'),
                    _buildKeyboardButton('2'),
                    _buildKeyboardButton('3'),
                    _buildKeyboardButton('4'),
                    _buildKeyboardButton('5'),
                    _buildKeyboardButton('6'),
                    _buildKeyboardButton('7'),
                    _buildKeyboardButton('8'),
                    _buildKeyboardButton('9'),
                    const SizedBox.shrink(),
                    _buildKeyboardButton('0'),
                    _buildKeyboardButton('', isBackspace: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
