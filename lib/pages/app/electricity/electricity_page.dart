import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/app/data/data_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:tekpayapp/pages/widgets/custom_text_field.dart';
import 'package:tekpayapp/pages/app/widgets/transaction_widget.dart';
import 'package:tekpayapp/pages/app/airtime/transaction_status_page.dart';

class ElectricityProvider {
  final String name;
  final String type;
  final String logo;

  ElectricityProvider({
    required this.name,
    required this.type,
    required this.logo,
  });
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
      name: 'Abuja Electricity Distribution Company',
      type: 'Prepaid',
      logo: 'assets/images/aedc.png',
    ),
    ElectricityProvider(
      name: 'Abuja Electricity Distribution Company',
      type: 'Postpaid',
      logo: 'assets/images/aedc.png',
    ),
    ElectricityProvider(
      name: 'Benin Electricity Distribution Company',
      type: 'Prepaid',
      logo: 'assets/images/bedc.png',
    ),
    ElectricityProvider(
      name: 'Benin Electricity Distribution Company',
      type: 'Postpaid',
      logo: 'assets/images/bedc.png',
    ),
    ElectricityProvider(
      name: 'Enugu Electricity Distribution Company',
      type: 'Prepaid',
      logo: 'assets/images/eedc.png',
    ),
    ElectricityProvider(
      name: 'Enugu Electricity Distribution Company',
      type: 'Postpaid',
      logo: 'assets/images/eedc.png',
    ),
    ElectricityProvider(
      name: 'Eko Electricity Distribution Company',
      type: 'Prepaid',
      logo: 'assets/images/ekedc.png',
    ),
    ElectricityProvider(
      name: 'Eko Electricity Distribution Company',
      type: 'Postpaid',
      logo: 'assets/images/ekedc.png',
    ),
    ElectricityProvider(
      name: 'Ibadan Electricity Distribution Company',
      type: 'Prepaid',
      logo: 'assets/images/ibedc.png',
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
              itemCount: _filteredProviders.length,
              itemBuilder: (context, index) {
                final provider = _filteredProviders[index];
                return GestureDetector(
                  onTap: () {
                    Get.back(result: {
                      'name': provider.name,
                      'type': provider.type,
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
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.image,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(width: 12.w),
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

class ElectricityPage extends StatefulWidget {
  const ElectricityPage({super.key});

  @override
  State<ElectricityPage> createState() => _ElectricityPageState();
}

class _ElectricityPageState extends State<ElectricityPage> {
  final TextEditingController _meterController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedProvider;
  String? _selectedType;

  Future<void> _showProviders() async {
    final result = await Get.to<Map<String, dynamic>>(
      () => const ProviderListPage(),
    );
    if (result != null) {
      setState(() {
        _selectedProvider = result['name'] as String;
        _selectedType = result['type'] as String;
      });
    }
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
    _meterController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
