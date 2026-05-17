# 🚀 Deploy Push Notifications NOW - Manual Steps

Follow these steps **in your Mac Terminal** (not in Cursor):

---

## Step 1: Open Terminal

Press `Cmd + Space`, type "Terminal", and press Enter.

---

## Step 2: Navigate to Project

```bash
cd /Users/mac/StudioProjects/instaclinics
```

---

## Step 3: Login to Supabase

```bash
supabase login
```

**What happens:**
- A browser window will open
- Log in with your Supabase account
- You'll see "Success! You are now logged in"
- Close the browser and return to Terminal

---

## Step 4: Get Your Project Reference ID

**Option A: From Supabase Dashboard**
1. Go to https://app.supabase.com
2. Click on your "instaclinics" project
3. Look at the URL: `https://app.supabase.com/project/YOUR_PROJECT_REF`
4. Copy the `YOUR_PROJECT_REF` part (it looks like: `djfbbxcvkwxwpkqqyjkr`)

**Option B: From Settings**
1. Go to your project in Supabase
2. Click Settings (bottom left)
3. Click General
4. Find "Reference ID" - copy it

---

## Step 5: Link Your Project

Replace `YOUR_PROJECT_REF` with the actual reference ID you copied:

```bash
supabase link --project-ref YOUR_PROJECT_REF
```

Example:
```bash
supabase link --project-ref djfbbxcvkwxwpkqqyjkr
```

**What you'll see:**
```
Linked to project YOUR_PROJECT_REF
```

---

## Step 6: Set Firebase Secrets

**Copy and paste each command ONE AT A TIME:**

### Secret 1: Project ID
```bash
supabase secrets set FIREBASE_PROJECT_ID="instaclinics-beace"
```

Wait for: `Finished supabase secrets set`

### Secret 2: Client Email
```bash
supabase secrets set FIREBASE_CLIENT_EMAIL="firebase-adminsdk-fbsvc@instaclinics-beace.iam.gserviceaccount.com"
```

Wait for: `Finished supabase secrets set`

### Secret 3: Private Key

**⚠️ IMPORTANT: Copy the ENTIRE command below including all line breaks:**

```bash
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

Wait for: `Finished supabase secrets set`

---

## Step 7: Verify All Secrets Are Set

```bash
supabase secrets list
```

**You should see:**
```
FIREBASE_PROJECT_ID
FIREBASE_CLIENT_EMAIL
FIREBASE_PRIVATE_KEY
```

---

## Step 8: Deploy the Edge Function

```bash
supabase functions deploy sendNotification
```

**What you'll see:**
```
Deploying Function sendNotification (project ref: xxx)
Bundling...
Deploying...
Function URL: https://YOUR_PROJECT_REF.supabase.co/functions/v1/sendNotification
Finished supabase functions deploy
```

**🎉 Success!** Copy this Function URL - you'll need it if there are any issues.

---

## Step 9: Test It!

1. Open your Flutter web dashboard
2. Go to **Notifications** page
3. Select a user or "All Users"
4. Enter:
   - Title: `Test Notification`
   - Message: `Hello from the dashboard!`
5. Click **Send Notification**

---

## ✅ Expected Result

You should see a green success message:
```
Success
Notification sent successfully
```

---

## 🐛 Troubleshooting

### Error: "project not linked"
- Make sure you ran `supabase link` successfully
- Try running it again with your project ref

### Error: "Failed to get access token"
- The private key might have formatting issues
- Make sure you copied the ENTIRE private key command including BEGIN/END lines
- Try setting it again

### Error: "No FCM tokens found"
- You need to register at least one device first
- Add test data to `device_tokens` table in Supabase
- Or register a device from your mobile app

### Function deployed but notification fails
- Check Edge Function logs: https://app.supabase.com/project/YOUR_PROJECT/functions/sendNotification/logs
- Make sure secrets are set correctly: `supabase secrets list`

---

## 📱 Next: Register Real Devices

To receive notifications on actual devices, add this code to your mobile app after login:

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io' show Platform;

Future<void> registerDevice() async {
  try {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    
    if (fcmToken != null && userId != null) {
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
```

---

## 🎯 Summary

After completing all steps:
- ✅ Supabase CLI logged in
- ✅ Project linked
- ✅ Firebase secrets configured
- ✅ Edge Function deployed
- ✅ Dashboard ready to send notifications

**You're all set!** 🚀

---

**Need help?** Come back and show me any error messages you get!
