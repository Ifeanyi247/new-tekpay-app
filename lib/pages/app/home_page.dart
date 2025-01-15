import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/controllers/transactions_controller.dart';
import 'package:tekpayapp/pages/app/add_money.dart';
import 'package:tekpayapp/pages/app/airtime/airtime_page.dart';
import 'package:tekpayapp/pages/app/airtime/transaction_status_page.dart';
import 'package:tekpayapp/pages/app/all_services_page.dart';
import 'package:tekpayapp/pages/app/data/data_page.dart';
import 'package:tekpayapp/pages/app/electricity/electricity_page.dart';
import 'package:tekpayapp/pages/app/internet/internet_page.dart';
import 'package:tekpayapp/pages/app/tv/tv_page.dart';
import 'package:tekpayapp/pages/app/widgets/custom_icon_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key}) {
    Get.put(TransactionsController());
  }

  Widget _buildServiceItem(String title, Widget icon) {
    return Column(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: icon,
        ),
        SizedBox(height: 8.h),
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

  Widget _buildTransactionItem({
    required String title,
    required String date,
    required String amount,
    required bool isSuccess,
    required IconData icon,
    required VoidCallback onTap,
    String? pin,
    List<dynamic>? cards,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.only(
                bottom: isSuccess && (pin != null || cards != null) ? 0 : 16.h),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: primaryColor),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      amount,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color:
                            amount.startsWith('-') ? Colors.red : Colors.green,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: isSuccess
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isSuccess ? 'Successful' : 'Failed',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: isSuccess ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (isSuccess && (pin != null || cards != null))
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pin != null)
                  Text(
                    'PIN: $pin',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (cards != null)
                  ...cards.map((card) => Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Text(
                          'Serial: ${card.serial}, PIN: ${card.pin}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final transactionsController = Get.find<TransactionsController>();

    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await userController.getProfile();
            },
            color: primaryColor,
            backgroundColor: Colors.white,
            displacement: 20,
            strokeWidth: 3,
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 32.h),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Obx(() {
                      if (userController.isLoading.value) {
                        return _buildShimmerHeader();
                      }

                      final user = userController.user.value;
                      return Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24.r,
                                backgroundImage: user != null
                                    ? NetworkImage(user.profile.profileUrl)
                                    : const AssetImage('assets/images/user.png')
                                        as ImageProvider,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user != null
                                          ? 'Hi, ${user.firstName}'
                                          : 'Welcome',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Let\'s make some payments!',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Stack(
                                children: [
                                  const Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 8.w,
                                      height: 8.w,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 12.w),
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/images/support_agent.png',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wallet Balance',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    user != null
                                        ? userController.isBalanceVisible.value
                                            ? '₦${NumberFormat('#,##0.00', 'en_US').format(user.profile.wallet)}'
                                            : '₦•••••'
                                        : '₦0.00',
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: Obx(
                                      () => Icon(
                                        userController.isBalanceVisible.value
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      userController.toggleBalanceVisibility();
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Referral Bonus: ₦1000',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            children: [
                              Expanded(
                                child: CustomIconButtonWidget(
                                  icon: const Icon(Icons.add),
                                  text: 'Add money',
                                  onPressed: () {
                                    Get.to(() => const AddMoneyPage());
                                  },
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: CustomIconButtonWidget(
                                  icon: const Icon(Icons.send),
                                  text: 'Transfer',
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Get.to(() => const AirtimePage()),
                              child: _buildServiceItem(
                                'Airtime',
                                Image.asset(
                                  'assets/images/phone_iphone.png',
                                  scale: 2,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.to(() => const DataPage()),
                              child: _buildServiceItem(
                                'Data',
                                Image.asset(
                                  'assets/images/internet-network-signal-svgrepo-com.png',
                                  scale: 2,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.to(() => const TvPage()),
                              child: _buildServiceItem(
                                'TV',
                                Image.asset(
                                  'assets/images/tv-03-svgrepo-com.png',
                                  scale: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  Get.to(() => const ElectricityPage()),
                              child: _buildServiceItem(
                                'Electricity',
                                Image.asset(
                                  'assets/images/elec-svgrepo-com.png',
                                  scale: 2,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.to(() => const InternetPage()),
                              child: _buildServiceItem(
                                'Internet',
                                Image.asset(
                                  'assets/images/transfer-data-svgrepo-com.png',
                                  scale: 2,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  Get.to(() => const AllServicesPage()),
                              child: _buildServiceItem(
                                'All Services',
                                Image.asset(
                                  'assets/images/widgets.png',
                                  scale: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 32.h),
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/bulb.png',
                                scale: 2,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  'Use Tekpay more to qualify for Buy now and pay later',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Transactions',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'See all',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Obx(() {
                          if (transactionsController.isLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final recentTransactions = transactionsController
                              .transactions
                              .take(3)
                              .toList();

                          if (recentTransactions.isEmpty) {
                            return Center(
                              child: Text(
                                'No recent transactions',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: recentTransactions.map((transaction) {
                              return _buildTransactionItem(
                                title: transaction.title,
                                date: DateFormat('MMM dd, yyyy').format(
                                  DateTime.parse(
                                      transaction.transactionDate.toString()),
                                ),
                                amount: transaction.formattedAmount,
                                isSuccess: ['delivered', 'success']
                                    .contains(transaction.status.toLowerCase()),
                                icon: transaction.icon,
                                onTap: () {
                                  Get.to(() => TransactionStatusPage(
                                        status: ['delivered', 'success']
                                                .contains(transaction.status
                                                    .toLowerCase())
                                            ? TransactionStatus.success
                                            : transaction.status
                                                        .toLowerCase() ==
                                                    'failed'
                                                ? TransactionStatus.failed
                                                : TransactionStatus.pending,
                                        amount: transaction.amount.toString(),
                                        reference: transaction.transactionId,
                                        date: transaction.transactionDate
                                            .toString(),
                                        recipient: transaction.phone,
                                        network: transaction.serviceId,
                                        productName: transaction.title,
                                      ));
                                },
                                pin: transaction.type?.toLowerCase() ==
                                            'education' &&
                                        transaction.title
                                            .toLowerCase()
                                            .contains('jamb') &&
                                        ['delivered', 'success'].contains(
                                            transaction.status.toLowerCase())
                                    ? transaction.pin
                                    : null,
                                cards: transaction.type?.toLowerCase() ==
                                            'education' &&
                                        transaction.title
                                            .toLowerCase()
                                            .contains('waec') &&
                                        ['delivered', 'success'].contains(
                                            transaction.status.toLowerCase())
                                    ? transaction.cards
                                    : null,
                              );
                            }).toList(),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Error Overlay
          Obx(() {
            final error = userController.error.value;
            if (error != null) {
              return Container(
                color: Colors.black26,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 32.w),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          error,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            userController.clearError();
                            userController.getProfile();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          child: Text(
                            'Retry',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildShimmerHeader() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.3),
      highlightColor: Colors.white.withOpacity(0.5),
      enabled: true,
      period: const Duration(milliseconds: 1500),
      direction: ShimmerDirection.ltr,
      child: Column(
        children: [
          Row(
            children: [
              // Profile picture shimmer
              Container(
                width: 48.r,
                height: 48.r,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name shimmer
                    Container(
                      width: 120.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Subtitle shimmer
                    Container(
                      width: 160.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
              // Notification and support icons shimmer
              Container(
                width: 24.w,
                height: 24.w,
                margin: EdgeInsets.only(right: 12.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 24.w,
                height: 24.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet Balance label shimmer
              Container(
                width: 100.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(height: 8.h),
              // Balance amount shimmer
              Row(
                children: [
                  Container(
                    width: 200.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Referral bonus shimmer
              Row(
                children: [
                  Container(
                    width: 150.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          // Action buttons shimmer
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
