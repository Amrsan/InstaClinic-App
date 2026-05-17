import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../views/address/address_view.dart';
import '../services/otp_service.dart';
import 'dart:async';
import '../routes/app_pages.dart';
import '../services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../views/auth/reset_password.dart';

class AuthController extends GetxController {
  final _supabase = Supabase.instance.client;
  final AuthService _authService = Get.find<AuthService>();

  //final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final OTPService _otpService = OTPService(
    apiKey: '090ebcac-232a-445e-b949-0b93d7d0f4b0',
    senderId: 'INSTACLINIC',
  );

  // Text controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final birthDateController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final genderController = ''.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final resetEmail = ''.obs;
  // Observable variables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final phoneNumber = ''.obs;
  final otpCode = ''.obs;
//  final user = Rxn<User>();
  final isAuthenticated = false.obs;

  // Static admin credentials for web
  static const adminEmail = 'admin';
  static const adminPassword = 'P@ssw0rd';

  // Gesture recognizer for sign up text
  late final signUpTapRecognizer = TapGestureRecognizer()
    ..onTap = () => Get.toNamed('/signup');

  // Add rate limiting variables
  final _lastAttemptTime = DateTime.now().obs;
  final _attemptCount = 0.obs;
  static const _maxAttempts = 5;
  static const _cooldownDuration = Duration(minutes: 15);
  final _retryDelay = Duration(seconds: 1).obs;

  StreamSubscription<AuthState>? _authStateSubscription;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  bool get _isRateLimited {
    final now = DateTime.now();
    final timeSinceLastAttempt = now.difference(_lastAttemptTime.value);

    if (timeSinceLastAttempt >= _cooldownDuration) {
      _attemptCount.value = 0;
      _retryDelay.value = const Duration(seconds: 1);
      return false;
    }

    return _attemptCount.value >= _maxAttempts;
  }

  Future<void> _handleAuthAttempt(Future<void> Function() authAction) async {
    if (_isRateLimited) {
      final remainingCooldown =
          _cooldownDuration - DateTime.now().difference(_lastAttemptTime.value);
      final minutes = remainingCooldown.inMinutes + 1;

      Get.snackbar(
        'Too Many Attempts',
        'Please wait $minutes minutes before trying again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      return;
    }

    try {
      await authAction();
      _attemptCount.value = 0; // Reset on successful attempt
      _retryDelay.value = const Duration(seconds: 1); // Reset retry delay
    } catch (e) {
      _lastAttemptTime.value = DateTime.now();
      _attemptCount.value++;

      if (e.toString().contains('429')) {
        // Implement exponential backoff
        _retryDelay.value = Duration(seconds: _retryDelay.value.inSeconds * 2);

        final remainingAttempts = _maxAttempts - _attemptCount.value;
        Get.snackbar(
          'Rate Limit Exceeded',
          'Please wait ${_retryDelay.value.inSeconds} seconds before trying again. You have $remainingAttempts attempts remaining.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );

        // Wait before allowing next attempt
        await Future.delayed(_retryDelay.value);
      } else {
        Get.snackbar(
          'Error',
          'Authentication failed: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      rethrow;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> _checkAuthStatus() async {
    try {
      // 1️⃣ Seed from any existing session (e.g. app restart)
      final session = _supabase.auth.currentSession;
      isAuthenticated.value = session != null;

      // 2️⃣ Listen to all auth state changes
      _authStateSubscription =
          _supabase.auth.onAuthStateChange.listen((AuthState state) {
        isAuthenticated.value = state.session != null;
      });
    } catch (e) {
      print('Error checking auth status: $e');
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final isValid = await _authService.verifyAdminCredentials(
        email: email,
        password: password,
      );

      if (!isValid) {
        Get.snackbar(
          'Error',
          'Invalid credentials',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isAuthenticated.value = true;
      Get.offAllNamed('/dashboard');

      Get.snackbar(
        'Success',
        'Welcome back, Admin!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error signing in: $e');
      Get.snackbar(
        'Error',
        'Failed to sign in',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _authService.signOut();
      isAuthenticated.value = false;

      Get.offAllNamed('/login');
    } catch (e) {
      print('Error signing out: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _handleAuthAttempt(() async {
      try {
        isLoading.value = true;
        errorMessage.value = '';

        final response = await _supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );

        if (response.user != null) {
          // Navigate to home page
          isAuthenticated.value = true;

          Get.offAllNamed('/mainScreen');
        } else {
          throw Exception('Failed to sign in');
        }
      } catch (e) {
        errorMessage.value = 'Failed to sign in: ${e.toString()}';
      } finally {
        isLoading.value = false;
      }
    });
  }

  Future<void> forgotPassword(String email, {String? language}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      resetEmail.value = email; // Store the email

      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'com.freshhealth.instaclinic://reset-password',
      );

      Get.snackbar(
        'Success',
        'Password reset email sent to $email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Failed to send reset email: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to send reset email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Authentication
      await _authService.signInWithGoogle();
      final user = _supabase.auth.currentUser;
      if (user == null)
        throw Exception(
            'No user after sign-in'); // This should no longer trigger

      // Database operations
      await _supabase.from('users').upsert({
        'id': user.id,
        'email': user.email,
        'first_name': user.userMetadata?['first_name'] ?? '',
        'last_name': user.userMetadata?['last_name'] ?? '',
        'avatar_url': user.userMetadata?['avatar_url'] ?? '',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'id');

      // Navigation logic
      final profile = await _supabase
          .from('users')
          .select('first_name,last_name,phone_number')
          .eq('id', user.id)
          .single();

      final needsCompletion = profile['first_name'] == null ||
          profile['phone_number'] == null ||
          (profile['phone_number'] as String).trim().isEmpty;

      if (needsCompletion) {
        Get.toNamed('/profile-completion');
      } else {
        Get.offAllNamed('/mainScreen');
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      errorMessage.value = 'Failed to sign in with Google: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to sign in with Google: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authService.signInWithFacebook();

      // Check if user profile is complete
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final profile =
            await _supabase.from('users').select().eq('id', user.id).single();

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
      }

      Get.snackbar(
        'Success',
        'Signed in with Facebook successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Failed to sign in with Facebook: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to sign in with Facebook',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithApple() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _authService.signInWithApple();

      // Check if user profile is complete
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final profile =
            await _supabase.from('users').select().eq('id', user.id).single();

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
      }

      Get.snackbar(
        'Success',
        'Signed in with Apple successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Failed to sign in with Apple: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to sign in with Apple',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSocialUserProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

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

      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      final profile =
          await _supabase.from('users').select().eq('id', user.id).single();

      final needsCompletion = (profile['first_name'] == null ||
              (profile['first_name'] as String).isEmpty) ||
          (profile['last_name'] == null ||
              (profile['last_name'] as String).isEmpty) ||
          (profile['phone_number'] == null ||
              (profile['phone_number'] as String).isEmpty) ||
          (profile['birth_date'] == null ||
              (profile['birth_date'] as String).isEmpty) ||
          (profile['gender'] == null || (profile['gender'] as String).isEmpty);

      if (needsCompletion) {
        // Navigate to profile completion if any field is empty
        Get.offAllNamed('/profile-completion');
      } else {
        // Navigate to main screen if profile is complete
        isAuthenticated.value = true;
        Get.offAllNamed('/mainScreen');
      }
    } catch (e) {
      errorMessage.value = 'Failed to update profile: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createAccount({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String birthDate,
    required String gender,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Store phone number for OTP view
      phoneNumber.value = phone;

      // Validate all fields
      if (firstName.isEmpty ||
          lastName.isEmpty ||
          email.isEmpty ||
          phone.isEmpty ||
          birthDate.isEmpty ||
          gender.isEmpty ||
          password.isEmpty) {
        errorMessage.value = 'Please fill in all fields';
        return;
      }

      // Validate email format
      if (!GetUtils.isEmail(email)) {
        errorMessage.value = 'Please enter a valid email address';
        return;
      }

      // Validate phone number format
      if (!GetUtils.isPhoneNumber(phone)) {
        errorMessage.value = 'Please enter a valid phone number';
        return;
      }

      // Validate password length
      if (password.length < 6) {
        errorMessage.value = 'Password must be at least 6 characters';
        return;
      }

      // Create auth user
      final authResponse = await _supabase.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'first_name': firstName,
          'last_name': lastName,
          'phone_number': phone,
          'birth_date': birthDate,
          'gender': gender,
        },
      );

      if (authResponse.user != null) {
        // Insert into users table
        await _supabase.from('users').upsert({
          'id': authResponse.user!.id,
          'email': email.trim(),
          'phone_number': phone,
          'first_name': firstName,
          'last_name': lastName,
          'birth_date': birthDate,
          'gender': gender,
          'avatar_url': null,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        // Send OTP
        // await _otpService.sendOTP(phone);

        // Navigate to OTP verification
        //Get.offAllNamed('/otp-verification');
        Get.offAllNamed('/address');
      } else {
        errorMessage.value = 'Failed to create account';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP(String otp) async {
    try {
      isLoading.value = true;

      // Verify OTP with Cequens API
      final isVerified = await _otpService.verifyOTP(phoneNumber.value, otp);

      if (isVerified) {
        // Navigate to address input page after successful verification
        Get.to(() => const AddressView());
      } else {
        errorMessage.value = 'Invalid OTP code';
      }
    } catch (e) {
      errorMessage.value = 'Failed to verify OTP: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> skipAuthentication() async {
    try {
      isLoading.value = true;
      // Create anonymous user
      final response = await _supabase.auth.signInAnonymously();

      if (response.user != null) {
        // Create a basic user profile for anonymous user

        // Navigate to home page
        Get.offAllNamed('/home');
      } else {
        throw Exception('Failed to create anonymous account');
      }
    } catch (e) {
      errorMessage.value = 'Failed to skip authentication: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to skip authentication',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Account deletion functionality per App Store Guideline 5.1.1(v)
  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        return;
      }

      await _authService.deleteAccount();

      Get.snackbar(
        'Success',
        'Your account has been deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to login screen
      Get.offAllNamed('/login');
    } catch (e) {
      errorMessage.value = 'Failed to delete account: ${e.toString()}';
      Get.snackbar(
        'Error',
        'Failed to delete account',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    birthDateController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    signUpTapRecognizer.dispose();
    super.onClose();
  }
}
