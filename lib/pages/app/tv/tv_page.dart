import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/bills/tv_controller.dart';
import 'package:tekpayapp/pages/app/data/data_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:tekpayapp/pages/widgets/custom_text_field.dart';
import 'package:tekpayapp/pages/app/widgets/transaction_widget.dart';
import 'package:tekpayapp/pages/app/airtime/transaction_status_page.dart';

class TvPackageListPage extends StatefulWidget {
  final String provider;
  const TvPackageListPage({super.key, required this.provider});

  @override
  State<TvPackageListPage> createState() => _TvPackageListPageState();
}

class _TvPackageListPageState extends State<TvPackageListPage> {
  final TextEditingController _searchController = TextEditingController();
  final TvController _tvController = Get.find<TvController>();
  List<Map<String, dynamic>> _filteredPlans = [];

  @override
  void initState() {
    super.initState();
    _fetchPlans();
    _searchController.addListener(_filterPlans);
  }

  Future<void> _fetchPlans() async {
    await _tvController.fetchTvPlans(widget.provider.toLowerCase());
    _filteredPlans = List.from(_tvController.tvPlans);
  }

  void _filterPlans() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPlans = _tvController.tvPlans.where((plan) {
        return plan['name'].toString().toLowerCase().contains(query);
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
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_tvController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_tvController.error.value.isNotEmpty) {
                return Center(child: Text(_tvController.error.value));
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _filteredPlans.length,
                itemBuilder: (context, index) {
                  final plan = _filteredPlans[index];
                  return GestureDetector(
                    onTap: () {
                      _tvController.selectPlan(plan);
                      Get.back(result: plan);
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
                          Text(
                            plan['name'],
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '₦${plan['variation_amount']}',
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
              );
            }),
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

class TvPage extends StatefulWidget {
  const TvPage({super.key});

  @override
  State<TvPage> createState() => _TvPageState();
}

class _TvPageState extends State<TvPage> {
  final TextEditingController _smartCardController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedPackage;
  int _selectedProvider = 0;
  Timer? _debounceTimer;

  final _providers = [
    {
      'name': 'Gotv',
      'logo': 'assets/images/gotv.png',
      'color': const Color(0xFFF3E5F5),
    },
    {
      'name': 'Dstv',
      'logo': 'assets/images/dstv.png',
      'color': Colors.white,
    },
    {
      'name': 'Startimes',
      'logo': 'assets/images/startime.png',
      'color': Colors.white,
    },
  ];

  @override
  void initState() {
    super.initState();
    Get.put(TvController());
  }

  Future<void> _showPackages() async {
    final result = await Get.to<Map<String, dynamic>>(
      () => TvPackageListPage(
        provider: _providers[_selectedProvider]['name']!.toString(),
      ),
    );
    if (result != null) {
      setState(() {
        _selectedPackage = result['name'] as String;
        _amountController.text = result['variation_amount'];
      });
    }
  }

  void _showTransactionConfirmation() {
    Get.bottomSheet(
      TransactionConfirmationSheet(
        amount: _amountController.text,
        recipientId: _smartCardController.text,
        network: _providers[_selectedProvider]['name']!.toString(),
        transactionType: 'TV Subscription',
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
          'Cable Purchase',
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
              height: 100.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _providers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedProvider = index;
                        _selectedPackage = null;
                        _amountController.clear();
                      });
                      Get.find<TvController>().clearSelection();
                    },
                    child: Container(
                      width: 100.w,
                      margin: EdgeInsets.only(right: 12.w),
                      decoration: BoxDecoration(
                        color: _selectedProvider == index
                            ? const Color(0xFFF3E5F5)
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
                            _providers[index]['logo']!.toString(),
                            height: 40.h,
                            width: 40.w,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            _providers[index]['name']!.toString(),
                            style: TextStyle(
                              fontSize: 14.sp,
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
            SizedBox(height: 32.h),
            Text(
              'Select Package',
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
                    Text(
                      _selectedPackage ?? 'Select package',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: _selectedPackage != null
                            ? Colors.black
                            : Colors.grey,
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
              'Enter Smartcard Number',
              style: TextStyle(
                fontSize: 16.sp,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextFieldWidget(
              controller: _smartCardController,
              label: '1234********',
              icon: Icons.credit_card,
              onChanged: (value) {
                if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
                _debounceTimer =
                    Timer(const Duration(milliseconds: 500), () async {
                  if (value.length >= 10) {
                    final controller = Get.find<TvController>();
                    await controller.verifySmartCard(
                      value,
                      _providers[_selectedProvider]['name']!
                          .toString()
                          .toLowerCase(),
                    );
                  }
                });
              },
            ),
            Obx(() {
              final controller = Get.find<TvController>();
              if (controller.isVerifying.value) {
                return Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }
              if (controller.verificationError.value.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    controller.verificationError.value,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12.sp,
                    ),
                  ),
                );
              }
              if (controller.customerInfo.isNotEmpty) {
                final info = controller.customerInfo;
                return Container(
                  margin: EdgeInsets.only(top: 8.h),
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Details',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _buildInfoRow('Name', info['Customer_Name'] ?? ''),
                      _buildInfoRow('Status', info['Status'] ?? ''),
                      _buildInfoRow('Due Date', info['Due_Date'] ?? ''),
                      _buildInfoRow(
                          'Current Plan', info['Current_Bouquet'] ?? ''),
                      if (info['Renewal_Amount'] != null)
                        _buildInfoRow(
                            'Renewal Amount', '₦${info['Renewal_Amount']}'),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
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
              label: '₦',
              icon: Icons.monetization_on_outlined,
            ),
            SizedBox(height: 40.h),
            CustomButtonWidget(
              text: 'Proceed',
              onTap: () {
                if (_selectedPackage != null &&
                    _smartCardController.text.isNotEmpty &&
                    _amountController.text.isNotEmpty) {
                  _showTransactionConfirmation();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _smartCardController.dispose();
    _amountController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }
}
