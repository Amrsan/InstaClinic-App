import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaclinics/controllers/auth_controller.dart';

class SignUpView extends GetView<AuthController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final size = MediaQuery.of(context).size;
    final scale = size.width / 412; // Base width from Figma design

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            padding: EdgeInsets.symmetric(
              horizontal: 24 * scale,
              vertical: 16 * scale,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => Get.offNamed('/mainScreen'),
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
                Text(
                  'sign_up'.tr,
                  style: TextStyle(
                    fontSize: 32 * scale,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF00A6A6),
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 8 * scale),
                Text(
                  'welcome_to_family'.tr,
                  style: TextStyle(
                    fontSize: 16 * scale,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 48 * scale),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.firstNameController,
                        decoration: InputDecoration(
                          labelText: 'first_name'.tr,
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
                    ),
                    SizedBox(width: 16 * scale),
                    Expanded(
                      child: TextField(
                        controller: controller.lastNameController,
                        decoration: InputDecoration(
                          labelText: 'last_name'.tr,
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
                    ),
                  ],
                ),
                SizedBox(height: 16 * scale),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.birthDateController,
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            controller.birthDateController.text =
                                '${date.day}/${date.month}/${date.year}';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'add_birthdate'.tr,
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
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            size: 24 * scale,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16 * scale),
                    Expanded(
                      child: Obx(() => Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: controller.genderController.value.isEmpty
                                ? null
                                : controller.genderController.value,
                            hint: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16 * scale,
                              ),
                              child: Text(
                                'gender'.tr,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontSize: 16 * scale,
                                ),
                              ),
                            ),
                            items: ['Male', 'Female', 'Other']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16 * scale,
                                  ),
                                  child: Text(
                                    value == 'Male'
                                        ? 'male'.tr
                                        : value == 'Female'
                                            ? 'female'.tr
                                            : 'other'.tr,
                                    style: TextStyle(
                                      fontSize: 16 * scale,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                controller.genderController.value = newValue;
                              }
                            },
                            isExpanded: true,
                            icon: Padding(
                              padding: EdgeInsets.only(right: 16 * scale),
                              child: Icon(
                                Icons.arrow_drop_down,
                                size: 24 * scale,
                              ),
                            ),
                          ),
                        ),
                      )),
                    ),
                  ],
                ),
                SizedBox(height: 16 * scale),
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
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black.withOpacity(0.6),
                        size: 24 * scale,
                      ),
                      onPressed: () =>
                          controller.isPasswordVisible.value = !controller.isPasswordVisible.value,
                    ),
                  ),
                )),
                SizedBox(height: 16 * scale),
                Obx(() => TextField(
                  controller: controller.confirmPasswordController,
                  obscureText: !controller.isConfirmPasswordVisible.value,
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
                        controller.isConfirmPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black.withOpacity(0.6),
                        size: 24 * scale,
                      ),
                      onPressed: () =>
                          controller.isConfirmPasswordVisible.value = !controller.isConfirmPasswordVisible.value,
                    ),
                  ),
                )),
                SizedBox(height: 16 * scale),
                Row(
                  children: [
                    Container(
                      width: 80 * scale,
                      height: 48 * scale,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '+20',
                          style: TextStyle(
                            fontSize: 16 * scale,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16 * scale),
                    Expanded(
                      child: TextField(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'phone_number'.tr,
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
                    ),
                  ],
                ),
                SizedBox(height: 32 * scale),
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48 * scale,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            if (controller.passwordController.text != controller.confirmPasswordController.text) {
                              controller.errorMessage.value = 'passwords_do_not_match'.tr;
                              return;
                            }
                            if (controller.passwordController.text.length < 6) {
                              controller.errorMessage.value = 'password_min_length'.tr;
                              return;
                            }
                            await controller.createAccount(
                              firstName: controller.firstNameController.text,
                              lastName: controller.lastNameController.text,
                              email: controller.emailController.text,
                              phone: controller.phoneController.text,
                              birthDate: controller.birthDateController.text,
                              gender: controller.genderController.value,
                              password: controller.passwordController.text,
                            );
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
                            'sign_up'.tr,
                            style: TextStyle(
                              fontSize: 16 * scale,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                )),
                Obx(() => controller.errorMessage.value.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 8 * scale),
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12 * scale,
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
                SizedBox(height: 24 * scale),
                Center(
                  child: TextButton(
                    onPressed: () => Get.toNamed('/login'),
                    child: RichText(
                      text: TextSpan(
                        text: 'already_have_account'.tr,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 14 * scale,
                        ),
                        children: [
                          TextSpan(
                            text: 'login'.tr,
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
                SizedBox(height: 24 * scale),
                // Skip button
                // TextButton(
                //   onPressed: () => controller.skipAuthentication(),
                //   child: Text(
                //     'Skip for now',
                //     style: TextStyle(
                //       fontSize: 14 * scale,
                //       color: Colors.grey[600],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 