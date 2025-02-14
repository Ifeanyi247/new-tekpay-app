import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/onbaording/widgets/onboarding_widget.dart';
import 'package:tekpayapp/pages/onbaording/widgets/rounded_button_widget.dart';
import 'package:tekpayapp/pages/welcome_screen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  final _storage = GetStorage();
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  void _finishOnboarding() async {
    await _storage.write(_hasSeenOnboardingKey, true);
    Get.off(() => const WelcomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Column(
              children: [
                SizedBox(
                  height: 550.h,
                  child: PageView(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    children: const [
                      OnBoardWidget(
                        image: 'assets/images/board_one.png',
                        bigText: 'Never miss a payment again with\nTekpay',
                        smallText:
                            'Pay your electricity, internet,and other utility bills\nquickly and early from the palm of your hand. ',
                      ),
                      OnBoardWidget(
                        image: 'assets/images/board_two.png',
                        bigText:
                            'Share the love with your friends &\nearn rewards!',
                        smallText:
                            'Refer a friend to Tekpay and you’ll recieve a\nbonus when they make their first deposit.',
                      ),
                      OnBoardWidget(
                        image: 'assets/images/board_three.png',
                        bigText:
                            'Trust and security are at the heart\nof Tekpay',
                        smallText:
                            'Our advanced security features ensure that every\ntransaction you make is safe and secure.',
                      ),
                    ],
                  ),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: primaryColor,
                    dotHeight: 10.h,
                    dotWidth: 10.w,
                  ),
                ),
                SizedBox(height: 30.h),
                RoundedButtonWidget(
                  onPressed: () {
                    if (_controller.page == 2) {
                      _finishOnboarding();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.fastLinearToSlowEaseIn,
                      );
                    }
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
