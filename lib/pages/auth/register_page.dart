import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/controllers/auth_controller.dart';
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
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _referralCodeController = TextEditingController();

  final _authController = Get.put(AuthController());

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _referralCodeController.dispose();
  }

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
                  controller: _usernameController,
                ),
                const SizedBox(height: 16),
                CustomTextFieldWidget(
                  icon: Icons.person_outline,
                  label: 'First Name',
                  controller: _firstNameController,
                ),
                const SizedBox(height: 16),
                CustomTextFieldWidget(
                  icon: Icons.person_outline,
                  label: 'Last Name',
                  controller: _lastNameController,
                ),
                const SizedBox(height: 16),
                CustomTextFieldWidget(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                ),
                const SizedBox(height: 16),
                CustomTextFieldWidget(
                  icon: Icons.phone_outlined,
                  label: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  controller: _phoneNumberController,
                ),
                const SizedBox(height: 16),
                CustomTextFieldWidget(
                  icon: Icons.lock_outline,
                  label: 'Password',
                  obscureText: _obscurePassword,
                  controller: _passwordController,
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
                  controller: _confirmPasswordController,
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
                  controller: _referralCodeController,
                ),
                const SizedBox(height: 32),
                Obx(() {
                  return _authController.isLoading.value
                      ? Center(child: const CircularProgressIndicator())
                      : CustomButtonWidget(
                          text: 'Continue',
                          onTap: () async {
                            await _authController.register(
                              username: _usernameController.text.trim(),
                              firstName: _firstNameController.text.trim(),
                              lastName: _lastNameController.text.trim(),
                              email: _emailController.text.trim(),
                              phoneNumber: _phoneNumberController.text.trim(),
                              password: _passwordController.text.trim(),
                              confirmPassword:
                                  _confirmPasswordController.text.trim(),
                            );
                          },
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
