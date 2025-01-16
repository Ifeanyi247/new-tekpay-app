import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/app/referral_bonus_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';

class ReferralPage extends StatelessWidget {
  const ReferralPage({super.key});

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
                    () {
                      // TODO: Share to Facebook
                      Get.back();
                    },
                  ),
                  _buildSocialButton(
                    'Instagram',
                    'assets/images/instagram.png',
                    () {
                      // TODO: Share to Instagram
                      Get.back();
                    },
                  ),
                  _buildSocialButton(
                    'WhatsApp',
                    'assets/images/whatsapp.png',
                    () {
                      // TODO: Share to WhatsApp
                      Get.back();
                    },
                  ),
                  _buildSocialButton(
                    'X',
                    'assets/images/x.png',
                    () {
                      // TODO: Share to X
                      Get.back();
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                'Or copy link',
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
                      child: Text(
                        'www.tekpay.app/share-to-social-to..',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.copy,
                        color: primaryColor,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(
                          text: 'www.tekpay.app/share-to-social-to',
                        ));
                        Get.snackbar(
                          'Success',
                          'Link copied to clipboard',
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
              'Invite your friends who have not used Tekpay to\njoin, and earn rewards!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 32.h),
            CustomButtonWidget(
              text: 'Share Link And Earn',
              onTap: _showShareDialog,
            ),
            SizedBox(height: 16.h),
            Text(
              'Share you invitation link with your friends to earn',
              style: TextStyle(
                fontSize: 14.sp,
                color: primaryColor,
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
                      Icon(
                        Icons.account_balance_wallet,
                        color: primaryColor,
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Total Earned: ₦ 0',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  InkWell(
                    onTap: () {
                      Get.to(() => const ReferralBonusPage());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Referral Records',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 24.sp,
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
