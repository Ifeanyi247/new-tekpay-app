import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/auth_controller.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/app/noAuthPage/email_page_no_auth.dart';
import 'package:tekpayapp/pages/app/support_page.dart';
import 'package:tekpayapp/services/storage_service.dart';
import 'package:local_auth/local_auth.dart';

class LockedPage extends StatefulWidget {
  const LockedPage({super.key});

  @override
  State<LockedPage> createState() => _LockedPageState();
}

class _LockedPageState extends State<LockedPage> {
  final _pinController = TextEditingController();
  final _authController = Get.find<AuthController>();
  late final UserController userController;
  final _showBiometric = false.obs;
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> _authenticateWithBiometrics() async {
    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (didAuthenticate) {
        await _authController.verifyPinFromLockScreen(
            userController.user.value!.profile.pinCode,
            userController.user.value!.profile.pinCode);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to authenticate: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    userController = Get.find<UserController>();
    _showBiometric.value = StorageService.getBiometricLogin();

    // Trigger biometric authentication if enabled
    if (_showBiometric.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _authenticateWithBiometrics();
      });
    }
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
          GestureDetector(
            onTap: () {
              Get.to(() => const SupportPage());
            },
            child: Image.asset(
              'assets/images/support_agent.png',
              color: Colors.black,
              scale: 0.7,
            ),
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
                      userController.user.value!.profile.profileUrl.isNotEmpty
                          ? NetworkImage(
                              userController.user.value!.profile.profileUrl)
                          : const AssetImage('assets/images/avatar.png')
                              as ImageProvider,
                )),
            SizedBox(height: 16.h),
            Obx(() => Text(
                  userController.user.value!.username.isNotEmpty
                      ? 'Hello, ${userController.user.value!.username}'
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
            SizedBox(height: 28.h),
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
                await _authController.verifyPinFromLockScreen(
                    int.parse(pin), userController.user.value!.profile.pinCode);
                // if (success) {
                //   Get.offAll(() => const BottomBar());
                // } else {
                //   Get.snackbar(
                //     'Error',
                //     _authController.error.value ?? 'Invalid PIN',
                //     backgroundColor: Colors.red,
                //     colorText: Colors.white,
                //   );
                //   _pinController.clear();
                // }
              },
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () {
                Get.to(() => const EmailPageNoAuth());
              },
              child: Text(
                'Forgot PIN?',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: primaryColor,
                ),
              ),
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
                    Obx(() => _showBiometric.value
                        ? InkWell(
                            onTap: _authenticateWithBiometrics,
                            child: Container(
                              width: 80.w,
                              height: 80.w,
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/fingerprint.png',
                                width: 32.w,
                                color: Colors.blue,
                              ),
                            ),
                          )
                        : SizedBox(width: 80.w)),
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
            SizedBox(height: 10.h),
            Obx(() {
              return GestureDetector(
                onTap: () {
                  _authController.logout();
                },
                child: _authController.isLoading.value
                    ? const CircularProgressIndicator()
                    : Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              );
            }),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }
}
