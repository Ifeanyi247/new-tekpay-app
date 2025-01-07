import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/models/user_model.dart';
import 'package:tekpayapp/services/api_service.dart';
import 'package:tekpayapp/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ProfileController extends GetxController {
  final _userController = Get.find<UserController>();
  final _imagePicker = ImagePicker();
  final _api = ApiService();

  final isLoading = false.obs;
  final selectedImage = Rxn<XFile>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  Map<String, String> get _headers {
    final token = StorageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    final user = _userController.user.value;
    if (user != null) {
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      usernameController.text = user.username;
      emailController.text = user.email;
      phoneController.text = user.phoneNumber;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        selectedImage.value = image;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      // Create multipart request
      final uri = Uri.parse('${ApiService.baseUrl}/user/profile');
      final request = http.MultipartRequest('POST', uri);

      // Add headers except Content-Type (it's automatically set for multipart)
      final token = StorageService.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';

      // Add fields
      request.fields['username'] = usernameController.text.trim();
      request.fields['first_name'] = firstNameController.text.trim();
      request.fields['last_name'] = lastNameController.text.trim();
      request.fields['email'] = emailController.text.trim();
      request.fields['phone_number'] = phoneController.text.trim();

      // Add image if selected
      if (selectedImage.value != null) {
        final file = File(selectedImage.value!.path);
        final stream = http.ByteStream(file.openRead());
        final length = await file.length();
        final filename = path.basename(file.path);

        final multipartFile = http.MultipartFile(
          'profile_image',
          stream,
          length,
          filename: filename,
        );
        request.files.add(multipartFile);
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Parse response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          // Refresh user data
          await _userController.getProfile();

          Get.back();
          Get.snackbar(
            'Success',
            'Profile updated successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          throw responseData['message'] ?? 'Failed to update profile';
        }
      } else {
        final responseData = json.decode(response.body);
        throw responseData['message'] ?? 'Failed to update profile';
      }
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
