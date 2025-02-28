import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/app/referral_bonus_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';

class ReferralController extends GetxController {
  final UserController _userController = Get.find<UserController>();
  final referralData = {}.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadReferralData();
  }

  Future<void> _loadReferralData() async {
    try {
      isLoading.value = true;
      final response = await _userController.getReferrals();
      if (response['status'] == true) {
        referralData.value = response['data'];
      }
    } finally {
      isLoading.value = false;
    }
  }

  String get shareMessage =>
      '''🌟 Join me on Tekpay and make seamless transactions! 🌟

Send and receive money instantly, pay bills, buy airtime, and more with Tekpay. 

📱 Use my referral code: ${referralData['referral_code'] ?? ''}

Join now and let's enjoy the future of digital payments together! 💫''';
}

class ReferralPage extends StatelessWidget {
  ReferralPage({super.key});

  final ReferralController controller = Get.put(ReferralController());

  void _showShareDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Share',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSocialButton(
                    'Facebook',
                    'assets/images/facebook.png',
                    () => _shareToSocial('Facebook'),
                  ),
                  _buildSocialButton(
                    'Instagram',
                    'assets/images/instagram.png',
                    () => _shareToSocial('Instagram'),
                  ),
                  _buildSocialButton(
                    'WhatsApp',
                    'assets/images/whatsapp.png',
                    () => _shareToSocial('WhatsApp'),
                  ),
                  _buildSocialButton(
                    'X',
                    'assets/images/x.png',
                    () => _shareToSocial('X'),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                'Or copy code',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(() => Text(
                            controller.referralData['referral_code'] ??
                                'Loading...',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: primaryColor,
                            ),
                          )),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.copy,
                        color: primaryColor,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                          text: controller.referralData['referral_code'] ?? '',
                        ));
                        Get.snackbar(
                          'Success',
                          'Code copied to clipboard',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Future<void> _shareToSocial(String platform) async {
    final text = controller.shareMessage;

    try {
      await Share.share(
        text,
        subject: 'Join me on Tekpay!',
      );
      Get.back(); // Close the share dialog
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to share to $platform',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildSocialButton(String label, String iconPath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              iconPath,
              width: 24.w,
              height: 24.w,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Referral & Bonus',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                'assets/images/banner.png',
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Invite your friends to join TekPay',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Obx(() => Text(
                  'Your referral code: ${controller.referralData['referral_code'] ?? 'Loading...'}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            SizedBox(height: 32.h),
            CustomButtonWidget(
              text: 'Share Link And Earn',
              onTap: _showShareDialog,
            ),
            SizedBox(height: 16.h),
            Text(
              'Share your referral code with your friends and\nget rewarded when they join!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 32.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '₦',
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bonus Balance',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                            Obx(() => Text(
                                  '₦${controller.referralData['total_earnings'] ?? '0.00'}',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  InkWell(
                    onTap: () {
                      Get.to(() => ReferralBonusPage());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'View Bonus History',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: primaryColor,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
