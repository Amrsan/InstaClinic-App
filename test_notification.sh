#!/bin/bash

# FCM Test Notification Script
# Usage: ./test_notification.sh <FCM_TOKEN>

if [ $# -eq 0 ]; then
    echo "Usage: $0 <FCM_TOKEN>"
    echo "Example: $0 'your_fcm_token_here'"
    exit 1
fi

FCM_TOKEN=$1

# Your Firebase Server Key (get this from Firebase Console > Project Settings > Cloud Messaging)
SERVER_KEY="YOUR_FIREBASE_SERVER_KEY_HERE"

echo "🔔 Testing FCM Notification..."
echo "📱 FCM Token: $FCM_TOKEN"
echo ""

# Test notification payload
curl -X POST \
  https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=$SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "'$FCM_TOKEN'",
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
  }'

echo ""
echo "✅ Test notification sent!"
echo "📝 Check your device for the notification"
