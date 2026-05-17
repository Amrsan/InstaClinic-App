import 'package:get/get.dart';
import '../services/fcm_service.dart';

class NotificationController extends GetxController {
  final FCMService _fcmService = Get.find<FCMService>();
  
  String? get fcmToken => _fcmService.fcmToken;
  bool get isInitialized => _fcmService.isInitialized;

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    await _fcmService.subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcmService.unsubscribeFromTopic(topic);
  }

  /// Send FCM token to server
  Future<void> sendTokenToServer(String userId) async {
    await _fcmService.sendTokenToServer(userId);
  }

  /// Show custom notification
  Future<void> showCustomNotification({
    required String title,
    required String body,
    String? route,
  }) async {
    await _fcmService.showCustomNotification(
      title: title,
      body: body,
      route: route,
    );
  }

  /// Show booking confirmation notification
  Future<void> showBookingNotification({
    required String serviceName,
    required String date,
    required String time,
    String? route,
  }) async {
    await showCustomNotification(
      title: 'Booking Confirmed',
      body: 'Your $serviceName appointment on $date at $time has been confirmed.',
      route: route ?? '/bookings',
    );
  }

  /// Show payment notification
  Future<void> showPaymentNotification({
    required String amount,
    required String serviceName,
    String? route,
  }) async {
    await showCustomNotification(
      title: 'Payment Successful',
      body: 'Payment of $amount for $serviceName has been processed successfully.',
      route: route ?? '/payments',
    );
  }

  /// Show emergency service notification
  Future<void> showEmergencyNotification({
    required String serviceName,
    String? route,
  }) async {
    await showCustomNotification(
      title: 'Emergency Service Requested',
      body: 'Your emergency $serviceName request has been received. We will contact you shortly.',
      route: route ?? '/emergency',
    );
  }

  /// Show reminder notification
  Future<void> showReminderNotification({
    required String serviceName,
    required String date,
    required String time,
    String? route,
  }) async {
    await showCustomNotification(
      title: 'Appointment Reminder',
      body: 'Reminder: Your $serviceName appointment is scheduled for $date at $time.',
      route: route ?? '/appointments',
    );
  }

  /// Show general notification
  Future<void> showGeneralNotification({
    required String title,
    required String message,
    String? route,
  }) async {
    await showCustomNotification(
      title: title,
      body: message,
      route: route,
    );
  }

  /// Print FCM token to console
  void printFCMToken() {
    _fcmService.printFCMToken();
  }
} 