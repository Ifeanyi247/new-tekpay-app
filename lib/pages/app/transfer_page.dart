import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/controllers/transfer_controller.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/models/bank_model.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/app/bank_selection_page.dart';
import 'package:tekpayapp/pages/app/confirm_in_app_transfer_page.dart';
import 'package:tekpayapp/pages/app/confirm_transfer.dart';
import 'package:intl/intl.dart';

class TransferPage extends StatefulWidget {
  final int? initialTab;
  final Map<String, dynamic>? preselectedRecipient;

  const TransferPage({
    super.key,
    this.initialTab,
    this.preselectedRecipient,
  });

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final accountNumberController = TextEditingController();
  final searchController = TextEditingController();
  final bankFormKey = GlobalKey<FormState>();
  final inAppFormKey = GlobalKey<FormState>();
  final selectedBank = Rxn<Bank>();
  final searchResult = ''.obs;
  final isSearching = false.obs;

  final userController = Get.find<UserController>();
  final transferController = Get.find<TransferController>();
  final remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab ?? 0,
    );

    if (widget.preselectedRecipient != null) {
      // Pre-fill the search field with recipient data
      transferController.userSearchResult.value = widget.preselectedRecipient;
      searchController.text = widget.preselectedRecipient!['email'] ?? '';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    accountNumberController.dispose();
    searchController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  void _onAccountNumberChanged(String value) {
    if (value.length == 10 && selectedBank.value != null) {
      transferController.verifyAccount(
        accountNumber: value,
        bankCode: selectedBank.value!.code,
      );
    }
  }

  Future<void> _searchUser(String value) async {
    if (value.isEmpty) {
      searchResult.value = '';
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    try {
      // Call your API to search for user
      final response = await transferController.searchUser(value);
      if (response != null) {
        searchResult.value = response;
      }
    } catch (e) {
      searchResult.value = 'User not found';
    } finally {
      isSearching.value = false;
    }
  }

  Widget _buildBankTransfer() {
    return Form(
      key: bankFormKey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                TextFormField(
                  controller: accountNumberController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: _onAccountNumberChanged,
                  decoration: InputDecoration(
                    hintText: 'Enter account number',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    suffixIcon:
                        Obx(() => transferController.verificationLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : accountNumberController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      accountNumberController.clear();
                                      transferController.accountDetails.value =
                                          null;
                                    },
                                    color: Colors.grey,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  )
                                : const SizedBox()),
                  ),
                ),
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: () async {
                    final result = await Get.to(() => BankSelectionPage());
                    if (result != null && result is Bank) {
                      selectedBank.value = result;
                      if (accountNumberController.text.length == 10) {
                        transferController.verifyAccount(
                          accountNumber: accountNumberController.text,
                          bankCode: result.code,
                        );
                      }
                    }
                  },
                  child: Row(
                    children: [
                      Container(
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
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Obx(() => Text(
                              selectedBank.value?.name ?? 'Select Bank',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Obx(() {
                  if (transferController.verificationLoading.value) {
                    return Center(
                      child: SizedBox(
                        height: 20.h,
                        width: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor,
                          ),
                        ),
                      ),
                    );
                  }

                  final accountDetails =
                      transferController.accountDetails.value;
                  if (accountDetails != null) {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(4.r),
                      child: Center(
                        child: Text(
                          accountDetails.accountName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }

                  if (transferController.verificationError.isNotEmpty) {
                    return Text(
                      'Invalid account number',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.red,
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (bankFormKey.currentState?.validate() ?? false) {
                    if (selectedBank.value == null) {
                      Get.snackbar(
                        'Error',
                        'Please select a bank',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    final accountDetails =
                        transferController.accountDetails.value;
                    if (accountDetails == null) {
                      Get.snackbar(
                        'Error',
                        'Please wait for account verification',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    Get.to(() => ConfirmTransferPage(
                          recipientName: accountDetails.accountName,
                          accountNumber: accountNumberController.text,
                          bankName: selectedBank.value!.name,
                          bankCode: selectedBank.value!.code,
                          isInAppTransfer: false,
                        ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B3DFF),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Proceed',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInAppTransfer() {
    return Form(
      key: inAppFormKey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                TextFormField(
                  controller: searchController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: (value) async {
                    if (value.length >= 3) {
                      final result = await transferController.searchUser(value);
                      if (result != null) {
                        searchResult.value = result;
                      }
                    } else {
                      searchResult.value = '';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter email or username',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    suffixIcon:
                        Obx(() => transferController.userSearchLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : searchController.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      searchController.clear();
                                      searchResult.value = '';
                                    },
                                    icon: const Icon(Icons.close),
                                    color: Colors.grey,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  )
                                : const SizedBox()),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email or username';
                    }
                    if (transferController.userSearchResult.value == null) {
                      return 'Please select a valid recipient';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                Obx(() {
                  if (transferController.userSearchResult.value == null) {
                    return const SizedBox();
                  }
                  final userData = transferController.userSearchResult.value!;
                  return GestureDetector(
                    onTap: () {
                      searchController.text = userData['email'] ?? '';
                      searchResult.value = searchController.text;
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: primaryColor.withOpacity(0.1),
                            child: Text(
                              '${userData['first_name']?[0] ?? ''}${userData['last_name']?[0] ?? ''}'
                                  .toUpperCase(),
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  searchResult.value,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  userData['email'] ?? '',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: primaryColor,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amount',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    prefix: Text(
                      'NGN ',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      transferController.amount.value =
                          double.parse(value.replaceAll(',', ''));
                    } else {
                      transferController.amount.value = 0;
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter amount';
                    }
                    final amount = double.parse(value.replaceAll(',', ''));
                    if (amount < 100) {
                      return 'Minimum amount is NGN 100';
                    }
                    if (amount > userController.user.value!.profile.wallet) {
                      return 'Insufficient balance';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (inAppFormKey.currentState!.validate()) {
                  Get.to(
                    () => ConfirmInAppTransferPage(
                      recipientName: searchResult.value,
                      accountNumber:
                          transferController.userSearchResult.value?['email'] ??
                              '',
                      bankName: 'In-App Transfer',
                      bankCode: 'INTERNAL',
                      prefillAmount: transferController.amount.value.toString(),
                      isInAppTransfer: true,
                      recipientId: transferController
                              .userSearchResult.value?['id']
                              ?.toString() ??
                          '',
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transfers',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => userController.fetchUserTransfers(),
                child: Text(
                  'Refresh',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          if (userController.isLoadingTransfers.value) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: const CircularProgressIndicator(),
              ),
            );
          }

          if (userController.transfers.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Text(
                  'No recent transfers',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: userController.transfers.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey[200],
              height: 1,
            ),
            itemBuilder: (context, index) {
              final transfer = userController.transfers[index];
              final formattedDate =
                  DateFormat('MMM d, y (HH:mm)').format(transfer.createdAt);

              return ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () async {
                  if (transfer.accountBank == 'Tekpay') {
                    // Get first name only for search
                    final firstName = transfer.accountName.split(' ')[0];
                    final recipientName =
                        await transferController.searchUser(firstName);
                    if (recipientName != null) {
                      final userData =
                          transferController.userSearchResult.value;
                      if (userData != null) {
                        Get.to(() => ConfirmInAppTransferPage(
                              recipientName:
                                  '${userData['first_name']} ${userData['last_name']}',
                              accountNumber: userData['email'] ?? '',
                              bankName: 'In-App Transfer',
                              bankCode: 'INTERNAL',
                              prefillAmount: transfer.amount,
                              isInAppTransfer: true,
                              recipientId: userData['id'],
                            ));
                      }
                    }
                  } else {
                    Get.to(() => ConfirmTransferPage(
                          recipientName: transfer.accountName,
                          accountNumber: transfer.accountNumber,
                          bankName: transfer.accountBank,
                          bankCode: transfer.accountCode,
                          prefillAmount: transfer.amount.toString(),
                          isInAppTransfer: false,
                        ));
                  }
                },
                leading: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      transfer.accountName.substring(0, 1),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        transfer.accountName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '₦${transfer.amount}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${transfer.accountBank} • ${transfer.accountNumber}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    userController.fetchUserTransfers();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Money'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Bank Transfer'),
            Tab(text: 'In-App Transfer'),
          ],
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildBankTransfer(),
                SizedBox(height: 32.h),
                _buildTransactionsList(),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                _buildInAppTransfer(),
                SizedBox(height: 32.h),
                _buildTransactionsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
