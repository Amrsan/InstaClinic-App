import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  final SupabaseClient _supabase = Supabase.instance.client;

  String? _fcmToken;
  bool _isInitialized = false;

  String? get fcmToken => _fcmToken;
  bool get isInitialized => _isInitialized;

  /// Initialize FCM service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request notification permissions for both platforms
      await _requestNotificationPermissions();

      // Initialize local notifications first
      await _initializeLocalNotifications();

      // Get FCM token with retry mechanism
      _fcmToken = await _getFCMTokenWithRetry();
      print('🔔 FCM Token: $_fcmToken');
      print('📱 Device FCM Token for notifications: $_fcmToken');

      // Automatically save token to Supabase (check if exists first)
      if (_fcmToken != null) {
        await _saveTokenIfNotExists(_fcmToken!);
      } else if (Platform.isIOS) {
        // For iOS, try to get token after a delay if APNS token wasn't ready
        print('📱 iOS: FCM token not available immediately, will retry after delay...');
        _retryTokenAfterDelay();
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((token) async {
        _fcmToken = token;
        print('🔄 FCM Token refreshed: $token');
        // Save updated token to Supabase (check if exists first)
        await _saveTokenIfNotExists(token);
      });

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification tap when app is opened from notification
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Handle notification tap when app is terminated
      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      _isInitialized = true;
      print('FCM Service initialized successfully');
    } catch (e) {
      print('Error initializing FCM: $e');
      // Don't set _isInitialized to false, so we can retry
    }
  }

  /// Request notification permissions for both platforms
  Future<void> _requestNotificationPermissions() async {
    try {
      if (Platform.isIOS) {
        // iOS permission request
        print('📱 Requesting iOS notification permissions...');
        NotificationSettings settings = await _firebaseMessaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        print('📱 iOS permission status: ${settings.authorizationStatus}');
        
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          print('📱 iOS notifications authorized');
        } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
          print('📱 iOS notifications denied - user needs to enable in Settings');
        } else {
          print('📱 iOS notifications status: ${settings.authorizationStatus}');
        }

      } else if (Platform.isAndroid) {
        // Android permission request
        print('🤖 Requesting Android notification permissions...');
        
        // Check current notification settings
        NotificationSettings settings = await _firebaseMessaging.getNotificationSettings();
        print('🤖 Current Android notification settings:');
        print('   - Authorization Status: ${settings.authorizationStatus}');
        print('   - Alert: ${settings.alert}');
        print('   - Badge: ${settings.badge}');
        print('   - Sound: ${settings.sound}');
        
        // Request permissions for Android
        NotificationSettings newSettings = await _firebaseMessaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        
        print('🤖 Android permission request result:');
        print('   - Authorization Status: ${newSettings.authorizationStatus}');
        print('   - Alert: ${newSettings.alert}');
        print('   - Badge: ${newSettings.badge}');
        print('   - Sound: ${newSettings.sound}');
        
        // Check if permissions were granted
        if (newSettings.authorizationStatus == AuthorizationStatus.authorized) {
          print('✅ Android notification permissions granted successfully');
        } else if (newSettings.authorizationStatus == AuthorizationStatus.denied) {
          print('❌ Android notification permissions denied');
          print('🤖 User will need to enable notifications manually in device settings');
        } else if (newSettings.authorizationStatus == AuthorizationStatus.notDetermined) {
          print('⏳ Android notification permissions not determined yet');
        }
      }
    } catch (e) {
      print('❌ Error requesting notification permissions: $e');
    }
  }

  /// Get FCM token with retry mechanism
  Future<String?> _getFCMTokenWithRetry() async {
    int maxRetries = 3;
    int currentRetry = 0;
    
    while (currentRetry < maxRetries) {
      try {
        // For iOS, ensure APNS token is available first
        if (Platform.isIOS) {
          await _ensureAPNSTokenIsSet();
        }
        
        String? token = await _firebaseMessaging.getToken();
        if (token != null && token.isNotEmpty) {
          return token;
        }
        print('📱 FCM token is null or empty, retrying... (${currentRetry + 1}/$maxRetries)');
        currentRetry++;

      } catch (e) {
        print('📱 Error getting FCM token: $e');
        currentRetry++;

      }
    }
    
    print('❌ Failed to get FCM token after $maxRetries retries');
    return null;
  }

  /// Ensure APNS token is set for iOS
  Future<void> _ensureAPNSTokenIsSet() async {
    if (!Platform.isIOS) return;
    
    try {
      // First, request notification permissions explicitly
      await _requestNotificationPermissions();
      
      // Wait for APNS token to be available
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      
      if (apnsToken == null) {
        print('📱 APNS token not available, waiting...');
        // Wait a bit for APNS token to be set
        await Future.delayed(const Duration(seconds: 2));
        
        // Try again
        apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken == null) {
          print('📱 APNS token still not available after waiting');
          print('📱 Make sure Push Notifications capability is enabled in Xcode');
        } else {
          print('📱 APNS token is now available');
        }
      } else {
        print('📱 APNS token is available');
      }
    } catch (e) {
      print('📱 Error checking APNS token: $e');
    }
  }


  /// Retry getting FCM token after a delay (for iOS)
  void _retryTokenAfterDelay() {
    Future.delayed(const Duration(seconds: 1), () async {
      try {
        print('📱 iOS: Retrying FCM token retrieval...');
        String? token = await _firebaseMessaging.getToken();
        if (token != null && token.isNotEmpty) {
          _fcmToken = token;
          print('✅ iOS: FCM token retrieved after delay: $token');
          await _saveTokenIfNotExists(token);
        } else {
          print('❌ iOS: FCM token still not available after delay');
        }
      } catch (e) {
        print('❌ iOS: Error getting FCM token after delay: $e');
      }
    });
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      print('🤖 Creating Android notification channels...');
      
      // High importance channel for critical notifications
      const AndroidNotificationChannel highImportanceChannel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications like appointments and emergencies.',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      // Default channel for general notifications
      const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
        'default_channel',
        'General Notifications',
        description: 'This channel is used for general app notifications.',
        importance: Importance.defaultImportance,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      // Low importance channel for informational notifications
      const AndroidNotificationChannel lowImportanceChannel = AndroidNotificationChannel(
        'low_importance_channel',
        'Informational Notifications',
        description: 'This channel is used for informational notifications.',
        importance: Importance.low,
        playSound: false,
        enableVibration: false,
        showBadge: false,
      );

      // Custom channel for custom notifications
      const AndroidNotificationChannel customChannel = AndroidNotificationChannel(
        'custom_channel',
        'Custom Notifications',
        description: 'This channel is used for custom notifications.',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(highImportanceChannel);
        await androidPlugin.createNotificationChannel(defaultChannel);
        await androidPlugin.createNotificationChannel(lowImportanceChannel);
        await androidPlugin.createNotificationChannel(customChannel);
        print('✅ Android notification channels created successfully');
      } else {
        print('❌ Android notification plugin not available');
      }
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      _showLocalNotification(message);
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    print('Notification tapped: ${message.data}');
    
    // Handle navigation based on notification data
    if (message.data.containsKey('route')) {
      String route = message.data['route'];
      Get.toNamed(route);
    }
  }

  /// Handle local notification tap
  void _onNotificationTap(NotificationResponse response) {
    print('Local notification tapped: ${response.payload}');
    
    if (response.payload != null) {
      Map<String, dynamic> data = json.decode(response.payload!);
      if (data.containsKey('route')) {
        String route = data['route'];
        Get.toNamed(route);
      }
    }
  }

  /// Show local notification with custom design
  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        // Using default system sound instead of custom sound
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        color: Color(0xFF006868), // Your app's primary color
        styleInformation: BigTextStyleInformation(''),
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        // Using default system sound instead of custom sound
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _localNotifications.show(
        message.hashCode,
        message.notification?.title ?? 'InstaClinics',
        message.notification?.body ?? '',
        platformChannelSpecifics,
        payload: json.encode(message.data),
      );
      
      print('✅ Local notification shown successfully');
    } catch (e) {
      print('❌ Error showing local notification: $e');
      // Fallback to basic notification without custom styling
      try {
        await _localNotifications.show(
          message.hashCode,
          message.notification?.title ?? 'InstaClinics',
          message.notification?.body ?? '',
          const NotificationDetails(),
        );
        print('✅ Fallback notification shown successfully');
      } catch (fallbackError) {
        print('❌ Fallback notification also failed: $fallbackError');
      }
    }
  }

  /// Subscribe to topics
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  /// Unsubscribe from topics
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }

  /// Print current FCM token to console
  void printFCMToken() {
    if (_fcmToken != null) {
      print('🔔 Current FCM Token: $_fcmToken');
      print('📱 Device FCM Token: $_fcmToken');
    } else {
      print('❌ FCM Token is null - FCM not initialized yet');
      print('🔄 Try calling retryFCMToken() to regenerate the token');
    }
  }

  /// Manually request notification permissions
  Future<void> requestPermissions() async {
    print('🔔 Manually requesting notification permissions...');
    await _requestNotificationPermissions();
  }

  /// Check current notification permission status
  Future<void> checkPermissionStatus() async {
    print('🔍 Checking notification permission status...');
    try {
      NotificationSettings settings = await _firebaseMessaging.getNotificationSettings();
      
      if (Platform.isAndroid) {
        print('🤖 Android Notification Permission Status:');
      } else if (Platform.isIOS) {
        print('📱 iOS Notification Permission Status:');
      }
      
      print('   - Authorization Status: ${settings.authorizationStatus}');
      print('   - Alert: ${settings.alert}');
      print('   - Badge: ${settings.badge}');
      print('   - Sound: ${settings.sound}');
      
      // Provide user-friendly status
      switch (settings.authorizationStatus) {
        case AuthorizationStatus.authorized:
          print('✅ Notifications are fully enabled');
          break;
        case AuthorizationStatus.denied:
          print('❌ Notifications are disabled');
          print('💡 User needs to enable notifications in device settings');
          break;
        case AuthorizationStatus.notDetermined:
          print('⏳ Permission not yet requested');
          break;
        case AuthorizationStatus.provisional:
          print('⚠️ Provisional permission granted');
          break;
      }
    } catch (e) {
      print('❌ Error checking permission status: $e');
    }
  }

  /// Show permission request dialog for Android
  Future<void> showPermissionDialog() async {
    if (!Platform.isAndroid) return;
    
    print('🤖 Showing Android permission request dialog...');
    
    try {
      // Check current status first
      NotificationSettings currentSettings = await _firebaseMessaging.getNotificationSettings();
      
      if (currentSettings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ Notifications already enabled');
        return;
      }
      
      // Request permissions
      NotificationSettings newSettings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      print('🤖 Permission request result: ${newSettings.authorizationStatus}');
      
      if (newSettings.authorizationStatus == AuthorizationStatus.denied) {
        print('❌ Permission denied. User needs to enable manually in settings.');
        // You could show a custom dialog here to guide users to settings
      }
    } catch (e) {
      print('❌ Error showing permission dialog: $e');
    }
  }

  /// Get permission status as a simple boolean
  Future<bool> areNotificationsEnabled() async {
    try {
      NotificationSettings settings = await _firebaseMessaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized;
    } catch (e) {
      print('❌ Error checking if notifications are enabled: $e');
      return false;
    }
  }

  /// Get FCM token as string for easy copying
  String? getFCMTokenString() {
    return _fcmToken;
  }

  /// Manually save current FCM token to Supabase
  Future<void> saveCurrentTokenToSupabase() async {
    if (_fcmToken != null) {
      await _saveTokenIfNotExists(_fcmToken!);
    } else {
      print('❌ No FCM token available to save');
    }
  }

  /// Handle authentication state changes and save token when user logs in
  Future<void> handleAuthStateChange() async {
    try {
      // Listen to Supabase auth state changes
      _supabase.auth.onAuthStateChange.listen((data) async {
        if (_fcmToken != null) {
          if (data.event == AuthChangeEvent.signedIn) {
            print('🔔 User signed in, updating FCM token with user ID...');
            await _saveTokenIfNotExists(_fcmToken!);
          } else if (data.event == AuthChangeEvent.signedOut) {
            print('🔔 User signed out, updating FCM token to anonymous...');
            await _saveTokenIfNotExists(_fcmToken!);
          } else if (data.event == AuthChangeEvent.initialSession) {
            print('🔔 Initial session, saving FCM token...');
            await _saveTokenIfNotExists(_fcmToken!);
          }
        }
      });
    } catch (e) {
      print('❌ Error handling auth state change: $e');
    }
  }

  /// Get all device tokens for a specific user
  Future<List<Map<String, dynamic>>> getUserDeviceTokens(String userId) async {
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

  /// Get all active device tokens (for sending notifications)
  Future<List<Map<String, dynamic>>> getAllActiveDeviceTokens() async {
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
  Future<List<Map<String, dynamic>>> getAnonymousDeviceTokens() async {
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
  Future<List<Map<String, dynamic>>> getAuthenticatedDeviceTokens() async {
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

  /// Deactivate a specific device token
  Future<void> deactivateDeviceToken(String fcmToken) async {
    try {
      await _supabase
          .from('device_tokens')
          .update({'is_active': false})
          .eq('fcm_token', fcmToken);
      
      print('✅ Device token deactivated: $fcmToken');
    } catch (e) {
      print('❌ Error deactivating device token: $e');
    }
  }


  /// Save FCM token to Supabase device_tokens table (check if exists first)
  Future<void> _saveTokenIfNotExists(String fcmToken) async {
    try {
      // Get current user (can be null for unauthenticated users)
      final user = _supabase.auth.currentUser;
      final userId = user?.id;

      // Check if token already exists for this user (or null for unauthenticated)
      final existingToken = await _supabase
          .from('device_tokens')
          .select('id, fcm_token, is_active, user_id')
          .eq('fcm_token', fcmToken)
          .maybeSingle();

      if (existingToken != null) {
        // Token exists, just update is_active and updated_at
        await _supabase
            .from('device_tokens')
            .update({
              'user_id': userId, // Update user_id in case user logged in/out
              'is_active': true,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', existingToken['id']);
        
        final userType = userId != null ? 'authenticated user' : 'anonymous user';
        print('✅ FCM token already exists, updated status for $userType');
        return;
      }

      // Token doesn't exist, create new entry
      final deviceInfo = await _getDeviceInfo();
      
      await _supabase.from('device_tokens').insert({
        'user_id': userId, // Can be null for unauthenticated users
        'fcm_token': fcmToken,
        'device_type': deviceInfo['device_type'],
        'device_id': deviceInfo['device_id'],
        'app_version': deviceInfo['app_version'],
        'is_active': true,
      });

      final userType = userId != null ? 'authenticated user' : 'anonymous user';
      print('✅ New FCM token saved to Supabase for $userType');
    } catch (e) {
      print('❌ Error saving FCM token to Supabase: $e');
    }
  }


  /// Get device information for token storage
  Future<Map<String, String>> _getDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final packageInfo = await PackageInfo.fromPlatform();
      
      String deviceType = 'android';
      String deviceId = 'unknown';
      
      if (Platform.isIOS) {
        deviceType = 'ios';
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'unknown';
      } else if (Platform.isAndroid) {
        deviceType = 'android';
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      }
      
      return {
        'device_type': deviceType,
        'device_id': deviceId,
        'app_version': packageInfo.version,
      };
    } catch (e) {
      print('❌ Error getting device info: $e');
      return {
        'device_type': Platform.isIOS ? 'ios' : 'android',
        'device_id': 'unknown',
        'app_version': 'unknown',
      };
    }
  }

  /// Send FCM token to your server
  Future<void> sendTokenToServer(String userId) async {
    if (_fcmToken == null) return;

    try {
      // TODO: Implement your server API call here
      // Example:
      // await ApiService.sendFCMToken(userId, _fcmToken!);
      print('FCM token sent to server for user: $userId');
    } catch (e) {
      print('Error sending FCM token to server: $e');
    }
  }

  /// Show custom notification manually
  Future<void> showCustomNotification({
    required String title,
    required String body,
    String? payload,
    String? route,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'custom_channel',
        'Custom Notifications',
        channelDescription: 'This channel is used for custom notifications.',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        color: Color(0xFF006868),
        styleInformation: BigTextStyleInformation(''),
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      Map<String, dynamic> data = {
        'title': title,
        'body': body,
        'route': route,
      };

      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        platformChannelSpecifics,
        payload: json.encode(data),
      );
      
      print('✅ Custom notification shown successfully');
    } catch (e) {
      print('❌ Error showing custom notification: $e');
      // Fallback to basic notification without custom styling
      try {
        await _localNotifications.show(
          DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title,
          body,
          const NotificationDetails(),
          payload: json.encode({
            'title': title,
            'body': body,
            'route': route,
          }),
        );
        print('✅ Fallback custom notification shown successfully');
      } catch (fallbackError) {
        print('❌ Fallback custom notification also failed: $fallbackError');
      }
    }
  }
}

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
} 