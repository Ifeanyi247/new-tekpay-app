import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:intl/intl.dart';

class ReferralBonusController extends GetxController {
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

  void showWithdrawConfirmation() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You are about to transfer NGN 1,000 to\nyour wallet balance',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: CustomButtonWidget(
                    text: 'Cancel',
                    onTap: () => Get.back(),
                    bgColor: Colors.white,
                    textColor: primaryColor,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: CustomButtonWidget(
                    text: 'Continue',
                    onTap: () {
                      // TODO: Implement withdrawal
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
    );
  }

  Widget buildStatItem(
      {required String title, required String value, required IconData icon}) {
    return Column(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 24.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: primaryColor,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget buildReferralItem(Map<String, dynamic> user) {
    final dateTime = DateTime.parse(user['joined_at']);
    final formattedDate = DateFormat('yyyy-MM-dd, HH:mm:ss').format(dateTime);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
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
                  user['name'] ?? 'N/A',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Phone: ${user['phone'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'NGN 10.00',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ReferralBonusPage extends StatelessWidget {
  ReferralBonusPage({super.key});

  final controller = Get.put(ReferralBonusController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Referral Record',
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
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() => controller.buildStatItem(
                      title: 'Total Earned',
                      value:
                          'NGN ${controller.referralData['total_earnings'] ?? '0.00'}',
                      icon: Icons.account_balance_wallet,
                    )),
                Obx(() => controller.buildStatItem(
                      title: 'Total Invited',
                      value:
                          '${controller.referralData['total_referrals'] ?? '0'}',
                      icon: Icons.group_add,
                    )),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            color: Colors.grey.shade100,
            child: Text(
              'Referral History',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: (controller.referralData['referred_users']
                              as List<dynamic>?)
                          ?.length ??
                      0,
                  itemBuilder: (context, index) {
                    final users = controller.referralData['referred_users']
                        as List<dynamic>;
                    return controller.buildReferralItem(users[index]);
                  },
                )),
          ),
          // Padding(
          //   padding: EdgeInsets.all(16.w),
          //   child: CustomButtonWidget(
          //     text: 'Withdraw Bonus',
          //     onTap: controller.showWithdrawConfirmation,
          //   ),
          // ),
        ],
      ),
    );
  }
}
