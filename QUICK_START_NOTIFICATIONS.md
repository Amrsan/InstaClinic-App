# Quick Start: Push Notifications

## 🚀 Quick Deployment Steps

### 1. Create Database Table (1 minute)

Run the migration in your Supabase SQL Editor:

```bash
# Or use Supabase CLI
supabase migration up
```

Or copy-paste from: `supabase/migrations/create_devices_table.sql`

### 2. Deploy Firebase Cloud Function (2 minutes)

```bash
cd functions
npm install
firebase deploy --only functions
```

Copy the deployed URL (e.g., `https://us-central1-YOUR_PROJECT.cloudfunctions.net/sendNotificationHttp`)

### 3. Deploy Supabase Edge Function (1 minute)

```bash
# Set the Firebase function URL
supabase secrets set FIREBASE_FUNCTION_URL=YOUR_FIREBASE_FUNCTION_URL

# Deploy the function
supabase functions deploy sendNotification
```

### 4. Test It! (1 minute)

1. Go to your dashboard at `/dashboard`
2. Click "Notifications" in the sidebar
3. Select "All Users" or a specific user
4. Enter a title and message
5. Click "Send Notification"

## 📋 What Was Added

### Dashboard UI (`lib/views/web/dashboard_view.dart`)
- ✅ New "Notifications" sidebar button
- ✅ Notifications content page with:
  - User selector dropdown
  - Title input field
  - Message text area
  - Send button
  - Devices table showing all registered FCM tokens

### Firebase Functions (`functions/index.js`)
- ✅ `sendNotification` - Callable function
- ✅ `sendNotificationHttp` - HTTP endpoint

### Supabase Edge Function (`supabase/functions/sendNotification/`)
- ✅ Proxy function to call Firebase

### Database
- ✅ Migration file to create `devices` table
- ✅ Row Level Security policies
- ✅ Indexes for performance

## 🔧 Configuration Checklist

- [ ] Database migration applied
- [ ] Firebase Cloud Function deployed
- [ ] Firebase function URL saved
- [ ] Supabase Edge Function deployed
- [ ] `FIREBASE_FUNCTION_URL` environment variable set
- [ ] Tested with a real device

## 🐛 Common Issues

### "No FCM tokens found"
→ Make sure devices are registered in the `devices` table

### "Failed to send notification"
→ Check Firebase function logs: `firebase functions:log`

### CORS error in browser
→ Verify both Firebase and Supabase functions have CORS headers

### Notification not received on device
→ Check device has granted notification permissions
→ Verify FCM token is current and not expired

## 📱 How to Register Devices

In your Flutter mobile app, when a user logs in:

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> registerDevice() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  final userId = Supabase.instance.client.auth.currentUser?.id;
  
  if (fcmToken != null && userId != null) {
    await Supabase.instance.client.from('devices').upsert({
      'user_id': userId,
      'fcm_token': fcmToken,
      'platform': Platform.isAndroid ? 'android' : 'ios',
      'last_active_at': DateTime.now().toIso8601String(),
    });
  }
}
```

## 🎯 Usage Example

### Send to All Users
1. Select "All Users" from dropdown
2. Title: "System Maintenance"
3. Message: "The app will be under maintenance from 2-4 AM"
4. Click "Send Notification"

### Send to Specific User
1. Select user from dropdown (shows name and email)
2. Title: "Appointment Reminder"
3. Message: "Your appointment is tomorrow at 10 AM"
4. Click "Send Notification"

## 📊 Monitoring

### Firebase Console
- Functions → sendNotificationHttp → View logs
- Cloud Messaging → See delivery stats

### Supabase Dashboard  
- Edge Functions → sendNotification → Logs
- Database → devices table → Check data

## 🔐 Security Notes

- ✅ Row Level Security enabled on `devices` table
- ✅ Users can only manage their own devices
- ⚠️ Admin access needed for dashboard - implement admin check!
- 🔑 Keep Firebase service account keys secure

## 📚 Full Documentation

See `PUSH_NOTIFICATIONS_SETUP.md` for:
- Detailed architecture
- Security best practices
- Advanced configuration
- Troubleshooting guide
- Future enhancements

## 💡 Pro Tips

1. **Token Refresh**: FCM tokens can expire - implement token refresh in your app
2. **Batch Size**: Firebase recommends max 500 tokens per batch
3. **Testing**: Use Firebase Console to send test notifications first
4. **Analytics**: Track notification open rates using Firebase Analytics
5. **Scheduling**: Consider adding a scheduling feature for future notifications

---

**Need Help?** Check the full setup guide in `PUSH_NOTIFICATIONS_SETUP.md`
