import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';

class BiometricSettingPage extends StatefulWidget {
  const BiometricSettingPage({super.key});

  @override
  State<BiometricSettingPage> createState() => _BiometricSettingPageState();
}

class _BiometricSettingPageState extends State<BiometricSettingPage> {
  bool _loginEnabled = false;
  bool _paymentEnabled = false;

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

  Future<void> _checkBiometricSupport() async {
    // TODO: Implement biometric support check
    // If biometrics is not supported, show a message and go back
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
                // TODO: Implement biometric authentication before enabling
                setState(() {
                  _loginEnabled = value;
                });
              },
            ),
            _buildBiometricOption(
              title: 'Biometrics To Pay',
              subtitle: 'Activate biometrics for transactions',
              value: _paymentEnabled,
              onChanged: (value) async {
                // TODO: Implement biometric authentication before enabling
                setState(() {
                  _paymentEnabled = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
