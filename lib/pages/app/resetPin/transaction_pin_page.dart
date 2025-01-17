import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/widgets/bottom_bar.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';

class TransactionPinPage extends StatefulWidget {
  final String pinToken;

  const TransactionPinPage({Key? key, required this.pinToken})
      : super(key: key);

  @override
  State<TransactionPinPage> createState() => _TransactionPinPageState();
}

class _TransactionPinPageState extends State<TransactionPinPage> {
  final UserController _userController = Get.find<UserController>();
  final newPinController = TextEditingController();
  final confirmPinController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _isLoading = false.obs;
  bool _obscureNewPin = true;
  bool _obscureConfirmPin = true;

  @override
  void dispose() {
    newPinController.dispose();
    confirmPinController.dispose();
    super.dispose();
  }

  void _toggleNewPinVisibility() {
    setState(() {
      _obscureNewPin = !_obscureNewPin;
    });
  }

  void _toggleConfirmPinVisibility() {
    setState(() {
      _obscureConfirmPin = !_obscureConfirmPin;
    });
  }

  bool _validatePin(String pin) {
    // Check if PIN contains consecutive numbers
    for (int i = 0; i < pin.length - 1; i++) {
      if (int.parse(pin[i + 1]) - int.parse(pin[i]) == 1) {
        return false;
      }
    }

    // Check if PIN contains repeated numbers
    final pinSet = pin.split('').toSet();
    if (pinSet.length != pin.length) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = primaryColor;
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Colors.grey;

    final defaultPinTheme = PinTheme(
      width: 64.w,
      height: 64.h,
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
        title: const Text('Change Transaction Pin'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The transaction pin must contain number which cannot be repeated or consecutive',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Text(
                    'New transaction pin',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      _obscureNewPin ? Icons.visibility_off : Icons.visibility,
                      size: 20.sp,
                      color: Colors.grey,
                    ),
                    onPressed: _toggleNewPinVisibility,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Center(
                child: Pinput(
                  length: 4,
                  controller: newPinController,
                  defaultPinTheme: defaultPinTheme,
                  obscureText: _obscureNewPin,
                  obscuringCharacter: '*',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter PIN';
                    }
                    if (value.length != 4) {
                      return 'PIN must be 4 digits';
                    }
                    if (!_validatePin(value)) {
                      return 'PIN cannot contain consecutive or repeated numbers';
                    }
                    return null;
                  },
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Text(
                    'Confirm new transaction pin',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      _obscureConfirmPin
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20.sp,
                      color: Colors.grey,
                    ),
                    onPressed: _toggleConfirmPinVisibility,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Center(
                child: Pinput(
                  length: 4,
                  controller: confirmPinController,
                  defaultPinTheme: defaultPinTheme,
                  obscureText: _obscureConfirmPin,
                  obscuringCharacter: '*',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm PIN';
                    }
                    if (value != newPinController.text) {
                      return 'PINs do not match';
                    }
                    return null;
                  },
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Obx(
                () => _isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColor),
                        ),
                      )
                    : CustomButtonWidget(
                        text: 'Continue',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            _isLoading.value = true;
                            final success =
                                await _userController.changeTransactionPin(
                              pin: newPinController.text,
                              pinToken: widget.pinToken,
                            );
                            _isLoading.value = false;
                            if (success) {
                              Get.offAll(() => const BottomBar());
                            }
                          }
                        },
                      ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
