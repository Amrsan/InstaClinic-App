import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class OTPVerificationView extends GetView<AuthController> {
  const OTPVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = size.width / 412; // Base width from Figma design

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF55B7B6),
        elevation: 0,
        title: Text(
          'contact_confirmation'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24 * scale),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32 * scale),
            Obx(() => Text(
              'confirmation_code_sent_to'.trParams({'phone': controller.phoneNumber.value}),
              style: TextStyle(
                fontSize: 16 * scale,
                color: Colors.black87,
              ),
            )),
            SizedBox(height: 32 * scale),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => _buildOtpBox(scale, index)),
            ),
            SizedBox(height: 24 * scale),
            Center(
              child: Text(
                'will_be_sent_at'.trParams({'time': '00:26'}),
                style: TextStyle(
                  fontSize: 14 * scale,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(height: 16 * scale),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'hadnt_came_throw'.tr,
                    style: TextStyle(
                      fontSize: 14 * scale,
                      color: Colors.black54,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Resend logic will be implemented later
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'resend'.tr,
                      style: TextStyle(
                        fontSize: 14 * scale,
                        color: const Color(0xFF55B7B6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 48 * scale,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.verifyOTP(controller.otpCode.value),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF55B7B6),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'confirm'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox(double scale, int index) {
    return Container(
      width: 45 * scale,
      height: 45 * scale,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: (value) {
          if (value.isNotEmpty) {
            // Update the OTP code in the controller
            final currentCode = controller.otpCode.value;
            final newCode = currentCode.length > index
                ? currentCode.substring(0, index) + value + currentCode.substring(index + 1)
                : currentCode.padRight(index, ' ') + value;
            controller.otpCode.value = newCode;
            
            // Move to next field if available
            if (index < 5 && value.isNotEmpty) {
              FocusScope.of(Get.context!).nextFocus();
            }
          }
        },
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        style: TextStyle(
          fontSize: 20 * scale,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 