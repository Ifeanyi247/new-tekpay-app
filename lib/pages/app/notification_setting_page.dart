import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/notification_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationSettingPage extends StatefulWidget {
  const NotificationSettingPage({super.key});

  @override
  State<NotificationSettingPage> createState() =>
      _NotificationSettingPageState();
}

class _NotificationSettingPageState extends State<NotificationSettingPage> {
  bool _paymentsEnabled = false;
  bool _messagesEnabled = false;
  bool _activitiesEnabled = false;
  final NotificationController _notificationController =
      Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  Future<void> _checkNotificationStatus() async {
    final settings = await FirebaseMessaging.instance.getNotificationSettings();
    final bool isEnabled =
        settings.authorizationStatus == AuthorizationStatus.authorized;
    setState(() {
      _paymentsEnabled = isEnabled;
      _messagesEnabled = isEnabled;
      _activitiesEnabled = isEnabled;
    });
  }

  Future<void> _handleNotificationToggle(bool value, String type) async {
    if (value) {
      // If enabling any notification, request permissions
      final settings =
          await _notificationController.requestNotificationPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        setState(() {
          switch (type) {
            case 'payments':
              _paymentsEnabled = true;
              break;
            case 'messages':
              _messagesEnabled = true;
              break;
            case 'activities':
              _activitiesEnabled = true;
              break;
          }
        });
        // Register device token when notifications are enabled
        await _notificationController.registerDeviceToken();
      } else {
        // Show dialog if permission denied
        Get.dialog(
          AlertDialog(
            title: const Text('Notification Permission Required'),
            content: const Text(
                'Please enable notifications in your device settings to receive updates.'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        setState(() {
          switch (type) {
            case 'payments':
              _paymentsEnabled = false;
              break;
            case 'messages':
              _messagesEnabled = false;
              break;
            case 'activities':
              _activitiesEnabled = false;
              break;
          }
        });
      }
    } else {
      setState(() {
        switch (type) {
          case 'payments':
            _paymentsEnabled = false;
            break;
          case 'messages':
            _messagesEnabled = false;
            break;
          case 'activities':
            _activitiesEnabled = false;
            break;
        }
      });
    }
  }

  Widget _buildNotificationOption({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primaryColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications Settings',
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
              'Select your notification preferences',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24.h),
            _buildNotificationOption(
              title: 'Payments',
              subtitle: 'Transactions related',
              value: _paymentsEnabled,
              onChanged: (value) =>
                  _handleNotificationToggle(value, 'payments'),
            ),
            _buildNotificationOption(
              title: 'Messages',
              subtitle: 'Chat and support related',
              value: _messagesEnabled,
              onChanged: (value) =>
                  _handleNotificationToggle(value, 'messages'),
            ),
            _buildNotificationOption(
              title: 'Activities',
              subtitle: 'Account activities and updates',
              value: _activitiesEnabled,
              onChanged: (value) =>
                  _handleNotificationToggle(value, 'activities'),
            ),
          ],
        ),
      ),
    );
  }
}
