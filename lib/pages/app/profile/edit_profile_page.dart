import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/profile_controller.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/widgets/custom_text_field.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final _profileController = Get.put(ProfileController());
  final _userController = Get.find<UserController>();

  Widget _buildProfileImage() {
    final user = _userController.user.value;
    return Stack(
      children: [
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: primaryColor.withOpacity(.2),
              width: 2.w,
            ),
          ),
          child: Obx(() {
            final selectedImage = _profileController.selectedImage.value;
            return ClipOval(
              child: selectedImage != null
                  ? Image.file(
                      File(selectedImage.path),
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      user?.profile.profileUrl ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person, size: 60);
                      },
                    ),
            );
          }),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _profileController.pickImage,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.w),
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Center(child: _buildProfileImage()),
              SizedBox(height: 32.h),
              CustomTextFieldWidget(
                label: 'First Name',
                controller: _profileController.firstNameController,
                icon: Icons.person_outline,
              ),
              SizedBox(height: 16.h),
              CustomTextFieldWidget(
                label: 'Last Name',
                controller: _profileController.lastNameController,
                icon: Icons.person_outline,
              ),
              SizedBox(height: 16.h),
              CustomTextFieldWidget(
                label: 'Username',
                controller: _profileController.usernameController,
                icon: Icons.alternate_email,
                keyboardType: TextInputType.emailAddress,
                // Disable username field
                suffixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
              ),
              SizedBox(height: 16.h),
              CustomTextFieldWidget(
                label: 'Email',
                controller: _profileController.emailController,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.h),
              CustomTextFieldWidget(
                label: 'Phone',
                controller: _profileController.phoneController,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 32.h),
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: _profileController.isLoading.value
                          ? null
                          : _profileController.updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: _profileController.isLoading.value
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Update',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
