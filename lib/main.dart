import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/controllers/auth_controller.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/controllers/transfer_controller.dart';
import 'package:tekpayapp/controllers/virtual_account_controller.dart';
import 'package:tekpayapp/controllers/notification_controller.dart';
import 'package:tekpayapp/pages/splash_screen.dart';
import 'package:tekpayapp/services/api_service.dart';
import 'package:tekpayapp/services/auth_service.dart';
import 'package:tekpayapp/services/storage_service.dart';
import 'package:tekpayapp/services/connectivity_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize services
  await StorageService.init();
  await Get.put(ConnectivityService()).init();

  print(StorageService.getToken());

  // Initialize services and controllers in correct order
  Get.put(ApiService());
  Get.put(AuthService());
  Get.put(AuthController());
  Get.put(UserController());
  Get.put(TransferController());
  Get.put(VirtualAccountController());
  Get.put(NotificationController()); // Add NotificationController

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Tekpay',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
