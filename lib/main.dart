import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/controllers/auth_controller.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/splash_screen.dart';
import 'package:tekpayapp/services/api_service.dart';
import 'package:tekpayapp/services/auth_service.dart';
import 'package:tekpayapp/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  print(StorageService.getToken());

  // Initialize services and controllers in correct order
  Get.put(ApiService());
  Get.put(AuthService());
  Get.put(AuthController());
  Get.put(UserController());

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
