# 🔔 FCM Notification Testing Guide

This guide will help you test Firebase Cloud Messaging (FCM) notifications in your InstaClinics app.

## 📱 How to Get FCM Token

### Method 1: Using the App (Recommended)
1. Run the app in debug mode: `flutter run --debug`
2. Navigate to Profile screen
3. Scroll down to find the "🔔 FCM Testing (Development)" section
4. Tap "Print FCM Token" button
5. Check the console logs for the token

### Method 2: Using Test Script
```bash
# Run the test script to get FCM token
dart test_fcm_token.dart
```

### Method 3: Check Console Logs
When the app starts, the FCM token is automatically printed to the console:
```
🔔 FCM Token: your_token_here
📱 Device FCM Token for notifications: your_token_here
```

## 🧪 Testing Notifications

### Method 1: Using App Test Buttons
1. Go to Profile screen
2. Find "🔔 FCM Testing (Development)" section
3. Use the test buttons:
   - **Print FCM Token**: Prints token to console
   - **Test Notification**: Sends a basic test notification
   - **Custom Test Notification**: Sends a custom notification

### Method 2: Using Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Messaging** > **Send your first message**
4. Fill in the notification details:
   - **Title**: Test Notification
   - **Body**: This is a test notification
   - **Target**: Single device
   - **FCM registration token**: Paste your FCM token
5. Click **Send**

### Method 3: Using Curl Script
1. Get your Firebase Server Key:
   - Go to Firebase Console > Project Settings > Cloud Messaging
   - Copy the Server key
2. Update the `test_notification.sh` script with your server key
3. Run the script:
```bash
./test_notification.sh "your_fcm_token_here"
```

### Method 4: Using Postman
1. Create a new POST request
2. URL: `https://fcm.googleapis.com/fcm/send`
3. Headers:
   ```
   Authorization: key=YOUR_SERVER_KEY
   Content-Type: application/json
   ```
4. Body (JSON):
   ```json
   {
     "to": "your_fcm_token_here",
     "notification": {
       "title": "Test Notification",
       "body": "This is a test notification from InstaClinics!",
       "sound": "default"
     },
     "data": {
       "route": "/home",
       "click_action": "FLUTTER_NOTIFICATION_CLICK"
     },
     "priority": "high"
   }
   ```

## 🔧 Notification Payload Examples

### Basic Notification
```json
{
  "to": "FCM_TOKEN",
  "notification": {
    "title": "Appointment Reminder",
    "body": "Your appointment is in 30 minutes",
    "sound": "default"
  }
}
```

### Notification with Custom Data
```json
{
  "to": "FCM_TOKEN",
  "notification": {
    "title": "New Booking",
    "body": "Your booking has been confirmed",
    "sound": "default"
  },
  "data": {
    "route": "/booking",
    "booking_id": "12345",
    "type": "confirmation"
  }
}
```

### Silent Notification (Data Only)
```json
{
  "to": "FCM_TOKEN",
  "data": {
    "route": "/profile",
    "action": "refresh",
    "timestamp": "2024-01-01T12:00:00Z"
  }
}
```

## 🚨 Troubleshooting

### Common Issues:

1. **Token is null**
   - Make sure Firebase is properly initialized
   - Check internet connection
   - Verify Firebase configuration

2. **Notifications not showing**
   - Check notification permissions on device
   - Verify app is not in background (for some devices)
   - Check if Do Not Disturb is enabled

3. **Token refresh issues**
   - Tokens can change when app is reinstalled
   - Always get fresh token for testing

4. **iOS specific issues**
   - Make sure you have proper provisioning profiles
   - Check that APNs is enabled in Firebase Console
   - Verify bundle ID matches

### Debug Steps:

1. **Check FCM Service Logs**:
   ```dart
   // Add this to your code to debug
   final fcmService = Get.find<FCMService>();
   fcmService.printFCMToken();
   ```

2. **Test Local Notifications**:
   ```dart
   // Test if local notifications work
   await fcmService.testNotification();
   ```

3. **Check Firebase Console**:
   - Go to Firebase Console > Analytics > Events
   - Look for FCM-related events

## 📋 Testing Checklist

- [ ] FCM token is generated and printed
- [ ] Local test notifications work
- [ ] Firebase Console notifications work
- [ ] Notifications show when app is in foreground
- [ ] Notifications show when app is in background
- [ ] Notifications show when app is closed
- [ ] Tapping notification opens correct screen
- [ ] Custom data is received correctly

## 🔐 Security Notes

- Never commit FCM tokens to version control
- Use environment variables for server keys
- Regularly rotate server keys
- Monitor FCM usage in Firebase Console

## 📞 Support

If you encounter issues:
1. Check the console logs for error messages
2. Verify Firebase configuration
3. Test on different devices
4. Check Firebase Console for delivery reports
