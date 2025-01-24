import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/auth/register_page.dart';
import 'package:tekpayapp/pages/onbaording/onboarding_page.dart';
import 'package:tekpayapp/pages/welcome_screen.dart';
import 'package:tekpayapp/pages/widgets/bottom_bar.dart';
import 'package:tekpayapp/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage = GetStorage();
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Show splash for 2 seconds

    final authService = Get.find<AuthService>();
    final hasSeenOnboarding = _storage.read(_hasSeenOnboardingKey) ?? false;

    if (authService.isSignedIn.value) {
      Get.offAll(() => const BottomBar());
    } else if (!hasSeenOnboarding) {
      Get.offAll(() => const OnboardingPage());
    } else {
      Get.offAll(() => const WelcomeScreen());
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
