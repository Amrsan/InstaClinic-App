# 📱 sendNotification Edge Function - Complete Code Explanation

## ✅ File Location
`supabase/functions/sendNotification/index.ts`

---

## 🎯 What This Function Does

This Edge Function receives notification requests from your Flutter dashboard and sends push notifications to user devices via Firebase Cloud Messaging (FCM).

---

## 📋 Code Structure

### 1️⃣ **Environment Setup** (Lines 1-9)
```typescript
import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const FIREBASE_PROJECT_ID = Deno.env.get("FIREBASE_PROJECT_ID")!;
const FIREBASE_CLIENT_EMAIL = Deno.env.get("FIREBASE_CLIENT_EMAIL")!;
const FIREBASE_PRIVATE_KEY = Deno.env.get("FIREBASE_PRIVATE_KEY")!;
```
- Imports Supabase runtime types
- Loads Firebase credentials from environment secrets

### 2️⃣ **Firebase Authentication** (Lines 15-97)
```typescript
async function getFirebaseAccessToken(): Promise<string>
```
**What it does:**
- Creates a JWT token using your Firebase service account
- Signs it with your private key
- Exchanges it for a Firebase OAuth2 access token
- This token is used to authenticate FCM API calls

**Why needed:**
Firebase requires authentication to send push notifications. This function handles all the OAuth2 flow.

### 3️⃣ **Send Notification** (Lines 102-152)
```typescript
async function sendFCMNotification(
  accessToken: string,
  fcmToken: string,
  title: string,
  body: string,
  data?: Record<string, string>
)
```
**What it does:**
- Sends one push notification to one device
- Uses Firebase Cloud Messaging API v1
- Includes platform-specific settings:
  - **Android**: High priority, default sound, click action
  - **iOS**: Default sound, badge count

**Notification Format:**
```json
{
  "message": {
    "token": "user_device_fcm_token",
    "notification": {
      "title": "Your Title",
      "body": "Your Message"
    },
    "android": { "priority": "high" },
    "apns": { "aps": { "sound": "default" } }
  }
}
```

### 4️⃣ **Main Handler** (Lines 157-262)
```typescript
Deno.serve(async (req) => { ... })
```

**Flow:**
1. **Handle CORS** (lines 159-167)
   - Allows requests from your web dashboard
   - Handles preflight OPTIONS requests

2. **Parse Request** (line 171)
   ```typescript
   const { tokens, title, message, data } = await req.json();
   ```
   Expected input from dashboard:
   ```json
   {
     "tokens": ["fcm_token_1", "fcm_token_2"],
     "title": "Notification Title",
     "message": "Notification Message"
   }
   ```

3. **Validate Input** (lines 174-204)
   - Checks tokens array exists and is not empty
   - Checks title and message are provided
   - Returns 400 error if validation fails

4. **Send Notifications** (lines 210-218)
   - Gets Firebase access token
   - Sends notification to each FCM token in parallel
   - Uses `Promise.allSettled()` to handle partial failures

5. **Return Results** (lines 220-245)
   ```json
   {
     "success": true,
     "totalSent": 5,
     "totalFailed": 1,
     "errors": ["FCM Error: ..."]
   }
   ```

---

## 🔄 Complete Flow Diagram

```
Dashboard Request
    ↓
[1] CORS Check (Allow web requests)
    ↓
[2] Parse JSON (tokens, title, message)
    ↓
[3] Validate Input (tokens exist? title/message provided?)
    ↓
[4] Get Firebase Access Token
    │   ├─ Create JWT with service account
    │   ├─ Sign with private key
    │   └─ Exchange for OAuth2 token
    ↓
[5] Send to Multiple Devices in Parallel
    │   ├─ Device 1: FCM API call ✓
    │   ├─ Device 2: FCM API call ✓
    │   └─ Device 3: FCM API call ✗ (token invalid)
    ↓
[6] Collect Results
    │   ├─ Count successes: 2
    │   └─ Count failures: 1
    ↓
[7] Return to Dashboard
    └─ { success: true, totalSent: 2, totalFailed: 1 }
```

---

## 📊 Request/Response Examples

### Request from Dashboard
```json
POST https://YOUR_PROJECT.supabase.co/functions/v1/sendNotification
Headers:
  Authorization: Bearer YOUR_ANON_KEY
  Content-Type: application/json
Body:
{
  "tokens": [
    "dGH7Qj9X...", 
    "fK8pLm3N..."
  ],
  "title": "New Appointment",
  "message": "Your appointment is confirmed for tomorrow at 10 AM"
}
```

### Success Response
```json
{
  "success": true,
  "totalSent": 2,
  "totalFailed": 0
}
```

### Partial Failure Response
```json
{
  "success": true,
  "totalSent": 1,
  "totalFailed": 1,
  "errors": [
    "FCM Error: The registration token is not a valid FCM registration token"
  ]
}
```

### Error Response
```json
{
  "success": false,
  "error": "Invalid or empty tokens array"
}
```

---

## 🔐 Required Environment Variables

Set via `supabase secrets set`:

| Variable | Value | Description |
|----------|-------|-------------|
| `FIREBASE_PROJECT_ID` | `instaclinics-beace` | Your Firebase project ID |
| `FIREBASE_CLIENT_EMAIL` | `firebase-adminsdk-fbsvc@...` | Service account email |
| `FIREBASE_PRIVATE_KEY` | `-----BEGIN PRIVATE KEY-----...` | Service account private key |

---

## 🧪 Testing

### Test with curl:
```bash
curl -X POST 'https://YOUR_PROJECT.supabase.co/functions/v1/sendNotification' \
  -H 'Authorization: Bearer YOUR_ANON_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "tokens": ["test_token"],
    "title": "Test",
    "message": "Hello from curl!"
  }'
```

### Test from Dashboard:
1. Go to Notifications page
2. Select user
3. Enter title and message
4. Click "Send Notification"

---

## ✅ Why This Code Works

1. **Secure**: Uses OAuth2 authentication with Firebase
2. **Scalable**: Handles multiple devices in parallel
3. **Robust**: Catches and reports errors for each device
4. **Compatible**: Works with Android & iOS
5. **Web-friendly**: CORS enabled for dashboard
6. **Detailed**: Returns success/failure counts

---

## 🚀 Ready to Deploy!

This code is complete and production-ready. Just run:

```bash
supabase functions deploy sendNotification
```

No modifications needed! 🎉
