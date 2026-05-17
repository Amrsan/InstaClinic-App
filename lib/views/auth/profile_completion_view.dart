import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../address/address_view.dart';

class ProfileCompletionView extends GetView<AuthController> {
  const ProfileCompletionView({super.key});

  @override
  Widget build(BuildContext context) {
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
                // Back button
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back,
                    size: 24 * scale,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 16 * scale),
                
                // Header
                Text(
                  'complete_profile'.tr,
                  style: TextStyle(
                    fontSize: 28 * scale,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF00A6A6),
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 8 * scale),
                Text(
                  'complete_profile_description'.tr,
                  style: TextStyle(
                    fontSize: 16 * scale,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 32 * scale),

                // Profile completion form
                _buildProfileForm(scale),
                
                SizedBox(height: 24 * scale),
                
                // Continue button
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48 * scale,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => _handleContinue(),
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
                            'continue'.tr,
                            style: TextStyle(
                              fontSize: 16 * scale,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                )),

                // Error message
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileForm(double scale) {
    return Column(
      children: [
        // Name fields
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

        // Phone field
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
        SizedBox(height: 16 * scale),

        // Birth date and gender
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.birthDateController,
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: Get.context!,
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
      ],
    );
  }

  void _handleContinue() async {
    // Validate required fields
    if (controller.firstNameController.text.isEmpty ||
        controller.lastNameController.text.isEmpty ||
        controller.emailController.text.isEmpty ||
        controller.phoneController.text.isEmpty ||
        controller.birthDateController.text.isEmpty ||
        controller.genderController.value.isEmpty) {
      controller.errorMessage.value = 'please_fill_all_fields'.tr;
      return;
    }

    // Validate email format
    if (!GetUtils.isEmail(controller.emailController.text)) {
      controller.errorMessage.value = 'please_enter_valid_email'.tr;
      return;
    }

    // Validate phone number
    if (!GetUtils.isPhoneNumber(controller.phoneController.text)) {
      controller.errorMessage.value = 'please_enter_valid_phone'.tr;
      return;
    }

    // Update user profile
    await controller.updateSocialUserProfile();
    
    // Navigate to address view
    Get.to(() => const AddressView());
  }
} 