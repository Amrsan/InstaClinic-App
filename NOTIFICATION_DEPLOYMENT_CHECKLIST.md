# 🚀 Push Notifications Deployment Checklist

## ✅ Pre-Deployment Checklist

- [x] Firebase service account JSON downloaded
- [x] `device_tokens` table exists in Supabase
- [x] Edge Function code created
- [ ] Supabase CLI installed
- [ ] Logged into Supabase CLI
- [ ] Firebase secrets set
- [ ] Edge Function deployed

---

## 📋 Step-by-Step Deployment

### 1️⃣ Install Supabase CLI (if not installed)

**macOS:**
```bash
brew install supabase/tap/supabase
```

**Windows/Linux:**
Visit: https://supabase.com/docs/guides/cli

### 2️⃣ Login to Supabase

```bash
supabase login
```

This will open a browser window. Log in with your Supabase account.

### 3️⃣ Link Your Project

```bash
cd /Users/mac/StudioProjects/instaclinics
supabase link --project-ref YOUR_PROJECT_REF
```

**To find your project ref:**
1. Go to https://app.supabase.com
2. Select your project
3. Look at the URL: `https://app.supabase.com/project/YOUR_PROJECT_REF`
4. Or go to Settings → General → Reference ID

### 4️⃣ Set Firebase Secrets

Run these commands **one by one**:

```bash
# Set Project ID
supabase secrets set FIREBASE_PROJECT_ID="instaclinics-beace"

# Set Client Email
supabase secrets set FIREBASE_CLIENT_EMAIL="firebase-adminsdk-fbsvc@instaclinics-beace.iam.gserviceaccount.com"

# Set Private Key (copy the entire command including line breaks)
supabase secrets set FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDeJ4TSDTq4gOj2
X2QdUZ+mDsqyeQ5fInn515KTltTxnIpNasega7p648wNfPm/p16LEgobyp+2UeBo
SAt/e3bUNoehTHFOppFrTin38mrwI5wiaxFPMnUqaip4h9q+qH3ZFqSv8YX0KAGJ
1auAEdHU4AFzwN9Cbrn4jBhqI4msJm4/F6d90w72/YCgBiAWFr1IwYgIfEbYKbcW
RVcXf8T/WdZhQdb5oWlD9zjCXRy904olGqdppraxR7DAndxh+mP58ydjdqzeCndX
ia3HEundTDtWEeajKDmSi3vyemTIlUzpUuNk69KIQpYkx8lFowWRjzPa61w71cRv
9HYdaMHTAgMBAAECggEAPYoP+ooMorCfGCSrnI2QXpVJZDAxoXvw8xta8MR/H6EA
FNsICrHc+g7hZzkgDA3GnFq2byVtoblDo0+V0841SCsE3lNJLgLpVKLV8Gf4ZKZQ
qZ4kMN6m40V+l1325ArTtc/WdiC/PTfZ2T9V30fQaxpUfKbIkeQPY0EXwEsw531H
tS5JbxsROGsV/2KLjpjsykY+5h4yAAmsjs4rKmwnTDMARyNsVms+UIT2lLiMqmmB
QB6/kpdqhnhVIAReEJqq929njyvwk6bAvOR23KAPMJpw5seo0k5v3dCj+B/B0VVE
+pm5wmdRNF8gvFdtfok5KHT41rsPrmHlvbpdFcIfEQKBgQDzY7LV8mQQhebRICeJ
qIc6koJP01TYWG5DgEsNStlBItGUUnquFooIBxFTTTXGH44JmRRa2UlWapoAcY1l
y19lQNVDp1049XGdA6+QbArkGudSoytEqIN5Wq1QOdPltXtFqVZP6S+nywi53Vu3
eheF/Er/GJv1MnvN8WsJl5xj0QKBgQDpqijb0aLlUhjQ5ggv2pr2XCdqEHYfJCgb
WuIrKc4xVhn3RvRKeKW6X/TrcrK+iZjEcUK0skc8TjmAKZcrtFA489fMukQrNzau
k5nCpDJLHR6O3wP/PN27Nz9PUrPhFWm86Qr5s3Y7B8nVAqCQQUs3IrwY5jaUHmrg
IMbLf92oYwKBgAITdKAMjDvz2G8qNgwfit++BiyGIfAiePZMbtdzLv02PdFlDrTT
bmP5I3Wxb+b7t+tvCdRojA6XpC6iyVD39h1X+zmzgMEOnuR29pVlxoYBkL2MtL7G
LTDozBemFp+b96w1cI4H8CcfPTjQoYqkGPVEnKMmY5Yo0xODnqUbTPMxAoGBANEY
ehOrVw/LFXXqQy0/fCg1cvfQ30MiwdkozPc/I8q2d+n1zqnNqNBNCgifzSAAVXqE
t+KnHmPyxDXSAfsUEi3E1znW/SWG9SHn51JsSK0605uaKiN/PhRIbhj3swwac1Kf
YDjuxUAxygUZosE0DLC8HoJRkEmfppgF/J8iPyJtAoGAKuTT0vu0dD5Nlevsfdms
jbJI5B3b5edaVQWJ8oEoaOQJpJOtNe5WfGXdexuGB/I3QuQKUPHVjw7Icsi0+vTo
5eL81sPknLNeDqN+Z5KgQQQlKrhvyT3sAZx+nLvHvfbyLauUATzboEhex1cqZS1P
GD1KQUD7raS9TyuKI0CNWuc=
-----END PRIVATE KEY-----"
```

