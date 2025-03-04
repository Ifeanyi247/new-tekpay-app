import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/bills/electricity_controller.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/app/data/data_page.dart';
import 'package:tekpayapp/pages/app/widgets/transaction_widget.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:tekpayapp/pages/widgets/custom_text_field.dart';

class ElectricityPage extends StatefulWidget {
  const ElectricityPage({super.key});

  @override
  State<ElectricityPage> createState() => _ElectricityPageState();
}

class _ElectricityPageState extends State<ElectricityPage> {
  final TextEditingController _meterController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  Timer? _debounceTimer;
  String? _selectedProvider;
  String? _selectedType;
  String? _selectedServiceID;
  String _selectedTypeValue = 'prepaid'; // Default to prepaid

  @override
  void initState() {
    super.initState();
    Get.put(ElectricityController());
  }

  Future<void> _showProviders() async {
    final result = await Get.to<Map<String, dynamic>>(
      () => const ProviderListPage(),
    );
    if (result != null) {
      print(result);
      setState(() {
        _selectedProvider = result['name'] as String;
        _selectedType = result['type'] as String;
        _selectedServiceID = result['serviceID'] as String;
      });
    }
  }

  Future<void> _verifyMeter() async {
    if (_selectedProvider == null) return;

    // final provider = _selectedProvider.firstWhere(
    //   (p) => p['name'] == _selectedProvider,
    //   orElse: () => _providers[0],
    // );

    final controller = Get.find<ElectricityController>();
    await controller.verifyMeter(
      billersCode: _meterController.text,
      serviceID: _selectedServiceID!,
      type: _selectedTypeValue,
    );
  }

  void _showTransactionConfirmation() {
    Get.bottomSheet(
      TransactionConfirmationSheet(
        amount: _amountController.text,
        recipientId: _meterController.text,
        network: '$_selectedProvider ($_selectedType)',
        transactionType: 'Electricity Bill',
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
    final provider = _selectedServiceID;

    Get.bottomSheet(
      PinEntrySheet(
        onPinComplete: (pin) async {
          final controller = Get.find<ElectricityController>();
          final userController = Get.find<UserController>();
          await controller.purchaseElectricity(
            billersCode: _meterController.text,
            serviceID: provider!,
            variationCode: _selectedTypeValue,
            amount: _amountController.text,
            phone: userController.user.value?.phoneNumber ?? '',
            pin: pin,
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
          'Electricity Purchase',
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
            Text(
              'Select Provider',
              style: TextStyle(
                fontSize: 16.sp,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: _showProviders,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedProvider != null
                            ? '$_selectedProvider ($_selectedType)'
                            : 'Select provider',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: _selectedProvider != null
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
              'Select Type',
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
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTypeValue = 'prepaid';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: _selectedTypeValue == 'prepaid'
                            ? const Color(0xFFF3E5F5)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Prepaid',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: _selectedTypeValue == 'prepaid'
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTypeValue = 'postpaid';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: _selectedTypeValue == 'postpaid'
                            ? const Color(0xFFF3E5F5)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Postpaid',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: _selectedTypeValue == 'postpaid'
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text(
              'Enter Meter Number',
              style: TextStyle(
                fontSize: 16.sp,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextFieldWidget(
              controller: _meterController,
              label: '1234********',
              icon: Icons.electric_meter_outlined,
              onChanged: (value) {
                if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
                _debounceTimer =
                    Timer(const Duration(milliseconds: 500), () async {
                  if (value.length >= 10) {
                    await _verifyMeter();
                  }
                });
              },
            ),
            GetX<ElectricityController>(
              builder: (controller) {
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

                final info = controller.customerInfo;
                if (info.isNotEmpty) {
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
                        _buildInfoRow(
                            'Meter Number', info['Meter_Number'] ?? ''),
                        _buildInfoRow('Address', info['Address'] ?? ''),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            SizedBox(height: 24.h),
            Text(
              'Enter Amount',
              style: TextStyle(
                fontSize: 16.sp,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextFieldWidget(
              controller: _amountController,
              label: 'Enter amount',
              // icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 40.h),
            CustomButtonWidget(
              text: 'Proceed',
              // onTap: () {
              //   print(_selectedServiceID);
              // },
              onTap: _showTransactionConfirmation,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _meterController.dispose();
    _amountController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }
}

class ProviderListPage extends StatefulWidget {
  const ProviderListPage({super.key});

  @override
  State<ProviderListPage> createState() => _ProviderListPageState();
}

class _ProviderListPageState extends State<ProviderListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<ElectricityProvider> _filteredProviders = [];

  final List<ElectricityProvider> _providers = [
    ElectricityProvider(
      name: 'IKEJA Electricity Distribution Company',
      type: 'IKEDC',
      serviceID: 'ikeja-electric',
    ),
    ElectricityProvider(
      name: 'Eko Electricity Distribution Company',
      type: 'EKEDC',
      serviceID: 'eko-electric',
    ),
    ElectricityProvider(
      name: 'Kano Electricity Distribution Company',
      type: 'KEDCO',
      serviceID: 'kano-electric',
    ),
    ElectricityProvider(
      name: 'Port Harcourt Electricity Distribution Company',
      type: 'PHED',
      serviceID: 'portharcourt-electric',
    ),
    ElectricityProvider(
      name: 'Joss’s Electricity Distribution Company',
      type: 'JED',
      serviceID: 'jos-electric',
    ),
    ElectricityProvider(
      name: 'Ibadan Electricity Distribution Company',
      type: 'IBEDC',
      serviceID: 'ibadan-electric',
    ),
    ElectricityProvider(
      name: 'Kaduna Electric',
      type: 'KAEDCO',
      serviceID: 'kaduna-electric',
    ),
    ElectricityProvider(
      name: 'Abuja Electricity Distribution Company',
      type: 'AEDC',
      serviceID: 'abuja-electric',
    ),
    ElectricityProvider(
      name: 'Enugu Electric',
      type: 'EEDC',
      serviceID: 'enugu-electric',
    ),
    ElectricityProvider(
      name: 'Benin Electricity Distribution Company',
      type: 'BEDC',
      serviceID: 'benin-electric',
    ),
    ElectricityProvider(
      name: 'ABA  Electricity Distribution Company',
      type: 'ABA',
      serviceID: 'aba-electric',
    ),
    ElectricityProvider(
      name: 'YOLA Electricity Distribution Company',
      type: 'YEDC',
      serviceID: 'yola-electric',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filteredProviders = List.from(_providers);
    _searchController.addListener(_filterProviders);
  }

  void _filterProviders() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProviders = _providers.where((provider) {
        return provider.name.toLowerCase().contains(query) ||
            provider.type.toLowerCase().contains(query);
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
          onPressed: () => Navigator.pop(context),
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
              itemCount: _filteredProviders.length,
              itemBuilder: (context, index) {
                final provider = _filteredProviders[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(
                      context,
                      {
                        'name': provider.name,
                        'type': provider.type,
                        'serviceID': provider.serviceID
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${provider.name} (${provider.type})',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black87,
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

class ElectricityProvider {
  final String name;
  final String type;
  final String serviceID;

  ElectricityProvider({
    required this.name,
    required this.type,
    required this.serviceID,
  });
}
