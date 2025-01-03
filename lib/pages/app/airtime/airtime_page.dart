import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';

class AirtimePage extends StatefulWidget {
  const AirtimePage({super.key});

  @override
  State<AirtimePage> createState() => _AirtimePageState();
}

class _AirtimePageState extends State<AirtimePage> {
  int _selectedNetwork = 0;
  final _networks = [
    {
      'name': 'MTN',
      'logo': 'assets/images/mtn.png',
      'color': const Color(0xFFFFF4E6),
    },
    {
      'name': 'GLO',
      'logo': 'assets/images/glo.png',
      'color': Colors.white,
    },
    {
      'name': 'Airtel',
      'logo': 'assets/images/airtel.png',
      'color': Colors.white,
    },
    {
      'name': '9Mobile',
      'logo': 'assets/images/9mobile.png',
      'color': Colors.white,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Airtime Purchase',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _networks.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedNetwork = index;
                      });
                    },
                    child: Container(
                      width: 80.w,
                      margin: EdgeInsets.only(right: 12.w),
                      decoration: BoxDecoration(
                        color: _selectedNetwork == index
                            ? const Color(0xFFFFF4E6)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            _networks[index]['logo']!.toString(),
                            height: 32.h,
                            width: 32.w,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            _networks[index]['name']!.toString(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Beneficiary',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.person_add_outlined,
                    color: primaryColor,
                    size: 24.sp,
                  ),
                  onPressed: () {
                    // Add beneficiary logic
                  },
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '080********',
                  labelText: 'Mobile Number',
                  labelStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 14.sp,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '₦',
                  labelText: 'Amount',
                  labelStyle: TextStyle(
                    color: Colors.black54,
                    fontSize: 14.sp,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 40.h),
            CustomButtonWidget(
              text: 'Proceed',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
