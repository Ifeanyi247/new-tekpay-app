import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/bills/airtime_controller.dart';
import 'package:tekpayapp/controllers/bills/data_controller.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:tekpayapp/pages/widgets/custom_text_field.dart';
import 'package:tekpayapp/pages/app/data/data_list.dart';
import 'package:intl/intl.dart';

class PinEntrySheet extends StatefulWidget {
  final Function(String pin) onPinComplete;

  const PinEntrySheet({
    super.key,
    required this.onPinComplete,
  });

  @override
  State<PinEntrySheet> createState() => _PinEntrySheetState();
}

class _PinEntrySheetState extends State<PinEntrySheet> {
  final _pinNotifier = ValueNotifier<String>('');
  final _isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _pinNotifier.dispose();
    _isLoading.dispose();
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
          ValueListenableBuilder<bool>(
            valueListenable: _isLoading,
            builder: (context, isLoading, child) {
              return isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox(height: 48);
            },
          ),
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
            child: ValueListenableBuilder<bool>(
              valueListenable: _isLoading,
              builder: (context, isLoading, child) {
                return IgnorePointer(
                  ignoring: isLoading,
                  child: Opacity(
                    opacity: isLoading ? 0.5 : 1.0,
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
                                  _isLoading.value = true;
                                  widget.onPinComplete(_pinNotifier.value);
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
                                    .substring(
                                        0, _pinNotifier.value.length - 1);
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
                                _isLoading.value = true;
                                widget.onPinComplete(_pinNotifier.value);
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
  final _userController = Get.find<UserController>();
  String? _selectedDataType;
  String? _selectedPlan;
  int _selectedNetwork = 0;
  DataController? _dataController;
  final _a_controller = Get.put(AirtimeWorkingController());

  final _networks = [
    {
      'name': 'MTN',
      'logo': 'assets/images/MTN.png',
      'color': const Color(0xFFFFF4E6),
      'serviceId': 'mtn-data',
    },
    {
      'name': 'GLO',
      'logo': 'assets/images/glo.png',
      'color': Colors.white,
      'serviceId': 'glo-data',
    },
    {
      'name': 'Airtel',
      'logo': 'assets/images/airtel.png',
      'color': Colors.white,
      'serviceId': 'airtel-data',
    },
    {
      'name': '9Mobile',
      'logo': 'assets/images/9mobile.png',
      'color': Colors.white,
      'serviceId': 'etisalat-data',
    },
    {
      'name': 'GLO SME',
      'logo': 'assets/images/glo.png',
      'color': Colors.white,
      'serviceId': 'glo-sme-data',
    },
    {
      'name': '9mobile SME',
      'logo': 'assets/images/9mobile.png',
      'color': Colors.white,
      'serviceId': '9mobile-sme-data',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchDataServices();
  }

  Future<void> _fetchDataServices() async {
    await _a_controller.fetchDataServices('data');
  }

  Future<void> _showDataPlans() async {
    final services = _a_controller.dataServices.value?.data.content ?? [];
    final serviceId = services.isEmpty
        ? _networks[_selectedNetwork]['serviceId']!.toString()
        : services[_selectedNetwork].serviceID;

    final result = await Get.to<Map<String, dynamic>>(() => DataListPage(
          serviceId: serviceId,
        ));

    if (result != null) {
      setState(() {
        _selectedPlan = result['code'] as String;
        _amountController.text = result['price'].toString();
      });
      _dataController = Get.put(DataController(serviceId));
    }
  }

  void _showTransactionConfirmation() {
    if (_mobileNumberController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a phone number',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedPlan == null) {
      Get.snackbar(
        'Error',
        'Please select a data plan',
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
            _buildInfoRow('Recipient ID', _mobileNumberController.text),
            _buildInfoRow('Transaction Type', 'Data'),
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
                _showPinEntry();
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

  void _showPinEntry() {
    Get.bottomSheet(
      PinEntrySheet(
        onPinComplete: (pin) async {
          await _dataController?.purchaseData(
            phone: _mobileNumberController.text,
            amount: _amountController.text,
            variationCode: _selectedPlan!,
            pin: pin,
          );
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
            Obx(() {
              final services =
                  _a_controller.dataServices.value?.data.content ?? [];
              if (_a_controller.isLoading.value && services.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return SizedBox(
                height: 80.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      services.isEmpty ? _networks.length : services.length,
                  itemBuilder: (context, index) {
                    // If no services loaded yet, use fallback network data
                    if (services.isEmpty) {
                      final network = _networks[index];
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
                                network['logo']!.toString(),
                                height: 32.h,
                                width: 32.w,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                network['name']!.toString(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Use data from services
                    final service = services[index];
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
                            ClipOval(
                              child: Image.network(
                                service.image,
                                height: 32.h,
                                width: 32.w,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.network_cell, size: 32.sp),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              service.name,
                              textAlign: TextAlign.center,
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
              );
            }),
            SizedBox(height: 32.h),
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
              readOnly: true,
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
