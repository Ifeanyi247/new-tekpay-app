import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/controllers/transfer_controller.dart';
import 'package:tekpayapp/models/bank_model.dart';

class BankSelectionPage extends StatelessWidget {
  BankSelectionPage({super.key});

  final searchController = TextEditingController();
  final transferController = Get.find<TransferController>();
  final filteredBanks = <Bank>[].obs;

  void filterBanks(String query) {
    if (transferController.banks.value == null) return;

    if (query.isEmpty) {
      filteredBanks.value = transferController.banks.value!.data;
    } else {
      filteredBanks.value = transferController.banks.value!.data
          .where(
              (bank) => bank.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onChanged: filterBanks,
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
            child: Obx(() {
              if (transferController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (transferController.error.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error loading banks',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      ElevatedButton(
                        onPressed: transferController.fetchBanks,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (transferController.banks.value == null) {
                return const Center(child: Text('No banks available'));
              }

              // Initialize filtered banks if empty
              if (filteredBanks.isEmpty) {
                filteredBanks.value = transferController.banks.value!.data;
              }

              return Obx(() => ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: filteredBanks.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey[200],
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final bank = filteredBanks[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
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
                        ),
                      );
                    },
                  ));
            }),
          ),
        ],
      ),
    );
  }
}
