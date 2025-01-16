import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/bills/airtime_controller.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/app/airtime/transaction_status_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:tekpayapp/pages/widgets/custom_text_field.dart';
import 'package:tekpayapp/pages/app/airtime/airtime_controller.dart';
import 'package:intl/intl.dart';

class AirtimePage extends StatefulWidget {
  const AirtimePage({super.key});

  @override
  State<AirtimePage> createState() => _AirtimePageState();
}

class _AirtimePageState extends State<AirtimePage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final AirtimeController _controller = Get.put(AirtimeController());
  final AirtimeWorkingController _a_controller =
      Get.put(AirtimeWorkingController());
  final _userController = Get.find<UserController>();
  final _pinNotifier = ValueNotifier<String>('');
  int _selectedNetwork = 0;
  bool _saveBeneficiary = false;
  bool _showSaveOption = false;

  void _showTransactionConfirmation() {
    // Validate phone number
    if (_phoneNumberController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a phone number',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validate phone number format (must be 11 digits)
    // if (_phoneNumberController.text.length != 11) {
    //   Get.snackbar(
    //     'Error',
    //     'Phone number must be 11 digits',
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //   );
    //   return;
    // }

    // Validate amount
    if (_amountController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter an amount',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validate amount is a number
    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      Get.snackbar(
        'Error',
        'Please enter a valid amount',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validate minimum amount (e.g., 50 Naira)
    if (amount < 50) {
      Get.snackbar(
        'Error',
        'Minimum amount is ₦50',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
          ),
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₦${_amountController.text}.00',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            _buildInfoRow('Recipient ID', _phoneNumberController.text),
            _buildInfoRow('Transaction Type', 'Airtime'),
            _buildInfoRow(
                'Network', _networks[_selectedNetwork]['name']!.toString()),
            _buildInfoRow('Paying', '₦ ${_amountController.text}.00'),
            _buildInfoRow('Date',
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())),
            SizedBox(height: 24.h),
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),
            Obx(() {
              final user = _userController.user.value;
              return Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.account_balance_wallet,
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
                            'Balance',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '₦${user?.profile.wallet ?? '0.00'}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.check_circle,
                      color: primaryColor,
                      size: 24.sp,
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 24.h),
            CustomButtonWidget(
              text: 'Pay',
              onTap: () {
                Get.back();
                _showPinBottomSheet();
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _showPinBottomSheet() {
    _pinNotifier.value = '';
    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.r),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8.h),
                // Handle bar
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),
                // Title with close button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Enter Transaction Pin',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _pinNotifier.value = '';
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                // PIN display
                ValueListenableBuilder<String>(
                  valueListenable: _pinNotifier,
                  builder: (context, pin, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (index) => Container(
                          width: 50.w,
                          height: 50.w,
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: pin.length > index
                                ? Container(
                                    width: 12.w,
                                    height: 12.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 24.h),
                // Loading indicator
                Obx(() => _a_controller.isLoading.value
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      )
                    : const SizedBox()),
                // Forgot PIN text
                TextButton(
                  onPressed: () {
                    // Handle forgot PIN
                  },
                  child: Text(
                    'Forgot Pin',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Number pad
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      if (index == 9) {
                        return GestureDetector(
                          onTap: () {
                            if (_pinNotifier.value.length < 4) {
                              _pinNotifier.value = _pinNotifier.value + '9';
                              if (_pinNotifier.value.length == 4) {
                                // PIN is complete, process the transaction
                                _a_controller.purchaseAirtime(
                                  phone: _phoneNumberController.text,
                                  amount: _amountController.text,
                                  network: _networks[_selectedNetwork]['name']!
                                      .toString(),
                                  pin: _pinNotifier.value,
                                );
                              }
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Text(
                                '9',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      if (index == 10) {
                        index = 0;
                      }
                      if (index == 11) {
                        return GestureDetector(
                          onTap: () {
                            if (_pinNotifier.value.isNotEmpty) {
                              _pinNotifier.value = _pinNotifier.value
                                  .substring(0, _pinNotifier.value.length - 1);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.backspace_outlined,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () {
                          if (_pinNotifier.value.length < 4) {
                            _pinNotifier.value =
                                _pinNotifier.value + index.toString();
                            if (_pinNotifier.value.length == 4) {
                              // PIN is complete, process the transaction
                              _a_controller.purchaseAirtime(
                                phone: _phoneNumberController.text,
                                amount: _amountController.text,
                                network: _networks[_selectedNetwork]['name']!
                                    .toString(),
                                pin: _pinNotifier.value,
                              );
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Text(
                              index.toString(),
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showBeneficiariesDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saved Beneficiaries',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Obx(
                () => _controller.savedBeneficiaries.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Text(
                            'No saved beneficiaries',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _controller.savedBeneficiaries.length,
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[200],
                        ),
                        itemBuilder: (context, index) {
                          final beneficiary =
                              _controller.savedBeneficiaries[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              beneficiary['name']!,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              beneficiary['number']!,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  color: Colors.red,
                                  onPressed: () {
                                    _controller.removeBeneficiary(index);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios),
                                  color: primaryColor,
                                  onPressed: () {
                                    _phoneNumberController.text =
                                        beneficiary['number']!;
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(_onPhoneNumberChanged);
  }

  void _onPhoneNumberChanged() {
    setState(() {
      _showSaveOption = _phoneNumberController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _phoneNumberController.removeListener(_onPhoneNumberChanged);
    _phoneNumberController.dispose();
    _amountController.dispose();
    _pinNotifier.dispose();
    super.dispose();
  }

  final _networks = [
    {
      'name': 'MTN',
      'logo': 'assets/images/MTN.png',
      'color': const Color(0xFFFFF4E6),
      'serviceID': 'mtn',
    },
    {
      'name': 'GLO',
      'logo': 'assets/images/glo.png',
      'color': Colors.white,
      'serviceID': 'glo',
    },
    {
      'name': 'Airtel',
      'logo': 'assets/images/airtel.png',
      'color': Colors.white,
      'serviceID': 'airtel',
    },
    {
      'name': '9Mobile',
      'logo': 'assets/images/9mobile.png',
      'color': Colors.white,
      'serviceID': 'etisalat',
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
                  onPressed: _showBeneficiariesDialog,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            CustomTextFieldWidget(
              label: 'Mobile Number',
              icon: Icons.phone,
              controller: _phoneNumberController,
            ),
            if (_showSaveOption) ...[
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Save as Beneficiary',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                  Switch(
                    value: _saveBeneficiary,
                    onChanged: (value) {
                      setState(() {
                        _saveBeneficiary = value;
                      });
                    },
                    activeColor: primaryColor,
                  ),
                ],
              ),
            ],
            SizedBox(height: 24.h),
            CustomTextFieldWidget(
              label: 'Amount',
              icon: Icons.card_giftcard_outlined,
              controller: _amountController,
              readOnly: false,
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
}
