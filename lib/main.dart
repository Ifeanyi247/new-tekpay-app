import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/controllers/auth_controller.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/controllers/transfer_controller.dart';
import 'package:tekpayapp/controllers/virtual_account_controller.dart';
import 'package:tekpayapp/controllers/notification_controller.dart';
import 'package:tekpayapp/pages/splash_screen.dart';
import 'package:tekpayapp/pages/auth/locked_page.dart';
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

  // Initialize services and controllers in correct order
  final apiService = Get.put(ApiService());
  Get.put(AuthService());
  Get.put(AuthController());
  Get.put(UserController());
  Get.put(TransferController());
  Get.put(VirtualAccountController());
  Get.put(NotificationController());

  // Set API token if it exists
  final token = StorageService.getToken();
  if (token != null && token.isNotEmpty) {
    apiService.setAuthToken(token);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLifecycleManager(
      child: ScreenUtilInit(
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
      ),
    );
  }
}

class AppLifecycleManager extends StatefulWidget {
  final Widget child;
  const AppLifecycleManager({super.key, required this.child});

  @override
  State<AppLifecycleManager> createState() => _AppLifecycleManagerState();
}

class _AppLifecycleManagerState extends State<AppLifecycleManager>
    with WidgetsBindingObserver {
  bool _wasInBackground = false;
  AuthController? _authController;
  UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Try to get AuthController, but don't throw error if not ready
    try {
      _authController = Get.find<AuthController>();
    } catch (_) {
      // Will try again in didChangeDependencies
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Try to get AuthController if not already obtained
    if (_authController == null) {
      try {
        _authController = Get.find<AuthController>();
      } catch (_) {
        // Will try again on next frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() {});
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('App lifecycle state changed to: $state');

    // Get auth controller if not already obtained
    if (_authController == null) {
      try {
        _authController = Get.find<AuthController>();
      } catch (_) {
        print('AuthController not yet available');
        return;
      }
    }

    // Only lock when app actually goes to background (paused)
    // Ignore inactive state which happens during notification shade
    if (state == AppLifecycleState.paused) {
      print('App entered background');
      _wasInBackground = true;
    } else if (state == AppLifecycleState.resumed) {
      print('App resumed from background');
      if (_wasInBackground && userController.user.value != null) {
        print('User is logged in, redirecting to LockedPage');
        Get.offAll(() => const LockedPage(), transition: Transition.fadeIn);
        _wasInBackground = false;
      } else {
        print(
            'Not redirecting to LockedPage. Background: $_wasInBackground, LoggedIn: ${_authController?.isLoggedIn}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
