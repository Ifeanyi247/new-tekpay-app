import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/pages/auth/otp_verification_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:tekpayapp/pages/widgets/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Register',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Get started',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create an account so you can pay and purchase top-ups faster.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextFieldWidget(
                  icon: Icons.person_outline,
                  label: 'Username',
                ),
                const SizedBox(height: 16),
                CustomTextFieldWidget(
                  icon: Icons.person_outline,
                  label: 'First Name',
                ),
                const SizedBox(height: 16),
                CustomTextFieldWidget(
                  icon: Icons.person_outline,
                  label: 'Last Name',
                ),
                const SizedBox(height: 16),
                CustomTextFieldWidget(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                CustomTextFieldWidget(
                  icon: Icons.phone_outlined,
                  label: 'Phone Number',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                CustomTextFieldWidget(
                  icon: Icons.lock_outline,
                  label: 'Password',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextFieldWidget(
                  icon: Icons.lock_outline,
                  label: 'Confirm Password',
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextFieldWidget(
                  icon: Icons.people_outline,
                  label: 'Referral (Optional)',
                ),
                const SizedBox(height: 32),
                CustomButtonWidget(
                  text: 'Continue',
                  onTap: () {
                    Get.to(
                      () => const OtpVerificationPage(
                          email: 'Oladelep77@gmail.com'),
                    );
                    // if (_formKey.currentState!.validate()) {
                    //   // Handle registration
                    // }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
