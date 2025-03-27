import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/auth/login_page.dart';
import 'package:tekpayapp/pages/auth/register_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  void openLink(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/black_logo.png',
                scale: 2,
              ),
              SizedBox(
                height: 7.h,
              ),
              Text(
                'Welcome to Tekpay',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.sp,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Join the Tekpay community today and simplify your bills,\nsubscriptions, and betting payments. To get started,\nplease sign into your account or create a new one.',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomButtonWidget(
                text: 'Register',
                bgColor: primaryColor,
                onTap: () {
                  Get.to(() => const RegisterPage());
                },
              ),
              SizedBox(
                height: 10.h,
              ),
              CustomButtonWidget(
                text: 'Login',
                bgColor: Colors.white,
                textColor: primaryColor,
                onTap: () {
                  Get.to(() => const LoginPage());
                },
              ),
              SizedBox(
                height: 30.h,
              ),
              RichText(
                textAlign: TextAlign.center,
                text:  TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'By tapping ',
                    ),
                    TextSpan(
                      text: '"Register" ',
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: 'or ',
                    ),
                    TextSpan(
                      text: '"Log In" ',
                      style: TextStyle(
                        color: primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: ', you agree to our ',
                    ),
                    TextSpan(
                      text: 'Terms',
                      style: TextStyle(),
                    ),
                    TextSpan(
                      text:
                          '. Learn more about how we process your data in our ',
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: primaryColor,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () => openLink("https://tekpay.co/privacy"),
                    ),
                    TextSpan(
                      text: ' and ',
                    ),
                    TextSpan(
                      text: 'cookies Policy',
                      style: TextStyle(
                        color: primaryColor,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () => openLink("https://tekpay.co/privacy"),
                    ),
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
