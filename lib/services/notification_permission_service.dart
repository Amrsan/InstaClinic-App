import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPermissionService {
  static final NotificationPermissionService _instance = NotificationPermissionService._internal();
  factory NotificationPermissionService() => _instance;
  NotificationPermissionService._internal();

  static const String _permissionRequestedKey = 'notification_permission_requested';

  Future<bool> hasRequestedPermission() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_permissionRequestedKey) ?? false;
  }

  Future<void> markPermissionRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_permissionRequestedKey, true);
  }

  Future<bool> requestNotificationPermission(BuildContext context) async {
    if (await hasRequestedPermission()) {
      return await _checkCurrentPermission();
    }

    final result = await _showPermissionDialog(context);
    if (result) {
      await markPermissionRequested();
      return await _requestActualPermission();
    }
    return false;
  }

  Future<bool> _showPermissionDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.notifications_active, color: Color(0xFF006868)),
              SizedBox(width: 8),
              Text('Enable Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stay updated with important health information:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16),
              _buildFeatureItem('📅 Appointment Reminders', 'Never miss your scheduled appointments'),
              _buildFeatureItem('💳 Payment Confirmations', 'Get notified when payments are processed'),
              _buildFeatureItem('🚨 Emergency Services', 'Immediate alerts for urgent care needs'),
              _buildFeatureItem('🏥 Health Updates', 'Important updates about your health services'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Not Now', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF006868),
                foregroundColor: Colors.white,
              ),
              child: Text('Enable'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _requestActualPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      return settings.authorizationStatus == AuthorizationStatus.authorized ||
             settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      print('Error requesting notification permission: $e');
      return false;
    }
  }

  Future<bool> _checkCurrentPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
             settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      print('Error checking notification permission: $e');
      return false;
    }
  }

  Future<void> showSettingsDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notification Permission Required'),
          content: Text(
            'To receive important notifications, please enable notifications for this app in your device settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF006868),
                foregroundColor: Colors.white,
              ),
              child: Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _openAppSettings() {
    // This would typically open the app settings
    // For now, we'll just print a message
    print('Open app settings to enable notifications');
  }
} 