# Social Login Setup Guide

This guide will help you configure Google, Facebook, and Apple Sign-In with Supabase for your InstaClinics app.

## Prerequisites

1. Supabase project set up
2. Flutter app with the required dependencies installed

## Dependencies Added

The following dependencies have been added to `pubspec.yaml`:

```yaml
sign_in_with_apple: ^5.0.0
crypto: ^3.0.3
```

## 1. Google Sign-In Setup

### For Android:
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable Google Sign-In API
4. Create OAuth 2.0 credentials
5. Add your Android package name and SHA-1 fingerprint
6. Download the `google-services.json` file and place it in `android/app/`

### For iOS:
1. In Google Cloud Console, add iOS bundle ID
2. Download `GoogleService-Info.plist` and add to iOS project
3. Add URL schemes to `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

### For Web:
1. Add your domain to authorized origins in Google Cloud Console
2. Update `lib/constants/app_constans.dart` with your web client ID

## 2. Facebook Sign-In Setup

### Create Facebook App:
1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Create a new app
3. Add Facebook Login product
4. Configure OAuth redirect URIs

### For Android:
1. Add Facebook app ID to `android/app/src/main/res/values/strings.xml`:
```xml
<string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
```

2. Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<application>
    <meta-data
        android:name="com.facebook.sdk.ApplicationId"
        android:value="@string/facebook_app_id"/>
</application>
```

### For iOS:
1. Add Facebook app ID to `ios/Runner/Info.plist`:
```xml
<key>FacebookAppID</key>
<string>YOUR_FACEBOOK_APP_ID</string>
<key>FacebookClientToken</key>
<string>YOUR_CLIENT_TOKEN</string>
<key>FacebookDisplayName</key>
<string>YOUR_APP_NAME</string>
```

## 3. Apple Sign-In Setup

### For iOS:
1. Enable Sign in with Apple capability in Xcode
2. Add to `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>signinwithapple</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>signinwithapple</string>
        </array>
    </dict>
</array>
```

### For Web:
1. Create Apple Developer account
2. Create App ID with Sign in with Apple enabled
3. Create Service ID
4. Configure domains and redirect URLs

## 4. Supabase Configuration

### Enable OAuth Providers:
1. Go to your Supabase dashboard
2. Navigate to Authentication > Providers
3. Enable Google, Facebook, and Apple providers
4. Add the respective client IDs and secrets

### Configure Redirect URLs:
Add these URLs to your Supabase project:
- `https://your-project.supabase.co/auth/v1/callback`
- `your-app-scheme://login-callback`

## 5. Environment Variables

Create a `.env` file in your project root:

```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GOOGLE_CLIENT_ID=your_google_client_id
FACEBOOK_APP_ID=your_facebook_app_id
```

## 6. Testing

1. Run `flutter pub get` to install dependencies
2. Test each social login method
3. Verify user profiles are created in your Supabase users table

## Troubleshooting

### Common Issues:
1. **Google Sign-In fails**: Check SHA-1 fingerprint and package name
2. **Facebook Sign-In fails**: Verify app ID and client token
3. **Apple Sign-In fails**: Ensure capability is enabled in Xcode
4. **Supabase errors**: Check OAuth provider configuration

### Debug Tips:
- Check console logs for detailed error messages
- Verify all URLs and redirect URIs are correct
- Test on both debug and release builds

## Security Notes

1. Never commit sensitive keys to version control
2. Use environment variables for all secrets
3. Regularly rotate OAuth client secrets
4. Monitor authentication logs in Supabase dashboard

## Features Implemented

✅ **Forgot Password**: Users can reset their password via email
✅ **Google Sign-In**: Complete Google authentication flow
✅ **Facebook Sign-In**: Complete Facebook authentication flow  
✅ **Apple Sign-In**: Complete Apple authentication flow
✅ **User Profile Creation**: Automatic profile creation for social login users
✅ **Error Handling**: Comprehensive error handling and user feedback
✅ **Loading States**: Visual feedback during authentication processes
✅ **Multi-language Support**: English and Arabic translations

## Usage

The social login buttons are now active in the login screen. Users can:
1. Click "Forgot Password?" to reset their password
2. Use Google, Facebook, or Apple to sign in
3. Receive appropriate success/error messages
4. Be automatically redirected to the main screen upon successful authentication 