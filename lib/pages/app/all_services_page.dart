import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tekpayapp/constants/colors.dart';

class AllServicesPage extends StatelessWidget {
  const AllServicesPage({super.key});

  Widget _buildServiceCard({
    required String title,
    required List<ServiceItem> items,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 1,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  item.icon,
                  SizedBox(height: 8.h),
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final billPayments = [
      ServiceItem(
        title: 'Airtime',
        icon: Image.asset(
          'assets/images/phone_iphone.png',
          scale: 2,
        ),
      ),
      ServiceItem(
        title: 'Data',
        icon: Image.asset(
          'assets/images/internet-network-signal-svgrepo-com.png',
          scale: 2,
        ),
      ),
      ServiceItem(
        title: 'TV',
        icon: Image.asset(
          'assets/images/tv-03-svgrepo-com.png',
          scale: 2,
        ),
      ),
      ServiceItem(
        title: 'Electricity',
        icon: Image.asset(
          'assets/images/elec-svgrepo-com.png',
          scale: 2,
        ),
      ),
      ServiceItem(
        title: 'Internet',
        icon: Image.asset(
          'assets/images/transfer-data-svgrepo-com.png',
          scale: 2,
        ),
      ),
      ServiceItem(
        title: 'Education',
        icon: Icon(
          Icons.school_outlined,
          color: primaryColor,
          size: 30.sp,
        ),
      ),
    ];

    final transfer = [
      ServiceItem(
        title: 'To Bank',
        icon: Icon(
          Icons.account_balance,
          color: primaryColor,
          size: 25.sp,
        ),
      ),
    ];

    final referAndEarn = [
      ServiceItem(
        title: 'Refer & Earn',
        icon: Icon(
          Icons.currency_exchange,
          color: primaryColor,
          size: 25.sp,
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'All Services',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildServiceCard(
              title: 'Bill Payments',
              items: billPayments,
            ),
            _buildServiceCard(
              title: 'Transfer',
              items: transfer,
            ),
            _buildServiceCard(
              title: 'Refer & Earn',
              items: referAndEarn,
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceItem {
  final String title;
  final Widget icon;

  ServiceItem({
    required this.title,
    required this.icon,
  });
}
