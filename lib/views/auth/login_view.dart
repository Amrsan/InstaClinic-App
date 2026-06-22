import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({Key? key}) : super(key: key);

  void _showForgotPasswordDialog(BuildContext context, double scale, [String? email]) {
    final emailController = TextEditingController(text: email ?? '');
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16 * scale),
          ),
          title: Text(
            'forgot_password'.tr,
            style: TextStyle(
              fontSize: 20 * scale,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF00A6A6),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter your email address to receive a password reset link.',
                style: TextStyle(
                  fontSize: 14 * scale,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 16 * scale),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'email'.tr,
                  labelStyle: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 14 * scale,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF00A6A6),
                      width: 1,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12 * scale,
                    vertical: 8 * scale,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'cancel'.tr,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14 * scale,
                ),
              ),
            ),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () {
                      if (emailController.text.isEmpty) {
                        Get.snackbar(
                          'Error',
                          'Please enter your email',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 5),
                        );
                        return;
                      }
                      controller.forgotPassword(emailController.text);
                      Navigator.of(context).pop();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A6A6),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8 * scale),
                ),
              ),
              child: controller.isLoading.value
                  ? SizedBox(
                      width: 16 * scale,
                      height: 16 * scale,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'send'.tr,
                      style: TextStyle(
                        fontSize: 14 * scale,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            )),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final scale = screenSize.width / 412; // Base width from Figma design

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24 * scale,
              vertical: 16 * scale,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      Get.offAllNamed('/mainScreen');
                    },
                    child: Text(
                      'skip'.tr,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 16 * scale,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32 * scale),

                // Login text
                Text(
                  'login'.tr,
                  style: TextStyle(
                    fontSize: 32 * scale,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF00A6A6),
                    height: 1.2,
                  ),
                ),

                SizedBox(height: 8 * scale),

                // Welcome back text
                Text(
                  'welcome_back'.tr,
                  style: TextStyle(
                    fontSize: 16 * scale,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: 48 * scale),

                // Email field
                TextField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'email'.tr,
                    labelStyle: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 16 * scale,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF00A6A6),
                        width: 1,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16 * scale,
                      vertical: 12 * scale,
                    ),
                  ),
                ),

                SizedBox(height: 16 * scale),

                // Password field
                Obx(() => TextField(
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: 'password'.tr,
                    labelStyle: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 16 * scale,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF00A6A6),
                        width: 1,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16 * scale,
                      vertical: 12 * scale,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.black.withOpacity(0.6),
                        size: 24 * scale,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                )),

                SizedBox(height: 16 * scale),

                // Forgot password button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // if (controller.emailController.text.isEmpty) {
                      //   Get.snackbar(
                      //     'Error',
                      //     'Please enter your email first',
                      //     snackPosition: SnackPosition.BOTTOM,
                      //     backgroundColor: Colors.red,
                      //     colorText: Colors.white,
                      //     duration: const Duration(seconds: 5),
                      //   );
                      //   return;
                      // }
                      _showForgotPasswordDialog(Get.context!, scale, controller.emailController.text);
                    },
                    child: Text(
                      'forgot_password'.tr,
                      style: TextStyle(
                        color: const Color(0xFF00A6A6),
                        fontSize: 14 * scale,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16 * scale),

                // Login button
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48 * scale,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.signInWithEmail(
                            email: controller.emailController.text,
                            password: controller.passwordController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A6A6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14 * scale),
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            width: 24 * scale,
                            height: 24 * scale,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'login'.tr,
                            style: TextStyle(
                              fontSize: 16 * scale,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                )),

                // Error message
                Obx(() {
                  if (controller.errorMessage.value.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14 * scale,
                          ),
                        ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(16 * scale),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8 * scale),
                          ),
                        ),
                      );
                      // Clear the error message after showing
                      controller.errorMessage.value = '';
                    });
                  }
                  return const SizedBox.shrink();
                }),

                SizedBox(height: 24 * scale),

                // SizedBox(height: 24 * scale),
                //
                // // Or login with text
                Center(
                  child: Text(
                    'or login with'.tr,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 14 * scale,
                    ),
                  ),
                ),

                SizedBox(height: 24 * scale),

                // Social login buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialLoginButton(
                      icon: FontAwesomeIcons.facebook,
                      onPressed: controller.signInWithFacebook,
                      scale: scale,
                    ),
                    SizedBox(width: 24 * scale),
                    _SocialLoginButton(
                      icon: FontAwesomeIcons.google,
                      onPressed: controller.signInWithGoogle,
                      scale: scale,
                    ),
                    if (Platform.isIOS) ...[
                      SizedBox(width: 24 * scale),
                      _SocialLoginButton(
                        icon: FontAwesomeIcons.apple,
                        onPressed: controller.signInWithApple,
                        scale: scale,
                      ),
                    ]
                  ],
                ),

                SizedBox(height: 32 * scale),

                // Sign up link
                Center(
                  child: TextButton(
                    onPressed: () => Get.toNamed('/signup'),
                    child: RichText(
                      text: TextSpan(
                        text: 'No Account'.tr,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 14 * scale,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign Up'.tr,
                            style: TextStyle(
                              color: const Color(0xFF00A6A6),
                              fontSize: 14 * scale,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final dynamic icon;
  final VoidCallback onPressed;
  final double scale;

  const _SocialLoginButton({
    required this.icon,
    required this.onPressed,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: FaIcon(icon as dynamic, size: 20 * scale),
        onPressed: onPressed,
        padding: EdgeInsets.all(12.0 * scale),
      ),
    );
  }
} 