import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class NotificationExamples {
  static final NotificationController _notificationController = Get.find<NotificationController>();

  /// Example: Show booking confirmation notification
  static Future<void> showBookingConfirmation() async {
    await _notificationController.showBookingNotification(
      serviceName: 'Dialysis Service',
      date: 'Monday, 15 January 2024',
      time: '10:00 AM',
      route: '/bookings',
    );
  }

  /// Example: Show payment success notification
  static Future<void> showPaymentSuccess() async {
    await _notificationController.showPaymentNotification(
      amount: 'EGP 500.00',
      serviceName: 'Dialysis Service',
      route: '/payments',
    );
  }

  /// Example: Show emergency service notification
  static Future<void> showEmergencyService() async {
    await _notificationController.showEmergencyNotification(
      serviceName: 'Emergency Nursing',
      route: '/emergency',
    );
  }

  /// Example: Show appointment reminder
  static Future<void> showAppointmentReminder() async {
    await _notificationController.showReminderNotification(
      serviceName: 'Consultation',
      date: 'Tomorrow, 16 January 2024',
      time: '2:00 PM',
      route: '/appointments',
    );
  }

  /// Example: Show custom notification
  static Future<void> showCustomNotification() async {
    await _notificationController.showGeneralNotification(
      title: 'Welcome to InstaClinics!',
      message: 'Thank you for choosing our healthcare services. We\'re here to help you stay healthy.',
      route: '/home',
    );
  }

  /// Example: Subscribe to topics
  static Future<void> subscribeToTopics() async {
    // Subscribe to general notifications
    await _notificationController.subscribeToTopic('general');
    
    // Subscribe to booking notifications
    await _notificationController.subscribeToTopic('bookings');
    
    // Subscribe to payment notifications
    await _notificationController.subscribeToTopic('payments');
    
    // Subscribe to emergency notifications
    await _notificationController.subscribeToTopic('emergency');
  }

  /// Example: Send FCM token to server
  static Future<void> sendTokenToServer(String userId) async {
    await _notificationController.sendTokenToServer(userId);
  }

  /// Example: Get FCM token
  static String? getFCMToken() {
    return _notificationController.fcmToken;
  }

  /// Example: Print FCM token to console
  static void printFCMToken() {
    _notificationController.printFCMToken();
  }

  /// Example: Check if FCM is initialized
  static bool isFCMInitialized() {
    return _notificationController.isInitialized;
  }
}

// Usage examples:
/*
// 1. Show booking confirmation
await NotificationExamples.showBookingConfirmation();

// 2. Show payment success
await NotificationExamples.showPaymentSuccess();

// 3. Show emergency service notification
await NotificationExamples.showEmergencyService();

// 4. Show appointment reminder
await NotificationExamples.showAppointmentReminder();

// 5. Show custom notification
await NotificationExamples.showCustomNotification();

// 6. Subscribe to topics
await NotificationExamples.subscribeToTopics();

// 7. Send token to server
await NotificationExamples.sendTokenToServer('user123');

// 8. Get FCM token
String? token = NotificationExamples.getFCMToken();

// 9. Check initialization
bool isInitialized = NotificationExamples.isFCMInitialized();
*/ 