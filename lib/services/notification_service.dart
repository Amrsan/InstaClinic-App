import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Send notification to a specific user
  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Get user's device tokens
      final tokens = await _getUserDeviceTokens(userId);
      
      if (tokens.isEmpty) {
        print('❌ No device tokens found for user: $userId');
        return;
      }

      // Send notification to each device
      for (final token in tokens) {
        await _sendFCMNotification(
          fcmToken: token['fcm_token'],
          title: title,
          body: body,
          data: data,
        );
      }

      print('✅ Notification sent to ${tokens.length} device(s) for user: $userId');
    } catch (e) {
      print('❌ Error sending notification to user: $e');
    }
  }

  /// Send notification to all active users (authenticated + anonymous)
  Future<void> sendNotificationToAll({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Get all active device tokens
      final tokens = await _getAllActiveDeviceTokens();
      
      if (tokens.isEmpty) {
        print('❌ No active device tokens found');
        return;
      }

      // Send notification to each device
      for (final token in tokens) {
        await _sendFCMNotification(
          fcmToken: token['fcm_token'],
          title: title,
          body: body,
          data: data,
        );
      }

      print('✅ Notification sent to ${tokens.length} device(s)');
    } catch (e) {
      print('❌ Error sending notification to all users: $e');
    }
  }

  /// Send notification to anonymous users only
  Future<void> sendNotificationToAnonymous({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Get anonymous device tokens
      final tokens = await _getAnonymousDeviceTokens();
      
      if (tokens.isEmpty) {
        print('❌ No anonymous device tokens found');
        return;
      }

      // Send notification to each device
      for (final token in tokens) {
        await _sendFCMNotification(
          fcmToken: token['fcm_token'],
          title: title,
          body: body,
          data: data,
        );
      }

      print('✅ Notification sent to ${tokens.length} anonymous device(s)');
    } catch (e) {
      print('❌ Error sending notification to anonymous users: $e');
    }
  }

  /// Send notification to authenticated users only
  Future<void> sendNotificationToAuthenticated({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Get authenticated device tokens
      final tokens = await _getAuthenticatedDeviceTokens();
      
      if (tokens.isEmpty) {
        print('❌ No authenticated device tokens found');
        return;
      }

      // Send notification to each device
      for (final token in tokens) {
        await _sendFCMNotification(
          fcmToken: token['fcm_token'],
          title: title,
          body: body,
          data: data,
        );
      }

      print('✅ Notification sent to ${tokens.length} authenticated device(s)');
    } catch (e) {
      print('❌ Error sending notification to authenticated users: $e');
    }
  }

  /// Get device tokens for a specific user
  Future<List<Map<String, dynamic>>> _getUserDeviceTokens(String userId) async {
    try {
      final response = await _supabase
          .from('device_tokens')
          .select('*')
          .eq('user_id', userId)
          .eq('is_active', true);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error getting user device tokens: $e');
      return [];
    }
  }

  /// Get all active device tokens
  Future<List<Map<String, dynamic>>> _getAllActiveDeviceTokens() async {
    try {
      final response = await _supabase
          .from('device_tokens')
          .select('*')
          .eq('is_active', true);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error getting all device tokens: $e');
      return [];
    }
  }

  /// Get device tokens for anonymous users (user_id is null)
  Future<List<Map<String, dynamic>>> _getAnonymousDeviceTokens() async {
    try {
      final response = await _supabase
          .from('device_tokens')
          .select('*')
          .isFilter('user_id', null)
          .eq('is_active', true);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error getting anonymous device tokens: $e');
      return [];
    }
  }

  /// Get device tokens for authenticated users only
  Future<List<Map<String, dynamic>>> _getAuthenticatedDeviceTokens() async {
    try {
      final response = await _supabase
          .from('device_tokens')
          .select('*')
          .not('user_id', 'is', null)
          .eq('is_active', true);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error getting authenticated device tokens: $e');
      return [];
    }
  }

  /// Send FCM notification using Firebase Admin SDK
  Future<void> _sendFCMNotification({
    required String fcmToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // You'll need to implement this using Firebase Admin SDK
      // For now, this is a placeholder that shows the structure
      
      final payload = {
        'to': fcmToken,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': data ?? {},
      };

      print('📱 Would send FCM notification to: $fcmToken');
      print('📱 Title: $title');
      print('📱 Body: $body');
      print('📱 Data: $data');
      
      // TODO: Implement actual FCM sending using Firebase Admin SDK
      // This requires server-side implementation
      
    } catch (e) {
      print('❌ Error sending FCM notification: $e');
    }
  }

  /// Get notification statistics
  Future<Map<String, int>> getNotificationStats() async {
    try {
      final response = await _supabase
          .from('device_tokens')
          .select('device_type, is_active');
      
      final tokens = List<Map<String, dynamic>>.from(response);
      
      int totalTokens = tokens.length;
      int activeTokens = tokens.where((token) => token['is_active'] == true).length;
      int iosTokens = tokens.where((token) => token['device_type'] == 'ios').length;
      int androidTokens = tokens.where((token) => token['device_type'] == 'android').length;
      
      return {
        'total_tokens': totalTokens,
        'active_tokens': activeTokens,
        'ios_tokens': iosTokens,
        'android_tokens': androidTokens,
      };
    } catch (e) {
      print('❌ Error getting notification stats: $e');
      return {};
    }
  }
}
