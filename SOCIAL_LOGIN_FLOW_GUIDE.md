# Social Login Flow with Profile Completion

This guide explains the complete social login flow for Google, Facebook, and Apple authentication with profile completion.

## 🔄 **Flow Overview**

### **Step 1: Social Login**
1. User taps on Google, Facebook, or Apple login button
2. Social provider authentication occurs
3. User data is retrieved from the provider
4. User is created/authenticated in Supabase

### **Step 2: Profile Check**
1. System checks if user profile is complete
2. If incomplete → Redirect to Profile Completion
3. If complete → Redirect to Main Screen

### **Step 3: Profile Completion (if needed)**
1. User fills in missing information:
   - First Name (pre-filled from provider)
   - Last Name (pre-filled from provider)
   - Email (pre-filled from provider)
   - Phone Number (required)
   - Birth Date (required)
   - Gender (required)
2. User taps "Continue"
3. Profile is updated in database

### **Step 4: Address Setup**
1. User is redirected to Address View
2. User enters delivery address:
   - City
   - Street/Village
   - Building Number
   - Apartment Number
   - Special Notes (optional)
3. User taps "Continue"
4. Address is saved and user goes to Main Screen

## 📱 **Implementation Details**

### **Files Created/Modified:**

#### **1. Profile Completion View**
- **File**: `lib/views/auth/profile_completion_view.dart`
- **Purpose**: Form for users to complete missing profile information
- **Features**:
  - Pre-filled fields from social provider data
  - Validation for required fields
  - Date picker for birth date
  - Gender dropdown
  - Phone number with country code (+20)

#### **2. Updated Auth Controller**
- **File**: `lib/controllers/auth_controller.dart`
- **New Methods**:
  - `updateSocialUserProfile()`: Updates user profile in database
  - Enhanced social login methods with profile checking
- **Features**:
  - Pre-fills form fields with provider data
  - Checks profile completeness
  - Routes to appropriate screen based on profile status

#### **3. Updated Routes**
- **File**: `lib/routes/app_pages.dart`
- **New Route**: `/profile-completion`
- **Binding**: AuthController for form management

#### **4. Updated Translations**
- **File**: `lib/translations/app_translations.dart`
- **New Keys**:
  - `complete_profile`
  - `complete_profile_description`
  - `continue`
  - `please_fill_all_fields`
  - `please_enter_valid_email`
  - `please_enter_valid_phone`

## 🔧 **Technical Implementation**

### **Profile Completeness Check**
```dart
// Check if user profile is complete
if (profile['phone_number'] == null || 
    profile['phone_number'].toString().isEmpty ||
    profile['birth_date'] == null ||
    profile['gender'] == null) {
  // Profile incomplete, go to profile completion
  Get.offAllNamed('/profile-completion');
} else {
  // Profile complete, go to main screen
  isAuthenticated.value = true;
  Get.offAllNamed('/mainScreen');
}
```

### **Form Pre-filling**
```dart
// Pre-fill form fields with available data
if (profile['first_name'] != null) {
  firstNameController.text = profile['first_name'];
}
if (profile['last_name'] != null) {
  lastNameController.text = profile['last_name'];
}
if (profile['email'] != null) {
  emailController.text = profile['email'];
}
```

### **Profile Update**
```dart
// Update user profile in Supabase
await _supabase.from('users').upsert({
  'id': user.id,
  'email': emailController.text.trim(),
  'phone_number': phoneController.text,
  'first_name': firstNameController.text,
  'last_name': lastNameController.text,
  'birth_date': birthDateController.text,
  'gender': genderController.value,
  'updated_at': DateTime.now().toIso8601String(),
});
```

## 🎯 **User Experience Flow**

### **First-Time Social Login:**
1. **Login Screen** → User taps Google/Facebook/Apple
2. **Social Auth** → Provider authentication
3. **Profile Completion** → Fill missing info (pre-filled with provider data)
4. **Address Setup** → Enter delivery address
5. **Main Screen** → App home page

### **Returning User (Complete Profile):**
1. **Login Screen** → User taps Google/Facebook/Apple
2. **Social Auth** → Provider authentication
3. **Main Screen** → Direct to app home page

