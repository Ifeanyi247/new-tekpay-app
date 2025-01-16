import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/pages/app/review_page.dart';
import 'package:tekpayapp/pages/widgets/custom_button_widget.dart';
import 'package:tekpayapp/pages/widgets/custom_text_field.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  String? _selectedState;
  String? _selectedLGA;
  String? _selectedBillType;
  XFile? _selectedBill;
  bool _isUploading = false;

  final List<String> _states = [
    'Lagos',
    'Abuja',
    'Rivers',
    // Add more states
  ];

  final List<String> _lgas = [
    'Alimosho',
    'Ikeja',
    'Eti-Osa',
    // Add more LGAs
  ];

  final List<String> _billTypes = [
    'Electricity Bill',
    'Water Bill',
    'Gas Bill',
  ];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 400,
      );
      if (image != null) {
        setState(() {
          _selectedBill = image;
          _isUploading = true;
        });
        // Simulate upload delay
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _isUploading = false;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _houseNumberController.dispose();
    super.dispose();
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              hint: Text(
                hint,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Upload valid utility Bill not later than 3 months ago.',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 16.h),
        InkWell(
          onTap: _selectedBill == null ? _pickImage : null,
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color:
                    _selectedBill != null ? primaryColor : Colors.grey.shade200,
              ),
            ),
            child: Column(
              children: [
                if (_selectedBill == null) ...[
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 32.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Click to upload',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'SVG, PNG, JPG or GIF (max. 800×400px)',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ] else if (_isUploading) ...[
                  const CircularProgressIndicator(),
                  SizedBox(height: 8.h),
                  Text(
                    'Uploading...',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        color: primaryColor,
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedBill!.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '200 KB',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey,
                              ),
                            ),
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
                  SizedBox(height: 8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: LinearProgressIndicator(
                      value: 1.0,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      minHeight: 4.h,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '100%',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ],
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
        title: Text(
          'Address',
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
            _buildDropdownField(
              label: 'State',
              hint: 'Select state',
              value: _selectedState,
              items: _states,
              onChanged: (value) {
                setState(() {
                  _selectedState = value;
                  _selectedLGA = null; // Reset LGA when state changes
                });
              },
            ),
            SizedBox(height: 24.h),
            _buildDropdownField(
              label: 'Local government',
              hint: 'Select local governement',
              value: _selectedLGA,
              items: _lgas,
              onChanged: (value) {
                setState(() {
                  _selectedLGA = value;
                });
              },
            ),
            SizedBox(height: 24.h),
            Text(
              'Address',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextFieldWidget(
              controller: _addressController,
              label: 'Enter your detailed address',
              icon: Icons.location_on_outlined,
            ),
            SizedBox(height: 24.h),
            Text(
              'House number',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextFieldWidget(
              controller: _houseNumberController,
              label: 'House number',
              icon: Icons.home_outlined,
            ),
            SizedBox(height: 24.h),
            _buildDropdownField(
              label: 'Utility bill type',
              hint: 'Electricity Bill',
              value: _selectedBillType,
              items: _billTypes,
              onChanged: (value) {
                setState(() {
                  _selectedBillType = value;
                });
              },
            ),
            SizedBox(height: 24.h),
            _buildUploadSection(),
            SizedBox(height: 48.h),
            CustomButtonWidget(
              text: 'Submit',
              onTap: () {
                Get.to(() => const ReviewPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
