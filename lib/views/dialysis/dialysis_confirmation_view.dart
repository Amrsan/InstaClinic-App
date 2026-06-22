import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // for date formatting
import '../../constants/app_colors.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/payment_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../models/models.dart'; // Service, AddressModel, etc.
import '../payment/payment_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../payment/test_payment_view.dart';

class DialysisBookingConfirmationView extends GetView<BookingController> {
  DialysisBookingConfirmationView({Key? key}) : super(key: key);

  // grab the already-registered ProfileController
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final Service clinic = args['primaryServices'] as Service;
    final List<DateTime> selectedDates = args['selectedDates'] as List<DateTime>;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF006868),
        title: Text('confirm_booking'.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Clinic Info ──────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              SvgPicture.network(
                clinic.imageUrl ?? 'assets/icons/abdominal.svg',
                width: 32,
                height: 32,
                colorFilter:
                    ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  clinic.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 24),

          // ── Address ──────────────────────────────────
          Obx(() {
            if (profileController.addresses.isEmpty) {
              return Text(
                'no_address_on_file'.tr,
                style: const TextStyle(color: Colors.red),
              );
            }
            final addr = profileController.addresses.first;
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: IntrinsicHeight(
                child: Row(children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Color(0xFF006868),
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(12))),
                      child: const Center(
                        child: Icon(Icons.location_on,
                            color: Colors.white, size: 40),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('service_delivery_to'.tr,
                          style: const TextStyle(color:Color(0xFF006868),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${addr['government']}, ${addr['city']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color(0xFF006868),
                                ),
                                onPressed: () => Get.toNamed('/address'),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(addr['street'] ?? '',
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('${addr['floor_no'] ?? ''} ${'floor'.tr} ',
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text('${'apt_no'.tr} ${addr['apartment_no'] ?? ''}',
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            );
          }),

          const SizedBox(height: 24),

          // ── Appointment Dates ─────────────────────────
          Text(
            'selected dates'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ...selectedDates.map((date) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              DateFormat('EEEE d MMMM').format(date),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF006868),
              ),
            ),
          )).toList(),
          const SizedBox(height: 4),
          Text(
            '${'time'.tr}: 10:00 AM - 10:00 PM',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF006868),
            ),
          ),

          const SizedBox(height: 24),

          // ── Contact Number ───────────────────────────
          Text(
            'contact_number'.tr,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: const Row(children: [
                  Text('🇪🇬', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 4),
                  Text('+20', style: TextStyle(fontSize: 16)),
                ]),
              ),
              Expanded(
                child: Obx(() {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      profileController.phoneNumber.value,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }),
              ),
            ]),
          ),
          SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'special_notes'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'type here',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  maxLines: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // ── Confirm Button ────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final authController = Get.find<AuthController>();
                final profileController = Get.find<ProfileController>();

                // Check if user is logged in
                if (!authController.isAuthenticated.value) {
                  Get.put<String>('/booking', tag: 'intended_route');
                  Get.toNamed('/login');
                  return;
                }
                // Check if user has selected at least 2 dates
                if (selectedDates.length < 2) {
                  Get.snackbar(
                    'Warring Massage'.tr,
                    'please select at least two dates'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 5),
                    colorText: Colors.red,
                  );
                  return;
                }

                // Check if user has address
                final addresses = await profileController.addresses;
                if (addresses.isEmpty) {
                  Get.toNamed('/address', arguments: {
                    'clinic': clinic,
                    'selectedDates': selectedDates,
                    'selectedTimeSlot': '10:00 AM - 10:00 PM',
                  });
                  return;
                }

                // Show confirmation dialog
                final confirmed = await _showConfirmationDialog(
                  clinic: clinic,
                  selectedDates: selectedDates,
                  profileController: profileController,
                );

                if (confirmed) {
                  await _processBooking(
                    clinic: clinic,
                    selectedDates: selectedDates,
                    profileController: profileController,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006868),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'confirm_booking'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // Show confirmation dialog with booking details
  Future<bool> _showConfirmationDialog({
    required Service clinic,
    required List<DateTime> selectedDates,
    required ProfileController profileController,
  }) async {
    final addresses = await profileController.addresses;
    final totalPrice = clinic.price * selectedDates.length;
    
    return await Get.dialog<bool>(
      AlertDialog(
        title: Text('Data Confirmation'.tr),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Kindly review the information below and confirm that it is correct. If everything looks good, please click confirm",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              
              // Service Name
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.medical_services, color: Color(0xFF006868)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        clinic.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              
              // Selected Dates
              Text(
                'Selected Dates:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(height: 8),
              ...selectedDates.map((date) => Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  '• ${DateFormat('EEEE, d MMMM yyyy').format(date)}',
                  style: TextStyle(fontSize: 14),
                ),
              )).toList(),
              SizedBox(height: 12),
              
              // Address
              if (addresses.isNotEmpty) ...[
                Text(
                  'Delivery Address:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${addresses.first['street'] ?? ''}, ${addresses.first['floor_no'] ?? ''} ${'floor'.tr}, ${'apt_no'.tr} ${addresses.first['apartment_no'] ?? ''}, ${addresses.first['city'] ?? ''}, ${addresses.first['government'] ?? ''}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(height: 12),
              ],
              
              // Contact Info
              Text(
                'Contact Information:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                'Name: ${profileController.firstName.value} ${profileController.lastName.value}',
                style: TextStyle(fontSize: 14),
              ),
              Text(
                'Phone: ${profileController.phoneNumber.value}',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 12),
              
              // Total Price
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF006868).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF006868)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Price:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'EGP ${totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF006868),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('confirm'.tr),
          ),
        ],
      ),
    ) ?? false;
  }

  // Process the booking after confirmation
  Future<void> _processBooking({
    required Service clinic,
    required List<DateTime> selectedDates,
    required ProfileController profileController,
  }) async {
    final addresses = await profileController.addresses;
    
    // Set the booking details in the controller
    final bookingData = {
      'service': clinic,
      'dates': selectedDates,
      'timeSlot': '10:00 AM - 10:00 PM',
      'addressId': addresses.first['id'],
      'contactNumber': profileController.phoneNumber.value,
      'patientName': '${profileController.firstName.value} ${profileController.lastName.value}',
      'patientAge': profileController.birthDate.value.toString(),
      'patientGender': profileController.gender.value,
      'notes': 'Dialysis Booking with selected dates: ${selectedDates.map(DateFormat('yyyy-MM-dd').format).join(', ')}',
    };

    // Create the booking
    final success = await controller.createBooking(
      statusOverride: 'pending',
      bookingData: bookingData,
    );
    
    if (success) {
      final paymentController = Get.find<PaymentController>();
      final checkoutUrl = await paymentController.getUnifiedCheckoutUrl(clinic.price * selectedDates.length);
      
      final result = await Get.to(() => PaymentWebView(
        paymentUrl: checkoutUrl,
        clinicName: clinic.name,
        price: clinic.price * selectedDates.length,
      ));
      
      if (result == 'success' || result == 'fail') {
        Get.snackbar(
          result == 'success' ? 'Payment request send Successful' : 'Payment Failed',
          'We will contact you soon.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: result == 'success' ? Colors.green : Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        Get.offAllNamed('/home');
      }
    } else {
      Get.snackbar(
        'error'.tr, 
        controller.errorMessage.value,
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM
      );
    }
  }
}
