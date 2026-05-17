import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclinics/controllers/auth_controller.dart';

class CreatePasswordView extends GetView<AuthController> {
  const CreatePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final isPasswordVisible = false.obs;
    final isConfirmPasswordVisible = false.obs;
    
    // Get screen size for responsive design
    final size = MediaQuery.of(context).size;
    final scale = size.width / 412; // Base width from Figma design

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'create_your_password'.tr,
          style: TextStyle(
            fontSize: 20 * scale,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24 * scale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'please_create_password'.tr,
                  style: TextStyle(
                    fontSize: 14 * scale,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 32 * scale),
                Obx(() => TextField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible.value,
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
                        isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black.withOpacity(0.6),
                        size: 24 * scale,
                      ),
                      onPressed: () =>
                          isPasswordVisible.value = !isPasswordVisible.value,
                    ),
                  ),
                )),
                SizedBox(height: 16 * scale),
                Obx(() => TextField(
                  controller: confirmPasswordController,
                  obscureText: !isConfirmPasswordVisible.value,
                  decoration: InputDecoration(
                    labelText: 'confirm_password'.tr,
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
                        isConfirmPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black.withOpacity(0.6),
                        size: 24 * scale,
                      ),
                      onPressed: () => isConfirmPasswordVisible.value =
                          !isConfirmPasswordVisible.value,
                    ),
                  ),
                )),
                SizedBox(height: 32 * scale),
                SizedBox(
                  width: double.infinity,
                  height: 48 * scale,
                  child: ElevatedButton(
                    onPressed: () {
                      if (passwordController.text.isEmpty ||
                          confirmPasswordController.text.isEmpty) {
                        controller.errorMessage.value =
                            'please_enter_both_passwords'.tr;
                        return;
                      }
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        controller.errorMessage.value =
                            'passwords_do_not_match'.tr;
                        return;
                      }
                      // TODO: Implement password update
                      // controller.updatePassword(passwordController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A6A6),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14 * scale),
                    ),
                    child: Text(
                      'confirm'.tr,
                      style: TextStyle(
                        fontSize: 16 * scale,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (controller.errorMessage.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 8 * scale),
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12 * scale,
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