import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final _connectivity = Connectivity();
  final isConnected = true.obs;

  Future<ConnectivityService> init() async {
    await _initConnectivity();
    _setupConnectivityStream();
    return this;
  }

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result[0]);
    } catch (e) {
      debugPrint('Couldn\'t check connectivity status: $e');
    }
  }

  void _setupConnectivityStream() {
    _connectivity.onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result[0]);
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    isConnected.value = result != ConnectivityResult.none;

    if (!isConnected.value) {
      Get.snackbar(
        'No Internet Connection',
        'Please check your internet connection and try again',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<bool> checkConnectivity() async {
    if (!isConnected.value) {
      Get.snackbar(
        'No Internet Connection',
        'Please check your internet connection and try again',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
    return true;
  }
}
