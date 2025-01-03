import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:tekpayapp/pages/widgets/custom_text_field.dart';
import 'package:tekpayapp/pages/app/data/data_list.dart';
import 'package:tekpayapp/pages/app/airtime/transaction_status_page.dart';
import 'package:tekpayapp/pages/app/widgets/transaction_widget.dart';

class PinEntrySheet extends StatefulWidget {
  final VoidCallback onPinComplete;

  const PinEntrySheet({
    super.key,
    required this.onPinComplete,
  });

  @override
  State<PinEntrySheet> createState() => _PinEntrySheetState();
}

class _PinEntrySheetState extends State<PinEntrySheet> {
  final _pinNotifier = ValueNotifier<String>('');

  @override
  void dispose() {
    _pinNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),
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
                  return const SizedBox.shrink();
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
                        Get.back();
                        widget.onPinComplete();
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
  }
}

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedDataType;
  String? _selectedPlan;
  int _selectedNetwork = 0;

  final _networks = [
    {
      'name': 'MTN',
      'logo': 'assets/images/MTN.png',
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

  final _dataTypes = [
    'SME',
    'GIFTING',
    'CORPORATE GIFTING',
  ];

  Future<void> _showDataPlans() async {
    final result =
        await Get.to<Map<String, dynamic>>(() => const DataListPage());
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
        recipientId: _mobileNumberController.text,
        network: _networks[_selectedNetwork]['name']!.toString(),
        transactionType: 'Data',
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
        onPinComplete: () {
          Get.to(() => const TransactionStatusPage());
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
          'Data Purchase',
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
            SizedBox(height: 32.h),
            Text(
              'Data Type*',
              style: TextStyle(
                fontSize: 16.sp,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(
                    'Select Plan Type SME, GIFTING or CORPORATE GIFTING',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                  value: _selectedDataType,
                  items: _dataTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedDataType = value;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Mobile Number*',
              style: TextStyle(
                fontSize: 16.sp,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextFieldWidget(
              controller: _mobileNumberController,
              label: '080**********',
              icon: Icons.contact_phone_outlined,
            ),
            SizedBox(height: 24.h),
            Text(
              'Plan*',
              style: TextStyle(
                fontSize: 16.sp,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: _showDataPlans,
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
                      _selectedPlan ?? 'Select a data plan',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color:
                            _selectedPlan != null ? Colors.black : Colors.grey,
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
              label: '₦',
              icon: Icons.monetization_on_outlined,
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
    _mobileNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
