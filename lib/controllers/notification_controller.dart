import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/firebase_options.dart';
import 'package:tekpayapp/services/api_service.dart';

class NotificationController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final ApiService _apiService = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    try {
      // Request permission (required for iOS)
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      print('Notification permission status: ${settings.authorizationStatus}');

      // Configure handlers for different notification scenarios
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      // Enable foreground notifications
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  Future<void> registerDeviceToken() async {
    try {
      // Check if Firebase is already initialized
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      // Check notification permissions first
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        print('Notification permissions not granted');
        return;
      }

      final token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      if (token != null) {
        try {
          await _apiService.post('device-token', body: {
            'device_token': token,
            'device_type': GetPlatform.isIOS ? 'ios' : 'android',
          });
          print('Successfully registered device token with backend');

          // Listen for token refresh
          _firebaseMessaging.onTokenRefresh.listen((newToken) async {
            print('New FCM Token: $newToken');
            try {
              await _apiService.post('device-token', body: {
                'device_token': newToken,
                'device_type': GetPlatform.isIOS ? 'ios' : 'android',
              });
              print('Successfully registered refreshed token with backend');
            } catch (refreshError) {
              print('Error registering refreshed token: $refreshError');
            }
          });
        } catch (apiError) {
          print('Error registering token with backend: $apiError');
          // Don't rethrow API errors - just log them
        }
      } else {
        print('Failed to get FCM token - token is null');
      }
    } catch (e) {
      print('Error registering device token: $e');
      print(StackTrace.current);
      // Don't rethrow the error to prevent login flow disruption
    }
  }

  Future<NotificationSettings> requestNotificationPermission() async {
    try {
      // Check if Firebase is already initialized
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      // Request permission
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      print('Notification permission status: ${settings.authorizationStatus}');
      return settings;
    } catch (e) {
      print('Error requesting notification permission: $e');
      print(StackTrace.current);
      rethrow;
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('Received foreground message: ${message.messageId}');

    if (message.notification != null) {
      Get.snackbar(
        message.notification?.title ?? 'New Notification',
        message.notification?.body ?? '',
        duration: const Duration(seconds: 3),
      );
    }

    // Handle data payload
    if (message.data.isNotEmpty) {
      _handleNotificationData(message.data);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print('App opened from background notification: ${message.messageId}');
    _handleNotificationData(message.data);
  }

  void _handleNotificationData(Map<String, dynamic> data) {
    // Handle different types of notifications based on data
    switch (data['type']) {
      case 'transaction':
        // Navigate to transaction details
        if (data['transaction_id'] != null) {
          // Get.toNamed('/transaction/${data['transaction_id']}');
        }
        break;
      case 'message':
        // Navigate to messages
        // Get.toNamed('/messages');
        break;
      default:
        print('Unknown notification type: ${data['type']}');
    }
  }
}

// Top-level function to handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');
  // Add any background message handling logic here
}
