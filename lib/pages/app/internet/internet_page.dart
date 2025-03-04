import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/app/data/data_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:tekpayapp/pages/widgets/custom_text_field.dart';
import 'package:tekpayapp/pages/app/widgets/transaction_widget.dart';
import 'package:tekpayapp/pages/app/airtime/transaction_status_page.dart';

class InternetPlan {
  final String name;
  final double price;

  InternetPlan({
    required this.name,
    required this.price,
  });
}

class InternetPackageListPage extends StatefulWidget {
  const InternetPackageListPage({super.key});

  @override
  State<InternetPackageListPage> createState() =>
      _InternetPackageListPageState();
}

class _InternetPackageListPageState extends State<InternetPackageListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<InternetPlan> _filteredPlans = [];

  final List<InternetPlan> _plans = [
    InternetPlan(name: '1.5GB Bigga for 30Days', price: 12500.00),
    InternetPlan(name: '2GB FlexiWeekly for 7Days', price: 19800.00),
    InternetPlan(
        name: 'International Smile Voice ONLY 125 (30Days)', price: 2850.00),
    InternetPlan(name: '40GB Bigga for 30Days', price: 29500.00),
    InternetPlan(name: '500GB for 365Days', price: 4200.00),
    InternetPlan(name: 'SmileVoice ONLY 135 (New) (30Days)', price: 45600.00),
    InternetPlan(name: 'UnlimitedLite 30Days', price: 7400.00),
    InternetPlan(name: '1TB for 365Days', price: 9900.00),
    InternetPlan(name: '60GB Biggga for 30Days', price: 9900.00),
    InternetPlan(name: '6GBFlexiWeekly for 7Days', price: 9900.00),
    InternetPlan(name: '3GB Bigga for 30Days', price: 9900.00),
  ];

  @override
  void initState() {
    super.initState();
    _filteredPlans = List.from(_plans);
    _searchController.addListener(_filterPlans);
  }

  void _filterPlans() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPlans = _plans.where((plan) {
        return plan.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _filteredPlans.length,
              itemBuilder: (context, index) {
                final plan = _filteredPlans[index];
                return GestureDetector(
                  onTap: () {
                    Get.back(result: {
                      'name': plan.name,
                      'price': plan.price,
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            plan.name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '₦${plan.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class InternetPage extends StatefulWidget {
  const InternetPage({super.key});

  @override
  State<InternetPage> createState() => _InternetPageState();
}

class _InternetPageState extends State<InternetPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedPlan;

  Future<void> _showPackages() async {
    final result = await Get.to<Map<String, dynamic>>(
      () => const InternetPackageListPage(),
    );
    if (result != null) {
      setState(() {
        _selectedPlan = result['name'] as String;
        _amountController.text = result['price'].toString();
      });
    }
  }

  void _showTransactionConfirmation() {
    Get.bottomSheet(
      TransactionConfirmationSheet(
        amount: _amountController.text,
        recipientId: _phoneController.text,
        network: 'Smile',
        transactionType: 'Internet Purchase',
        onProceed: () {
          Get.back();
          _showPinEntry();
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showPinEntry() {
    Get.bottomSheet(
      PinEntrySheet(
        onPinComplete: (pin) {
          // Get.to(() => const TransactionStatusPage());
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

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
          'Internet Purchase',
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
            Container(
              width: 80.w,
              height: 80.h,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5F5),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Image.asset(
                'assets/images/smile.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Smile',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24.h),
            // Text(
            //   'Select Beneficiary',
            //   style: TextStyle(
            //     fontSize: 16.sp,
            //     color: primaryColor,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
            // SizedBox(height: 8.h),
            // Row(
            //   children: [
            //     Expanded(
            //       child: Container(
            //         padding:
            //             EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            //         decoration: BoxDecoration(
            //           border: Border.all(color: Colors.grey.shade300),
            //           borderRadius: BorderRadius.circular(8.r),
            //         ),
            //         child: Text(
            //           'Select Beneficiary',
            //           style: TextStyle(
            //             fontSize: 14.sp,
            //             color: Colors.grey,
            //           ),
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 8.w),
            //     Container(
            //       decoration: BoxDecoration(
            //         color: primaryColor.withOpacity(0.1),
            //         borderRadius: BorderRadius.circular(8.r),
            //       ),
            //       child: IconButton(
            //         icon: Icon(
            //           Icons.person_add_outlined,
            //           color: primaryColor,
            //         ),
            //         onPressed: () {},
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 24.h),
            Text(
              'Select Product',
              style: TextStyle(
                fontSize: 16.sp,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: _showPackages,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _selectedPlan ?? 'Select product',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: _selectedPlan != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Mobile Number',
              style: TextStyle(
                fontSize: 16.sp,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextFieldWidget(
              controller: _phoneController,
              label: '08012345678',
              icon: Icons.phone_android,
            ),
            SizedBox(height: 24.h),
            Text(
              'Amount',
              style: TextStyle(
                fontSize: 16.sp,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextFieldWidget(
              controller: _amountController,
              readOnly: true,
              label: '₦',
              // icon: Icons.card,
            ),
            SizedBox(height: 40.h),
            CustomButtonWidget(
              text: 'Proceed',
              onTap: _showTransactionConfirmation,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
