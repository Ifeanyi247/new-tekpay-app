import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/bills/education_controller.dart';
import 'package:tekpayapp/pages/app/data/data_page.dart';
import 'package:tekpayapp/pages/app/education/education_success_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:tekpayapp/pages/widgets/custom_text_field.dart';
import 'package:tekpayapp/pages/app/widgets/transaction_widget.dart';
import 'package:tekpayapp/pages/app/education/widgets/education_transaction_widget.dart';

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

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final EducationController _educationController =
      Get.put(EducationController());
  String? _selectedNetwork;
  String _selectedProvider = 'WAEC';
  String? _selectedVariation;

  @override
  void initState() {
    super.initState();
    _fetchVariations();
  }

  void _fetchVariations() {
    _educationController.fetchVariations(_selectedProvider.toLowerCase());
  }

  Widget _buildProviderOption(String name, String imagePath) {
    final isSelected = _selectedProvider == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProvider = name;
          _selectedVariation = null;
          _fetchVariations();
        });
      },
      child: Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 40.w,
              height: 40.h,
            ),
            SizedBox(height: 8.h),
            Text(
              name,
              style: TextStyle(
                fontSize: 12.sp,
                color: primaryColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Education',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProviderOption('WAEC', 'assets/images/waec.png'),
                _buildProviderOption('JAMB', 'assets/images/jamb.png'),
              ],
            ),
            SizedBox(height: 24.h),
            Obx(() {
              final variations = _educationController.variations.value;
              if (_educationController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (variations == null) {
                return Container();
              }
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedVariation,
                    hint: Text(
                      'Select ${_selectedProvider} Type',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                    items: variations.variations
                        .map((variation) => DropdownMenuItem(
                              value: variation.variationCode,
                              child: Text(variation.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVariation = value;
                        final selectedVar = variations.variations
                            .firstWhere((v) => v.variationCode == value);
                        _amountController.text = selectedVar.variationAmount;
                      });
                    },
                  ),
                ),
              );
            }),
            SizedBox(height: 16.h),
            CustomTextFieldWidget(
              controller: _amountController,
              label: '₦',
              icon: Icons.monetization_on_outlined,
            ),
            SizedBox(height: 16.h),
            CustomTextFieldWidget(
              controller: _mobileController,
              label: 'Mobile Number',
              icon: Icons.phone_android,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 40.h),
            CustomButtonWidget(
              text: 'Proceed',
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => EducationTransactionSheet(
                    title: _selectedProvider,
                    description: 'Result PIN Purchase',
                    amount: _amountController.text,
                    mobileNumber: _mobileController.text,
                    onProceed: () {
                      Get.back();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => PinEntrySheet(
                          onPinComplete: () {
                            Get.to(() => EducationSuccessPage(
                                  transactionType: 'WAEC Result PIN',
                                  amount: '2,500',
                                  reference:
                                      'EDU${DateTime.now().millisecondsSinceEpoch}',
                                ));
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
