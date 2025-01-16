import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/app/address_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:tekpayapp/pages/widgets/custom_text_field.dart';

class BvnNinPage extends StatefulWidget {
  const BvnNinPage({super.key});

  @override
  State<BvnNinPage> createState() => _BvnNinPageState();
}

class _BvnNinPageState extends State<BvnNinPage> {
  final TextEditingController _bvnController = TextEditingController();
  final TextEditingController _ninController = TextEditingController();

  @override
  void dispose() {
    _bvnController.dispose();
    _ninController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BVN/NIN',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BVN Number',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextFieldWidget(
              controller: _bvnController,
              label: 'BVN Number',
              icon: Icons.numbers,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24.h),
            Text(
              'National Identification Number',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextFieldWidget(
              controller: _ninController,
              label: 'National Identification Number',
              icon: Icons.badge_outlined,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 48.h),
            CustomButtonWidget(
              text: 'Proceed',
              onTap: () {
                Get.to(() => const AddressPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