### **Returning User (Incomplete Profile):**
1. **Login Screen** → User taps Google/Facebook/Apple
2. **Social Auth** → Provider authentication
3. **Profile Completion** → Complete missing fields
4. **Address Setup** → Enter delivery address
5. **Main Screen** → App home page

## 📋 **Required Fields**

### **Profile Completion:**
- ✅ First Name (pre-filled from provider)
- ✅ Last Name (pre-filled from provider)
- ✅ Email (pre-filled from provider)
- ❌ Phone Number (user must enter)
- ❌ Birth Date (user must select)
- ❌ Gender (user must select)

### **Address Setup:**
- ❌ City (user must enter)
- ❌ Street/Village (user must enter)
- ❌ Building Number (user must enter)
- ❌ Apartment Number (user must enter)
- ⚪ Special Notes (optional)

## 🔍 **Validation Rules**

### **Profile Validation:**
- All required fields must be filled
- Email must be valid format
- Phone number must be valid format
- Birth date must be selected
- Gender must be selected

### **Address Validation:**
- Street must be filled
- Building number must be filled
- City must be filled

## 🚀 **Testing the Flow**

### **Test Scenarios:**

1. **New User - Google Login:**
   ```bash
   flutter run
   # Tap Google login
   # Verify profile completion screen appears
   # Fill required fields
   # Verify address screen appears
   # Fill address details
   # Verify main screen appears
   ```

2. **New User - Facebook Login:**
   ```bash
   flutter run
   # Tap Facebook login
   # Verify profile completion screen appears
   # Fill required fields
   # Verify address screen appears
   # Fill address details
   # Verify main screen appears
   ```

3. **New User - Apple Login:**
   ```bash
   flutter run
   # Tap Apple login
   # Verify profile completion screen appears
   # Fill required fields
   # Verify address screen appears
   # Fill address details
   # Verify main screen appears
   ```

4. **Returning User (Complete Profile):**
   ```bash
   flutter run
   # Tap any social login
   # Verify direct navigation to main screen
   ```

## 🔧 **Configuration Requirements**

### **Database Schema:**
Ensure your `users` table has these columns:
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email TEXT,
  first_name TEXT,
  last_name TEXT,
  phone_number TEXT,
  birth_date TEXT,
  gender TEXT,
  avatar_url TEXT,
  provider TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

### **Supabase Configuration:**
1. Enable social providers in Supabase dashboard
2. Configure OAuth settings for each provider
3. Set up proper redirect URIs

### **Social Provider Setup:**
1. **Google**: Configure OAuth 2.0 credentials
2. **Facebook**: Set up Facebook app with proper permissions
3. **Apple**: Configure Apple Sign In in Apple Developer Console

## 🐛 **Troubleshooting**

### **Common Issues:**

1. **Profile completion not showing:**
   - Check database schema
   - Verify profile completeness check logic
   - Check user data in Supabase

2. **Form fields not pre-filled:**
   - Verify social provider data retrieval
   - Check database user record
   - Debug pre-filling logic

3. **Navigation issues:**
   - Check route definitions
   - Verify GetX navigation
   - Check binding configurations

4. **Validation errors:**
   - Check validation rules
   - Verify form field names
   - Test validation logic

### **Debug Steps:**
1. Check console logs for errors
2. Verify database records
3. Test each step individually
4. Check social provider configuration

## 📈 **Future Enhancements**

### **Potential Improvements:**
1. **Profile Picture**: Allow users to upload/select profile picture
2. **Address Validation**: Integrate with address validation service
3. **Phone Verification**: Add SMS verification for phone numbers
4. **Profile Editing**: Allow users to edit profile later
5. **Multiple Addresses**: Support multiple delivery addresses
6. **Address Book**: Save and manage multiple addresses

### **Analytics:**
1. Track social login conversion rates
2. Monitor profile completion rates
3. Analyze user drop-off points
4. Measure time to complete profile

---

**Note**: This flow ensures that all users have complete profiles and delivery addresses before accessing the main app functionality, providing a better user experience and ensuring all necessary data is collected. 