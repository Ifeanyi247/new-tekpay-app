import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/app/add_money.dart';
import 'package:tekpayapp/pages/app/airtime/airtime_page.dart';
import 'package:tekpayapp/pages/app/all_services_page.dart';
import 'package:tekpayapp/pages/app/data/data_page.dart';
import 'package:tekpayapp/pages/app/electricity/electricity_page.dart';
import 'package:tekpayapp/pages/app/internet/internet_page.dart';
import 'package:tekpayapp/pages/app/tv/tv_page.dart';
import 'package:tekpayapp/pages/app/widgets/custom_icon_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
                  color: amount.startsWith('-') ? Colors.red : Colors.green,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24.r,
                        backgroundImage: AssetImage(
                          'assets/images/user.png',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, Joyce',
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
                            '₦500,000',
                            style: TextStyle(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined,
                                color: Colors.white),
                            onPressed: () {},
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
              ),
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
                        onTap: () => Get.to(() => const ElectricityPage()),
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
                        onTap: () => Get.to(() => const AllServicesPage()),
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
                  _buildTransactionItem(
                    title: 'Airtime Purchased (MTN)',
                    date: '2024-03-23 05:13:53',
                    amount: '-₦5000',
                    isSuccess: true,
                    icon: Icons.phone_android,
                  ),
                  _buildTransactionItem(
                    title: 'Transfer to JOSEPHINE AYO',
                    date: '2024-03-23 05:13:53',
                    amount: '-₦2000',
                    isSuccess: true,
                    icon: Icons.swap_vert,
                  ),
                  _buildTransactionItem(
                    title: 'Transfer to AYOBAMI JOYCE',
                    date: '2024-03-23 05:13:53',
                    amount: '₦2000',
                    isSuccess: false,
                    icon: Icons.swap_vert,
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