### 5️⃣ Verify Secrets

```bash
supabase secrets list
```

You should see all three secrets listed.

### 6️⃣ Deploy Edge Function

```bash
supabase functions deploy sendNotification
```

Expected output:
```
Deploying Function sendNotification (project ref: xxx)
Function URL: https://xxx.supabase.co/functions/v1/sendNotification
```

---

## 🧪 Testing

### Test from Terminal

```bash
# Replace YOUR_PROJECT_REF and YOUR_ANON_KEY with your actual values
curl -i --location --request POST \
  'https://YOUR_PROJECT_REF.supabase.co/functions/v1/sendNotification' \
  --header 'Authorization: Bearer YOUR_ANON_KEY' \
  --header 'Content-Type: application/json' \
  --data '{
    "tokens": ["test_token_here"],
    "title": "Test Notification",
    "message": "Hello from Supabase!"
  }'
```

**Get your keys:**
- Go to: https://app.supabase.com/project/YOUR_PROJECT/settings/api
- Copy: `Project URL` and `anon public` key

### Test from Dashboard

1. Open your Flutter web dashboard
2. Go to "Notifications" page
3. Select a user (or "All Users")
4. Enter title and message
5. Click "Send Notification"

---

## 📱 Register Devices from Mobile App

Add this code to your Flutter mobile app (after user login):

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io' show Platform;

Future<void> registerDevice() async {
  try {
    // Get FCM token
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    
    if (fcmToken != null && userId != null) {
      // Save to Supabase device_tokens table
      await Supabase.instance.client.from('device_tokens').upsert({
        'user_id': userId,
        'fcm_token': fcmToken,
        'device_type': Platform.isAndroid ? 'android' : 'ios',
        'is_active': true,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'fcm_token');
      
      print('✅ Device registered for push notifications');
    }
  } catch (e) {
    print('❌ Error registering device: $e');
  }
}

// Call this after successful login
Future<void> onUserLogin() async {
  // ... your login code ...
  
  // Register device for push notifications
  await registerDevice();
  
  // Listen for token refresh
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    // Update token in database
    Supabase.instance.client.from('device_tokens').upsert({
      'user_id': Supabase.instance.client.auth.currentUser?.id,
      'fcm_token': newToken,
      'device_type': Platform.isAndroid ? 'android' : 'ios',
      'updated_at': DateTime.now().toIso8601String(),
    }, onConflict: 'fcm_token');
  });
}
```

---

## 🔧 Troubleshooting

### Error: "command not found: supabase"
- Install Supabase CLI (see step 1)
- Restart your terminal

### Error: "project not linked"
- Run: `supabase link --project-ref YOUR_PROJECT_REF`

### Error: "Failed to get access token"
- Check that private key is set correctly (including BEGIN/END lines)
- Make sure there are no extra spaces or characters

### Error: "No FCM tokens found"
- Make sure `device_tokens` table has data
- Register a device from mobile app first
- Check RLS policies allow reading from device_tokens

### Function deployed but not working:
- Check Edge Function logs: https://app.supabase.com/project/YOUR_PROJECT/functions
- Verify secrets are set: `supabase secrets list`
- Test with curl command to see actual error

---

## 📊 Monitoring

### View Edge Function Logs

https://app.supabase.com/project/YOUR_PROJECT/functions/sendNotification/logs

### View FCM Delivery Stats

https://console.firebase.google.com/project/instaclinics-beace/notification

---

## ✅ Success Criteria

- [ ] Edge Function deployed successfully
- [ ] Test notification sent via curl
- [ ] Dashboard shows registered devices
- [ ] Notification sent from dashboard
- [ ] Mobile device receives notification

---

## 🎉 You're Done!

Once all steps are completed, your push notification system is live!

**Important Files:**
- Edge Function: `supabase/functions/sendNotification/index.ts`
- Dashboard Code: `lib/views/web/dashboard_view.dart`
- Setup Guide: `FIREBASE_SETUP_COMMANDS.md`
- This Checklist: `NOTIFICATION_DEPLOYMENT_CHECKLIST.md`
