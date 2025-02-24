import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Bank {
  final String name;
  final String code;

  Bank(this.name, this.code);
}

class BankSelectionPage extends StatelessWidget {
  BankSelectionPage({super.key});

  final searchController = TextEditingController();
  final RxList<Bank> filteredBanks = <Bank>[].obs;
  
  final banks = [
    Bank('AAA FINANCE', '001'),
    Bank('AB MICROFINANCE BANK', '002'),
    Bank('ACCESS BANK PLC', '003'),
    Bank('BORGU MFB', '004'),
    Bank('BOSAK MFB', '005'),
    Bank('CITIBANK NIGERIA', '006'),
    Bank('FCMB MFB', '007'),
    Bank('FIRST BANK PLC', '008'),
    Bank('MONIEPOINT MICROFINANCE BANK', '009'),
  ];

  @override
  Widget build(BuildContext context) {
    // Initialize filtered banks
    if (filteredBanks.isEmpty) {
      filteredBanks.value = banks;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F2FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filteredBanks.value = banks.where((bank) => 
                  bank.name.toLowerCase().contains(value.toLowerCase())
                ).toList();
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16.sp,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
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
            child: Obx(() => ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: filteredBanks.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey[200],
                height: 1,
              ),
              itemBuilder: (context, index) {
                final bank = filteredBanks[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.account_balance,
                        size: 20.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  title: Text(
                    bank.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Get.back(result: bank);
                  },
                );
              },
            )),
          ),
        ],
      ),
    );
  }
}
