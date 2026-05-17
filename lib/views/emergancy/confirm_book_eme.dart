import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:instaclinics/controllers/address_controller.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/payment_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../models/models.dart'; // Service, AddressModel, etc.
import '../payment/payment_view.dart';
import '../payment/test_payment_view.dart';

class EmeBookingConfirmationView extends GetView<BookingController> {
  EmeBookingConfirmationView({super.key});
  final args = Get.arguments ;
  // grab the already-registered ProfileController
  final ProfileController profileController = Get.find<ProfileController>();
  final BookingController bookingController = Get.put(BookingController());

  @override
  Widget build(BuildContext context) {
    final Service clinic = args['clinic'] as Service;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF006868),
        title: Text('Making a Request'.tr, style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Clinic Info ──────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF006868).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'note'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(fontSize: 14, height: 1.4),
                    ),
                    Expanded(
                      child: Text(
                        'Amount Non refundable'.trParams({'service': clinic.name}),
                        style: const TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Address ──────────────────────────────────
          Obx(() {
            if (profileController.addresses.isEmpty) {
              return Row(
                children: [
                  Text(
                    'no_address_on_file'.tr,
                    style: const TextStyle(color: Colors.red),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xFFE65100),
                    ),

                    onPressed: () => Get.toNamed('/address'),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
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
                          style: TextStyle(color:Color(0xFF006868),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          ),
                          ),
                          const SizedBox(height: 4),
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
                                  color: Color(0xFFE65100),
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
                  final phone = profileController.phoneNumber.value;
                  if (phone.isEmpty) {
                    // INPUT MODE
                    return TextField(
                      keyboardType: TextInputType.phone,
                      controller: bookingController.phoneNumberController,
                      decoration: const InputDecoration(
                        hintText: '123456789',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onSubmitted: (val) {
                        // save trimmed number into your controller
                        bookingController.contactNumber.value = val.trim();
                        // optionally persist it: profileController.updateProfile(...)
                      },
                    );
                  } else {
                    // DISPLAY MODE
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        phone,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }
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
                  controller: bookingController.notesController,
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
            height: 50,
            child: ElevatedButton(
              onPressed: () => _chooseAddressAndBook(context, clinic),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF006868),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'confirm'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _chooseAddressAndBook(
    BuildContext ctx,
    Service clinic,
  ) {
    final addr = profileController.addresses.first;
    return showDialog(
      context: ctx,
      builder: (_) => StatefulBuilder(
        builder: (c, setState) => AlertDialog(
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
                
                // Emergency Service Note
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFE65100).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFE65100)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Color(0xFFE65100)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Emergency Service - Immediate Response',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE65100),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                
                // Address
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
                    '${addr['street'] ?? ''}, ${addr['floor_no'] ?? ''} ${'floor'.tr}, ${'apt_no'.tr} ${addr['apartment_no'] ?? ''}, ${addr['city'] ?? ''}, ${addr['government'] ?? ''}',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(height: 12),
                
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
                  'Phone: ${bookingController.phoneNumberController.text.trim().isEmpty ? profileController.phoneNumber.value : bookingController.phoneNumberController.text.trim()}',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                
                // Notes
                if (bookingController.notesController.text.isNotEmpty) ...[
                  Text(
                    'Special Notes:',
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
                      bookingController.notesController.text,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 12),
                ],
                
                // Price
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
                        'Price:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'EGP ${clinic.price.toStringAsFixed(2)}',
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
                onPressed: () => Get.back(), child: Text('cancel'.tr)),
            TextButton(
              onPressed: () async {
                // 1) Populate bookingController with everything
                controller.selectedService.value = clinic;
                controller.selectedDates.add(DateTime.now()); // Add current date to selected dates
                controller.selectedTimeSlot.value = '10:00 AM - 10:00 PM';
                controller.selectedAddressId.value = addr?['id'] ?? '';
                controller.contactNumber.value =
                    bookingController.phoneNumberController.text.trim();
                controller.patientName.value =
                    profileController.firstName.value +
                        ' ' +
                        profileController.lastName.value;
                controller.patientAge.value =
                    profileController.birthDate.value.toString();
                controller.patientGender.value = profileController.gender.value;
                controller.notes.value = controller.notesController.text;
                final ok =
                    await controller.createBooking(statusOverride: 'unpaid');
                Get.back(); // close dialog

                if (ok) {
                  final paymentController = Get.find<PaymentController>();
                  final authToken = await paymentController.getAuthToken();
                  final orderId = await paymentController.getOrderId(authToken, clinic.price);
                  final paymentKey = await paymentController.getPaymentKey(authToken, orderId, clinic.price);
                  final iframeUrl = 'https://accept.paymob.com/api/acceptance/iframes/867108?payment_token=$paymentKey';
                  final result = await Get.to(() => PaymentWebView(
                    paymentUrl: iframeUrl,
                    clinicName: clinic.name,
                    price: clinic.price,
                  ));
                  if (result == 'success' || result == 'fail') {
                    Get.snackbar(
                      result == 'success' ? 'Payment request send Successful' : 'Payment Failed',
                      'We will contact you soon.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: result == 'success' ? Colors.green : Colors.red,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 5),
                    );
                    Get.offAllNamed('/home');
                  }
                } else {
                  Get.snackbar('error'.tr, controller.errorMessage.value,        duration: const Duration(seconds: 5),

                      snackPosition: SnackPosition.BOTTOM);
                }
              },
              child: Text('confirm'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
