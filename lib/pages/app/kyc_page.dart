import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/app/personal_information_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';

class KYCPage extends StatelessWidget {
  const KYCPage({super.key});

  Widget _buildRequirementItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: primaryColor,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
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
      appBar: AppBar(
        title: Text(
          'KYC',
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
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details to provide',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'The following are information we want from you.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'KYC Requirement',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            _buildRequirementItem(
                title: 'Personal information',
                subtitle:
                    'Provide your First name, Last name, Gender and Date of Birth.',
                icon: Icons.layers,
                onTap: () {}),
            _buildRequirementItem(
              title: 'BVN/NIN',
              subtitle: 'Provide us with your BVN and NIN number respectively.',
              icon: Icons.view_in_ar,
              onTap: () {
                // TODO: Navigate to BVN/NIN form
              },
            ),
            _buildRequirementItem(
              title: 'Residential address',
              subtitle:
                  'Provide us with your permanent address and proof and address.',
              icon: Icons.flash_on,
              onTap: () {
                // TODO: Navigate to address form
              },
            ),
            const Spacer(),
            Text(
              'By clicking on Accept and Proceed, you consent to provide us with the requested data.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16.h),
            CustomButtonWidget(
              text: 'Accept And Proceed',
              onTap: () {
                Get.to(() => const PersonalInformationPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
