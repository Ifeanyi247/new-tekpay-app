import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/app/data/data_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:tekpayapp/pages/widgets/custom_text_field.dart';
import 'package:tekpayapp/pages/app/widgets/transaction_widget.dart';
import 'package:tekpayapp/pages/app/airtime/transaction_status_page.dart';

class TvPlan {
  final String name;
  final double price;

  TvPlan({
    required this.name,
    required this.price,
  });
}

class TvPackageListPage extends StatefulWidget {
  final String provider;
  const TvPackageListPage({super.key, required this.provider});

  @override
  State<TvPackageListPage> createState() => _TvPackageListPageState();
}

class _TvPackageListPageState extends State<TvPackageListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<TvPlan> _filteredPlans = [];

  final Map<String, List<TvPlan>> _providerPlans = {
    'Gotv': [
      TvPlan(name: 'Compact', price: 12500.00),
      TvPlan(name: 'Compact Plus', price: 19800.00),
      TvPlan(name: 'Padi', price: 2950.00),
      TvPlan(name: 'Premium Asia', price: 29500.00),
      TvPlan(name: 'Yanga', price: 4200.00),
      TvPlan(name: 'Premium French', price: 45600.00),
      TvPlan(name: 'Confam', price: 7400.00),
      TvPlan(name: 'Asia', price: 9900.00),
    ],
    'Dstv': [
      TvPlan(name: 'Premium', price: 24500.00),
      TvPlan(name: 'Compact Plus', price: 18500.00),
      TvPlan(name: 'Compact', price: 10500.00),
      TvPlan(name: 'Family', price: 7500.00),
      TvPlan(name: 'Access', price: 4500.00),
    ],
    'Startime': [
      TvPlan(name: 'Nova', price: 1200.00),
      TvPlan(name: 'Basic', price: 2400.00),
      TvPlan(name: 'Smart', price: 3200.00),
      TvPlan(name: 'Classic', price: 4200.00),
      TvPlan(name: 'Super', price: 6200.00),
    ],
  };

  @override
  void initState() {
    super.initState();
    _filteredPlans = List.from(_providerPlans[widget.provider] ?? []);
    _searchController.addListener(_filterPlans);
  }

  void _filterPlans() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPlans = (_providerPlans[widget.provider] ?? []).where((plan) {
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
                        Text(
                          plan.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '₦ ${plan.price.toStringAsFixed(2)}',
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
      'name': 'Startime',
      'logo': 'assets/images/startime.png',
      'color': Colors.white,
    },
  ];

  Future<void> _showPackages() async {
    final result = await Get.to<Map<String, dynamic>>(
      () => TvPackageListPage(
        provider: _providers[_selectedProvider]['name']!.toString(),
      ),
    );
    if (result != null) {
      setState(() {
        _selectedPackage = result['name'] as String;
        _amountController.text = result['price'].toString();
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
    _smartCardController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
