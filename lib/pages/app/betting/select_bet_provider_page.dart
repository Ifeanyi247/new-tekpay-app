import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';

class SelectBetProviderPage extends StatefulWidget {
  const SelectBetProviderPage({super.key});

  @override
  State<SelectBetProviderPage> createState() => _SelectBetProviderPageState();
}

class _SelectBetProviderPageState extends State<SelectBetProviderPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> providers = [
    {'name': '1xBet', 'image': 'assets/images/1xbet.png'},
    {'name': 'Bet9ja', 'image': 'assets/images/bet9ja.png'},
    {'name': 'BangBet', 'image': 'assets/images/bangbet.png'},
    {'name': 'CloudBet', 'image': 'assets/images/cloudbet.png'},
    {'name': 'BetKing', 'image': 'assets/images/betking.png'},
    {'name': 'BetLand', 'image': 'assets/images/betland.png'},
    {'name': 'BetLion', 'image': 'assets/images/betlion.png'},
    {'name': 'LiveScore Bet', 'image': 'assets/images/livescore_bet.png'},
    {'name': 'MerryBet', 'image': 'assets/images/merrybet.png'},
  ];

  List<Map<String, String>> get filteredProviders {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return providers;
    return providers
        .where((provider) => provider['name']!.toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.h),
        child: Container(
          color: Colors.white,
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16.sp,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: filteredProviders.length,
        separatorBuilder: (context, index) => SizedBox(height: 8.h),
        itemBuilder: (context, index) {
          final provider = filteredProviders[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              onTap: () {
                Get.back(result: provider);
              },
              leading: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.sports_basketball,
                  color: primaryColor,
                ),
              ),
              title: Text(
                provider['name']!,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
