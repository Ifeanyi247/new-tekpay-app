import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/auth/register_page.dart';
import 'package:tekpayapp/pages/widgets/bottom_bar.dart';
import 'package:tekpayapp/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2)); // Show splash for 2 seconds
    
    final authService = Get.find<AuthService>();
    if (authService.isSignedIn.value) {
      Get.offAll(() => const BottomBar());
    } else {
      Get.offAll(() => const RegisterPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Image.asset(
          'assets/images/white_logo.png',
          scale: 1.5,
        ),
      ),
    );
  }
}
