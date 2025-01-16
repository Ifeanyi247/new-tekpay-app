import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:pinput/pinput.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/auth_controller.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/widgets/bottom_bar.dart';

class InputPinPage extends StatefulWidget {
  const InputPinPage({super.key});

  @override
  State<InputPinPage> createState() => _InputPinPageState();
}

class _InputPinPageState extends State<InputPinPage> {
  final _pinController = TextEditingController();
  final _authController = Get.find<AuthController>();
  late final UserController userController;

  @override
  void initState() {
    super.initState();
    userController = Get.find<UserController>();
  }

  void _onKeyTap(String value) {
    if (value == 'delete') {
      if (_pinController.text.isNotEmpty) {
        _pinController.text =
            _pinController.text.substring(0, _pinController.text.length - 1);
      }
    } else if (_pinController.text.length < 4) {
      _pinController.text = _pinController.text + value;
    }
  }

  Widget _buildNumberButton(String number) {
    return InkWell(
      onTap: () => _onKeyTap(number),
      child: Container(
        width: 80.w,
        height: 80.w,
        alignment: Alignment.center,
        child: Text(
          number,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60.w,
      height: 60.w,
      textStyle: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/images/support_agent.png',
              width: 24.w,
              height: 24.w,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Obx(() => CircleAvatar(
                  radius: 40.r,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      _authController.tempUserImage.value.isNotEmpty
                          ? NetworkImage(_authController.tempUserImage.value)
                          : const AssetImage('assets/images/avatar.png')
                              as ImageProvider,
                )),
            SizedBox(height: 16.h),
            Obx(() => Text(
                  _authController.tempUserName.value.isNotEmpty
                      ? 'Hello, ${_authController.tempUserName.value}'
                      : 'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                )),
            SizedBox(height: 8.h),
            Text(
              'Please login to continue',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 32.h),
            Pinput(
              controller: _pinController,
              length: 4,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              obscureText: true,
              obscuringCharacter: '●',
              showCursor: true,
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 20,
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
              onCompleted: (pin) async {
                final success = await _authController.verifyPin(pin.toString());
                if (success) {
                  Get.offAll(() => const BottomBar());
                } else {
                  Get.snackbar(
                    'Error',
                    _authController.error.value ?? 'Invalid PIN',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  _pinController.clear();
                }
              },
            ),
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
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
                    Container(
                      width: 80.w,
                      height: 80.w,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/fingerprint.png',
                        width: 32.w,
                        color: Colors.blue,
                      ),
                    ),
                    _buildNumberButton('0'),
                    InkWell(
                      onTap: () => _onKeyTap('delete'),
                      child: Container(
                        width: 80.w,
                        height: 80.w,
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
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not You? ',
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Text(
                    'Switch Account',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 34.h),
          ],
        ),
      ),
    );
  }
}
