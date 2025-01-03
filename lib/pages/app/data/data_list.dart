import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';

class DataPlan {
  final String name;
  final double originalPrice;
  final double discountedPrice;

  DataPlan({
    required this.name,
    required this.originalPrice,
    required this.discountedPrice,
  });
}

class DataListPage extends StatefulWidget {
  const DataListPage({super.key});

  @override
  State<DataListPage> createState() => _DataListPageState();
}

class _DataListPageState extends State<DataListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DataPlan> _filteredPlans = [];

  final List<DataPlan> _allPlans = [
    DataPlan(
        name: '100MB for 1Day', originalPrice: 100.00, discountedPrice: 98.00),
    DataPlan(
        name: '1.5GB for 7Day',
        originalPrice: 1000.00,
        discountedPrice: 980.00),
    DataPlan(
        name: '1.2GB for 30Day',
        originalPrice: 1000.00,
        discountedPrice: 980.00),
    DataPlan(
        name: '40GB for 30Day',
        originalPrice: 10000.00,
        discountedPrice: 9800.00),
    DataPlan(
        name: '1TB for 365Day',
        originalPrice: 100000.00,
        discountedPrice: 98000.00),
    DataPlan(
        name: '1.5GB for 30Day',
        originalPrice: 1200.00,
        discountedPrice: 1176.00),
    DataPlan(
        name: '5GB for 7Day', originalPrice: 1500.00, discountedPrice: 1470.00),
  ];

  @override
  void initState() {
    super.initState();
    _filteredPlans = List.from(_allPlans);
    _searchController.addListener(_filterPlans);
  }

  void _filterPlans() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPlans = _allPlans.where((plan) {
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
                      'price': plan.discountedPrice,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₦ ${plan.originalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              '₦ ${plan.discountedPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
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
