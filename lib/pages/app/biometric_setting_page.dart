import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/services/storage_service.dart';

class BiometricSettingPage extends StatefulWidget {
  const BiometricSettingPage({super.key});

  @override
  State<BiometricSettingPage> createState() => _BiometricSettingPageState();
}

class _BiometricSettingPageState extends State<BiometricSettingPage> {
  bool _loginEnabled = false;
  bool _paymentEnabled = false;
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> _authenticate() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        Get.snackbar(
          'Error',
          'Biometric authentication is not available on this device',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to enable biometric settings',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      return didAuthenticate;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to authenticate: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<void> _checkBiometricSupport() async {
    try {
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      if (!canAuthenticate) {
        Get.snackbar(
          'Error',
          'Biometric authentication is not available on this device',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Get.back();
        return;
      }

      setState(() {
        _loginEnabled = StorageService.getBiometricLogin();
        _paymentEnabled = StorageService.getBiometricPayment();
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to check biometric support: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.back();
    }
  }

  Widget _buildBiometricOption({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.fingerprint,
              color: primaryColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Biometrics Settings',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildBiometricOption(
              title: 'Biometrics Login',
              subtitle: 'Activate biometrics Login',
              value: _loginEnabled,
              onChanged: (value) async {
                if (value) {
                  final authenticated = await _authenticate();
                  if (authenticated) {
                    setState(() {
                      _loginEnabled = true;
                    });
                    await StorageService.setBiometricLogin(true);
                    Get.snackbar(
                      'Success',
                      'Biometric login enabled',
                      backgroundColor: primaryColor,
                      colorText: Colors.white,
                    );
                  }
                } else {
                  setState(() {
                    _loginEnabled = false;
                  });
                  await StorageService.setBiometricLogin(false);
                }
              },
            ),
            // _buildBiometricOption(
            //   title: 'Biometrics To Pay',
            //   subtitle: 'Activate biometrics for transactions',
            //   value: _paymentEnabled,
            //   onChanged: (value) async {
            //     if (value) {
            //       final authenticated = await _authenticate();
            //       if (authenticated) {
            //         setState(() {
            //           _paymentEnabled = true;
            //         });
            //         await StorageService.setBiometricPayment(true);
            //         Get.snackbar(
            //           'Success',
            //           'Biometric payment enabled',
            //           backgroundColor: primaryColor,
            //           colorText: Colors.white,
            //         );
            //       }
            //     } else {
            //       setState(() {
            //         _paymentEnabled = false;
            //       });
            //       await StorageService.setBiometricPayment(false);
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
