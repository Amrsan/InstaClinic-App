# Push Notifications Setup Guide

This guide explains how to set up and use the push notifications feature in the InstaClinic dashboard.

## Overview

The push notifications feature allows administrators to send notifications from the web dashboard to:
- All users
- Specific individual users

The system consists of three main components:
1. **Flutter Dashboard UI** - Admin interface for sending notifications
2. **Supabase Edge Function** - Proxy to handle requests from the dashboard
3. **Firebase Cloud Function** - Handles actual FCM message delivery

## Prerequisites

- Firebase project with Cloud Messaging enabled
- Supabase project
- Firebase Admin SDK configured
- FCM tokens stored in Supabase `devices` table

## Database Schema

Your Supabase `devices` table should have the following structure:

```sql
CREATE TABLE devices (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  fcm_token TEXT NOT NULL,
  platform TEXT, -- 'android', 'ios', or 'web'
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for faster queries
CREATE INDEX idx_devices_user_id ON devices(user_id);
CREATE INDEX idx_devices_fcm_token ON devices(fcm_token);
```

## Setup Instructions

### 1. Deploy Firebase Cloud Function

Navigate to your functions directory and deploy:

```bash
cd functions
npm install
firebase deploy --only functions:sendNotification,functions:sendNotificationHttp
```

After deployment, you'll get a function URL like:
```
https://us-central1-YOUR_PROJECT_ID.cloudfunctions.net/sendNotificationHttp
```

Save this URL - you'll need it for the Supabase Edge Function.

### 2. Configure Supabase Edge Function

1. Update the `FIREBASE_FUNCTION_URL` in the Edge Function:

```bash
# Set the environment variable in Supabase
supabase secrets set FIREBASE_FUNCTION_URL=https://us-central1-YOUR_PROJECT_ID.cloudfunctions.net/sendNotificationHttp
```

2. Deploy the Supabase Edge Function:

```bash
supabase functions deploy sendNotification
```

### 3. Test the Setup

You can test the entire flow using curl:

```bash
# Test Supabase Edge Function
curl -i --location --request POST 'https://YOUR_PROJECT_REF.supabase.co/functions/v1/sendNotification' \
  --header 'Authorization: Bearer YOUR_SUPABASE_ANON_KEY' \
  --header 'Content-Type: application/json' \
  --data '{
    "tokens": ["YOUR_FCM_TOKEN"],
    "title": "Test Notification",
    "message": "This is a test message"
  }'
```

## Using the Dashboard

### Accessing the Notifications Page

1. Log in to the admin dashboard
2. Click on "Notifications" in the left sidebar
3. You'll see two sections:
   - **Send Notification Form** - Top section for composing messages
   - **Registered Devices** - Bottom section showing all devices with FCM tokens

### Sending a Notification

1. **Select User**:
   - Choose "All Users" to send to everyone
   - Or select a specific user from the dropdown

2. **Enter Title**: 
   - Write a short, descriptive title

3. **Enter Message**: 
   - Write your notification message

4. **Click "Send Notification"**:
   - The system will fetch FCM tokens for the selected user(s)
   - Send the notification via Firebase Cloud Messaging
   - Display a success or error message

### Viewing Registered Devices

The bottom section shows a table with:
- User ID
- User Name
- Email
- FCM Token (truncated, hover to see full token)
- Platform (Android/iOS/Web)
- Registration Date

## How It Works

### Flow Diagram

```
Dashboard (Flutter Web)
    ↓
    | 1. User selects recipient and writes message
    ↓
Supabase (Fetch FCM tokens)
    ↓
    | 2. Fetch tokens from 'devices' table
    ↓
Supabase Edge Function
    ↓
    | 3. Forward request to Firebase
    ↓
Firebase Cloud Function
    ↓
    | 4. Send FCM messages
    ↓
Firebase Cloud Messaging (FCM)
    ↓
    | 5. Deliver to devices
    ↓
User Devices (Android/iOS/Web)
```

### Code Flow

1. **Dashboard Selection**: User selects recipient and writes notification
2. **Token Fetching**: App queries Supabase for FCM tokens:
   - For "All Users": fetches all tokens from `devices` table
   - For specific user: fetches tokens matching that `user_id`
3. **API Call**: Dashboard calls Supabase Edge Function
4. **Proxy**: Edge Function forwards request to Firebase Cloud Function
5. **FCM Delivery**: Cloud Function sends notifications via FCM
6. **Result**: Success/failure message shown in dashboard

## Troubleshooting

### No FCM Tokens Found
- Ensure users have registered their devices
- Check that `devices` table is populated
- Verify `user_id` is correctly linked

### Notification Not Received
- Check FCM token is valid and not expired
- Verify Firebase project configuration
- Check device notification permissions
- Review Firebase Cloud Function logs: `firebase functions:log`

### Edge Function Errors
- Check Supabase function logs in dashboard
- Verify `FIREBASE_FUNCTION_URL` is set correctly
- Ensure Firebase function is deployed and accessible

### CORS Issues
- Verify CORS headers are set in both functions
- Check browser console for CORS errors

## Security Considerations

### Row Level Security (RLS)

Add RLS policies to protect the `devices` table:

```sql
-- Enable RLS
ALTER TABLE devices ENABLE ROW LEVEL SECURITY;

-- Users can only insert/update their own devices
CREATE POLICY "Users can manage their own devices"
ON devices FOR ALL
USING (auth.uid() = user_id);

-- Admins can view all devices (for dashboard)
CREATE POLICY "Admins can view all devices"
ON devices FOR SELECT
USING (
  auth.jwt() ->> 'role' = 'admin'
  -- Or use a custom admin check based on your auth setup
);
```

### Function Authentication

Ensure your Edge Function validates the user is an admin:

```typescript
// In your Edge Function, add authentication check
const authHeader = req.headers.get('Authorization')
if (!authHeader) {
  return new Response('Unauthorized', { status: 401 })
}

// Verify user is admin (implement based on your auth system)
const token = authHeader.replace('Bearer ', '')
// ... verify token and check admin role
```

## Monitoring

### Firebase Console
- View notification delivery statistics
- Check Cloud Function execution logs
- Monitor FCM quota usage

### Supabase Dashboard
- View Edge Function invocations
- Check database query performance
- Monitor API usage

## Cost Estimation

### Firebase
- Cloud Functions: Free tier includes 2M invocations/month
- FCM: Free for unlimited notifications

### Supabase
- Edge Functions: Included in all plans
- Database reads: Included in plan limits

## Future Enhancements

Potential improvements:
1. **Scheduled Notifications**: Send notifications at specific times
2. **Notification Templates**: Pre-defined message templates
3. **Delivery Reports**: Track delivery status and open rates
4. **User Preferences**: Allow users to opt-in/out of notifications
5. **Rich Notifications**: Add images, actions, and custom data
6. **Analytics**: Track notification performance metrics

## Support

For issues or questions:
1. Check Firebase Console logs
2. Review Supabase Edge Function logs
3. Verify database schema and data
4. Test with curl commands to isolate issues

## Additional Resources

- [Firebase Cloud Messaging Documentation](https://firebase.google.com/docs/cloud-messaging)
- [Supabase Edge Functions Guide](https://supabase.com/docs/guides/functions)
- [Flutter FCM Plugin](https://pub.dev/packages/firebase_messaging)
