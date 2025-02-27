import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:intl/intl.dart';

class EducationTransactionSheet extends StatelessWidget {
  final String title;
  final String description;
  final String amount;
  final String mobileNumber;
  final VoidCallback onProceed;

  const EducationTransactionSheet({
    super.key,
    required this.title,
    required this.description,
    required this.amount,
    required this.mobileNumber,
    required this.onProceed,
  });

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final currencyFormat = NumberFormat("#,##0.00", "en_US");

    return Container(
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
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₦$amount',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildInfoRow('Service Provider', title),
          _buildInfoRow('Transaction Type', description),
          _buildInfoRow('Mobile Number', mobileNumber),
          _buildInfoRow('Paying', '₦$amount'),
          _buildInfoRow(
              'Date', DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())),
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
          Container(
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
                      Obx(() {
                        final balance =
                            userController.user.value?.profile.wallet ?? 0.0;
                        final isVisible = userController.isBalanceVisible.value;
                        return Text(
                          isVisible
                              ? '₦${currencyFormat.format(balance)}'
                              : '₦*****',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        );
                      }),
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
          ),
          SizedBox(height: 24.h),
          CustomButtonWidget(
            text: 'Pay',
            onTap: onProceed,
          ),
        ],
      ),
    );
  }
}

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
