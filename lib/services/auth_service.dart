import 'dart:async';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'dart:math';


class AuthService extends GetxService {
  final _supabase = supabase.Supabase.instance.client;
  final _isAuthenticated = false.obs;

  bool get isAuthenticated => _isAuthenticated.value;
  supabase.Session? get currentSession => _isAuthenticated.value
      ? supabase.Session(
          accessToken: 'admin_token',
          tokenType: 'bearer',
          user: supabase.User(
            id: 'admin',
            email: 'admin',
            createdAt: DateTime.now().toIso8601String(),
            updatedAt: DateTime.now().toIso8601String(),
            appMetadata: {},
            userMetadata: {},
            aud: 'authenticated',
          ),
        )
      : null;

  Future<void> initialize() async {
    try {
      _isAuthenticated.value = false;
      // Auth service initialization complete
    } catch (e) {
      print('Error initializing auth service: $e');
    }
  }

  Future<bool> verifyAdminCredentials({
    required String email,
    required String password,
  }) async {
    if (email == 'admin' && password == 'P@ssw0rd') {
      _isAuthenticated.value = true;
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    _isAuthenticated.value = false;
  }

  // Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign up with email and password
  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await _supabase.auth.signUp(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final success = await _supabase.auth.signInWithOAuth(
        supabase.OAuthProvider.google,
        redirectTo: 'com.freshhealth.instaclinic://login-callback',
        authScreenLaunchMode: supabase.LaunchMode.platformDefault,
      );

      if (!success) {
        throw Exception('Failed to initiate Google sign-in');
      }

      // Wait for the user to be signed in
      await _waitForUser();

      print('Signed in with Google!');
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  Future<void> _waitForUser() async {
    final completer = Completer<void>();
    final subscription = _supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        completer.complete();
      }
    });

    await completer.future;
    await subscription.cancel();
  }

  Future<void> signInWithFacebook() async {
    try {
      // Use Supabase OAuth flow for Facebook
      final success = await _supabase.auth.signInWithOAuth(
        supabase.OAuthProvider.facebook,
        redirectTo: 'com.freshhealth.instaclinic://login-callback',
        authScreenLaunchMode: supabase.LaunchMode.platformDefault,
      );

      if (!success) {
        throw Exception('Failed to initiate Facebook sign-in');
      }

      // Wait for the user to be signed in
      await _waitForUser();

      print('Signed in with Facebook!');
    } catch (e) {
      print('Error signing in with Facebook: $e');
      rethrow;
    }
  }

  Future<void> signInWithApple() async {
    try {
      // Check if Apple Sign In is available
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        throw Exception('Apple Sign In is not available on this device');
      }

      // Generate a random nonce
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.freshhealth.instaclinic',
          redirectUri:
              Uri.parse('https://your-project.supabase.co/auth/v1/callback'),
        ),
      );

      // Create a credential from the authorization code
      final response = await _supabase.auth.signInWithIdToken(
        provider: supabase.OAuthProvider.apple,
        idToken: appleCredential.identityToken!,
        nonce: rawNonce,
      );

      if (response.session == null) {
        throw Exception('Failed to sign in with Apple');
      }

      // Create or update user profile
      await _createOrUpdateUserProfile(response.user!, {
        'email': appleCredential.email,
        'first_name': appleCredential.givenName,
        'last_name': appleCredential.familyName,
      });
    } catch (e) {
      print('Error signing in with Apple: $e');
      rethrow;
    }
  }

  // Helper method to create or update user profile
  Future<void> _createOrUpdateUserProfile(
      supabase.User user, Map<String, dynamic> userData) async {
    try {
      await _supabase.from('users').upsert({
        'id': user.id,
        'email': userData['email'] ?? user.email,
        'first_name': userData['first_name'],
        'last_name': userData['last_name'],
        'avatar_url': userData['avatar_url'],
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error creating/updating user profile: $e');
      // Don't rethrow as this is not critical for authentication
    }
  }

  // Generate a random nonce
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  // SHA256 hash of the nonce
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Account deletion functionality per App Store Guideline 5.1.1(v)
  Future<void> deleteAccount() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Delete user data from users table
      await _supabase.from('users').delete().eq('id', user.id);

      // Delete the auth user account
      await _supabase.auth.admin.deleteUser(user.id);

      // Sign out the user
      await signOut();

      print('Account deleted successfully');
    } catch (e) {
      print('Error deleting account: $e');
      rethrow;
    }
  }
}
