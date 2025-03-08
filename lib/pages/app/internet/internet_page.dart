import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/app/data/data_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:tekpayapp/pages/widgets/custom_text_field.dart';
import 'package:tekpayapp/pages/app/widgets/transaction_widget.dart';
import 'package:tekpayapp/pages/app/airtime/transaction_status_page.dart';
import 'package:tekpayapp/controllers/bills/internet_controller.dart';

class InternetPackageListPage extends StatefulWidget {
  final List<Map<String, dynamic>> plans;

  const InternetPackageListPage({super.key, required this.plans});

  @override
  State<InternetPackageListPage> createState() =>
      _InternetPackageListPageState();
}

class _InternetPackageListPageState extends State<InternetPackageListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredPlans = [];

  @override
  void initState() {
    super.initState();
    _filteredPlans = List.from(widget.plans);
    _searchController.addListener(_filterPlans);
  }

  void _filterPlans() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPlans = widget.plans.where((plan) {
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
                    Navigator.of(context).pop(plan);
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
                            plan['name'],
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _internetController = Get.put(InternetController());
  String? _selectedPlan;
  bool _isVerified = false;
  bool _isVerifying = false;
  Map<String, dynamic>? _selectedAccount;

  Future<void> _verifyEmail() async {
    if (_emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter an email address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!_emailController.text.contains('@')) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    try {
      final verified =
          await _internetController.verifyEmail(_emailController.text);
      setState(() {
        _isVerified = verified;
        _selectedAccount = null; // Reset selected account on new verification
      });
    } finally {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  Future<void> _showPackages() async {
    if (!_isVerified) {
      Get.snackbar(
        'Error',
        'Please verify your email first',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedAccount == null) {
      Get.snackbar(
        'Error',
        'Please select an account first',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    await _internetController.fetchInternetPlans();

    if (_internetController.variations.isNotEmpty) {
      final result = await Get.to<Map<String, dynamic>>(
        () => InternetPackageListPage(
          plans: _internetController.variations,
        ),
      );

      if (result != null) {
        setState(() {
          _selectedPlan = result['name'] as String;
          _amountController.text = result['variation_amount'].toString();
        });
      }
    }
  }

  void _showTransactionConfirmation() {
    if (!_isVerified) {
      Get.snackbar(
        'Error',
        'Please verify your email first',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedAccount == null) {
      Get.snackbar(
        'Error',
        'Please select an account first',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedPlan == null) {
      Get.snackbar(
        'Error',
        'Please select a plan first',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a phone number',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_phoneController.text.length < 11) {
      Get.snackbar(
        'Error',
        'Please enter a valid phone number',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.bottomSheet(
      TransactionConfirmationSheet(
        amount: _amountController.text,
        recipientId: _selectedAccount!['AccountId'],
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
        onPinComplete: (pin) async {
          Get.back(); // Close pin entry sheet

          try {
            final result = await _internetController.purchaseInternet(
              phone: _phoneController.text,
              variationCode: _internetController.variations.firstWhere(
                  (v) => v['name'] == _selectedPlan)['variation_code'],
              amount: _amountController.text,
              billersCode: _selectedAccount!['AccountId'],
              pin: pin,
            );

            if (result != null) {
              Get.off(() => TransactionStatusPage(
                    status: TransactionStatus.success,
                    amount: _amountController.text,
                    reference: result['reference'],
                    date: result['date'],
                    recipient: _selectedAccount!['FriendlyName'],
                    network: 'Smile',
                    productName: _selectedPlan!,
                  ));
            }
          } catch (e) {
            print('Error in PIN entry: $e');
            Get.snackbar(
              'Error',
              'Failed to process transaction. Please try again.',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildAccountSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Account',
          style: TextStyle(
            fontSize: 16.sp,
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Obx(() {
            final accounts = _internetController.accountList;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                final isSelected = _selectedAccount == account;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedAccount = account;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor.withOpacity(0.1) : null,
                      border: index != accounts.length - 1
                          ? Border(bottom: BorderSide(color: Colors.grey[300]!))
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: isSelected ? primaryColor : Colors.grey,
                          size: 20.w,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                account['FriendlyName'],
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                account['AccountId'],
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Get.back(),
            ),
            title: Text(
              'Internet',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
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
                Text(
                  'Smile Email Address',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFieldWidget(
                        controller: _emailController,
                        label: 'smile@gmail.com',
                        icon: Icons.email,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    if (!_isVerified)
                      ElevatedButton(
                        onPressed: _isVerifying ? null : _verifyEmail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          minimumSize: Size(80.w, 48.h),
                        ),
                        child: _isVerifying
                            ? SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'Verify',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                  ],
                ),
                if (_isVerified) ...[
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: Colors.green, size: 16.w),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Obx(() => Text(
                                'Verified: ${_internetController.customerName.value}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.green,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextFieldWidget(
                    controller: _phoneController,
                    label: 'Enter phone number',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 24.h),
                  _buildAccountSelector(),
                  SizedBox(height: 24.h),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
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
              ],
            ),
          ),
        ),
        Obx(() {
          if (_internetController.isLoading.value) {
            return Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
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
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
