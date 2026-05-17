# iOS Provisioning Profile Setup Guide

This guide will help you set up the provisioning profile for your InstaClinics app to enable Apple Sign In and app distribution.

## 📱 **Current Configuration**

### ✅ **Bundle Identifier:**
- **Current**: `com.freshhealth.instaclinic`
- **Status**: ✅ Correctly configured

### ✅ **Apple Team ID:**
- **Team ID**: `5W5GSCB6C4`
- **Status**: ✅ Configured in Info.plist

## 🔧 **Provisioning Profile Setup Steps**

### **Step 1: Create App ID in Apple Developer Console**

1. **Go to Apple Developer Console:**
   - Visit [developer.apple.com](https://developer.apple.com/account/)
   - Sign in with your Apple Developer account

2. **Navigate to Certificates, Identifiers & Profiles:**
   - Click on **Certificates, Identifiers & Profiles**
   - Select **Identifiers** from the left sidebar

3. **Create New App ID:**
   - Click the **+** button
   - Select **App IDs**
   - Choose **App** and click **Continue**

4. **Configure App ID:**
   - **Description**: `InstaClinics`
   - **Bundle ID**: `com.freshhealth.instaclinic`
   - **Capabilities**: Enable **Sign In with Apple**
   - Click **Continue** and **Register**

### **Step 2: Create Development Certificate**

1. **Go to Certificates:**
   - Select **Certificates** from the left sidebar
   - Click the **+** button

2. **Create Development Certificate:**
   - Select **iOS App Development**
   - Click **Continue**
   - Follow the instructions to create a Certificate Signing Request (CSR)
   - Upload the CSR and download the certificate

### **Step 3: Create Provisioning Profile**

1. **Go to Profiles:**
   - Select **Profiles** from the left sidebar
   - Click the **+** button

2. **Create Development Profile:**
   - Select **iOS App Development**
   - Click **Continue**

3. **Configure Profile:**
   - **App ID**: Select `com.freshhealth.instaclinic`
   - **Certificates**: Select your development certificate
   - **Devices**: Select your test devices
   - **Profile Name**: `InstaClinics Development`
   - Click **Continue** and **Generate**

4. **Download Profile:**
   - Download the `.mobileprovision` file
   - Double-click to install it in Xcode

### **Step 4: Configure Xcode Project**

1. **Open Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Select Runner Target:**
   - Click on **Runner** in the project navigator
   - Select the **Runner** target

3. **Configure Signing & Capabilities:**
   - Go to **Signing & Capabilities** tab
   - **Team**: Select your team (`5W5GSCB6C4`)
   - **Bundle Identifier**: `com.freshhealth.instaclinic`
   - **Provisioning Profile**: Select your development profile

4. **Add Sign In with Apple Capability:**
   - Click **+ Capability**
   - Search for **Sign In with Apple**
   - Add it to your project

### **Step 5: Update Xcode Project Settings**

#### **Method 1: Using Xcode GUI (Recommended)**

1. **Open Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Configure Signing:**
   - Select **Runner** project
   - Select **Runner** target
   - Go to **Signing & Capabilities**
   - **Automatically manage signing**: ✅ Check this
   - **Team**: Select your team
   - **Bundle Identifier**: `com.freshhealth.instaclinic`

#### **Method 2: Manual Configuration**

If you prefer to configure manually, update the project file:

```bash
# Open the project file
open ios/Runner.xcodeproj
```

## 🔍 **Troubleshooting Common Issues**

### **Issue 1: "No provisioning profiles found"**

**Solution:**
1. Make sure you have a valid Apple Developer account
2. Create a development provisioning profile
3. Download and install the profile
4. Select the correct team in Xcode

### **Issue 2: "Bundle identifier does not match"**

**Solution:**
1. Verify bundle ID in Xcode matches: `com.freshhealth.instaclinic`
2. Check that App ID in Apple Developer Console matches
3. Update provisioning profile if needed

### **Issue 3: "Team ID does not match"**

**Solution:**
1. Verify team ID: `5W5GSCB6C4`
2. Make sure you're signed in with the correct Apple Developer account
3. Check team membership

### **Issue 4: "Sign In with Apple capability not found"**

**Solution:**
1. Add Sign In with Apple capability in Xcode
2. Make sure App ID has Sign In with Apple enabled
3. Update provisioning profile

## 📋 **Configuration Checklist**

### **Apple Developer Console:**
- [ ] Create App ID: `com.freshhealth.instaclinic`
- [ ] Enable Sign In with Apple capability
- [ ] Create development certificate
- [ ] Create development provisioning profile
- [ ] Download and install provisioning profile

### **Xcode Configuration:**
- [ ] Open project in Xcode
- [ ] Select correct team (`5W5GSCB6C4`)
- [ ] Set bundle identifier: `com.freshhealth.instaclinic`
- [ ] Enable automatic signing
- [ ] Add Sign In with Apple capability
- [ ] Select development provisioning profile

### **Flutter Configuration:**
- [ ] Bundle ID matches in all places
- [ ] Apple Team ID configured in Info.plist
- [ ] Apple Sign In configured in auth service

## 🚀 **Testing the Setup**

### **1. Build and Run:**
```bash
flutter clean
flutter pub get
flutter run
```

### **2. Test Apple Sign In:**
1. Run the app on iOS device/simulator
2. Tap Apple Sign In button
3. Verify authentication works

### **3. Check for Errors:**
- Look for signing errors in Xcode
- Check console logs for authentication errors
- Verify provisioning profile is selected

## 🔧 **Advanced Configuration**

### **For Production:**
1. Create distribution certificate
2. Create App Store provisioning profile
3. Configure production signing in Xcode
4. Test on multiple devices

### **For Enterprise:**
1. Create enterprise distribution certificate
2. Create enterprise provisioning profile
3. Configure enterprise signing

## 📞 **Support Resources**

### **Apple Developer Documentation:**
- [Provisioning Profiles](https://developer.apple.com/documentation/xcode/managing-signing-for-your-app)
- [Sign In with Apple](https://developer.apple.com/documentation/sign_in_with_apple)
- [App Distribution](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases)

### **Xcode Help:**
- [Signing & Capabilities](https://developer.apple.com/documentation/xcode/managing-signing-for-your-app)
- [Troubleshooting](https://developer.apple.com/documentation/xcode/troubleshooting)

### **Flutter Documentation:**
- [iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [Platform Configuration](https://docs.flutter.dev/platform-integration)

## 🎯 **Next Steps**

After completing the provisioning profile setup:

1. **Test Apple Sign In** on iOS device
2. **Configure production signing** for App Store
3. **Set up CI/CD** for automated builds
4. **Configure app distribution** for beta testing

---

**Note**: Make sure to replace any placeholder values with your actual Apple Developer account information and project-specific details. 